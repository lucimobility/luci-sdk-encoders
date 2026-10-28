//! Dual quadrature encoder interface for LUCI.
//!
//! Decodes the two RS-422 encoder inputs (J2 = left wheel, J3 = right wheel)
//! with the eQDC peripherals and streams the wheel angles over USB CDC-ACM at
//! 100 Hz using the LUCI sensors framing from the AS5600 Arduino firmware.

#![no_std]
#![no_main]

use defmt::{info, unwrap, warn};
use defmt_rtt as _;
use embassy_executor::Spawner;
use embassy_mcxa as hal;
use embassy_mcxa::clocks::PoweredClock;
use embassy_mcxa::clocks::config::{FircFreqSel, SpllConfig, SpllMode, SpllSource, VddLevel};
use embassy_mcxa::eqdc::{self, Eqdc};
use embassy_mcxa::gpio::{DriveStrength, Level, Output, SlewRate};
use embassy_mcxa::peripherals::USB0;
use embassy_mcxa::{bind_interrupts, usb};
use embassy_time::{Duration, Instant, Ticker, Timer, with_timeout};
use embassy_usb::class::cdc_acm::device::{CdcAcmClass, Receiver, Sender, State};
use embassy_usb::driver::EndpointError;
use embassy_usb::{Builder, UsbDevice};
use panic_probe as _;
use static_cell::StaticCell;

/// Decoded (4x) counts per wheel revolution: 160 pole MR101 ring read by an
/// LM13 programmed for 8 counts per pole.
const COUNTS_PER_REV: i32 = 1280;
/// Flip the counting direction of the left (J2) encoder.
const LEFT_REVERSED: bool = true;
/// Flip the counting direction of the right (J3) encoder.
const RIGHT_REVERSED: bool = false;

const USB_VID: u16 = 0x3272;
const USB_PID: u16 = 0x8001;

const REPORT_PERIOD: Duration = Duration::from_millis(10);
/// Frames the host doesn't collect within this time are dropped, so a host
/// that is not reading doesn't end up with a backlog of stale positions.
const WRITE_TIMEOUT: Duration = Duration::from_millis(20);

bind_interrupts!(struct Irqs {
    USB0 => usb::InterruptHandler<USB0>;
});

type UsbDriver = usb::Driver<'static, USB0>;

#[embassy_executor::task]
async fn usb_task(mut device: UsbDevice<'static, UsbDriver>) -> ! {
    device.run().await
}

/// Read and discard anything the host sends. A tty opened in its default
/// mode echoes the received frames back, and the host blocks (e.g. in
/// `tcsetattr`) until that output has been accepted.
#[embassy_executor::task]
async fn discard_rx_task(mut rx: Receiver<'static, UsbDriver>) -> ! {
    let mut buf = [0; 64];
    loop {
        rx.wait_connection().await;
        while rx.read_packet(&mut buf).await.is_ok() {}
    }
}

#[embassy_executor::task]
async fn heartbeat_task(mut led: Output<'static>) -> ! {
    loop {
        led.set_low();
        Timer::after_millis(50).await;
        led.set_high();
        Timer::after_millis(950).await;
    }
}

struct Encoders {
    left: Eqdc<'static>,
    right: Eqdc<'static>,
    /// Signal lost since the last error frame was sent.
    left_lost: bool,
    right_lost: bool,
    error_cooldown: protocol::ErrorCooldown,
}

impl Encoders {
    fn new(left: Eqdc<'static>, right: Eqdc<'static>) -> Self {
        Self {
            left,
            right,
            left_lost: false,
            right_lost: false,
            error_cooldown: protocol::ErrorCooldown::new(),
        }
    }

    fn frame(&self, now_ms: u32) -> [u8; protocol::DATA_FRAME_LEN] {
        let left = protocol::counts_to_centidegrees(self.left.position(), COUNTS_PER_REV);
        let right = protocol::counts_to_centidegrees(self.right.position(), COUNTS_PER_REV);
        protocol::data_frame(left, right, now_ms)
    }

    /// Error frame for encoders that lost the magnetic signal, rate limited
    /// like the AS5600 firmware.
    ///
    /// An LM13 that loses the signal stops driving its outputs and counts are
    /// lost. The receivers then hold both phases high, which is only detected
    /// when both phases were low at that moment, so not every loss is
    /// reported. A loss during the cooldown is reported once it ends.
    fn error_frame(&mut self, now_ms: u32) -> Option<[u8; protocol::ERROR_FRAME_LEN]> {
        self.left_lost |= self.left.take_phase_error();
        self.right_lost |= self.right.take_phase_error();
        let code = protocol::magnet_error(self.left_lost, self.right_lost)?;
        if !self.error_cooldown.try_send(now_ms) {
            return None;
        }
        warn!("signal lost: left {} right {}", self.left_lost, self.right_lost);
        self.left_lost = false;
        self.right_lost = false;
        Some(protocol::error_frame(code, now_ms))
    }
}

