---
date: 2010-01-15T00:00:00Z
title: TweetDeck on Ubuntu Karmic 64bit
---

Since Karmic is out, I couldn't find a good way to make TweetDeck working.

I decided to try troubleshooting it for just 5 minutes and found a simple solution with the help of several blogs:

First make sure you have the proper 32bit required libraries already installed: <http://www.ossramblings.com/tweetdeck_in_64_bit_ubuntu>

{{< highlight bash >}}
sudo apt-get install lib32asound2 lib32gcc1 lib32ncurses5 lib32stdc++6 lib32z1 libc6 libc6-i386 lib32nss-mdns
sudo cp /usr/lib/libadobecertstore.so /usr/lib32
sudo ldconfig
{{< / highlight >}}

But that wasn't enough. By simply launching TweetDeck in a terminal you could see the app can't access to th gnome-keyring library. So I used getlibs to grab the right version as explained [here](http://ubuntuforums.org/archive/index.php/t-956824.html)

{{< highlight bash >}}
sudo getlibs -l libgnome-keyring.so.0.1.1
{{< / highlight >}}

And suddenly works like a charm :)

"Simple" ;)
