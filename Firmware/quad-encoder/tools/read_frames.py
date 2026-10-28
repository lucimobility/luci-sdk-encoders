#!/usr/bin/env python3
"""Print the LUCI encoder frames streamed by the quad-encoder board.

Usage: read_frames.py [/dev/ttyACM0]

Requires pyserial (`pip install pyserial`).
"""

import struct
import sys
import time

import serial

DATA_TAG = b"+AR NCDR="
ERROR_TAG = b"+AR ENER="
DATA_LEN = 29
ERROR_LEN = 14


def main() -> None:
    port = sys.argv[1] if len(sys.argv) > 1 else "/dev/ttyACM0"
    buf = bytearray()
    frames = 0
    started = time.monotonic()
    last_ts = None

    with serial.Serial(port, 115200, timeout=0.1) as ser:
        while True:
            buf += ser.read(256)
            while True:
                data = buf.find(DATA_TAG)
                err = buf.find(ERROR_TAG)
                starts = [i for i in (data, err) if i >= 0]
                if not starts:
                    del buf[: max(0, len(buf) - len(DATA_TAG))]
                    break
                start = min(starts)
                length = DATA_LEN if start == data else ERROR_LEN
                if len(buf) - start < length:
                    del buf[:start]
                    break
                frame = bytes(buf[start : start + length])
                del buf[: start + length]

                if length == DATA_LEN:
                    left, right = struct.unpack_from("<ii", frame, 9)
                    (ts,) = struct.unpack_from("<I", frame, 25)
                    dt = "" if last_ts is None else f" dt={ts - last_ts}ms"
                    last_ts = ts
                    frames += 1
                    rate = frames / max(time.monotonic() - started, 1e-6)
                    print(
                        f"t={ts}ms left={left / 100:7.2f}deg right={right / 100:7.2f}deg"
                        f"{dt} ({rate:5.1f} Hz)"
                    )
                else:
                    code = frame[9]
                    (ts,) = struct.unpack_from("<I", frame, 10)
                    print(f"t={ts}ms ERROR 0x{code:02x}")


if __name__ == "__main__":
    main()
