---
title: Binary I/O
description: Binary I/O mod from busspirate doc from dangerousprototypes
weight: 1
---

The bitbang protocol uses a single byte for all commands. The default start-up state is pin input (HiZ).

- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Check in between if BBIO1 is returned. 
- Send 0x0F to exit raw bitbang mode and reset the Buzzpirat.
- Other raw protocol modes are accessible from within bitbang mode, 0x00 always returns to raw bitbang mode and prints the version string.
- There is a slight settling delay between pin updates, currently about 5us.

{{< alert color="warning" title="Warning" >}}To avoid the BBIO1 endless loop bug in the Buzzpirat, it is crucial to send each 0x00 command individually and verify the presence of a "BBIO1" response. Transmitting multiple 0x00 commands rapidly in succession may lead to a continuous BBIO1 response loop. The sole solution to this loop issue is to disconnect and then reconnect the USB: http://dangerousprototypes.com/forum/index.php?topic=4227.0{{< /alert >}}

## b00000000 (0x00) - Reset, responds "BBIO1"
This command resets the Buzzpirat into raw bitbang mode from the user terminal. It also resets to raw bitbang mode from raw SPI mode, or any other protocol mode. This command always returns a five byte bitbang version string "BBIO1", where 1 is the current protocol version.

Some terminals send a NULL character (0x00) on start-up, causing the Buzzpirat to enter binary mode when it wasn't wanted. To get around this, you must now enter 0x00 at least 20 times to enter raw bitbang mode.

{{< alert color="warning" title="Warning" >}}The Buzzpirat user terminal could be stuck in a configuration menu when your program attempts to enter binary mode. One way to ensure that you're at the command line is to send <enter> at least 10 times, and then send '#' to reset. Next, send 0x00 to the command line 20+ times until you get the BBIO1 string.{{< /alert >}}

After entering bitbang mode, you can enter other binary protocol modes.

## b00000001 (0x01) - Enter binary SPI mode, responds "SPI1"

Commands are a single byte, except bulk SPI transfers. The Buzzpirat responds to SPI write commands with the data read from the SPI bus during the write. Most other commands return 0x01 for success, or 0x00 for failure/unknown command.

### SPI Mode, Key points
- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Pause briefly after sending each 0x00 to check if BBIO1 is returned. Example binary mode entry functions.
- Enter 0x01 in bitbang mode to enter raw SPI mode.
- Return to raw bitbang mode from raw SPI mode by sending 0x00 one time.
- Operations that write a byte to the SPI bus also return a byte read from the SPI bus.
- Hex values shown here, like 0x00, represent actual byte values; not typed ASCII entered into a terminal.

Once you have successfully entered the mode, you can use the following commands:

### SPI b00000001 (0x01) - Enter raw SPI mode, display version string
Once in raw bitbang mode, send 0x01 to enter raw SPI mode. The Buzzpirat responds 'SPI1', where 1 is the raw SPI protocol version. Get the version string at any time by sending 0x01 again.

### SPI b0000001x - CS high (1) or low (0)
Toggle the Buzzpirat chip select pin, follows HiZ configuration setting. CS high is pin output at 3.3volts, or HiZ. CS low is pin output at ground. Buzzpirat responds 0x01.

### SPI b000011xx - Sniff SPI traffic when CS low(10)/all(01)

The SPI sniffer is implemented in hardware and should work up to 10MHz. It follows the configuration settings you entered for SPI mode. The sniffer can read all traffic, or filter by the state of the CS pin.

- [/] - CS enable/disable
- \xy - escape character (\\) precedes two byte values X (MOSI pin) and Y (MISO pin) 

Sniffed traffic is encoded according to the table above. The two data bytes are escaped with the '\' character to help locate data in the stream.

Send the SPI sniffer command to start the sniffer, the Buzzpirat responds 0x01 then sniffed data starts to flow. Send any byte to exit. 

If the sniffer can't keep with the SPI data, the MODE LED turns off and the sniff is aborted.

The sniffer follows the output clock edge and output polarity settings of the SPI mode, but not the input sample phase.

### SPI b0001xxxx - Bulk SPI transfer, send/read 1-16 bytes (0=1byte!)
Bulk SPI allows direct byte reads and writes. The Buzzpirat expects xxxx+1 data bytes. Up to 16 data bytes can be sent at once, each returns a byte read from the SPI bus during the write.

Note that 0000 indicates 1 byte because there's no reason to send 0. BP replies 0x01 to the bulk SPI command, and returns the value read from SPI after each data byte write.

The way it goes together:
- The upper 4 bit of the command byte are the bulk read command (0001xxxx)
- xxxx = the number of bytes to read. 0000=1, 0001=2, etc, up to 1111=16

If we want to read (0001) four bytes (0011=3=read 4) the full command is 00010011 (0001 + 0011 ). Convert from binary to hex and it is 0x13

### SPI b0100wxyz - Configure peripherals w=power, x=pull-ups, y=AUX, z=CS
Enable (1) and disable (0) Buzzpirat peripherals and pins. Bit w enables the power supplies, bit x toggles the on-board pull-up resistors, y sets the state of the auxiliary pin, and z sets the chip select pin. Features not present in a specific hardware version are ignored. Buzzpirat responds 0x01 on success.

{{< alert title="Note" >}}CS pin always follows the current HiZ pin configuration. AUX is always a normal pin output (0=GND, 1=3.3volts){{< /alert >}}