#[embassy_executor::main]
async fn main(spawner: Spawner) {
    let mut cfg = hal::config::Config::default();

    // USB needs BUS_CLK (SYSTEM_CLK / 2) above 24MHz, which mid-drive mode
    // cannot provide, so run from FIRC at 180MHz in over-drive mode.
    // The low-power level must match when both modes use the same drive
    // strength; this firmware never enters deep sleep.
    cfg.clock_cfg.vdd_power.active_mode.level = VddLevel::OverDriveMode;
    cfg.clock_cfg.vdd_power.low_power_mode.level = VddLevel::OverDriveMode;
    if let Some(firc) = cfg.clock_cfg.firc.as_mut() {
        firc.frequency = FircFreqSel::Mhz180;
    }
    // 48MHz USB clock: 12MHz x 32 / (2 x 4), as in NXP's CLOCK_EnableUsbfsClock().
    cfg.clock_cfg.spll = Some(SpllConfig {
        source: SpllSource::Sirc,
        mode: SpllMode::Mode1b {
            m_mult: 32,
            p_div: 4,
            bypass_p2_div: false,
        },
        power: PoweredClock::NormalEnabledDeepSleepDisabled,
        pll1_clk_div: None,
    });

    let p = hal::init(cfg);
    info!("quad-encoder starting");

    let mut red = Output::new(p.P2_0, Level::Low, DriveStrength::Normal, SlewRate::Slow);
    let mut green = Output::new(p.P2_1, Level::High, DriveStrength::Normal, SlewRate::Slow);
    let blue = Output::new(p.P2_2, Level::High, DriveStrength::Normal, SlewRate::Slow);
    spawner.spawn(unwrap!(heartbeat_task(blue)));

    // Enable both AM26LV32E receivers (G high, ~G low).
    let _rx_enable = Output::new(p.P3_12, Level::High, DriveStrength::Normal, SlewRate::Slow);
    let _rx_enable_n = Output::new(p.P3_11, Level::Low, DriveStrength::Normal, SlewRate::Slow);

    // Three matching samples of the 90MHz bus clock divided by 2: rejects
    // glitches shorter than ~67ns while allowing edge rates up to ~7MHz.
    let qdc_config = |reverse| {
        let mut c = eqdc::Config::default();
        c.filter_period = 2;
        c.filter_count = 0;
        c.reverse = reverse;
        c
    };
    let mut encoders = Encoders::new(
        unwrap!(Eqdc::new_with_index(
            p.EQDC0,
            p.P3_10,
            p.P3_9,
            p.P3_8,
            qdc_config(LEFT_REVERSED)
        )),
        unwrap!(Eqdc::new_with_index(
            p.EQDC1,
            p.P3_7,
            p.P1_1,
            p.P1_0,
            qdc_config(RIGHT_REVERSED)
        )),
    );
    info!(
        "encoder inputs: left {} right {}",
        encoders.left.inputs(),
        encoders.right.inputs()
    );

    let driver = unwrap!(usb::Driver::new(p.USB0, Irqs, usb::Config::default()));

    let mut config = embassy_usb::Config::new(USB_VID, USB_PID);
    config.manufacturer = Some("LUCI");
    config.product = Some("Quadrature Encoder Interface");
    config.max_power = 100;
    config.max_packet_size_0 = 64;

    static STATE: StaticCell<State> = StaticCell::new();
    static CONFIG_DESC: StaticCell<[u8; 256]> = StaticCell::new();
    static BOS_DESC: StaticCell<[u8; 256]> = StaticCell::new();
    static CONTROL_BUF: StaticCell<[u8; 64]> = StaticCell::new();
    let mut builder = Builder::new(
        driver,
        config,
        &mut CONFIG_DESC.init([0; 256])[..],
        &mut BOS_DESC.init([0; 256])[..],
        &mut [],
        &mut CONTROL_BUF.init([0; 64])[..],
    );
    let class = CdcAcmClass::new(&mut builder, STATE.init(State::new()), 64);
    let (mut tx, rx) = class.split();
    spawner.spawn(unwrap!(usb_task(builder.build())));
    spawner.spawn(unwrap!(discard_rx_task(rx)));

    loop {
        red.set_low();
        green.set_high();
        tx.wait_connection().await;
        info!("USB configured");
        red.set_high();
        green.set_low();

        stream(&mut tx, &mut encoders).await;
        info!("USB disconnected");
    }
}

/// Send a data frame every [`REPORT_PERIOD`], preceded by an error frame when
/// an encoder lost its signal, until the USB interface goes away.
///
/// Like the Arduino board, frames are sent whether or not the host has
/// asserted DTR.
async fn stream(tx: &mut Sender<'static, UsbDriver>, encoders: &mut Encoders) {
    let mut ticker = Ticker::every(REPORT_PERIOD);
    loop {
        ticker.next().await;
        let now_ms = Instant::now().as_millis() as u32;
        if let Some(frame) = encoders.error_frame(now_ms)
            && !send(tx, &mut ticker, &frame).await
        {
            return;
        }
        if !send(tx, &mut ticker, &encoders.frame(now_ms)).await {
            return;
        }
    }
}

/// Send one frame. Returns `false` once the USB interface has gone away.
async fn send(tx: &mut Sender<'static, UsbDriver>, ticker: &mut Ticker, frame: &[u8]) -> bool {
    match with_timeout(WRITE_TIMEOUT, tx.write_packet(frame)).await {
        Ok(Ok(())) => {}
        // The timeout is longer than the period: drop the missed ticks
        // instead of sending a burst of stale frames once the host reads.
        Err(_) => ticker.reset(),
        Ok(Err(EndpointError::Disabled)) => return false,
        Ok(Err(EndpointError::BufferOverflow)) => warn!("frame larger than max packet size"),
    }
    true
}
