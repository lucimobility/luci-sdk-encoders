#include <AS5600.h>
#include <Wire.h>
AS5600 encoder;

#define TCAADDR 0x70
#define AS5600_ADDRESS 0x36
#define AS5600_STATUS_REG 0x0B

#define LEFT_WHEEL 1
#define RIGHT_WHEEL 4

unsigned long timestamp;
unsigned long lastErrorTime = 0;

// Error codes
// TCA9548A I2C Multiplexer errors (0x01-0x02)
#define ERROR_TCA_INVALID_CHANNEL              0x01  // Channel number > 7
#define ERROR_TCA_NO_ACK                       0x02  // TCA9548A not responding to I2C address

// AS5600 Magnet Detection errors (0x03-0x06)
#define ERROR_LEFT_MAGNET_NOT_DETECTED         0x03  // Left encoder: magnet not detected or too weak
#define ERROR_RIGHT_MAGNET_NOT_DETECTED        0x04  // Right encoder: magnet not detected or too weak
#define ERROR_BOTH_MAGNETS_NOT_DETECTED        0x05  // Both encoders: magnets not detected

// AS5600 I2C Communication errors (0x06-0x09)
#define ERROR_LEFT_ENCODER_NO_ACK              0x06  // Left AS5600 not ACKing I2C address 0x36
#define ERROR_RIGHT_ENCODER_NO_ACK             0x07  // Right AS5600 not ACKing I2C address 0x36
#define ERROR_BOTH_ENCODERS_NO_ACK             0x08  // Both AS5600s not ACKing I2C address 0x36

// AS5600 Angle Reading errors (0x0C-0x0F)
#define ERROR_LEFT_ANGLE_OUT_OF_RANGE          0x09  // Left encoder angle > 4095 (invalid)
#define ERROR_RIGHT_ANGLE_OUT_OF_RANGE         0x0A  // Right encoder angle > 4095 (invalid)
#define ERROR_BOTH_ANGLES_OUT_OF_RANGE         0x0B  // Both encoder angles > 4095 (invalid)

// Configuration constants
#define ERROR_COOLDOWN_MS 1000                       // Minimum time between error messages

// Encoder status tracking for consolidated error reporting
enum EncoderStatus {
  ENCODER_OK = 0,
  ENCODER_NO_ACK,
  ENCODER_MAGNET_NOT_DETECTED,
  ENCODER_ANGLE_OUT_OF_RANGE
};

// Buffer to be sent over serial that luci sensors receives and parses
// Luci sensors is looking for the tag "+AR NCDR="
// Buffer layout:
//    [ +AR NCDR= | LEFT W | Right W | FL   | BL   | FR   | BR   | edge timestamp ]
//    [0-8        |9-12    |13-16    |17-18 |19-20 |21-22 |23-24 |25-28           ]
byte buf[29] = {'+', 'A', 'R', ' ', 'N', 'C', 'D', 'R', '=', 
                0, 0, 0, 0,     // Left wheel (bytes 9-12)
                0, 0, 0, 0,     // Right wheel (bytes 13-16)
                0, 0,           // FL caster angle - unused (bytes 17-18)
                0, 0,           // BL caster angle - unused (bytes 19-20)
                0, 0,           // FR caster angle - unused (bytes 21-22)
                0, 0,           // BR caster angle - unused (bytes 23-24)
                0, 0, 0, 0};    // Timestamp in milliseconds (bytes 25-28)

// Error buffer with different tag "+AR ENER="
// Buffer layout:
//    [ +AR ENER= | ERROR_CODE | TIMESTAMP]
//    [0-8        |9           |10-13     ]
byte errorBuf[14] = {'+', 'A', 'R', ' ', 'E', 'N', 'E', 'R', '=',
                     0,             // Error code (byte 9)
                     0, 0, 0, 0};    // Timestamp (bytes 10-13)

/**
 * Send error code to Luci sensors with timestamp
 * Implements cooldown to prevent error spam
 * @param errorCode - One of the ERROR_* constants defined above
 */
void sendError(uint8_t errorCode) {
  
  unsigned long currentTime = millis();

  // Implement error cooldown to prevent spam
  if (currentTime - lastErrorTime < ERROR_COOLDOWN_MS) {
    return;
  }

//  Serial.print("Error: ");
//  Serial.println(errorCode);
  
  lastErrorTime = currentTime;
  
  // Set error code
  errorBuf[9] = errorCode;
  
  // Set timestamp (4 bytes)
  errorBuf[10] = currentTime;
  errorBuf[11] = currentTime >> 8;
  errorBuf[12] = currentTime >> 16;
  errorBuf[13] = currentTime >> 24;
  
  // Send error packet
  Serial.write(errorBuf, sizeof(errorBuf));
}

