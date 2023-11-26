---
title: Firmware Update
description: How to update your Buzzpirat
weight: 1
---

{{< alert color="warning" title="Warning" >}}
Do not install this firmware on the Bus Pirate v3. Please refer to the lower section of this page for compatible firmware options{{< /alert >}}


Download the last firmware from this page: 
- https://github.com/therealdreg/buzzpirat/tree/main/bin/stablefirm


{{< alert color="warning" title="Warning" >}}
Do not install the firmware labeled with "pickit" in its name{{< /alert >}}


Download the last buzzloader app (There are versions available for Windows, Linux and Mac) from this page:
- https://github.com/therealdreg/buzzpirat/tree/main/bin/buzzloader

- put a jumper/dupont_wire connecting the PGD pin to the PGC pin
- connect the buzzpirat to your computer via a usb cable
- check for the new COM port assignment in the device manager (e.g., COM29)

Make sure to close Tera Term or any other software that might be using the COM port to free it up and execute:
```
buzzloader.exe --dev=COM29 --hex=BZ-firmware-v7.1.6969.hex
```

Just ignore a800...ERROR[50] error message, it's a known issue and the firmware is updated correctly.
```
Writing page 41 row 331, a580...OK
Writing page 41 row 332, a600...OK
Writing page 41 row 333, a680...OK
Writing page 41 row 334, a700...OK
Writing page 41 row 335, a780...OK
Erasing page 42, a800...ERROR [50]

Error updating firmware :(
```

Remove the jumper/Dupont cable, then reconnect the device to the USB port, and you're all set! You should now have the latest firmware installed. 

Run the 'i' command and perform a self-test with the '~' command to ensure everything has gone smoothly.

----------------


## Buzzpirat firmware for BPv3 hardware

For each firmware version, we also generate a firmware that is 100% compatible with the Bus Pirate v3 hardware.

So, users with the Bus Pirate v3 hardware can benefit from Buzzpirat features: 

- https://github.com/therealdreg/buzzpirat/tree/main/bin/stablefirm/bpv3comp/


To ensure compatibility with Buzzpirat firmware, you need to install bootloader 4.5

More information on how to update it can be found here:
- http://dangerousprototypes.com/forum/index.php?topic=8498.0


{{< alert color="warning" title="Warning" >}}BOOTLOADER UPDATE IS RISKY, YOU COULD BRICK YOUR BUS PIRATE, AND I AM NOT RESPONSIBLE FOR ANY DAMAGES.{{< /alert >}}

----------------

## Last community BPv3 firmware & bootloader

Any firmware and bootloader from the original Bus Pirate v3 will work well with Buzzpirat. Here are some that I have tested.

4.5 Bootloader upgrade from v4x:
- https://github.com/therealdreg/buzzpirat/tree/main/bin/oldfirm/BPv3-bootloader-upgrade-v4xtov4.5_Aug-2023_USBEprom.hex

Last community firmware:
- https://github.com/therealdreg/buzzpirat/tree/main/bin/oldfirm/BPv3-firmware-v7.1-JTAG_SAFE_1_Aug-2023_USBEprom.hex

{{< alert title="Note" >}}This community firmware have a bug in the binary SPI mode and cause problems with flashrom
{{< /alert >}}

----------------


## Legacy BPv3 firmware & bootloader

4.4 Bootloader:
- https://github.com/therealdreg/buzzpirat/tree/main/bin/oldfirm/BPv3-Bootloader-v4.4.hex

6.3-r2151 Firmware:
- https://github.com/therealdreg/buzzpirat/tree/main/bin/oldfirm/BPv3-firmware-v6.3-r2151.hex