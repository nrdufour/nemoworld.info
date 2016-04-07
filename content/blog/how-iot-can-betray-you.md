---
date: 2016-04-06T20:49:57-04:00
title: How IoT can betray you
---

I recently restored a part of my wireless sensor network, and I'm quite pleased of the current state:

+ the sensor part is working
+ the gateway is processing
+ a first chart to visualize what was stored

So after running it for a whole day, I got this chart:

{{< image "/images/blogs/light-chart-20160406.png" >}}

OK, so far it looks great. You can see the sun:

1. going down in a quasi linear fashion from the beginning to around 6,
2. then the S transition to night,
3. then the flat night.

{{< image "/images/blogs/light-chart-with-trend-20160406.png" >}}

So all good, except for one thing: that big spike in the last part! Guess what it is?

Simply me going into the room and switching the light. As simple as that. In fact I did that experiment on purpose to see how much light difference I would measure (since this measurement is relative -- 0 being close to total darkness).

But then it seems rather obvious that if I was to push this kind of stream on internet, anybody would be able to figure out when I'm switching on and off the light ... You're starting to see when I'm going.

So yes IoT is promising a lot of "happy days" but if you want other to track you down in your own home, you have 2 solutions:

+ you don't publish certain streams and especially the ones coming from inside
+ you "sanitize" some streams by removing any kind of spikes, you basically doctor the data

~ Happy streaming.
