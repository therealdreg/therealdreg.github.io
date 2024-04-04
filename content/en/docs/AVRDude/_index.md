---
title: AVRDude
description: 
weight: 20
---


[AVRDude](https://github.com/avrdudes/avrdude/), which stands for AVR Downloader Uploader, is a software utility used for programming the onboard memory of Microchip's AVR microcontrollers, typically found in popular Arduino boards. This tool allows for the downloading and uploading of data to the chip's Flash and EEPROM memory. Additionally, when supported by the programming protocol, AVRDUDE can program fuse and lock bits, which are essential for configuring the microcontroller's settings and security features. A distinctive feature of AVRDUDE is its direct instruction mode. This mode empowers users to send any programming instruction directly to the AVR chip, bypassing the limitations of the software's built-in functions. This flexibility makes it an invaluable tool for developers working with AVR-based systems, particularly in the Arduino ecosystem, where customization and direct hardware control are often required

## Update AVRDude & Buzzpirat

AVRDude supports Buzzpirat out of the box

Ensure you have the latest stable firmware installed; learn how in the [Firmware Update](/docs/firmware-update) section. 

Finally, make sure to use the latest development version of AVRDude:

- https://github.com/avrdudes/avrdude/releases

A nice GUI for avrdude is AVRDUDESS:

- https://github.com/ZakKemble/AVRDUDESS
- https://blog.zakkemble.net/avrdudess-a-gui-for-avrdude/

Image avrdudess:

![](/otherimgs/avrdudess.png)

## Tutorial Arduino UNO (ATmega328P)

For this case, simply use the official Buzzpirat cables with the female Dupont connector they come with; there's no need to use SMD IC clips. Connect the Buzzpirat to the Arduino UNO board by attaching the +5v0(SW5V0) to VCC, CS to RESET, MISO to MISO, GND to GND, CLK to SCK, and MOSI to MOSI, ensuring each connection is secure for proper functionality

| Buzzpirat | Arduino UNO ICSP Connector |
| --- | --- |
| +5v(SW5V0) | VCC |
| CS | RESET |
| MISO | MISO |
| MOSI | MOSI |
| CLK | SCK |
| GND | GND |

![](/conn/arduinoicspbuzz.png)

To detect the AVR chip, run the following command:

```bash
avrdude -c buspirate -P COM59 -b 115200 -p m328pb
```

AVR chip detected is ATmega328PB, which is the microcontroller used in the Arduino UNO board. The output of the command will look like this:

```bash
avrdude -c buspirate -P COM59 -b 115200 -p m328pb
attempting to initiate BusPirate binary mode ...
avrdude: paged flash write enabled
avrdude: AVR device initialized and ready to accept instructions
avrdude: device signature = 0x1e9516 (probably m328pb)
avrdude error: did not get a response to power off command

avrdude done.  Thank you.
```

The command uses the following parameters:

* **-c buspirate**: Specifies the programmer type. In this case, it's set to buspirate, indicating that the Buzzpirat is used for programming.

* **-P COM59**: Specifies the port where the Buzzpirat is connected. The COM port number may vary depending on your system's configuration. You can find the COM port number by opening the Device Manager in Windows and looking for the Bus Pirate device under the Ports (COM & LPT) section.

* **-b 115200**: Sets the baud rate for serial communication between the computer and the Buzzpirat to 115200 bits per second. This is a common baud rate for serial communication.

* **-p m328pb**: Specifies the AVR microcontroller model. In this case, it's set to m328pb, which is the model used in the Arduino UNO board.

If the AVR chip is detected successfully, you can proceed with programming the chip using the appropriate commands. For example, to upload a HEX file to the chip, you can use the following command:

```bash
avrdude -c buspirate -p m328pb -P COM59 -b 115200 -U flash:w:"C:\Users\dreg\Desktop\Blink\build\arduino.avr.uno\Blink.ino.with_bootloader.hex":i
```

The command uses the following parameter:

* **-U flash:w:"C:\Users\dreg\Desktop\Blink\build\arduino.avr.uno\Blink.ino.with_bootloader.hex":i**: Specifies the operation to perform. In this case, it's set to write (w) the contents of the specified HEX file to the flash memory of the AVR chip. The path to the HEX file should be replaced with the actual path to the file on your system.

How to read flash memory:

```bash
avrdude -c buspirate -p m328pb -P COM59 -b 115200 -U flash:r:"C:\Users\dreg\Desktop\dump.hex":i
```

The command uses the following parameter:

* **-U flash:r:"C:\Users\dreg\Desktop\dump.hex":i**: Specifies the operation to perform. In this case, it's set to read (r) the contents of the flash memory of the AVR chip and save it to the specified HEX file. The path to the output file should be replaced with the actual path on your system.

How to read EEPROM:

```bash
avrdude -c buspirate -p m328pb -P COM59 -b 115200 -U eeprom:r:"C:\Users\dreg\Desktop\eeprom_dump.hex":i
```

The command uses the following parameter:

* **-U eeprom:r:"C:\Users\dreg\Desktop\eeprom_dump.hex":i**: Specifies the operation to perform. In this case, it's set to read (r) the contents of the EEPROM memory of the AVR chip and save it to the specified HEX file. The path to the output file should be replaced with the actual path on your system.







