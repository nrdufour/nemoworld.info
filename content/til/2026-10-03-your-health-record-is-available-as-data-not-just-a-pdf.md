---
title: "Your health record is available as data, not just a PDF"
date: 2026-10-03T09:47:32-04:00
draft: false
topics: [Health, Data]
---

I like to take care of my health pro-actively and since I also love playing with data,
I was looking at my patient portal test results and a way to retrieve them directly.

I didn't know that since the 2021 Cures Act rules, a US provider has to give you electronic access
to your own health record, at no cost, and "electronic access" is not a PDF.

What the portal actually hands you is a **C-CDA** XML: every lab value with its unit,
its reference range and its LOINC code, plus vitals, medications, immunizations
and encounters.

It is buried, of course. *Tasks and Tools*, then the record download. Two clicks
I had never made, after years of using the portal.

Why it matters: a PDF is a **picture** of your data. A C-CDA **is** the data. And
it is one standard, everywhere: the same parser reads the file from your clinic
and from the hospital down the road.

You cannot grep a PDF. So go play with your health data :)!
