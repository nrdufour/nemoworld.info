---
date: 2016-04-11T18:07:04-04:00
title: Basics
topics: Zigbee
---

As wikipedia states [nicely](https://en.wikipedia.org/wiki/ZigBee), "ZigBee is an IEEE 802.15.4-based specification for a suite of high-level communication protocols used to create personal area networks with small, low-power digital radios."

It's a rather simple way to transfer data from a bunch of wireless sensors distributed in your house. Another very important characteristic is its true mesh routing, allowing a more resilient architecture.

The one thing you need to understand how a zigbee network works is it relies on a PAN ID which is unique for a given group of nodes, and a node can play 3 roles:

+ a coordinator (ZC): there is only *one* coordinator in one given PAN. Its role is to create the network and helps on its routing
+ a router (ZR): you can have any number of routers in A PAN. They both emit new data and help to route data from other nodes
+ an end device (ZED): you can any number of EDs in a PAN and work similarly to a router except they don't route data from other nodes

Here is an example:

{{< image "/images/notes/zigbee/zigbee-mesh-networking-supported-device.png" >}}