/**
 * Send consolidated error based on both encoder statuses
 * Only sends error if both encoders have the same issue, or individual errors if different
 * @param leftStatus - Status of left encoder
 * @param rightStatus - Status of right encoder
 */
void sendConsolidatedError(EncoderStatus leftStatus, EncoderStatus rightStatus) {
  // If both encoders have the same problem, send consolidated error
  if (leftStatus == rightStatus && leftStatus != ENCODER_OK) {
    switch (leftStatus) {
      case ENCODER_NO_ACK:
        sendError(ERROR_BOTH_ENCODERS_NO_ACK);
        break;
      case ENCODER_MAGNET_NOT_DETECTED:
        sendError(ERROR_BOTH_MAGNETS_NOT_DETECTED);
        break;
      case ENCODER_ANGLE_OUT_OF_RANGE:
        sendError(ERROR_BOTH_ANGLES_OUT_OF_RANGE);
        break;
      default:
        break;
    }
  } else {
    // Send individual errors for each encoder if different problems or only one failing
    if (leftStatus == ENCODER_NO_ACK) {
      sendError(ERROR_LEFT_ENCODER_NO_ACK);
    } else if (leftStatus == ENCODER_MAGNET_NOT_DETECTED) {
      sendError(ERROR_LEFT_MAGNET_NOT_DETECTED);
    } else if (leftStatus == ENCODER_ANGLE_OUT_OF_RANGE) {
      sendError(ERROR_LEFT_ANGLE_OUT_OF_RANGE);
    }
    
    if (rightStatus == ENCODER_NO_ACK) {
      sendError(ERROR_RIGHT_ENCODER_NO_ACK);
    } else if (rightStatus == ENCODER_MAGNET_NOT_DETECTED) {
      sendError(ERROR_RIGHT_MAGNET_NOT_DETECTED);
    } else if (rightStatus == ENCODER_ANGLE_OUT_OF_RANGE) {
      sendError(ERROR_RIGHT_ANGLE_OUT_OF_RANGE);
    }
  }
}

/**
 * Select channel on TCA9548A I2C multiplexer
 * Each AS5600 encoder is on a different channel to avoid I2C address conflicts
 * @param i - Channel number (0-7), corresponds to encoder position
 */
void tcaselect(uint8_t i) {
  if (i > 7) {
    sendError(ERROR_TCA_INVALID_CHANNEL);
    return;
  }

  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  uint8_t result = Wire.endTransmission();

  if (result != 0) {
    // TCA9548A failed to ACK - multiplexer communication problem
    sendError(ERROR_TCA_NO_ACK);
  }
}

/**
 * Test if AS5600 encoder is responding on I2C bus
 * Performs a basic I2C transaction to verify encoder presence and communication
 * @param channel - TCA9548A channel number where encoder is connected
 * @return true if encoder responds properly, false if communication fails
 */
bool testEncoderI2C(uint8_t channel) {
  tcaselect(channel);
  delay(1);
  
  // Attempt to write to AS5600 status register
  Wire.beginTransmission(AS5600_ADDRESS);
  Wire.write(AS5600_STATUS_REG);
  uint8_t transmissionResult = Wire.endTransmission();
  
  if (transmissionResult != 0) {
    // AS5600 is not ACKing
    return false;
  }
  
 // Attempt to read back one byte from the status register
  uint8_t bytesReceived = Wire.requestFrom(AS5600_ADDRESS, 1);
  if (bytesReceived != 1) {
    // AS5600 ACK'd the address but didn't send data back
    // This indicates a communication timeout or device hang
    return false;
  }
  
  Wire.read(); // Clear the received byte
  return true;
}

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    // Wait for serial connection to be established
  };

  Wire.begin();

  // Test TCA multiplexer first
  Wire.beginTransmission(TCAADDR);
  uint8_t tcaResult = Wire.endTransmission();
  if (tcaResult != 0) {
    sendError(ERROR_TCA_NO_ACK);
    // Continue anyway in case it recovers
  }

  // Test both encoder channels with consolidated error reporting
  EncoderStatus leftStatus = ENCODER_OK;
  EncoderStatus rightStatus = ENCODER_OK;

  // Test left encoder
  if (testEncoderI2C(LEFT_WHEEL)) {
    tcaselect(LEFT_WHEEL);
    delay(10);
    if (!encoder.detectMagnet()) {
      leftStatus = ENCODER_MAGNET_NOT_DETECTED;
    }
  } else {
    leftStatus = ENCODER_NO_ACK;
  }
  
  // Test right encoder
  if (testEncoderI2C(RIGHT_WHEEL)) {
    tcaselect(RIGHT_WHEEL);
    delay(10);
    if (!encoder.detectMagnet()) {
      rightStatus = ENCODER_MAGNET_NOT_DETECTED;
    }
  } else {
    rightStatus = ENCODER_NO_ACK;
  }
  
  // Send consolidated error report for startup issues
  sendConsolidatedError(leftStatus, rightStatus);
  
  // Add delay for things to settle
  delay(1000);
}

