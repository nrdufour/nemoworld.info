---
date: 2025-03-05T13:42:00Z
title: Hardware is hard no matter what
---

I have an interesting hardware issue I would like to share, because it really shows that hardware is never simple when it breaks. \
You have to pay attention to every possibility and/or detail before really calling it a day.

<!--more-->

# The context

So, before starting, let me introduce to the fact that I operate a kubernetes cluster at home for now several years.

That cluster is currently composed of:

- 3 raspberry pi 4 as control plane
- 3 raspberry pi 4 as workers
- 3 orange pi 5+ as workers as well

All those nodes running on Linux NixOS 24.11, and using k3s as its kubernetes main component.

Recently (in January 2025), I was searching for a way to add actual storage to those raspberry pi 4 worker nodes, and after several prototypes, I found that using the [GeeekPi M.2 NVME SSD Storage Expansion Board](https://www.amazon.com/dp/B0CBJYWKJ1) was probably the best option I have:

- it's a board that welcomes NVME SSDs on an M2 port
- it connects to the raspberry via USB
- it's powered via 3 push pins directly onto the raspberry pins

{{< figure src="geekpi_board.jpg" width="50%" >}}

Once assembled, you see the disk as /dev/sdx.

I ended up plugging a [Klevv 1Tb SSD](https://www.amazon.com/dp/B0CBSSC21F) which has decent enough properties and not too expensive.

I did this on those 3 raspberry pi 4 working as worker nodes. From the start, the SSD was used since all the container images were stored on it. So since January, it has been a pretty smooth sail.

---

Now, on the morning of Monday 24th 2025, I was checking the cluster, as I usually do, and saw that one of those raspberry pi worker nodes (with ssd) was in the `NotReady` state. \
Let's called that Day 1.

# Day 1

Somehow, my intuition was telling me to look at the kernel messages, rather than see if k3s was running with errors.

I still checked k3s, and was indeed in trouble for images, then immediately did a `df -h` and right away saw that the disk was missing.

Then looked at `dmesg -T` to try to understand, and finally with the journal saw that somewhere during the night (around ~3am), the disk went in error and the usb driver dropped it.

I then powered off the machine, dismantled the whole thing, in order to test the SSD. I dit put it into a M2 enclosure to test the disk, then plugged it to my laptop, and sure enough : the disk was busted ... At this point, I was wondering how come a disk bought in January can be dead that soon.

I bought a replacement from Western Digital (a [WD Blue](https://www.amazon.com/dp/B0D7MLHCQ7)), thinking that maybe I went too cheap before.

And waited.

# Day 2

Upon reception of the new SSD, I reassembled the whole thing, powered the machine on (with the caveat that I had to change nixos configuration -- because the disk wasn't recognized).

But still: no disk. Not even a single mention in `dmesg` or anywhere.

I did test that SSD with my M2 enclosure before that to be sure it was working, and it was.

So, as the next possible failure, I thought the GeeekPi extension board was actually busted (and probably caused the previous ssd to go pouf). 

So I ordered a new GeeekPi extension board.

And waited.

# Day 3

Upon reception of the new GeeekPi extension board ... reassembled yet again, powered it, and ...

Still no disk ! This is where you should always check your components in different ways (like I checked that the SSD was indeed busted with a different interface).

The next in line for this failure had to be the raspberry pi itself ... but what exactly ? The whole machine seems ok. This is when I remembered the USB connector between the extension board and the pi.

Could the connector be in trouble, or worse : could the raspberry pi usb connector be busted !

Simple test: I have plenty of usb disks, and plugged it to the port used --> no disk !
Moved then the usb disk to a different usb port, --> disk visible !!!

All this time, to understand that I had in fact 2 failures:

- a bad SSD
- a bad USB connector on the pi

Hardware is hard, no matter what you do with it.

I thought it would have been the end of the saga, so I ordered a flexible USB-A to USB-A cable to link the extension board to the non-busted usb connector on the pi.

And waited.

# Day 4

Upon reception of that cable, reassembled the whole thing, and could **finally** see the SSD disk.

Reconfigured the machine properly, put it back in the cluster and it was the end of the story ...

So I thought.

# Day 5

Another morning, another look at the cluster : same node was back at `NotReady` state!

I was really pissed off at this point ... but this time it showed something different: `dmesg` was showing that the kernel had some issues of its own. The disk was ok, somehow reachable.

Precisely this kind of messages:

    [ 573.203294] sd 6:0:0:0: [sda] tag#29 uas_eh_abort_handler 0 uas-tag 9 inflight: CMD OUT
    [ 573.203302] sd 6:0:0:0: [sda] tag#29 CDB: Write(10) 2a 00 00 4f a0 00 00 04 00 00
    [ 573.205063] sd 6:0:0:0: [sda] tag#28 uas_eh_abort_handler 0 uas-tag 10 inflight: CMD OUT
    [ 573.205070] sd 6:0:0:0: [sda] tag#28 CDB: Write(10) 2a 00 00 4f a4 00 00 04 00 00
    [ 573.208537] sd 6:0:0:0: [sda] tag#27 uas_eh_abort_handler 0 uas-tag 6 inflight: CMD OUT

After several search, it looked that the `UAS` driver was the culprit.

On the machine itself, I checked with `lsusb -t` and yes the disk was using the `uas` driver.

I didn't know UAS before that, and I still under the impression that `usb-storage` driver was going to be used. [UAS](https://en.wikipedia.org/wiki/USB_Attached_SCSI) is indeed a faster and better (overall) protocol to use usb disks, as long as the hardware is compatible to it ... And raspberry pi 4 don't seem to be 100% compatible either (another thing I didn't knwow).

All in all, this is the `find out` phase, where the more you test the more you understand what is going on. \
The solution was to switch those boards back to the `usb-storage` driver, which is indeed slower, but absolutely 100% compatible.

For that, you have to get the USB id of your device and add the following kernel parameters:

    usb-storage.quirks=XXXX:YYYY:u usbcore.quirks=XXXX:YYYY:u

where XXXX:YYYY are the USB id.

Look with `lsusb`:

    > lsusb 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 2109:3431 VIA Labs, Inc. Hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 002 Device 002: ID 174c:2362 ASMedia Technology Inc. M.2 Series SSD

Here this is the ASMedia board, so its USB id is `174c:2362`.

With NixOS, I could configure it this way:

    boot.kernelParams = [
        "usb-storage.quirks=174c:2362:u"
        "usbcore.quirks=174c:2362:u"
    ];

Once this configuration was deployed and the machines rebooted, no issue since. This is finally it! (for now :D ...)
I will probably order extra flexible USB-A to USB-A cables because I still don't trust what I have on the other pis.

# So what was it?

Yes, what was the root cause of all of this ?

Two things are certain:

- the previous SSD is broken
- the previous USB connector on the pi is broken as well

But still, why ? This is very difficult to know:

- the SSD could had a defect that makes it age prematurely
- the USB connector could have been damaged with handling / assembling
- this happened a few days after I moved all my postgresql databases on those machines and therefore involving more the disks ... but why this one ?

So, no I don't have a solid root cause for all of this.

---

Be mindful of **each** element you are using to troubleshoot a hardware issue, because even a connector can fail.

Thank you for reading, and have fun!

# Update on 2025-03-08 {#update-20250308}

All the raspberry pi with the SSD extension card are in good shape and I ended up changing the usb connection with a high speed **flexible** [cable](https://www.amazon.com/dp/B0C9J1QQV1) to avoid mechanical tension over time.

{{< figure src="rasp4_ssd.png" width="100%" >}}

---

# References

I used the following pages as help:

- A good description of the overall issue with UAS <https://forums.raspberrypi.com/viewtopic.php?f=28&t=245931&sid=d8df335a2e30668e9852048027efba3b>
- A description of UAS and its drawbacks <https://linux-sunxi.org/USB/UAS>