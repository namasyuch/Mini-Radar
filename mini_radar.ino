#include <Servo.h>

Servo radarServo;

const int trigPin = 7;
const int echoPin = 6;
const int servoPin = 9;

void setup() {
  Serial.begin(9600);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  radarServo.attach(servoPin);
}

long getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);

  if (duration == 0) {
    return 0;
  }

  long distance = duration * 0.034 / 2;

  return distance;
}

void loop() {

  // Sweep right to left
  for (int angle = 180; angle >= 0; angle--) {
    radarServo.write(angle);

    delay(15);

    long distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);
  }

  // Sweep left to right
  for (int angle = 0; angle <= 180; angle++) {
    radarServo.write(angle);

    delay(15);

    long distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);
  }
}