/**
 * Check if raw angle reading is within AS5600's valid range
 * AS5600 returns 12-bit values (0-4095) for valid readings
 * @param rawAngle - Raw angle value from encoder
 * @return true if angle is valid, false if out of range
 */
bool isAngleValid(unsigned int rawAngle) {
  return (rawAngle <= 4095);
}

/**
 * Convert AS5600 raw angle (0-4095) to degrees (0-360)
 * @param newAngle - Raw 12-bit angle value from AS5600
 * @return Angle in degrees as floating point
 */
float convertRawAngleToDegrees(unsigned int newAngle) {
  // 360 degrees / 4096 unique readings = 0.087890625
  float ang = newAngle * 0.087890625;
  return ang;
}

/**
 * Read angle from specified encoder with comprehensive error checking
 * @param channel - TCA9548A channel number for the encoder
 * @param angleResult - Pointer to store the angle result (in centidegrees)
 * @param status - Pointer to store the encoder status for consolidated error reporting
 * @return true if reading successful, false if any error occurred
 */
bool readEncoder(uint8_t channel, long* angleResult, EncoderStatus* status) {
  *status = ENCODER_OK;  // Initialize to OK
  
  // First verify that encoder is still responding on I2C bus
  if (!testEncoderI2C(channel)) {
    *status = ENCODER_NO_ACK;
    return false;
  }

  tcaselect(channel);
  delay(1); // Small delay for multiplexer switching
  
  // Check if magnet is still detected
  if (!encoder.detectMagnet()) {
    *status = ENCODER_MAGNET_NOT_DETECTED;
    return false;
  }
  
  unsigned int rawAngle = encoder.rawAngle();

  // Validate that angle reading is within expected range
  if (!isAngleValid(rawAngle)) {
    *status = ENCODER_ANGLE_OUT_OF_RANGE;
    return false;
  }
  
  float degrees = convertRawAngleToDegrees(rawAngle);

  // Convert to centidegrees (degrees * 100) for transmission
  // This preserves precision to the hundredth of a degree as integer
  *angleResult = long(degrees * 100);
  return true;
}

void loop() {
  // Time since arduino booted up
  timestamp = millis();
  
  // Initialize angle readings to zero
  long leftWheelAng = 0;
  long rightWheelAng = 0;
  
  // Track encoder statuses for consolidated error reporting
  EncoderStatus leftStatus, rightStatus;
  
  // Attempt to read both encoders
  bool leftEncoderValid = readEncoder(LEFT_WHEEL, &leftWheelAng, &leftStatus);
  bool rightEncoderValid = readEncoder(RIGHT_WHEEL, &rightWheelAng, &rightStatus);

  // Send consolidated error report if either encoder has issues
  if (!leftEncoderValid || !rightEncoderValid) {
    sendConsolidatedError(leftStatus, rightStatus);
  }

  // Only send data if BOTH encoders have valid readings with magnets detected
  if (leftEncoderValid && rightEncoderValid) {
    // Prepare the buffer to be sent over serial to luci sensors
    // Note: Caster angles are not used in this application (drive wheels only)

    // Left wheel angle (4 bytes)
    buf[9] = leftWheelAng;
    buf[10] = leftWheelAng >> 8;
    buf[11] = leftWheelAng >> 16;
    buf[12] = leftWheelAng >> 24;

    // Right wheel angle (4 bytes)
    buf[13] = rightWheelAng;
    buf[14] = rightWheelAng >> 8;
    buf[15] = rightWheelAng >> 16;
    buf[16] = rightWheelAng >> 24;

    // Caster angles remain 0 (bytes 17-24)

    // Timestamp (4 bytes)
    buf[25] = timestamp;
    buf[26] = timestamp >> 8;
    buf[27] = timestamp >> 16;
    buf[28] = timestamp >> 24;

    Serial.write(buf, sizeof(buf));
  }

  // Run at maximum 100Hz (10ms delay)
  delay(10);
}
