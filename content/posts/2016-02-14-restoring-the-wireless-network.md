---
date: 2016-02-14T17:41:33-05:00
title: Restoring the wireless network
---

I have been started to slowly try to restore both the wireless network I used to have and most important: the knowledge used to develop/maintain it.

It's truly another example on how notes and backups can save your life.

Anyway, I managed to have a good working sensor reporting nice data to the zigbee coordinator:

{{< image "/images/blogs/sample-rf-data-20160209.png" >}}

    TC1:20.00;TF1:68.00;P:98194;H1:25.50;TC2:20.20;LG:50

Which means:

+ TC1: temperature measured by a BMP085 from Adafruit (in Celcius)
+ TF1: the same temperature than above but in F
+ P: the pressure from the BMP085 in Pa
+ H1: the humidity measured by a DHT22 from Adafruit (in %)
+ TC2: the temperature measured by the same DHT22 (in C)
+ LG: a simple light level measured by a photoresistor (1024 being total darkness, 0 the maximum light)

Then I left the sensor run for a while and plotted by hand the light level as the sun was rising on a morning, and it's rather what you should expect (with a measure done every minute or so):

{{< image "/images/blogs/light-level-morning-20160210.png" >}}

It's good to restore such abilities. I will document further more both the zigbee setup and the sensor one. The data themselves were collected via a simple erlang program that is decoding the zigbee API packets and dump the body on the stdout (will publish it as well).

~Nicolas
