---
date: 2010-11-16T00:00:00Z
title: Using a laptop as bridge
---

From time to time you need to reach your network where it's not possible directly (the computer has no wifi card, the driver is missing, etc).

Fortunately, you have at least an Ethernet port and ... a laptop or other computer using Linux that you can use as a bridge.

Just connect the 2 devices with a regular Ethernet cable (or a cross one for old cards) and activate IP_forwards and NAT with the following script, found in this [forum](https://bbs.archlinux.org/viewtopic.php?pid=671501) :

{{< highlight bash >}}
#!/bin/bash
# Shares internet from wlan0 through eth0

case "$1" in 
    start)
        ifconfig eth0 up
        ifconfig eth0 192.168.0.1
        iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
        iptables --append FORWARD --in-interface eth0 -j ACCEPT
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo "set other computers in the range of"
        echo "192.168.0.0 255.255.255.0"
        echo "gateway 192.168.0.1"
        echo "dns 192.168.10.1"  #this is my router's ip, you should use yours or another dns server
        ;;
    stop)
        echo 0 > /proc/sys/net/ipv4/ip_forward
        ifconfig eth0 down
        iptables --table nat --delete POSTROUTING --out-interface wlan0 -j MASQUERADE
        ;;
    *)
        echo "usage: $0 {start|stop}"
        ;;
esac
{{< / highlight >}}

That's it.
