//! Serial framing understood by LUCI sensors.
//!
//! Byte-compatible with the frames sent by the AS5600 Arduino firmware in
//! `luci-sdk-encoders/Firmware/ams5600/ams5600.ino`. All multi-byte fields are
//! little endian.
//!
//! Data frame (29 bytes):
//!
//! | bytes | field                                   |
//! |-------|-----------------------------------------|
//! | 0-8   | `+AR NCDR=`                             |
//! | 9-12  | left wheel angle, centidegrees (i32)    |
//! | 13-16 | right wheel angle, centidegrees (i32)   |
//! | 17-24 | four caster angles (i16), unused, zero  |
//! | 25-28 | timestamp, milliseconds since boot (u32)|
//!
//! Error frame (14 bytes):
//!
//! | bytes | field                                   |
//! |-------|-----------------------------------------|
//! | 0-8   | `+AR ENER=`                             |
//! | 9     | error code                              |
//! | 10-13 | timestamp, milliseconds since boot (u32)|

#![no_std]

pub const DATA_TAG: &[u8; 9] = b"+AR NCDR=";
pub const ERROR_TAG: &[u8; 9] = b"+AR ENER=";

pub const DATA_FRAME_LEN: usize = 29;
pub const ERROR_FRAME_LEN: usize = 14;

/// Minimum time between two error frames.
pub const ERROR_COOLDOWN_MS: u32 = 1000;

/// The left encoder lost the magnetic signal.
pub const ERROR_LEFT_MAGNET_NOT_DETECTED: u8 = 0x03;
/// The right encoder lost the magnetic signal.
pub const ERROR_RIGHT_MAGNET_NOT_DETECTED: u8 = 0x04;
/// Both encoders lost the magnetic signal.
pub const ERROR_BOTH_MAGNETS_NOT_DETECTED: u8 = 0x05;

/// Error code for encoders that lost the magnetic signal, combined into a
/// single code when both did, like the AS5600 firmware.
pub fn magnet_error(left: bool, right: bool) -> Option<u8> {
    match (left, right) {
        (true, true) => Some(ERROR_BOTH_MAGNETS_NOT_DETECTED),
        (true, false) => Some(ERROR_LEFT_MAGNET_NOT_DETECTED),
        (false, true) => Some(ERROR_RIGHT_MAGNET_NOT_DETECTED),
        (false, false) => None,
    }
}

/// Centidegrees in one full revolution.
pub const CENTIDEGREES_PER_REV: i32 = 36_000;

/// Build a data frame from both wheel angles.
pub fn data_frame(left_centideg: i32, right_centideg: i32, timestamp_ms: u32) -> [u8; DATA_FRAME_LEN] {
    let mut frame = [0; DATA_FRAME_LEN];
    frame[0..9].copy_from_slice(DATA_TAG);
    frame[9..13].copy_from_slice(&left_centideg.to_le_bytes());
    frame[13..17].copy_from_slice(&right_centideg.to_le_bytes());
    frame[25..29].copy_from_slice(&timestamp_ms.to_le_bytes());
    frame
}

/// Build an error frame.
pub fn error_frame(code: u8, timestamp_ms: u32) -> [u8; ERROR_FRAME_LEN] {
    let mut frame = [0; ERROR_FRAME_LEN];
    frame[0..9].copy_from_slice(ERROR_TAG);
    frame[9] = code;
    frame[10..14].copy_from_slice(&timestamp_ms.to_le_bytes());
    frame
}

/// Convert an encoder count into the wheel angle within the current
/// revolution, in centidegrees (`0..36000`), truncating like the AS5600
/// firmware does.
///
/// `counts_per_rev` is the number of decoded (4x) counts per wheel
/// revolution and must be positive.
pub fn counts_to_centidegrees(count: i32, counts_per_rev: i32) -> i32 {
    let within_rev = count.rem_euclid(counts_per_rev) as i64;
    (within_rev * CENTIDEGREES_PER_REV as i64 / counts_per_rev as i64) as i32
}

/// Rate limit for error frames, matching the AS5600 firmware: an error is
/// sent only if [`ERROR_COOLDOWN_MS`] have passed since the last one, with
/// the first window starting at boot.
#[derive(Default)]
pub struct ErrorCooldown {
    last_ms: u32,
}

impl ErrorCooldown {
    pub const fn new() -> Self {
        Self { last_ms: 0 }
    }

    /// Returns whether an error may be sent now, and if so starts a new
    /// cooldown window.
    pub fn try_send(&mut self, now_ms: u32) -> bool {
        if now_ms.wrapping_sub(self.last_ms) < ERROR_COOLDOWN_MS {
            return false;
        }
        self.last_ms = now_ms;
        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn data_frame_layout() {
        let frame = data_frame(0x0102_0304, -2, 0xA0B0_C0D0);
        assert_eq!(&frame[..9], b"+AR NCDR=");
        assert_eq!(&frame[9..13], &[0x04, 0x03, 0x02, 0x01]);
        assert_eq!(&frame[13..17], &[0xFE, 0xFF, 0xFF, 0xFF]);
        assert_eq!(&frame[17..25], &[0; 8]);
        assert_eq!(&frame[25..29], &[0xD0, 0xC0, 0xB0, 0xA0]);
    }

    #[test]
    fn error_frame_layout() {
        let frame = error_frame(0x0B, 1234);
        assert_eq!(&frame[..9], b"+AR ENER=");
        assert_eq!(frame[9], 0x0B);
        assert_eq!(&frame[10..14], &1234u32.to_le_bytes());
    }

    #[test]
    fn angle_wraps_each_revolution() {
        assert_eq!(counts_to_centidegrees(0, 4096), 0);
        assert_eq!(counts_to_centidegrees(1024, 4096), 9000);
        assert_eq!(counts_to_centidegrees(4096, 4096), 0);
        assert_eq!(counts_to_centidegrees(4096 + 2048, 4096), 18000);
        assert_eq!(counts_to_centidegrees(-1024, 4096), 27000);
        assert_eq!(counts_to_centidegrees(i32::MIN, 4096), 0);
        assert_eq!(counts_to_centidegrees(4095, 4096), 35991);
    }

    #[test]
    fn angle_matches_as5600_scaling() {
        // The AS5600 firmware computes long(raw * 0.087890625 * 100).
        for raw in [0, 1, 7, 100, 2048, 4095] {
            let expected = (raw as f64 * 0.087890625 * 100.0) as i32;
            assert_eq!(counts_to_centidegrees(raw, 4096), expected);
        }
    }

    #[test]
    fn magnet_error_codes() {
        assert_eq!(magnet_error(false, false), None);
        assert_eq!(magnet_error(true, false), Some(0x03));
        assert_eq!(magnet_error(false, true), Some(0x04));
        assert_eq!(magnet_error(true, true), Some(0x05));
    }

    #[test]
    fn error_cooldown() {
        let mut cooldown = ErrorCooldown::new();
        assert!(!cooldown.try_send(500));
        assert!(cooldown.try_send(1000));
        assert!(!cooldown.try_send(1999));
        assert!(cooldown.try_send(2000));
        assert!(cooldown.try_send(u32::MAX));
        assert!(!cooldown.try_send(500));
        assert!(cooldown.try_send(1000));
    }
}
