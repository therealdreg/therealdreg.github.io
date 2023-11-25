---
title: Firmware Update
description: How to update your Buzzpirat
weight: 1
---

- put a jumper/dupont_wire connecting the PGD pin to the PGC pin
- connect the buzzpirat to your computer via a usb cable
- check for the new COM port assignment in the device manager (e.g., COM29)

Download the last firmware from this page: 
- https://github.com/therealdreg/buzzpirat/tree/main/bin/stablefirm

Download the last buzzloader app (There are versions available for Windows, Linux and Mac) from this page:
- https://github.com/therealdreg/buzzpirat/tree/main/bin

Example for windows:
```
buzzloader.exe --dev=COM29 --hex=BZ-firmware-v7.1.6969.hex
```

