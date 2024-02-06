#include <Wire.h>
#include <AS5600.h>
AS5600 encoder;

#define TCAADDR 0x70

#define LEFT_WHEEL 1
#define RIGHT_WHEEL 4
#define FL_CASTOR 0
#define BL_CASTOR 2
#define FR_CASTOR 5
#define BR_CASTOR 3

// Buffer to be sent over serial that luci sensors receives and parses
// Luci sensors is looking for the tag "+AR NCDR="
byte buf[25] = {'+', 'A', 'R', ' ', 'N', 'C', 'D', 'R', '=', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

void tcaselect(uint8_t i)
{
    if (i > 7)
    {
        return;
    }
    Wire.beginTransmission(TCAADDR);
    Wire.write(1 << i);
    Wire.endTransmission();
}

void setup()
{
    Serial.begin(9600);
    Wire.begin();
    tcaselect(1);

    if (!encoder.detectMagnet())
    {
        while (true)
        {
            if (encoder.detectMagnet())
            {
                encoder.readMagnitude();
                break;
            }
            delay(1000);
        }
    }
}

float convertRawAngleToDegrees(unsigned int newAngle)
{
    // 360 degrees / 4096 unique readings = 0.087890625
    // Karl's multiplier = 13/31
    // 0.087890625 * Karl's multiplier = 0.0368573589
    float ang = newAngle * 0.037;

    return ang;
}

void loop()
{
    // Get the data from all 6 encoders
    // Switch the decimal to the right by 2 for both wheel angles in order to send over
    // a long that includes wheel angle precision to the hundredth of a degree
    tcaselect(LEFT_WHEEL);
    long leftWheelAng = long(convertRawAngleToDegrees(encoder.rawAngle()) * 100);
//    Serial.print("Left ");
//    Serial.println(leftWheelAng);
    tcaselect(RIGHT_WHEEL);
    long rightWheelAng = long(convertRawAngleToDegrees(encoder.rawAngle()) * 100);
//    Serial.print("Right ");
//    Serial.println(rightWheelAng);
    tcaselect(FL_CASTOR);
    int front_left_castor = int(convertRawAngleToDegrees(encoder.rawAngle()));
    tcaselect(BL_CASTOR);
    int back_left_castor = int(convertRawAngleToDegrees(encoder.rawAngle()));
    tcaselect(FR_CASTOR);
    int front_right_castor = int(convertRawAngleToDegrees(encoder.rawAngle()));
    tcaselect(BR_CASTOR);
    int back_right_castor = int(convertRawAngleToDegrees(encoder.rawAngle()));

    // Prepare the buffer to be sent over serial to luci sensors
    // [ 1 - 9     | 10 11 12 13 | 14 15 16 17 | 18 19 | 20 21 | 22 23 | 24 25 ]
    // [ +AR NCDR= | LEFT W      | Right W     | FL    | BL    | FR    | BR    ]
    buf[9] = leftWheelAng;
    buf[10] = leftWheelAng >> 8;
    buf[11] = leftWheelAng >> 16;
    buf[12] = leftWheelAng >> 24;

    buf[13] = rightWheelAng;
    buf[14] = rightWheelAng >> 8;
    buf[15] = rightWheelAng >> 16;
    buf[16] = rightWheelAng >> 24;

    buf[17] = front_left_castor;
    buf[18] = front_left_castor >> 8;

    buf[19] = back_left_castor;
    buf[20] = back_left_castor >> 8;

    buf[21] = front_right_castor;
    buf[22] = front_right_castor >> 8;

    buf[23] = back_right_castor;
    buf[24] = back_right_castor >> 8;

    int bytesWritten = Serial.write(buf, sizeof(buf));

    delay(50);
}
