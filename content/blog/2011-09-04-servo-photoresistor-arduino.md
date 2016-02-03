---
date: 2011-09-04T00:00:00Z
title: How to couple a servo to a photo-resistor on an Arduino board
---

After using the great examples provided in the Arduino kit, I decided to create my own circuit (nothing very fancy) by combining 2 examples and see if it's going to work.

So I first draw the schema:

{{< image "/images/blogs/servo_photoresistor2_schem.png" >}}

Components:

 - 10k ohms resistor (R1)
 - photo-resistor (LDR)
 - Servo motor (Servo)
 - Arduino UNO or alike

Then tested it. And it worked the first time :)

Pretty nice to see the servo moving when the light goes down or up.

{{< youtube SkFT8sQVbG4 >}}

Here is the code I'm using:

{{< highlight cpp >}}
#include <Servo.h>    
Servo myservo;
int pos = 0;
int lightPin = 0;

void setup() {
  // attach the pin 9 to the servo
  myservo.attach(9);
}

void loop() {
  // read the current voltage at lightPin (0) 
  int lightLevel = analogRead(lightPin); 
  
  // make sure to constrain the value from 0 to 360 
  // this analog pin has 1024 values (10 bits)
  lightLevel = map(lightLevel, 0, 1023, 0, 359);
  pos = constrain(lightLevel, 0, 359);
  
  // finally set the servo angle
  myservo.write(pos);
  delay(100);
}
{{< / highlight >}}

I guess now it's time to create something more complex! :-)

**Update - 2011/09/07**:

I'm adding also the breadboard view made with [Fritzing](http://fritzing.org/):


{{< image "/images/blogs/servo_photoresistor2_bb.png" >}}

I have also fixed the source to take account that the analog pin is encoded with 10 bits and therefore goes from 0 to 1023.

The resistance R1 is actually 10k ohms and not 330 ... sorry about that.
