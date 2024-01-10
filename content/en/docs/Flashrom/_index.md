---
title: Flashrom
description: 
weight: 20
---


[Flashrom](https://www.flashrom.org) is a versatile utility for managing flash chips, capable of identifying, reading, writing, verifying, and erasing them. It's particularly adept at flashing BIOS/EFI/coreboot/firmware/optionROM images on a variety of hardware, including mainboards, network/graphics/storage controllers, and other programmer devices.

**Key features include:**

- Support for over 476 flash chips, 291 chipsets, 500 mainboards, 79 PCI devices, 17 USB devices, and a range of programmers via parallel/serial ports.
- Compatibility with parallel, LPC, FWH, and SPI flash interfaces, and various chip packages like DIP32, PLCC32, DIP8, SO8/SOIC8, TSOP32, TSOP40, TSOP48, BGA, and more.
- Operable without physical access; root access is typically sufficient, with some programmers not requiring it.
- No need for bootable media, keyboard, or monitor; capable of remote flashing via SSH.
- Allows flashing within a running system with no immediate reboot required; the new firmware activates on the next boot.
- Supports crossflashing and hotflashing, given electrical and logical compatibility of flash chips.
- Scriptable for simultaneous flashing across multiple machines.
- Faster than many vendor-specific flash tools.
- Portable across various operating systems including DOS, Linux, FreeBSD, NetBSD, OpenBSD, DragonFlyBSD, Solaris-like systems, Mac OS X, and other Unix-like OSes, as well as GNU Hurd. Partial Windows support is available, excluding internal programmer support."

## Update Flashrom & Buzzpirat

Flashrom supports Buzzpirat out of the box

Ensure you have the latest stable firmware installed; learn how in the [Firmware Update](/docs/firmware-update) section. 

Finally, make sure to use the latest development version of flashrom or our mod:

- Windows mod: https://github.com/therealdreg/flashrom_build_windows_x64
- mod code (For Unix): https://github.com/therealdreg/flashrom-dregmod 
- Official repo: https://github.com/flashrom/flashrom


## Help

A required `dev` parameter specifies the Buzzpirat device node and an optional `spispeed` parameter specifies the frequency of the SPI bus. The parameter delimiter is a comma. Syntax is:

```bash
flashrom -p buspirate_spi:dev=/dev/device,spispeed=frequency
```

where `frequency` can be `30k`, `125k`, `250k`, `1M`, `2M`, `2.6M`, `4M` or `8M` (in Hz). The default is the maximum frequency of 8 MHz.

The baud rate for communication between the host and the Buzzpirat can be specified with the optional `serialspeed` parameter. Syntax is:

```bash
flashrom -p buspirate_spi:serialspeed=baud
```

where `baud` can be `115200`, `230400`, `250000` or `2000000` (`2M`). The default is `2M` baud.

An optional pullups parameter specifies the use of the Buzzpirat internal pull-up resistors. This may be needed if you are working with a flash ROM chip that you have physically removed from the board. Syntax is:

```bash
flashrom -p buspirate_spi:pullups=state
```

where `state` can be `on` or `off`.

When working with low-voltage chips, the internal 10k pull-ups of the Buzzpirat might be too high. In such cases, it’s necessary to create an external pull-up using lower-value resistors.

For this, you can use the `hiz` parameter. This way, the Buzzpirat will operate as an open drain. Syntax is:

```bash
flashrom -p buspirate_spi:hiz=state
```

where `state` can be `on` or `off`.

The state of the Buzzpirat power supply pins is controllable through an optional `psus` parameter. Syntax is:

```bash
flashrom -p buspirate_spi:psus=state
```

where `state` can be `on` or `off`. This allows the Buzzpirat to power the ROM chip directly. This may also be used to provide the required pullup voltage (when using the `pullups` option), by connecting the Buzzpirat’s Vpu input to the appropriate Vcc pin.

An optional aux parameter specifies the state of the Buzzpirat auxiliary pin. This may be used to drive the auxiliary pin high or low before a transfer. Syntax is:

```bash
flashrom -p buspirate_spi:aux=state
```

where `state` can be `high` or `low`. The default `state` is `high`.

## Tutorial Winbond 3v3 64M-BIT w25q64fv board

![](/winbondcntdiag.png)

![](/realclips.png)

