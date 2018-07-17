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

///* Calibration register globals for Accel and Gyro*/
//byte calARL = 0;
//byte calARM = 0;
//byte calAOXL = 0;
//byte calAOXM = 0;
//byte calAOYL = 0;
//byte calAOYM = 0;
//byte calAOZL = 0;
//byte calAOZM = 0;
//
//byte calGOXL = 0;
//byte calGOXM = 0;
//byte calGOYL = 0;
//byte calGOYM = 0;
//byte calGOZL = 0;
//byte calGOZM = 0;

void setup(void)
{
  Serial.begin(115200);

  /* Initialize the sensor and check its status */
  if(!bno.begin(bno.OPERATION_MODE_IMUPLUS))
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }

  delay(1000);

  /* Set calibration parameters */
  bno.setMode(bno.OPERATION_MODE_CONFIG);
  delay(25);
  bno.setCalvalARL(-24);
  bno.setCalvalARM(3);
  bno.setCalvalAOXL(-17);
  bno.setCalvalAOXM(-1);
  bno.setCalvalAOYL(3);
  bno.setCalvalAOYM(0);
  bno.setCalvalAOZL(-21);
  bno.setCalvalAOZM(-1);
  bno.setCalvalGOXL(-1);
  bno.setCalvalGOXM(-1);
  bno.setCalvalGOYL(-1);
  bno.setCalvalGOYM(-1);
  bno.setCalvalGOZL(0);
  bno.setCalvalGOZM(0);
  bno.setMode(bno.OPERATION_MODE_IMUPLUS);
  delay(25);

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

  /* Display calibration data to record for later */
//  bno.setMode(bno.OPERATION_MODE_CONFIG);
//  Serial.println(bno.getCalvalARL());
//  Serial.println(bno.getCalvalARM());
//  Serial.println(bno.getCalvalAOXL());
//  Serial.println(bno.getCalvalAOXM());
//  Serial.println(bno.getCalvalAOYL());
//  Serial.println(bno.getCalvalAOYM());
//  Serial.println(bno.getCalvalAOZL());
//  Serial.println(bno.getCalvalAOZM());
//  Serial.println(bno.getCalvalGOXL());
//  Serial.println(bno.getCalvalGOXM());
//  Serial.println(bno.getCalvalGOYL());
//  Serial.println(bno.getCalvalGOYM());
//  Serial.println(bno.getCalvalGOZL());
//  Serial.println(bno.getCalvalGOZM());
//  bno.setMode(bno.OPERATION_MODE_IMUPLUS);  
  
  delay(BNO055_SAMPLERATE_DELAY_MS);
}
