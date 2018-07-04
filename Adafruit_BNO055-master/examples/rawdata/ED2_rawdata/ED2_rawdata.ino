#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

/* This driver reads raw data from the BNO055 */

/* Set the delay between fresh samples */
#define BNO055_SAMPLERATE_DELAY_MS (100)

/* Create sensor object */
Adafruit_BNO055 bno = Adafruit_BNO055();

/* Create calibration/quaternion array */
float quatCalArray[] = {1, 0, 0, 0, 0, 0, 0, 0};

/* Calibration flag */
bool calibrated = false;

void setup(void)
{
  Serial.begin(115200);

  /* Initialize the sensor and check its status */
  if(!bno.begin(0X08))
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }

  delay(1000);

  /* Adafruit recommendation for low power performance, external crystal may not be needed */
  bno.setExtCrystalUse(true);
}

void loop(void)
{

  /* Grab calibration */
  uint8_t system, gyro, accel, mag = 0;
  bno.getCalibration(&system, &gyro, &accel, &mag);

//  if ((system == 3) && (gyro == 3) && (accel == 3) && (mag == 3))
//  {
//    calibrated = true;
//  }
//
//  if (calibrated)
//  {
//    /* Grab quaternion */
//    imu::Quaternion quat = bno.getQuat();
//  
//    /* Assign each axis and w */
//    quatCalArray[0] = quat.w();
//    quatCalArray[1] = quat.x();
//    quatCalArray[2] = quat.y();
//    quatCalArray[3] = quat.z();
//  }

  /* Grab quaternion */
  imu::Quaternion quat = bno.getQuat();
  
  /* Assign each axis and w */
  quatCalArray[0] = quat.w();
  quatCalArray[1] = quat.x();
  quatCalArray[2] = quat.y();
  quatCalArray[3] = quat.z();

  /* Assign each sensor calibration */
  quatCalArray[4] = system;
  quatCalArray[5] = gyro;
  quatCalArray[6] = accel;
  quatCalArray[7] = mag;

  /* Serial transfer to Matlab */
  for (int i = 0; i < 8; i++)
  {
    Serial.print(quatCalArray[i]);
    Serial.print("\t");
  }
  Serial.print("\n");
  
  delay(BNO055_SAMPLERATE_DELAY_MS);
}
