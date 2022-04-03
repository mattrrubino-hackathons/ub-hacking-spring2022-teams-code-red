#include <Servo.h>

Servo servo;

int pirPin = 2;
int motorPin = 4;
int stat;
int enabled;
int triggered;

void setup() {
  pinMode(pirPin, INPUT);
  pinMode(motorPin, OUTPUT);
  servo.attach(motorPin);
  Serial.begin(9600);
  servo.write(90);
}

void loop() {
  int state = digitalRead(pirPin);

  if (enabled && !triggered && stat == LOW && state == HIGH) {
    Serial.write(1);
  }
  stat = state;
  
  if (Serial.available() > 0) {
    int b = Serial.read();

    if (b == 'a' || b == 'b') {
      enabled = b == 'a';
    } else if (b == 'c' || b == 'd') {
      triggered = b == 'c';
    }
  }

  if (enabled && triggered) {
    servo.write(180);
  } else {
    servo.write(90);
  }
  delay(100);
}
