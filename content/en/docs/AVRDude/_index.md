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


## Tutorial Arduino UNO (ATmega328P)

For this case, simply use the official Buzzpirat cables with the female Dupont connector they come with; there's no need to use SMD IC clips. Connect the Buzzpirat to the Arduino UNO board by attaching the +5v0(SW5V0) to VCC, CS to RESET, MISO to MISO, GND to GND, CLK to SCK, and MOSI to MOSI, ensuring each connection is secure for proper functionality

| Buzzpirat | Arduino UNO ICSP Connector |
| --- | --- |
| +5v0(SW5V0) | VCC |
| CS | RESET |
| MISO | MISO |
| MOSI | MOSI |
| CLK | SCK |
| GND | GND |

![](/conn/arduinoicspbuzz.png)

To read the content of a flash memory chip using `flashrom` with Buzzpirat, execute the following command:


```bash
flashrom.exe --progress -V -c "W25Q64BV/W25Q64CV/W25Q64FV" -p buspirate_spi:dev=COM8,spispeed=1M,serialspeed=115200 -r flash_content.bin 
```

* **`--`progress**: This parameter shows the progress of the operation, providing visual feedback in the terminal.
* **-V**: Stands for 'verbose'. It increases the verbosity of the program, providing detailed output about the operations being performed. This is useful for debugging or getting more information about the process.
* **-c "W25Q64BV/W25Q64CV/W25Q64FV"** in flashrom is used to specify the exact model of the flash chip that you intend to interact with. When you run flashrom without the -c parameter, the tool attempts to automatically detect the types of flash memory chips that are present in your system.
* **-p buspirate_spi**: Specifies the programmer type. In this case, it's set to buspirate_spi, indicating that the Buzzpirat is used for SPI (Serial Peripheral Interface) programming.
    * **dev=COM8**: This part of the parameter specifies the device name. COM8 refers to the COM port where the Buzzpirat is connected. **This will vary depending on your system's configuration**. You can find the COM port number by opening the Device Manager in Windows and looking for the Bus Pirate device under the Ports (COM & LPT) section.
    * **spispeed=1M**: Sets the SPI communication speed to 1 MHz. Adjusting the SPI speed can be necessary depending on the flash chip's specifications and the quality of the connections.
    * **serialspeed=115200**: Sets the serial communication speed (baud rate) between the computer and the Buzzpirat to 115200 bits per second. This is a common baud rate for serial communication.
* **-r flash_content.bin**: This part of the command tells flashrom to read the flash memory's content and save it into a file named flash_content.bin

The read operation may take about 15 minutes to complete. Once it's done, you can use a hex editor / binwalk etc to open the flash_content.bin file and inspect its contents.






