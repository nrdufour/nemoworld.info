---
date: 2026-01-20T10:00:00Z
title: It Wasn't the Heat
---

My Beelink SER5 Max build server would spontaneously reboot whenever it tried to build ARM64 Docker images. Not sometimes, but every time ! The machine would be humming along, QEMU would spin up to emulate ARM64, and then ... nothing. Power cut. Reboot. No warning, no error, no kernel panic. Just gone.

<!--more-->

The strange part ? I could run CPU stress tests for minutes on end. All cores pegged at 100%, temperatures climbing, fans screaming, rock solid. But ask it to compile a Go binary for ARM64 and it will be dead within 30 seconds :-)

## The usual suspect

Of course, my first instinct was to wonder if the machine wasn't cooling itself fast enough. QEMU emulation is notoriously CPU-intensive, and mini PCs aren't known for their cooling prowess. The SER5 Max packs an AMD Ryzen 7 6800U, an 8-core beast that can turbo up to 4.7GHz, into a case smaller than a book.

So I simply SSH'd in, started logging CPU temps every 2 seconds, and triggered a build.

The first surprise: the machine crashed at 75-80°C. Warm, but nowhere near the 95-105°C thermal limit for Ryzen chips. Suspicious, but saying nothing.

## Let's test it for real

To rule out thermal accumulation, I let the machine sit idle for 20 minutes. The CPU cooled down to a reported 20°C, basically room temperature. Perfect baseline.

I started the monitoring, triggered the build, and watched.

    08:55:41 CPU:20 GPU:37
    08:55:43 CPU:20 GPU:37
    08:55:45 CPU:20 GPU:37
    ...
    08:56:55 CPU:20 GPU:37  <-- Last reading before crash

The machine crashed with the CPU at 20°C. The temperature never rose. Not even a degree.

So a problem with the heat ? Nope !

## Back to the drawing board

So if it wasn't heat, what was different about QEMU compared to stress tests ?

Stress tests create sustained load. Every core runs flat out, the CPU boosts once and stays boosted, power draw stabilizes, and everything reaches equilibrium.

QEMU does something different. ARM64 emulation is bursty, translate a block of instructions, execute them, wait for more, repeat. This means the CPU is constantly transitioning between states: idle, boost, idle, boost, thousands of times per second.

Each time turbo boost engages, the CPU demands higher voltage from the VRM (Voltage Regulator Module). Each time it disengages, that demand drops. In a mini PC with a compact power delivery system and a 65W power adapter, those rapid transitions create transient power spikes that the hardware might not handle gracefully.

## The frequency limit test

If power spikes from turbo boost were the culprit, disabling turbo should fix it. I manually capped the CPU at 2.7GHz, its base clock, eliminating the boost transitions entirely:

    echo 2700000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq

Then I triggered the build.

The first minute passed. Then two. Then five. Load climbed above 10, QEMU processes churned through compilation, and the machine ... kept running. The build completed successfully for the first time ...

Turbo boost was the killer.

## Down the rabbit hole

A quick web search revealed I wasn't alone. The Beelink forums were littered with reports of SER5 Max units crashing under load:

- "Crashes when a single core is idle and boosts"
- "PC crash under load, thermal zone reading 20°C constantly"
- "Disabling turbo mode appeared to improve stability"

Wait, other users were also seeing that stuck 20°C reading ? That wasn't actually a cool CPU: it was a faulty ACPI thermal sensor. A known defect.

The Level1Techs forum had an even deeper analysis of similar issues on Beelink GTR7 units: C6 power state malfunctions, VRM instability during rapid core parking, and recommendations to adjust BIOS power limits or disable turbo entirely.

This wasn't a software bug or a misconfiguration. This was a hardware defect affecting **multiple** Beelink mini PCs.

## The fix

For NixOS, the permanent fix was simple, a systemd tmpfiles rule to disable turbo boost at every boot:

    systemd.tmpfiles.rules = [
        "w /sys/devices/system/cpu/cpufreq/boost - - - - 0"
    ];

(I first tried the kernel parameter `amd_pstate.no_boost=1`, but it doesn't work with the amd-pstate-epp driver. The sysfs write is more reliable.)

After deploying, I ran the problematic builds again. Both completed without issue. The machine has been stable ever since.

## The takeaway

Not all instability is thermal. When a system crashes under specific workloads but survives stress tests, think about how the workload differs, not just how much load it creates.

QEMU's bursty emulation pattern was the perfect storm for exposing weak power delivery: thousands of turbo boost transitions per second that a sustained stress test would never trigger.

The Beelink SER5 Max is a capable little machine, but its power delivery has a known weakness. If you're running VM workloads, QEMU emulation, or anything with rapid load fluctuations, you might encounter this same issue. The fix is simple: disable turbo boost, or adjust BIOS power limits if you want to preserve some boost capability.

As for me, I reached out to Beelink, explained the whole situation (the stuck thermal sensor, the crashes under bursty load, the fact that the machine can't handle its own advertised turbo speeds) and got back the usual bullshit about Windows power management. On a Linux box. Yeah, thanks for not listening at all ...

Either way, my ARM64 builds are finally working, slowly but surely without a reboot coming from nowhere.

Keep testing and experimenting, you may find some unexpected behavior ;)

---

## Related discussions

Other people running into the same family of Beelink instability:

- Beelink forum, SER5 Max crashing when a single core is idle and boosts <https://bbs.bee-link.com/d/9082-ser5-max-6800u-crashes>
- Beelink forum, same stuck 20°C sensor reading, with a recommendation to disable turbo <https://bbs.bee-link.com/d/8466-pc-crash-while-under-load-ser5-max-6800u-32gb-1tb>
- Level1Techs deep dive on GTR7 random reboots: C6 power state, core parking and VRM instability <https://forum.level1techs.com/t/updated-beelink-gtr7-7840-7940-pro-random-reboot-crashing-issue-the-reason-and-a-possible-fix-for-some/199561>