### SPI b01100xxx - SPI speed
000=30kHz, 001=125kHz, 010=250kHz, 011=1MHz, 100=2MHz, 101=2.6MHz, 110=4MHz, 111=8MHz

This command sets the SPI bus speed according to the values shown. Default startup speed is 000 (30kHz).

### SPI b1000wxyz - SPI config, w=HiZ/3.3v, x=CKP idle, y=CKE edge, z=SMP sample
This command configures the SPI settings. Options and start-up defaults are the same as the user terminal SPI mode. w= pin output HiZ(0)/3.3v(1), x=CKP clock idle phase (low=0), y=CKE clock edge (active to idle=1), z=SMP sample time (middle=0). The Buzzpirat responds 0x01 on success.

Default raw SPI startup condition is 0010. HiZ mode configuration applies to the SPI pins and the CS pin, but not the AUX pin. See the PIC24FJ64GA002 datasheet and the SPI section of the PIC24 family manual for more about the SPI configuration settings.

### SPI b00000100 (0x04) - Write then read & b00000101 (0x05) - Write then read, no CS
This command was developed to help speed ROM programming with Flashrom, asprogrammer dreg mod. It might be helpful for a lot of common SPI operations. 

- b00000100 - Write then read: It enables chip select, writes 0-4096 bytes, reads 0-4096 bytes, then disables chip select.
- b00000101 - Write then read, no CS: writes 0-4096 bytes, reads 0-4096 bytes (CS transitions are NOT automated/included).

All data for this command can be sent at once, and it will be buffered in the Buzzpirat. The write and read operations happen all at once, and the read data is buffered. At the end of the operation, the read data is returned from the buffer. The goal is to meet the stringent timing requirements of some ROM chips by buffering everything instead of letting the serial port delay things.

Write then read command format:
1. send 1 byte: b00000100 (Write then read command) or b00000101 (Write then read, no CS)
2. send 2 bytes: number of write bytes 0-4096 (first byte High8, second Low8)
3. send 2 bytes: number of read bytes 0-4096 (first byte High8, second Low8)
4. If the number of bytes to read or write are out of bounds, the Buzzpirat will send 0x00 now
5. send 0-4096 bytes: bytes to write (specified by step 2)
6. read 1 byte: success/0x01
7. read 0-4096 bytes: bytes to read (specified by step 3)

Key Points:
- There is no acknowledgment that a byte is received.
- All write bytes are sent at once (before that CS goes low for b00000100 - Write then read command)
- Read starts immediately, all bytes are put into a buffer at max SPI speed (no waiting for UART)
- At the end of the read, CS goes high for b00000100 - Write then read command

### SPI b00000110 (0x06) - AVR Extended Commands
- b00000000 (0x00) - Null operation - verifies extended commands are available.
- b00000001 (0x01) - Return version (2 bytes)
- b00000010 (0x02) - Bulk Memory Read from Flash

### SPI b11111110 (0xFE) - Execute Buzz Commands
Buzz Commands allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

You have access to the same commands as when you enter Buzz Mode using 0x0A. A list of the supported commands is available further below (the first one is 0x00)

Buzzpirat returns 0x01 if it has successfully entered this mode.


----------------

## b00000010 (0x02) - Enter binary I2C mode, responds "I2C1"

Enter binary I2C mode by first entering bitbang mode, then send 0x02 to enter I2C mode.

Most I2C mode commands are a single byte. Commands generally return 1 for success, 0 for failure.

### I2C Mode, Key points
- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Pause briefly after sending each 0x00 to check if BBIO1 is returned. Example binary mode entry functions.
- Enter 0x02 in bitbang mode to enter raw I2C mode.
- Return to raw bitbang mode from raw I2C mode by sending 0x00 one time.
- Hex values shown here, like 0x00, represent actual byte values; not typed ASCII entered into a terminal.

Once you have successfully entered the mode, you can use the following commands:

### I2C b00000001 (0x01) – Display mode version string, responds "I2C1"
Once in binary I2C mode, send 0x01 to get the current mode version string. The Buzzpirat responds ‘I2C1’, where x is the raw I2C protocol version (currently 1). Get the version string at any time by sending 0x01 again. This command is the same in all binary modes, the current mode can always be determined by sending 0x01.


### I2C b00000010 (0x02) – I2C start bit
Send an I2C start bit. Responds 0x01.

### I2C b00000011 (0x03) - I2C stop bit
Send an I2C stop bit. Responds 0x01.

### I2C b00000100 (0x04) - I2C Read Byte
Reads a byte from the I2C bus and returns the byte. You must manually ACK or NACK each byte!

### I2C b00000110 (0x06) - ACK bit
Send an I2C ACK bit after reading a byte. Tells a slave device that you will read another byte. Responds 0x01.

### I2C b00000111 (0x07) - NACK bit
Send an I2C NACK bit after reading a byte. Tells a slave device that you will stop reading, next bit should be an I2C stop bit. Responds 0x01.


### I2C b00001111 (0x0F) - Start bus sniffer
Sniff traffic on an I2C bus.

- [/] - Start/stop bit
- \ - escape character precedes a data byte value
- +/- - ACK/NACK

Sniffed traffic is encoded according to the table above. Data bytes are escaped with the '\' character. Send a single byte to exit, Buzzpirat responds 0x01 on exit.

### I2C b0001xxxx – Bulk I2C write, send 1-16 bytes (0=1byte!)
Bulk I2C allows multi-byte writes. The Buzzpirat expects xxxx+1 data bytes. Up to 16 data bytes can be sent at once. Note that 0000 indicates 1 byte because there’s no reason to send 0.

