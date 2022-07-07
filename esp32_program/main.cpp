#include <ESP32Servo.h>
#include "BluetoothSerial.h"
Servo myservo; // create servo object to control a servo
// 16 servo objects can be created on the ESP32
Servo myservo2;
int posservo1 = 25; // variable to store the servo position
int posservo2 = 25;
// Recommended PWM GPIO pins on the ESP32 include 2,4,12-19,21-23,25-27,32-33
int servoPin = 23;
int servoPin2 = 22;
String btmsg;
BluetoothSerial SerialBT;
char sendBuffer[256];

void setup()
{
	Serial.begin(115200);
	SerialBT.begin("Robot Control Esp32");
	Serial.println("ESP32 Bluetooth Serial Test pronto para iniciar");

	// Allow allocation of all timers
	ESP32PWM::allocateTimer(0);
	ESP32PWM::allocateTimer(1);
	ESP32PWM::allocateTimer(2);
	ESP32PWM::allocateTimer(3);
	myservo2.attach(servoPin2, 500, 2000); // attaches the servo on pin D5 to the servo object
	myservo2.setPeriodHertz(50);
	// attaches the servo on pin 23 to the servo object
	myservo.setPeriodHertz(50);			 // standard 50 hz servo
	myservo.attach(servoPin, 500, 2400); // attaches the servo on pin 18 to the servo object
										 // using default min/max of 1000us and 2000us
										 // different servos may require different min/max settings
										 // for an accurate 0 to 180 sweep
}
String Bluemsg()
{
	btmsg = "";
	while (SerialBT.available())
	{
		btmsg += (char)SerialBT.read();
	}
	return btmsg;
}

void loop()
{
	while (SerialBT.available())
	{
		btmsg = Bluemsg();
		Serial.println("mensagem recebida: " + btmsg);
		// up , down , left , right , stop
		if (btmsg == "u")
		{	posservo2 += 20;
			myservo2.write(posservo2);
		}
		if (btmsg == "d")
		{	posservo2 -= 20;
			myservo2.write(posservo2);
		}
		if (btmsg == "l")
		{	posservo1 += 20;
			myservo.write(posservo1);
		}
		if (btmsg == "r")
		{	posservo1 -= 20;
			myservo.write(posservo1);
		}
		if (btmsg == "s")
		{	posservo1 = 25;
			posservo2 = 25;
			myservo.write(posservo1);
			myservo2.write(posservo2);
		}
	}
}