---
date: 2016-02-01T07:54:06-05:00
project_icon: wireless_sensor.png
project_type: Hardware
title: Wireless Sensor
started: 2011
desc: An ongoing project to create a network of wireless sensors reporting temperature/humidity/etc inside/outside.
weight: 10
unmaintained: false
---

The idea is to create a network of simple wireless sensors reporting mostly the temperature, humidity and pressure (or even light).

The first step was to create to a small prototype:

{{< image "/images/projects/sensor_version_v1.jpg" >}}

The vision is the following:

{{< image "/images/projects/vision.png" >}}

With: 

1. Zigbee Wireless sensor in Router mode
2. Zigbee Coordinator connected to a linux machine
3. linux machine on which the gateway (ZGate) is runnging in order to process the zigbee packets and storing the final result into a Barrel-DB node
4. DX is a project to come: basically a way to assign / post-process / visualize the data
5. An optional replication stream into a cloud node for anything not too private.

**TODO**: add the BOM, code, repo url, schema.