BP replies 0x01 to the bulk I2C command. After each data byte the Buzzpirat returns the ACK (0x00) or NACK (0x01) bit from the slave device.

### I2C b0100wxyz – Configure peripherals w=power, x=pullups, y=AUX, z=CS
Enable (1) and disable (0) Buzzpirat peripherals and pins. Bit w enables the power supplies, bit x toggles the on-board pull-up resistors, y sets the state of the auxiliary pin, and z sets the chip select pin. Features not present in a specific hardware version are ignored. Buzzpirat responds 0x01 on success.

{{< alert title="Note" >}}CS pin always follows the current HiZ pin configuration. AUX is always a normal pin output (0=GND, 1=3.3volts){{< /alert >}}


### I2C b011000xx - Set I2C speed, 3=~400kHz, 2=~100kHz, 1=~50kHz, 0=~5kHz
0110000x - Set I2C speed, 1=high (50kHz) 0=low (5kHz)

The lower bits of the speed command determine the I2C bus speed. Binary mode currently uses the software I2C library, though it may be configurable in a future update. Startup default is high-speed. Buzzpirat responds 0x01 on success.

### I2C b00001000 (0x08) - Write then read
This command internally sends I2C start, writes from 0-4096 bytes, then reads 0-4096 bytes into the Buzzpirats internal buffer, ACKing each byte internally until the final byte at which point it sends an NACK stop bit.

All data for this command can be sent at once, and it will be buffered in the Buzzpirat. The write and read operations happen once the completed command has been passed to the Buzzpirat. Any write data is internally buffered by the Buzzpirat. At the end of the operation, any read data is returned from the buffer, be aware that the write buffer is re-used as the read buffer, as such any write data needs to be re-loaded if the command is re-executed.

