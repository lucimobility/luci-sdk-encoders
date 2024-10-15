#include <AS5600.h>
#include <Wire.h>
AS5600 encoder;

#define TCAADDR 0x70

#define LEFT_WHEEL 1
#define RIGHT_WHEEL 4

unsigned long timestamp;

// Buffer to be sent over serial that luci sensors receives and parses
// Luci sensors is looking for the tag "+AR NCDR="
byte buf[29] = {'+', 'A', 'R', ' ', 'N', 'C', 'D', 'R', '=', 0, 0, 0, 0, 0, 0,
                0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 0, 0, 0,0};

void tcaselect(uint8_t i) {
  if (i > 7) {
    return;
  }
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();
}

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    // Wait for serial connection to be established
  };

  Wire.begin();
  // Add delay for things to settle
  delay(1000);
}

float convertRawAngleToDegrees(unsigned int newAngle) {
  // 360 degrees / 4096 unique readings = 0.087890625
  float ang = newAngle * 0.087890625;
  return ang;
}

void loop() {

  // Time since arduino booted up
  timestamp = millis();
  // If the encoder loses the magnet it will send 0.0 for that wheel angle
  // reading
  long leftWheelAng = 0.0;
  long rightWheelAng = 0.0;
  // Get the data from both encoders
  // Switch the decimal to the right by 2 for both wheel angles in order to send
  // over a long that includes wheel angle precision to the hundredth of a
  // degree
  tcaselect(LEFT_WHEEL);
  if (encoder.detectMagnet()) {
    leftWheelAng = long(convertRawAngleToDegrees(encoder.rawAngle()) * 100);
  }

  tcaselect(RIGHT_WHEEL);
  if (encoder.detectMagnet()) {
    rightWheelAng = long(convertRawAngleToDegrees(encoder.rawAngle()) * 100);
  }
  // Prepare the buffer to be sent over serial to luci sensors
  // The casters are empty in the buffer since we only are using drive motors
  // [ 1 - 9     | 10 11 12 13 | 14 15 16 17 | 18 19 | 20 21 | 22 23 | 24 25 |
  // 26 27 28 29 ] [ +AR NCDR= | LEFT W      | Right W     | FL    | BL    | FR
  // | BR    | edge timestamp ]
  buf[9] = leftWheelAng;
  buf[10] = leftWheelAng >> 8;
  buf[11] = leftWheelAng >> 16;
  buf[12] = leftWheelAng >> 24;

  buf[13] = rightWheelAng;
  buf[14] = rightWheelAng >> 8;
  buf[15] = rightWheelAng >> 16;
  buf[16] = rightWheelAng >> 24;

  buf[25] = timestamp;
  buf[26] = timestamp >> 8;
  buf[27] = timestamp >> 16;
  buf[28] = timestamp >> 24;

  int bytesWritten = Serial.write(buf, sizeof(buf));

  delay(10); // Max out at 100Hz
}