Write then read command format:
1. send 1 byte: b00001000 (Write then read command)
2. send 2 bytes: number of write bytes 0-4096 (first byte High8, second Low8)
3. send 2 bytes: number of read bytes 0-4096 (first byte High8, second Low8)
4. If the number of bytes to read or write are out of bounds, the Buzzpirat will send 0x00 now
5. send 0-4096 bytes: bytes to write (specified by step 2. The initial byte can serve as the I2C address. Therefore, in step 2, it's necessary to specify at least one byte for writing).
6. read 1 byte: success/0x01, would be 0x00 If an I2C write is not ACKed by a slave device, then the operation will abort.
7. read 0-4096 bytes: bytes to read (specified by step 3). 

Key points:
- The Buzzpirat sends an I2C start bit, then all write bytes are sent at once.
- All read bytes are ACKed, except the last byte which is NACKed, this process is handled internally between the Buzzpirat and the I2C device.
- At the end of the read process, the Buzzpirat sends an I2C stop
- Except as described above, there is no acknowledgment that a byte is received.

### I2C b00001001 (0x09) Extended AUX command
Provides extended use of AUX pin. Requires one command byte. Buzzpirat acknowledges 0x01.

Command	Function
- b00000000 (0x00) - AUX/CS low
- b00000001 (0x01) - AUX/CS high
- b00000010 (0x02) - AUX/CS HiZ
- b00000011 (0x03) - AUX read
- b00010000 (0x10) - use AUX
- b00100000 (0x20) - use CS


### I2C b11111110 (0xFE) - Execute Buzz Commands
Buzz Commands allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

You have access to the same commands as when you enter Buzz Mode using 0x0A. A list of the supported commands is available further below (the first one is 0x00)

Buzzpirat returns 0x01 if it has successfully entered this mode.

----------------


## b00000011 (0x03) - Enter binary UART mode, responds "ART1"

Enter binary UART mode by first entering bitbang mode, then send 0x03 to enter UART mode.

Most UART mode commands are a single byte. Commands generally return 1 for success, 0 for failure.

### UART Mode, Key points
- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Pause briefly after sending each 0x00 to check if BBIO1 is returned. Example binary mode entry functions.
- Enter 0x03 in bitbang mode to enter raw UART mode.
- Return to raw bitbang mode from raw UART mode by sending 0x00 one time.
- Hex values shown here, like 0x00, represent actual byte values; not typed ASCII entered into a terminal.

Once you have successfully entered the mode, you can use the following commands:

### UART b00000001 (0x01) – Display mode version string, responds "ART1"
Once in binary UART mode, send 0x01 to get the current mode version string. The Buzzpirat responds ‘ART1’, where 1 is the raw UART protocol version. Get the version string at any time by sending 0x01 again. This command is the same in all binary modes, the current mode can always be determined by sending 0x01.


### UART b0000001x – Start (0)/stop(1) echo UART RX
In binary UART mode the UART is always active and receiving. Incoming data is only copied to the USB side if UART RX echo is enabled. This allows you to configure and control the UART mode settings without random data colliding with response codes. UART mode starts with echo disabled. This mode has no impact on data transmissions.

Responds 0x01. Clears buffer overrun bit.

### UART b00000111 (0x07) – Manual baud rate configuration, send 2 bytes
Configures the UART using custom baud rate generator settings. This command is followed by two data bytes that represent the BRG register value. Send the high 8 bits first, then the low 8 bits.

Use the UART manual or an online calculator to find the correct value (key values: fosc 32mHz, clock divider = 2, BRGH=1) . Buzzpirat responds 0x01 to each byte. Settings take effect immediately.

### UART b00001111 (0x0F) - UART bridge mode (reset to exit)
Starts a transparent UART bridge using the current configuration. Unplug the Buzzpirat to exit.

### UART b0001xxxx – Bulk UART write, send 1-16 bytes (0=1byte!)
Bulk UART allows multi-byte writes. The Buzzpirat expects xxxx+1 data bytes. Up to 16 data bytes can be sent at once. Note that 0000 indicates 1 byte because there’s no reason to send 0. Buzzpirat replies 0x01 to each byte.

### UART b0100wxyz – Configure peripherals w=power, x=pullups, y=AUX, z=CS
Enable (1) and disable (0) Buzzpirat peripherals and pins. Bit w enables the power supplies, bit x toggles the on-board pull-up resistors, y sets the state of the auxiliary pin, and z sets the chip select pin. Features not present in a specific hardware version are ignored. Buzzpirat responds 0x01 on success.

{{< alert title="Note" >}}CS pin always follows the current HiZ pin configuration. AUX is always a normal pin output (0=GND, 1=3.3volts){{< /alert >}}

### UART b011000xx - Set UART speed
Set the UART at a preconfigured speed value: 0000=300, 0001=1200, 0010=2400,0011=4800,0100=9600,0101=19200,0110=31250 (MIDI), 0111=38400,1000=57600,1010=115200

Start default is 300 baud. Buzzpirat responds 0x01 on success. A read command is planned but not implemented in this version.

### UART b100wxxyz – Configure UART settings
- w=pin output HiZ(0)/3.3v(1)
- xx=databits and parity 8/N(0), 8/E(1), 8/O(2), 9/N(3)
- y=stop bits 1(0)/2(1)
- z=RX polarity idle 1 (0), idle 0 (1)

Startup default is 00000. Buzzpirat responds 0x01 on success. A read command is planned but not implemented in this version.

{{< alert title="Note" >}} that this command code is three bits because the databits and parity setting consists of two bits. It is not quite the same as the binary SPI mode configuration command code. {{< /alert >}}

### UART b11111110 (0xFE) - Execute Buzz Commands
Buzz Commands allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

You have access to the same commands as when you enter Buzz Mode using 0x0A. A list of the supported commands is available further below (the first one is 0x00)

Buzzpirat returns 0x01 if it has successfully entered this mode.

----------------

## b00000100 (0x04) - Enter binary 1-Wire mode, responds "1W01"

Enter binary 1-Wire mode by first entering bitbang mode, then send 0x04 to enter 1-Wire mode.
Most 1-Wire mode commands are a single byte. Commands generally return 1 for success, 0 for failure.

### 1-Wire Mode, Key points

- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Pause briefly after sending each 0x00 to check if BBIO1 is returned. Example binary mode entry functions.
- Enter 0x04 in bitbang mode to enter raw 1-Wire mode.
- Return to raw bitbang mode from raw 1-Wire mode by sending 0x00 one time.
- Hex values shown here, like 0x00, represent actual byte values; not typed ASCII entered into a terminal.

Once you have successfully entered the mode, you can use the following commands:

### 1-Wire b00000001 (0x01) – Display mode version string, responds "1W01"
Once in binary 1-Wire mode, send 0x01 to get the current mode version string. The Buzzpirat responds ‘1W01’, where 1 is the raw 1-Wire protocol version. Get the version string at any time by sending 0x01 again. This command is the same in all binary modes, the current mode can always be determined by sending 0x01.

### 1-Wire b00000010 (0x02) – 1-Wire reset
Send a 1-Wire reset. Responds 0x01.

### 1-Wire b00000100 (0x04) – Read byte
Reads a byte from the bus, returns the byte.

### 1-Wire b00001000 (0x08) - ROM search macro (0xF0)

### 1-Wire b00001001 (0x09) - ALARM search macro (0xEC)
Search macros are special 1-Wire procedures that determine device addresses. The command returns 0x01, and then each 8-byte 1-Wire address located. Data ends with 8 bytes of 0xff.

### 1-Wire b0001xxxx – Bulk 1-Wire write, send 1-16 bytes (0=1byte!)
Bulk write transfers a packet of xxxx+1 bytes to the 1-Wire bus. Up to 16 data bytes can be sent at once. Note that 0000 indicates 1 byte because there’s no reason to send 0. BP replies 0x01 to each byte.

### 1-Wire b0100wxyz – Configure peripherals w=power, x=pullups, y=AUX, z=CS
Enable (1) and disable (0) Buzzpirat peripherals and pins. Bit w enables the power supplies, bit x toggles the on-board pull-up resistors, y sets the state of the auxiliary pin, and z sets the chip select pin. Features not present in a specific hardware version are ignored. Buzzpirat responds 0x01 on success.

{{< alert title="Note" >}}CS pin always follows the current HiZ pin configuration. AUX is always a normal pin output (0=GND, 1=3.3volts){{< /alert >}}

### 1-Wire b11111110 (0xFE) - Execute Buzz Commands
Buzz Commands allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

You have access to the same commands as when you enter Buzz Mode using 0x0A. A list of the supported commands is available further below (the first one is 0x00)

Buzzpirat returns 0x01 if it has successfully entered this mode.

----------------

## b00000101 (0x05) - Enter binary RAW-WIRE mode, responds "RAW1"

Enter binary RAW-WIRE  mode by first entering bitbang mode, then send 0x05 to enter RAW2WIRE mode.

Most RAW-WIRE  mode commands are a single byte. Commands generally return 1 for success, 0 for failure.

### RAW-WIRE  Mode, Key points

- Send 0x00 to the user terminal (max.) 20 times to enter the raw binary bitbang mode. Pause briefly after sending each 0x00 to check if BBIO1 is returned. 
- Enter 0x05 in bitbang mode to enter raw RAW-WIRE  mode.
- Return to raw bitbang mode from raw RAW-WIRE  mode by sending 0x00 one time.
- Hex values shown here, like 0x00, represent actual byte values; not typed ASCII entered into a terminal.

Once you have successfully entered the mode, you can use the following commands:

### RAW-WIRE  b00000001 (0x01) – Display mode version string, responds "RAW1"
Once in binary RAW-WIRE  mode, send 0x01 to get the current mode version string. The Buzzpirat responds ‘RAW1’, where 1 is the raw RAW-WIRE  protocol version. Get the version string at any time by sending 0x01 again. This command is the same in all binary modes, the current mode can always be determined by sending 0x01.

### RAW-WIRE  b0000001x - I2C-style start (0) / stop (1) bit
Send an I2C start or stop bit. Responds 0x01. Useful for I2C-like 2-wire protocols, or building a custom implementation of I2C using the raw-wire library.

### RAW-WIRE  b0000010x- CS low (0) / high (1)
Toggle the Buzzpirat chip select pin, follows HiZ configuration setting. CS high is pin output at 3.3volts, or HiZ. CS low is pin output at ground. Buzzpirat responds 0x01.

### RAW-WIRE  b00000110 (0x06) - Read byte
Reads a byte from the bus, returns the byte. Writes 0xff to bus in 3-wire mode.

### RAW-WIRE  b00000111 (0x07) - Read bit
Read a single bit from the bus, returns the bit value.

### RAW-WIRE  b00001000 (0x08) - Peek at input pin
Returns the state of the data input pin without sending a clock tick.

### RAW-WIRE  b00001001 (0x09) - Clock Tick
Sends one clock tick (low->high->low). Responds 0x01.

### RAW-WIRE  b0000101x - Clock low (0) / high (1)
Set clock signal low or high. Responds 0x01.

### RAW-WIRE  b0000110x - Data low (0) / high (1)
Set data signal low or high. Responds 0x01.


### RAW-WIRE  b0001xxxx – Bulk transfer, send 1-16 bytes (0=1byte!)
Bulk write transfers a packet of xxxx+1 bytes to the bus. Up to 16 data bytes can be sent at once. Note that 0000 indicates 1 byte because there’s no reason to send 0. BP replies 0x01 to each byte in 2wire mode, returns the bus read in 3wire (SPI) mode.

### RAW-WIRE  b0010xxxx - Bulk clock ticks, send 1-16 ticks
Create bulk clock ticks on the bus. Note that 0000 indicates 1 clock tick because there’s no reason to send 0. BP replies 0x01.

### RAW-WIRE  b0011xxxx - Bulk bits, send 1-8 bits of the next byte (0=1bit!)
Bulk bits sends xxxx+1 bits of the next byte to the bus. Up to 8 data bytes can be sent at once. Note that 0000 indicates 1 byte because there’s no reason to send 0. BP replies 0x01 to each byte.

This is a PIC programming extension that only supports 2wire mode. All writes are most significant bit first, regardless of the mode set with the configuration command.

### RAW-WIRE  b0100wxyz – Configure peripherals w=power, x=pullups, y=AUX, z=CS

Enable (1) and disable (0) Buzzpirat peripherals and pins. Bit w enables the power supplies, bit x toggles the on-board pull-up resistors, y sets the state of the auxiliary pin, and z sets the chip select pin. Features not present in a specific hardware version are ignored. Buzzpirat responds 0x01 on success.

{{< alert title="Note" >}}CS pin always follows the current HiZ pin configuration. AUX is always a normal pin output (0=GND, 1=3.3volts){{< /alert >}}

### RAW-WIRE  b011000xx - Set bus speed, 3=~400kHz, 2=~100kHz, 1=~50kHz, 0=~5kHz
The last bit of the speed command determines the bus speed. Startup default is high-speed. Buzzpirat responds 0x01.

### RAW-WIRE  b1000wxyz – Config, w=HiZ/3.3v, x=2/3wire, y=msb/lsb, z=not used
Configure the raw-wire mode settings. w= pin output type HiZ(0)/3.3v(1). x= protocol wires (0=2, 1=3), toggles between a shared input/output pin (raw2wire), and a separate input pin (raw3wire). y= bit order (0=MSB, 1=LSB). The Buzzpirat responds 0x01 on success.

Default raw startup condition is 000z. HiZ mode configuration applies to the data pins and the CS pin, but not the AUX pin.

### RAW-WIRE  b10100100 (0xA4) - PIC write. Send command + 2 bytes of data, read 1 byte
An extension for programming PIC microcontrollers. Writes 20bits to the 2wire interface.

Payload is three bytes.

The first byte is XXYYYYYY, where XX are the delay in MS to hold the PGC pin high on the last command bit, this is a delay required at the end of a page write. YYYYYY is a 4 or 6 bit ICSP programming command to send to the PIC (enter 4 bit commands as 00YYYY, commands clocked in LSB first).

The second and third bytes are 16bit instructions to execute on the PIC.

See the PIC 16F/18F programming specifications for more about ICSP.

### RAW-WIRE  b10100101 (0xA5) - PIC read. Send command, read 1 byte of data
An extension for programming PIC microcontrollers. Writes 12bits, reads 8bits.

Payload is one byte 00YYYYYY, where YYYYYY is a 4 or 6 bit ICSP programming command to send to the PIC. Enter 4 bit commands as 00YYYY, all commands are clocked in LSB first.

The Buzzpirat send the 4/6bit command, then 8 '0' bits, then reads one byte. The read byte is returned.

See the PIC 16F/18F programming specifications for more about ICSP.

### RAW-WIRE b11111110 (0xFE) - Execute Buzz Commands
Buzz Commands allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

You have access to the same commands as when you enter Buzz Mode using 0x0A. A list of the supported commands is available further below (the first one is 0x00)

Buzzpirat returns 0x01 if it has successfully entered this mode.

----------------


## b00000110 (0x06) - Enter OpenOCD JTAG mode
OpenOCD mode is documented in the source only.

----------------


## b00001010 (0x0A) - Enter Buzz mode
This mode is exclusive to Buzzpirat and allows for actions such as reading all voltages (similar to the 'v' command), manipulating the TP0 pin, etc.

Buzzpirat returns 0x01 if it has successfully entered this mode.

Once you have successfully entered to the Buzz mode via b00001010 (0x0A) (from the main bitbang) or via b11111110 (0xFE) (from a protocol mode), you can use the following Buzz mode commands:

### Buzz b00000000 (0x00) - Take voltage measurement from all sources
Take a measurement from the Buzzpirat voltage sources. 

1. Returns a 2 byte ADC reading for 5v0 PWR, high 8bits come first.
2. Returns a 2 byte ADC reading for 3v3 PWR, high 8bits come first.
3. Returns a 2 byte ADC reading for 2v5 PWR, high 8bits come first.
4. Returns a 2 byte ADC reading for 1v8 PWR, high 8bits come first.
5. Returns a 2 byte ADC reading for VPU, high 8bits come first.
6. Returns a 2 byte ADC reading for ADC PROBE, high 8bits come first.
7. returns 0x01 if it has successfull.

{{< alert title="Note" >}}At the end of this page, you will find a code to convert each 2-byte ADC value.
{{< /alert >}}


### Buzz b00000001 (0x01) - TP0 INPUT LOW
Configure TP0 as INPUT LOW.

{{< alert title="Note" >}}TP0 is connected to VPU like MOSI, MISO.. pins. 
{{< /alert >}}

returns 0x01 if it has successfull.

### Buzz b00000010 (0x02) - TP0 OUTPUT LOW
Configure TP0 as OUTPUT LOW.

{{< alert title="Note" >}}TP0 is connected to VPU like MOSI, MISO.. pins. 
{{< /alert >}}

returns 0x01 if it has successfull.


### Buzz b00000011 (0x03) - Read TP0 status
Return 0x01 or 0x00 depending on the status of TP0 (1=HIGH, 0=LOW).

{{< alert title="Note" >}}TP0 is connected to VPU like MOSI, MISO.. pins. 
{{< /alert >}}

returns 0x01 if it has successfull.

### Buzz b00010000 (0x10) - Check for short circuits in the power supply units

Inspect the power supply units for short circuits across the 5V, 3.3V, 2.5V, and 1.8V lines.

Return 0x01 if any PSU voltage is abnormally low, indicating a potential short circuit.

Return 0x00 if all PSU voltages are within normal parameters.


{{< alert color="warning" title="Warning" >}}This command activates all the PSUs, checks the voltage of each one, and then turns off all the PSUs as quickly as possible{{< /alert >}}

{{< alert title="Note" >}}It is recommended to use this command before executing the command: "Configure peripherals w=1"{{< /alert >}}


## Buzz b00010010 (0x12) - Setup pulse-width modulation (requires 5 byte setup)

Configure and enable pulse-width modulation output in the AUX pin. 

Requires a 5 byte configuration sequence. 

Equations to calculate the PWM frequency and period are in the PIC24F output compare manual. 

- Bit 0 and 1 of the first configuration byte set the prescaler value. 
- The Next two bytes set the duty cycle register, high 8bits first. 
- The final two bytes set the period register, high 8bits first.

Responds 0x01 after a complete sequence is received. 

{{< alert color="warning" title="Warning" >}}The PWM remains active after leaving binary bitbang mode!{{< /alert >}}

{{< alert title="Note" >}}Further down on this page, you will find examples of how to generate the 5 byte setup.{{< /alert >}}

{{< alert title="Note" >}}This command was previously available only in the main menu; now, you can use it from any mode, including SPI, I2C, etc..{{< /alert >}}


### Buzz b00010011 (0x13) - Clear/disable PWM
Clears the PWM, disables PWM output. Responds 0x01.

{{< alert title="Note" >}}This command was previously available only in the main menu; now, you can use it from any mode, including SPI, I2C, etc..{{< /alert >}}

### Buzz b00010100 (0x14) - Take voltage probe measurement (returns 2 bytes)
Take a measurement from the Buzzpirat voltage probe. Returns a 2 byte ADC reading, high 8bits come first. To determine the actual voltage measurement: (ADC/1024)x3.3voltsx2; or simply (ADC/1024)x6.6.

{{< alert title="Note" >}}At the end of this page, you will find a code to convert the ADC value.{{< /alert >}}

{{< alert title="Note" >}}This command was previously available only in the main menu; now, you can use it from any mode, including SPI, I2C, etc..{{< /alert >}}

### Buzz b00010101 (0x15) - Continuous voltage probe measurement
Sends ADC data (2bytes, high 8 first) as fast as UART will allow. A new reading is not taken until the previous finishes transmitting to the PC, this prevents time distortion from the buffer. Added for the oscilloscope script.

{{< alert title="Note" >}}This command was previously available only in the main menu; now, you can use it from any mode, including SPI, I2C, etc..{{< /alert >}}

### Buzz b00010110 (0x16) - Frequency measurement on AUX pin
Takes frequency measurement on AUX pin. Returns 4byte frequency count, most significant byte first.

{{< alert title="Note" >}}This command was previously available only in the main menu; now, you can use it from any mode, including SPI, I2C, etc..{{< /alert >}}

----------------

## b00001111 (0x0F) - Reset Buzzpirat

The Buzzpirat responds 0x01 and then performs a complete hardware reset. The hardware and firmware version is printed (same as the 'i' command in the terminal), and the Buzzpirat returns to the user terminal interface. Send 0x00 20 times to enter binary mode again.
Note: there may be garbage data between the 0x01 reply and the version information as the PIC UART initializes.

----------------

## b00010000 (0x10) - Buzzpirat Short self-test & b00010001 (0x11) Long self-test

Self-test commands

b00010001 (0x11) Long test (requires jumpers between +5 and Vpu, +3.3 and ADC)

The full test is the same as self-test in the user terminal, it requires jumpers between two sets of pins in order to test some features. The short test eliminates the six checks that require jumpers.

After the test is complete, the Buzzpirat responds with the number of errors. It also echoes any input plus the number of errors. The MODE LED blinks if the test was successful, or remains solid if there were errors. Exit the self-test by sending 0xff, the Buzzpirat will respond 0x01 and return to binary bitbang mode.

----------------

## b00010010 (0x12) - Setup pulse-width modulation (requires 5 byte setup)

Configure and enable pulse-width modulation output in the AUX pin. 

Requires a 5 byte configuration sequence. 

Equations to calculate the PWM frequency and period are in the PIC24F output compare manual. 

- Bit 0 and 1 of the first configuration byte set the prescaler value. 
- The Next two bytes set the duty cycle register, high 8bits first. 
- The final two bytes set the period register, high 8bits first.

Responds 0x01 after a complete sequence is received. 

{{< alert color="warning" title="Warning" >}}The PWM remains active after leaving binary bitbang mode!{{< /alert >}}

{{< alert title="Note" >}}Further down on this page, you will find examples of how to generate the 5 byte setup.{{< /alert >}}

----------------

## b00010011 (0x13) - Clear/disable PWM
Clears the PWM, disables PWM output. Responds 0x01.

----------------

## b00010100 (0x14) - Take voltage probe measurement (returns 2 bytes)
Take a measurement from the Buzzpirat voltage probe. Returns a 2 byte ADC reading, high 8bits come first. To determine the actual voltage measurement: (ADC/1024)x3.3voltsx2; or simply (ADC/1024)x6.6.

{{< alert title="Note" >}}At the end of this page, you will find a code to convert the ADC value.{{< /alert >}}

----------------

## b00010101 (0x15) - Continuous voltage probe measurement
Sends ADC data (2bytes, high 8 first) as fast as UART will allow. A new reading is not taken until the previous finishes transmitting to the PC, this prevents time distortion from the buffer. Added for the oscilloscope script.

----------------

## b00010110 (0x16) - Frequency measurement on AUX pin
Takes frequency measurement on AUX pin. Returns 4byte frequency count, most significant byte first.

----------------

## b010xxxxx - Configure pins as input(1) or output(0): AUX|MOSI|CLK|MISO|CS

Configure pins as an input (1) or output(0). The pins are mapped to the lower five bits in this order:
- AUX|MOSI|CLK|MISO|CS.

The Buzzpirat responds to each direction update with a byte showing the current state of the pins, regardless of direction. This is useful for open collector I/O modes.

----------------

## b1xxxxxxx - Set on (1) or off (0): POWER|PULLUP|AUX|MOSI|CLK|MISO|CS
The lower 7bits of the command byte control the Buzzpirat pins and peripherals. Bitbang works like a player piano or bitmap. The Buzzpirat pins map to the bits in the command byte as follows:

- 1|POWER|PULLUP|AUX|MOSI|CLK|MISO|CS

The Buzzpirat responds to each update with a byte in the same format that shows the current state of the pins.



----------------

## ADC Calculation

### Python 3
```python
#!/usr/bin/env python3

adc_high = 0x03
adc_low = 0x08

adc_buzz = (adc_high << 8) + adc_low
print(f"Combined ADC value (hex): {hex(adc_buzz)}")

result = (adc_buzz / 1024) * 6.6
print(f"Result for ADC value {adc_buzz} (hex {hex(adc_buzz)}): {result}")
```

Output:
```
Combined ADC value (hex): 0x308
Result for ADC value 776 (hex 0x308): 5.0015624999999995
```

### C
```c
#include <stdio.h>

int main() {
    unsigned char adc_high = 0x03;
    unsigned char adc_low = 0x08;

    unsigned int adc_buzz = (adc_high << 8) + adc_low;
    printf("Combined ADC value (hex): 0x%x\n", adc_buzz);

    double result = (((double)adc_buzz) / 1024.0) * 6.6;
    printf("Result for ADC value %u (hex 0x%x): %f\n", adc_buzz, adc_buzz, result);

    return 0;
}
```

Output:
```
Combined ADC value (hex): 0x308
Result for ADC value 776 (hex 0x308): 5.001562
```

----------------

## PWM Computation

### Python 3
Here is a Python Script for computing the PWM for Buzzpirat.

For example, setup PWM with Period of 1msec, 50% duty cycle. Using 1:1 Prescaler.

Modify only the 3 lines:
```
Prescaler=1 # 1:1
PwmPeriod=1e-3  # 0.1msec
DutyCycleInPercent=.5 # 50%
```

It will output:
```
======================
PwmPeriod: 0.00100000000000000002 sec.
Tcy: 0.00000006250000000000 sec.
Prescaler: 1
PR2: 0x3e7f = 15999
OCR: 0x1f3f = 7999
5 Byte Setup:
1st Byte: 0x00
2nd Byte: 0x1f
3rd Byte: 0x3f
4th Byte: 0x3e
5th Byte: 0x7f
```

Use the 5byte setup to set the PWM.

```python
#!/usr/bin/env python3

'''
Python Script 00.08.00
    - by 7 mod by Dreg
'''

# 32MHz Crystal Oscillator
Fosc = 32e6  # DONT MODIFY THIS

Prescaler = 1  # [1, 8, 64, 256]
PwmPeriod = 1e-3  # 0.1 msec
DutyCycleInPercent = 0.5  # 50%

###################################################
#### ---------------------------------------- #####
#### -- DON'T MODIFY ANYTHING BELOW THIS LINE #####
#### ---------------------------------------- #####
###################################################

'''
Configure and enable pulse-width modulation output in the AUX pin.
Requires a 5 byte configuration sequence.
Responds 0x01 after a complete sequence is received.
The PWM remains active after leaving binary bitbang mode! 
Equations to calculate the PWM frequency and period are in the PIC24F
output compare manual. Bit 0 and 1 of the first configuration byte
set the prescaler value. The Next two bytes set the duty cycle register,
high 8 bits first. The final two bytes set the period register, high 8 bits first.
'''

PrescalerList = {1: 0, 8: 1, 64: 2, 256: 3}
Tcy = 2.0 / Fosc
PRy = PwmPeriod / (Tcy * Prescaler)
PRy = PRy - 1
OCR = PRy * DutyCycleInPercent

print("======================")
print(f"PwmPeriod: {PwmPeriod:.20f} sec.")
print(f"Tcy: {Tcy:.20f} sec.")
print(f"Prescaler: {int(Prescaler)}")
print(f"PR2: 0x{int(PRy):x} = {int(PRy)}")
print(f"OCR: 0x{int(OCR):x} = {int(OCR)}")
#####
print("5 Byte Setup:")
print(f"1st Byte: 0x{int(PrescalerList[Prescaler]):02x}")
print(f"2nd Byte: 0x{(int(OCR) >> 8) & 0xFF:02x}")
print(f"3rd Byte: 0x{int(OCR) & 0xFF:02x}")
print(f"4th Byte: 0x{(int(PRy) >> 8) & 0xFF:02x}")
print(f"5th Byte: 0x{int(PRy) & 0xFF:02x}")
```

### C

```c
#include <stdio.h>

int main() {
    // 32MHz Crystal Oscillator
    double Fosc = 32e6;  // DON'T MODIFY THIS

    unsigned int Prescaler = 1;    
    //unsigned int Prescaler = 8;  
    //unsigned int Prescaler = 64; 
    //unsigned int Prescaler = 256;  
    double PwmPeriod = 1e-3;  // 0.1 msec
    double DutyCycleInPercent = 0.5;  // 50%

    // DON'T MODIFY ANYTHING BELOW THIS LINE

    // Configure and enable pulse-width modulation output in the AUX pin
    unsigned int listv;
    switch (Prescaler) {
        case 1:
            listv = 0;
            break;
        case 8:
            listv = 1;
            break;
        case 64:
            listv = 2;
            break;
        case 256:
            listv = 3;
            break;
        default:
            listv = 0;
            break;
    }
    double Tcy = 2.0 / Fosc;
    double PRy = PwmPeriod / (Tcy * Prescaler);
    PRy = PRy - 1;
    double OCR = PRy * DutyCycleInPercent;

    printf("======================\n");
    printf("PwmPeriod: %.20f sec.\n", PwmPeriod);
    printf("Tcy: %.20f sec.\n", Tcy);
    printf("Prescaler: %u\n", Prescaler);
    printf("PR2: 0x%x = %u\n", (unsigned int)PRy, (unsigned int)PRy);
    printf("OCR: 0x%x = %u\n", (unsigned int)OCR, (unsigned int)OCR);
    printf("5 Byte Setup:\n");
    printf("1st Byte: 0x%02x\n", listv);
    printf("2nd Byte: 0x%02x\n", ((unsigned int)OCR >> 8) & 0xFF);
    printf("3rd Byte: 0x%02x\n", (unsigned int)OCR & 0xFF);
    printf("4th Byte: 0x%02x\n", ((unsigned int)PRy >> 8) & 0xFF);
    printf("5th Byte: 0x%02x\n", (unsigned int)PRy & 0xFF);

    return 0;
}
```

Output:
```
======================
PwmPeriod: 0.00100000000000000002 sec.
Tcy: 0.00000006250000000000 sec.
Prescaler: 1
PR2: 0x3e7f = 15999
OCR: 0x1f3f = 7999
5 Byte Setup:
1st Byte: 0x00
2nd Byte: 0x1f
3rd Byte: 0x3f
4th Byte: 0x3e
5th Byte: 0x7f
```
