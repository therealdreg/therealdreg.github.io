---
title: How to use
description: How to use your Buzzpirat mod from dangerousprototypes
weight: 1
---

Once you have understood the 'Getting Started' section, here you can delve deeper into the use of Buzzpirat.

The Buzzpirat is controlled by text commands entered through the serial terminal. If the terminal is blank, press enter to show the command prompt. Press '?', followed by enter, to show the help menu.

Menus configure various Buzzpirat options like pull-up resistors, terminal speed, data display format (DEC, HEX, BIN), etc. Type the menu command, followed by enter, to display the options.
Syntax is used to interact with a device connected over a bus. Commands are mostly single characters, such as 'r' to read a byte. Enter up to 4000 characters of syntax, press enter to execute the sequence.

Most menus have a default option shown in () before the prompt:

```
Output type:
1. High-Z outputs (H=input, L=GND)
2. Normal outputs (H=Vcc, L=GND)
(1) > <<< option 1 is the default

Press enter to select the default option.
```

{{< toc >}}


## Terminal

Talk to the Buzzpirat from a serial terminal set to 115200bps, 8/N/1

The Buzzpirat understands some VT-100 (ANSI C0) terminal emulation.

| Keyboard Key   | Ctrl-Key | Action                                                               |
|----------------|----------|----------------------------------------------------------------------|
| [left arrow]   | ^B       | Moves the cursor left one character                                  |
| [right arrow]  | ^F       | Moves the cursor right one character                                 |
| [up arrow]     | ^P       | Copies the previous command in the command history buffer to the command line |
| [down arrow]   | ^N       | Copies the next command in the command history buffer to the command line |
|                | ^A       | Moves the cursor to the beginning of the line                        |
|                | ^E       | Moves the cursor to the end of the line                              |
| [backspace]    | ^H       | Erases the character to the left of the cursor and moves the cursor left one character |
| [delete]       | ^D       | Erases the character under (or to the right of) the cursor and moves the cursor left one character |


## Configuration commands

### '?' Help menu with latest menu and syntax options

Print a help screen with all available menu and syntax options in the current firmware and hardware.

```
HiZ>?
 General                                        Protocol interaction
 ---------------------------------------------------------------------------
 ?      This help                       (0)     List current macros
 =X/|X  Converts X/reverse X            (x)     Macro x
 ~      Selftest                        [       Start
 #      Reset the BP                    ]       Stop
 $      Jump to bootloader              {       Start with read
 &/%    Delay 1 us/ms                   }       Stop
 a/A/@  AUXPIN (low/HI/READ)            "abc"   Send string
 b      Set baudrate                    123
 c/C    AUX assignment (aux/CS)         0x123
 d/D    Measure ADC (once/CONT.)        0b110   Send value
 f      Measure frequency               r       Read
 g/S    Generate PWM/Servo              /       CLK hi
 h      Commandhistory                  \       CLK lo
 i      Versioninfo/statusinfo          ^       CLK tick
 l/L    Bitorder (msb/LSB)              -       DAT hi
 m      Change mode                     _       DAT lo
 o      Set output type                 .       DAT read
 p/P    Pullup resistors (off/ON)       !       Bit read
 s      Script engine                   :       Repeat e.g. r:10
 v      Show volts/states               .       Bits to read/write e.g. 0x55.2
 w/W    PSU (off/ON)            <x>/<x= >/<0>   Usermacro x/assign x/list all
 e/E    TP0 (input-low+READ/output-low) (TP0 is connected to VPU)
HiZ>
```

### 'i' Hardware, firmware, microcontroller version information

The information menu displays the hardware, firmware, and microcontroller version.

```
HiZ> i
Buzzpirat v3.5 <<<hardware version
Community Firmware v7.1 - buzzpirat.com by Dreg LASTDEV [HiZ 1-WIRE UART I2C SPI 2WIRE 3WIRE KEYB LCD PIC DIO] Bootloader v4.5 <<<firmware and bootloader version, project webpage
DEVID:0x0447 REVID:0x3046 (24FJ64GA00 2 B8) <<<PIC device ID and revision
http://dangerousprototypes.com <<<dangerousprototypes webpage
```
HiZ>


If a bus mode is configured additional information about the configuration options is printed.

```
*----------*
POWER SUPPLIES OFF
Voltage monitors: 5V: 0.0 | 3.3V: 0.0 | VPULLUP: 0.0 |
a/A/@ controls AUX pin
Normal outputs (H=V+, L=GND)
Pull-up resistors ON
MSB set: MOST sig bit first

* ----------*
RAW2WIRE>
```

### 'm' Set bus mode (1-Wire, SPI, I2C, JTAG, UART, etc)

Select a bus mode. The command resets the Buzzpirat and immediately disables all pins, pull-up resistors, and power supplies.

The default mode is HiZ, a safe mode with all pins set to high-impedance and all peripherals disabled.

```
HiZ>m
1. HiZ
2. 1-WIRE
3. UART
4. I2C
5. SPI
6. 2WIRE
7. 3WIRE
8. KEYB
9. LCD
10. PIC
11. DIO
x. exit(without change)

(1)>
```

### 'h' Command history

The previous 10 commands can be replayed from the command history menu.
```
SPI> h
1. h
2. [10 r:3]
3. m
4. i
x. exit

(0)> 2 <<<replay #2
CS ENABLED
WRITE: 0x0A
READ: 0x00 0x00 0x00
CS DISABLED
SPI>
``` 

### 'c'/'C' Toggle AUX control between AUX and CS/TMS pins

Sometimes it's useful to control the CS pin from the user terminal. The c/C configures the a/A/@ commands to control the AUX or CS pins.
```
3WIRE> c
a/A/@ controls AUX pin
3WIRE> C
a/A/@ controls CS/TMS pin
3WIRE>
```

### 'l'/'L' Set MSB/LSB first in applicable modes
The l/L command determines the bit order for reading and writing bytes in some bus modes. The bitorder command is available in all modes
```
3WIRE> l
MSB set: MOST sig bit first
3WIRE> L
MSB set: LEAST sig bit first
3WIRE>
```

### 'o' Data display format (DEC, HEX, BIN, or raw)

The Buzzpirat can display values as hexadecimal, decimal, binary, and a raw ASCII byte. Change the setting in the data display format menu (o). The default display format is HEX.

The RAW display mode sends values to the terminal as raw byte values without any text conversion. This is useful for ASCII serial interfaces. It can also be used to speed up the display of bus sniffers and other high-speed functions where converting raw bytes to text takes too much time. Adjust the display format in your serial terminal to see the raw values as HEX/DEC/BIN.
```
HiZ> o
1. HEX
2. DEC
3. BIN
4. RAW

(1)>
Display format set
HiZ>
```

### 'b' Set PC side serial port speed

Adjust the speed of the serial port facing the computer (and USB->serial converter chip).

After choosing a speed you must adjust the serial terminal and press space to continue. The Buzzpirat will pause until the space key is pressed to verify that the terminal speed is correct.

```
(9)> 10
Enter raw value for BRG

(34)> 34
Adjust your terminal
Space to continue
HiZ>
```

There is an option to set a custom baud rate with a raw BRG value. The value can be calculated according to the datasheet or with a utility (key constants: PIC24, 32MHz/16MIPS, BRGH=1): https://github.com/therealdreg/buzzpirat/tree/main/bin/PicBaud.exe

230400 baud is '16' (2.2% error)
460800 baud is '8' (3.3% error)
921600 baud is '3' (8.51% error)
One thing to note is that on some early PIC revisions (A3) the UART is weird and the exact values won't work. On these chips try a value +/-1.

```
HiZ> b
Set serial port speed: (bps)
1. 300
2. 1200
3. 2400
4. 4800
5. 9600
6. 19200
7. 38400
8. 57600
9. 115200
10. BRG raw value

(9)>
Adjust your terminal
Space to continue
HiZ>
```

### '~' Perform a self-test

Perform a hardware self-test. Requires jumpers between +5 and Vpu, +3.3 and ADC.

```
HiZ> ~
Disconnect any devices
Connect (Vpu to +5V) and (ADC to +3.3V)
Space to continue
```

### '#' Reset
Reset the Buzzpirat. 

```
HiZ>#
RESET

Buzzpirat v3.5
Community Firmware v7.1 - buzzpirat.com by Dreg LASTDEV [HiZ 1-WIRE UART I2C SPI 2WIRE 3WIRE KEYB LCD PIC DIO] Bootloader v4.5
DEVID:0x0447 REVID:0x3046 (24FJ64GA00 2 B8)
http://dangerousprototypes.com
HiZ>
```


### '$' Jump to bootloader

Bootloader v4.5 will respond with a version string if a key is pressed while it's active.

```
HiZ> $
Are you sure? y
BOOTLOADER

Enter the bootloader for a firmware update without connecting the PGC and PGD pins. Remember to disconnect your terminal program before the upgrade.

BL4+BL4+
```


## Utilities commands

### 'w'/'W' Power supplies (off/ON)

Toggle the switchable 1.8volt, 2.5volt, 3.3volt and 5.0volt power supplies with the w/W command. Capital 'W' enables the supplies, lowercase 'w' disables them. The power supplies on the Buzzpirat can supply up to 300mA

```
1-WIRE> w
POWER SUPPLIES OFF
1-WIRE> W
POWER SUPPLIES ON
1-WIRE>
```

### 'v' Power supply voltage report

The voltage report shows the current state of all the Buzzpirat pins and peripherals.

The first line is the pin number, according to the silk screen on the v3 PCB, and the wire color. T

The second line is the pin function in the current bus mode. The power supplies (1.8v, 2.5v, 3.3v, 5.0v), ADC, Vpu, and AUX pins are available in all modes. The other four pins will differ depending on the mode. In 1-Wire mode only one pin is used, one wire data (OWD).

The third line shows the current direction of each pin. I is an input pin, O is an output pin, P is a power supply.

The fourth line shows the current state of each pin. A voltage measurement is displayed for analog pins. The current pin reading, H high and L low, is printed for each digital pins.

```
I2C>v
Pinstates:
1.(BR)  2.(RD)  3.(OR)  4.(YW)  5.(GN)  6.(BL)  7.(PU)  8.(GR)  9.(WT)  0.(Blk)
GND     3.3V    5.0V    ADC     VPU     AUX     SCL     SDA     -       -
P       P       P       I       I       I       I       I       I       I
GND     3.31V   4.87V   0.00V   2.44V   L       H       H       H       H

1.(BR)  2.(RD)  3.(OR)
2.5V    1.8V    TP0
P       P       I
2.50V   1.79V   H
I2C>
```

### 'p'/'P' Pull-up resistors

p and P toggle the pull-up resistors off and on. 

The on-board pull-up resistors must be powered through the Vpullup pin of the IO header. A warning is displayed if there's no voltage on the Vpullup pin. Check the voltage report ('v') and verify that Vpu is attached to a power supply. See the practical guide to Buzzpirat pull-up resistors for a simple introduction.

Pull-up resistors are generally used with open collector/open drain bus types. A warning is displayed when the pull-ups are enabled if the Buzzpirat is configured for normal pin output.

```
I2C>P
Pull-up resistors ON
I2C>
```

### 'f' Measure frequency on the AUX pin

Measures frequency from 0Hz to 40MHz on the AUX pin, the method is an actual 1 second tick count. If the frequency is lower than a few MHz, the Buzzpirat does an 'autorange' and measures the frequency again for an additional second.

```
2WIRE> f
Frequency on AUX pin: autorange 50,283 Hz
2WIRE>
```

### 'g' Frequency generator/PWM on the AUX pin

Enable the frequency generator with g, then set frequency and duty cycle. Frequencies from 1kHz to 4MHz are possible. Use g again to disable the PWM.

Note that the resolution at 4MHz is only 1 bit. Anything other than 50% duty cycle will be 100% off or 100% on.

```
2WIRE> g
1KHz-4,000KHz PWM/frequency generator
Frequency in KHz
(50)> 2000
Duty cycle in %
(50)>
PWM active
2WIRE> g
PWM disabled
2WIRE>
```

### 'S' Servo

S positions the servo arm to the desired angle, 0-180 degrees. The servo value can be updated as needed, press enter or x to exit. Use 'S' or 'g' again to disable the servo.

```
1-WIRE>S
Position in degrees
(90)>20
Servo active
(x)>100
Servo active
(x)>30
Servo active
(x)>
1-WIRE>S
PWM disabled
1-WIRE>S 90 %:5000 S 180
Servo active
DELAY 5000ms
Servo active
1-WIRE>
```

{{< alert color="warning" title="Warning" >}}Some servos draw more current than the Buzzpirat can supply!! Use an external power supply instead.{{< /alert >}}

### '=' Convert to HEX/DEC/BIN number format

Base conversion command, available in all modes. Press '=' and enter any byte value to see the HEX/DEC/BIN equivalent. Firmware v2.1+

```
2WIRE> =0b110
0x06 = 6 = 0b00000110
2WIRE> =0xa
0x0A = 10 = 0b00001010
2WIRE> =12
0x0C = 12 = 0b00001100
2WIRE>
```

### '|' Reverse bits in byte 

Reverse bit order in byte X. Displays the HEX/DEC/BIN value of the reversed byte.

```
I2C> |0b10101010
0x55 = 85 = 0b01010101
I2C> |0b10000000
0x01 = 1 = 0b00000001
I2C> |1
0x80 = 128 = 0b10000000
I2C>
```

### 's' BASIC script engine
Simple BASIC scripts can automate repetitive and tedious tasks.

```
2WIRE> s
2WIRE(BASIC)> list

65535 bytes.
Ready.
2WIRE(BASIC)>
```

### 'd'/'D' Measure from voltage probe (once/CONTINUOUS)

A lowercase d takes a measurement from the voltage measurement probe (ADC pin on the IO header).

A capital D takes continuous measurements from the voltage probe, press any key to exit.

The Buzzpirat voltage probe can measure up to 6.0volts (max 6.6volts, but with some margin for error).

```
HiZ> d
VOLTAGE PROBE: 3.31V
HiZ> D
VOLTMETER MODE
Any key to exit
VOLTAGE PROBE: 3.30V
```

### 'a'/'A'/'@' Control axillary pin (low/HIGH/read)

The axillary pin is a general purpose digital pin that can be controlled from the Buzzpirat terminal. Capital A makes it a 3.3volt output (25mA max). Lowercase a makes it sink to ground (25mA max). @ makes in an input and reads the current state (5volt maximum input).

a/A/@ can also be used to control the CS pin using the 'c'/'C' commands.

```
UART> A
AUX HIGH
UART> a
AUX LOW
UART> @
AUX INPUT/HI-Z, READ: 0
UART>
```

## Macros, user macros
Macros perform complex actions, like scanning for I2C addresses, interrogating a smart card, or probing a JTAG chain. Macros are numbers entered inside (). Macro (0) always displays a list of macros available in the current bus mode.


### (0) List mode macros
```
I2C> (0)
0.Macro menu
1.7bit address search
2.I2C sniffer
I2C>
```

Macro (0) always displays a list of macros available in the current bus mode.

### (#) Run macro
```
I2C>(1)<<<I2C search macro
Searching 7bit I2C address space.
Found devices at:
0xA0(0x50 W) 0xA1(0x50 R)
I2C>
```

Execute a macro by typing the macro number between ().

### <x= > Assign user macro
```
I2C> <1=[0xa1 r:8]>
I2C>
```

5 user macros can be stored to automate common commands. Each position can store 32 chars (including space).

### <0> List user macros
```
I2C> <0>
1. <[0xa1 r:8]>
2. <>
3. <>
4. <>
5. <>
I2C>
```

User macro <0> lists the currently stored use macros.

### <#> Run user macro #
```
I2C> <1>
I2C> [0xa1 r:8]
```

Enter the macro number to recall the command. Press enter to execute.

## Bitwise bus commands
Bitwise commands are only available in certain bus modes.

### '^' Send one clock tick
```
2WIRE> ^
CLOCK TICK
2WIRE>
```

Send one clock tick. ^:1…255 for multiple clock ticks.

### '/' or '\\' Toggle clock level high (/) and low (\\)

```
2WIRE> /\
CLOCK, 1
CLOCK, 0
2WIRE>
```

Set the clock signal high or low. Includes clock delay.

### '-' or '&#95;' Toggle data state high (-) and low ('&#95;')
```
2WIRE> -_
DATA OUTPUT, 1
DATA OUTPUT, 0
2WIRE>
```

Set the data signal high or low. Includes data setup delay

### '!' Read one bit with clock
```
2WIRE> !
READ BIT:
0 *pin is now HiZ
2WIRE>
```

Send one clock tick and read one bit from the bus.

On a bus with a bi-directional data line (raw2wire, 1-Wire), the data pin is left as a high-impedance input after this command.

### '.' Read data pin state (no clock)
```
2WIRE> .
0 *pin is now HiZ
2WIRE>
```

Make the data pin an input and read, but do not send a clock. This can be used as /.\ to achieve the same thing as the ! command.

On a bus with a bi-directional data line (raw2wire, 1-wire), the data pin is left as a high-impedance input after this command.

## Bus interaction commands

These commands actually manipulate the bus and interacts with chips. These commands have the same general function in each bus mode, such as 'r' to read a byte of data. See the individual bus mode guides for each protocol.

### '&#123;' or '&#91;' Bus start condition

``` 
I2C> [
I2C START BIT
I2C>
```

This command generally starts bus activity. In various modes it starts (I2C), selects (SPI), resets (1-wire), or opens (UART).

### ']' or '}' Bus stop condition
```
SPI> ]
CS DISABLED
SPI>
```

This command generally stops bus activity. In various modes it stops (I2C), deselects (SPI), or closes (UART).

### 'r' Read byte
```
I2C> r
READ: 0x00
I2C> r:3
READ: ACK 0x00 ACK 0x00 ACK 0x00
I2C>
```

r reads a byte from the bus. Use with the repeat command (r:1…255) for bulk reads.

### 0b01 Write this binary value
```
I2C> 0b1001
WRITE: 0x09 ACK
I2C> 0b1001:2
WRITE: 0x09 ACK 0x09 ACK
I2C>
```

Enter a binary value to write it to the bus.

Binary values are commonly used in electronics because the 1's and 0's correspond to register 'switches' that control various aspects of a device. Enter a binary number as 0b and then the bits. Padding 0's are not required, 0b00000001=0b1. Can be used with the repeat command.

### 0x01 Write this HEX value
```
SPI> 0x15
WRITE: 0x15
SPI> 0xfa:5
WRITE: 0xFA 0xFA 0xFA 0xFA 0xFA
SPI>
```

Enter a HEX value to write it to the bus.

Hexadecimal values are base 16 numbers that use a-f for the numbers 10-15, this format is very common in computers and electronics. Enter HEX values as shown above, precede the value with 0x or 0h. Single digit numbers don't need 0 padding, 0x01 and 0x1 are interpreted the same. A-F can be lower-case or capital letters.

### 0-255 Write this decimal value
```
SPI> 18
WRITE: 0x12
SPI> 13:5
WRITE: 0x0D 0x0D 0x0D 0x0D 0x0D
SPI>
```

Any number not preceded by 0x, 0h, or 0b is interpreted as a decimal value and sent to the bus.

Decimal values are common base 10 numbers. Just enter the value, no special designator is required.

### "abc" Write this ASCII string
```
SPI> "abcd"
WRITE: "abcd"
SPI>
```

The ASCII values enclosed in "" are sent to the bus. 

### ' ' (space), Value delimiter
```
SPI> [1 2,3rr]
CS ENABLED
WRITE: 0x01
WRITE: 0x02
WRITE: 0x03
READ: 0x0A
READ: 0x0A
CS DISABLED
SPI>
```

Use a coma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values.

### '&'/'%' Delay 1uS/MS
```
SPI> &
DELAY 1us
SPI> &:10
DELAY 10us
SPI> %
DELAY 1ms
SPI> %:10
DELAY 10ms
SPI>
```

& delays 1us, % delays 1ms. Use the repeat command for multiple delays.

### ':' Repeat (e.g. r:10)
```
SPI> &:10
DELAY 10us
SPI> r:0b10
READ: 0x00 0x00
SPI> 5:0x3
WRITE: 0x05 0x05 0x05
SPI>
```

Many Buzzpirat commands can be repeated by adding ': ' to a command, followed by the number of times to repeat the command. To read five byte, enter r:5, etc. The repeat values can be HEX/DEC/BIN.

### ';' Partial (<16 bit) read/write (e.g. 0x55;3)
```
2WIRE> 0xaa;4
WRITE: 0x0A;4
```

Will write 0x0a (4 bits) to the bus.

```
2WIRE> 0xFFFF;12
WRITE: 0x0FFF;12
```

Will write 0x0FFF (12 bits) to the bus.

```
2WIRE> 0x55:4;2
WRITE: 0x01;2 0x01;2 0x1;2 0x01;2
```

Can be combined with the repeat command.

NOTE: works currently only with the raw2wire and raw3wire busses.


## 1-Wire

- **Bus:** [1-Wire](http://en.wikipedia.org/wiki/1-Wire) (Dallas/Maxim 1-Wire protocol).
- **Connections:** one pin (OWD) and ground.
- **Output types:** open drain/open collector, pull-up resistor required.
- **Pull-up resistors:** always required (2K – 10K, 2K or less for parasitic power parts).
- **Maximum voltage:** 5.5volts (5volt safe).

1-Wire uses a single data signal wire. Most devices also require a power and ground connection. Some parts draw power parasitically through the 1-Wire bus and don't require a separate power source.

### Syntax


| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. @ sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `{` or `[` | 1-Wire bus reset. |
| `]` or `}` | – |
| `r` | Read one byte. (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is 0b00000000 for a byte, but partial bytes are also fine: 0b1001. |
| `0x` | Write this HEX value. Format is 0×01. Partial bytes are fine: 0xA. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by 0x or 0b is interpreted as a decimal value. |
| `,` | Value delimiter. Use a coma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |
| `Bitwise` | - |
| `^` | One clock tick, use data state from previous – or _ operation. (`^:1…255` for multiple clock ticks) |
| `/` or `\` | – |
| `-` or `_` | Set the 1-Wire data state to 1 (-) or 0 (_). This will be used on the next ^ command, no actual bus change. (updated in v5.2, this previously set the state and sent a bit) |
| `!` | Read one bit with clock. |
| `.` | Read current data state setting from last - or _ command, no actual bus change. |


### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1-50` | Reserved for device address shortcuts. |
| `51` | READ ROM (0×33) *for single device bus |
| `85` | MATCH ROM (0×55) *followed by 64bit address |
| `204` | SKIP ROM (0xCC) *followed by command |
| `236` | ALARM SEARCH (0xEC) |
| `240` | SEARCH ROM (0xF0) |


**Notes:**

1-Wire specifies a 2K or smaller resistor when working with parasitically powered devices. Since v3a the on-board pull-up resistor on MOSI are 2K. Use an external 2K pull-up resistor if you have a v2go. Parasitically powered parts may appear to work with resistors larger than 2K ohms, but will fail certain operations (like EEPROM writes).

The 1-wire reset command can detect two bus errors. If no 1-wire chips respond to the reset command by pulling the bus low, it will report *No device detected (0x02). If the bus stays low for too long after the reset, because the pull-up resistor isn't working or there's a short circuit, it will report *Short or no pull-up (0x01).

One wire is a time sensitive protocol. There's no actual data wire to set high or low with the - and _ commands, so we just store the desired value and send it with the next clock tick (^).

The _ and - commands just set the data state that will be used on the next clock tick command (^). Example: previously you could write 4 high bits with -^^^, now you must use -^^^^. We feel this is more consistent with the operation of the other modes.

## UART

- **Bus:** [UART](http://en.wikipedia.org/wiki/Serial_uart), [MIDI](http://en.wikipedia.org/wiki/Musical_Instrument_Digital_Interface) (universal asynchronous receiver transmitter).
- **Connections:** two pins (RX/TX) and ground.
- **Output types:** 3.3volt normal output, or [open collector](http://en.wikipedia.org/wiki/High_impedence)  pull-up resistors required.
- **Pull-up resistors:** required for open collector output mode (2K – 10K).
- **Maximum Voltage:** 5.5volts (5volt safe).

UART is also known as the common PC serial port. The PC serial port operates at full RS232 voltage levels (-13volts to +13volts) which are not compatible with the Buzzpirat.

### Configuration options

- **Speed (bps):** 300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 31250, BRG.
- **Data bits and parity:** 8/none, 8/even, 8/odd, 9/none.
- **Stop bits:** 1, 2.
- **Receive polarity:** idle 1, idle 0.
- **Output type:** open drain/open collector (high=Hi-Z, low=ground), normal (high=3.3volts, low=ground). Use open drain/open collector output types with pull-up resistors for multi-voltage interfacing.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. @ sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `[` | Open UART, discard received bytes. |
| `{` | Open UART, display data as it arrives asynchronously. |
| `]` or `}` | Close UART. |
| `r` | Check UART for byte, or fail if empty. Displays framing (-f) and parity (-p) errors (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is 0b00000000 for a byte, but partial bytes are also fine: 0b1001. |
| `0x` | Write this HEX value. Format is 0×01. Partial bytes are fine: 0xA. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by 0x or 0b is interpreted as a decimal value. |
| `,` | Value delimiter. Use a coma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |

### 'r' read a byte

UART mode requires special handling compared to the other Buzzpirat modes because data can arrive at any time. UART mode displays framing and parity errors, and automatically clears buffer overruns.

### Parity and framing errors
```
READ: -p -f 0×40 <<<-p -f flag set
```

The Buzzpirat reports framing errors (-f) and parity errors (-p) when reading a byte from the UART. It’s unlikely you’ll see these errors unless the UART speed is mismatched with the sender.

### Buffer overrun errors
The Buzzpirat hardware has a four-byte UART buffer that holds data until you read it with an ‘r’ command, or until it can be printed to the terminal if live display is enabled with ‘['. After it fills, new data will be lost. This is called a buffer overrun.
```
READ: 0x40 *Bytes dropped*<<<bytes dropped error
```

The Buzzpirat detects buffer errors, clears them, and alerts you of dropped bytes. The overrun bit is cleared any time you use the r, {, or [commands. If you close the live UART display (]) and more than 5 bytes come in, the next read command (r) will clear the error and print the *bytes dropped* warning.

Prevent buffer problems by reducing the amount of data the Buzzpirat transfers over USB for each byte of UART data. Raw display mode reduces the four byte hex value 0×00 to a single raw byte value. A better way is to use macro (1) or (2) to view unformatted UART output, this is a 1:1 transfer of bytes that should work at the highest possible speeds.


### Custom baud rate
A custom baud rate is set with the BRG option. Use a PIC UART calculator to find the correct value.

Set the calculator with the Buzzpirat values: PIC24, 32MHz clock. Enter the desired baud rate and hit calculate. Use the value from the BRGH=1 section. For 9700bps enter 411 at the Buzzpirat BRG prompt.


### Macros
| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | Transparent UART bridge. Reset to exit. |
| `2` | Live raw UART monitor. Any key exits. |
| `3` | Transparent UART bridge with flow control. |

#### Transparent UART bridge

```
UART>(1)<<<macro 1, transparent UART bridge
UART bridge. Space continues, anything else exits.
Reset to exit.
```

The transparent UART mode macro (1) creates a simple serial->USB bridge. The only way to exit this mode is to reset the Buzzpirat hardware.

Buffer overrun errors that occur during bridge mode are automatically cleared so that data continues as normal (firmware v3.0+). The MODE LED will turn off to alert you of the buffer overrun error.

Macro (3) is a second UART bridge mode that includes the CTS and RTS flow control signals. CTS is on the CS pin (PIC input from external circuit is passed to FTDI USB->serial chip). RTS is on the CLOCK pin (PIC output mirrors output from FTDI chip).

Note that the Buzzpirat serial port UART facing the computer (the one that connects to the USB->serial converter chip and sends text to your computer) is NOT adjusted to the same speed as the UART bridge. The USB-side serial port UART will continue to operate at the default setting (115200bps) unless adjusted with the 'b' menu.

If you use the UART bridge with a computer program that opens the virtual serial port at a different baud rate, say 9600bps, the exchange will be garbled because the Buzzpirat expects 115200bps input from the computer. Adjust the computer-side serial speed first with the 'b' menu, then start the serial bridge at the desired speed.

#### Live UART monitor
```
UART>(2)<<<macro 2, UART monitor
Raw UART input. Space to exit.
UART>
```

The UART monitor macro (2) shows a live display of UART input as raw byte values without any type of formatting. Press any key to exit the live monitor. This mode works best with a terminal that can display raw byte values in a variety of formats.

This macro is like the transparent UART macro (1) but without transmission abilities, and it can be exited with a key press. It’s useful for monitoring high-speed UART input that causes buffer overrun errors in other modes.

### MIDI

MIDI is a command set used by electronic (music) instruments. It travels over a standard serial UART configured for 31250bps/8/n/1. Since firmware v2.7 MIDI is a speed option in the UART library.

MIDI is a ring network, each node has an input and output socket. Each node passes messages to the next in the ring. The input and outputs are opto-isolated. The signaling is at 5volts, 5ma (current-based signaling). An adapter is required.

### Connections

Connect the Buzzpirat transmit pin (TX/MOSI) to the UART device receive pin (RX). Connect the Buzzpirat receive pin (RX/MISO) to the UART device transmit pin (TX).

For macros and modes with flow control: CTS is on the CS pin (PIC input from external circuit is passed to FTDI USB->serial chip). RTS is on the CLOCK pin (PIC output mirrors output from FTDI chip)

## I2C

- **Bus:** [I2C](http://en.wikipedia.org/wiki/I2c) (eye-squared-see or eye-two-see)
- **Connections:** two pins (SDA/SCL) and ground
- **Output types:** [open drain/open collector](/docs/Pull-up_resistors,_high_impedance_pins,_and_open_collector_buses)
- **Pull-up resistors:** pull-ups always required (2K - 10K ohms)
- **Maximum voltage:** 5.5volts (5volt safe)

I2C is a common 2-wire bus for low speed interfaces.

I2C implementation does not currently support clock stretching.

### Configuration options

- **Speed:** I2C has three speed options:~50kHz, ~100kHz, and ~400kHz.

```
HiZ>m<<<open the mode menu
1. HiZ
…
4. I2C
…
(1) >4<<<choose I2C mode
Set speed:
1. 50KHz
2. 100KHz
3. 400kHz
(1) >1<<<choose I2C speed
I2C READY
I2C>
```

#### Pull-up resistors

I2C is an open-collector bus, it requires pull-up resistors to hold the clock and data lines high and create the data '1'. I2C parts don't output high, they only pull low, without pull-up resistors there can never be a '1'. This will cause common errors such as the I2C address scanner reporting a response at every address. Read more about open drain/open collector bus types, and the Buzzpirat's on-board pull-up resistors.

I2C requires pull-up resistors to hold the clock and data lines high.
I2C parts don't output high, they only pull low.
Without pull-up resistors there can never be a '1'.


### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. @ sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `{` or `[` | Issue I2C start condition. |
| `]` or `}` | Issue I2C stop condition. |
| `r` | Read one byte, send ACK. (`r:1…255` for bulk reads) |
| `0b` | Write this binary value, check ACK. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value, check ACK. Format is `0×01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value, check ACK. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a coma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |

### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | 7bit address search. Find all connected devices by brute force. |
| `2` | I2C snooper (alpha testing, unlisted) v2.1+ |

#### I2C address search scanner macro

You can find the [I2C](http://en.wikipedia.org/wiki/I%C2%B2C) address for most I2C-compatible chips in the datasheet. But what if you're working with an unknown chip, a dated chip with no datasheet, or you're just too lazy to look it up?

The Buzzpirat has a built-in address scanner that checks every possible I2C address for a response. This brute force method is a fast and easy way to see if any chips are responding, and to uncover undocumented access addresses.

I2C chips respond to a 7bit address, so up to 128 devices can share the same two communication wires. An additional bit of the address determines if the operation is a write to the chip (0), or a read from the chip (1).

We connected the Buzzpirat to the 3EEPROM explorer board. The 7bit base address for the 24LC/AA I2C EEPROM is 101 0000 (0x50 in HEX). It answers at the write address 1010 0000 (0xA0) and the read address 1010 0001 (0xA1).

```
I2C>(1)
Searching 7bit I2C address space.
Found devices at:
0xA0(0x50 W) 0xA1(0x50 R)
I2C>
```

Macro 1 in the I2C library runs the address scanner. The scanner displays the raw addresses the chip acknowledged (0xA0, 0xA1), and the 7bit address equivalent (0x50) with write or read bit indicators (W/R). Datasheets usually list the 7bit address, but the 8bit value is more recognizable on a logic analyzer, snooper, debugger, etc.

```
I2C> (1)
Searching I2C address space. Found devices at:
Warning: *Short or no pull-up
I2C>
```

The scanner will find a chip at every address if there's no pull-up resistors on the I2C bus. This is a really common error. the scanner checks for pull-ups, and exits with an error if the bus isn't pulled up.

##### Scanner details
Details about the address scanner macro are at the end of this post and around here in the source.

- For I2C write addresses: the BP sends a start, the write address, looks for an ACK, then sends a stop.

- For I2C read addresses: the BP sends a start, the read address, looks for an ACK. If there is an ACK, it reads a byte and NACKs it. Finally it sends a stop.

When the I2C chip responds to the read address, it outputs data and will miss a stop condition sent immediately after the read address (bus contention). If the I2C chip misses the stop condition, the address scanner will see ghost addresses until the read ends randomly. By reading a byte after any read address that ACKs, we have a chance to NACK the read and properly end the I2C transaction.


#### I2C Bus Sniffer macro
The I2C sniffer is implemented in software and seems to work up to 100kHz (firmware v5.3+). It’s not a substitute for a proper logic analyzer, but additional improvements are probably possible.

- [/] – Start/stop bit
- +/- – ACK/NACK

I2C start and stop bits are represented by the normal Buzzpirat syntax.
```
I2C> (2)
Sniffer
Any key to exit
[0x40-][0x40-0x40-0x30-0x56-0x77-]
I2C>
```
Sniffed data values are always HEX formatted in user mode. Press any key to exit the sniffer.

Notes The sniffer uses a 4096byte output ring buffer. Sniffer output goes into the ring buffer and gets pushed to the PC when the UART is free. This should eliminate problems with dropped bytes, regardless of UART speed or display mode. A long enough stream of data will eventually overtake the buffer, after which bytes are dropped silently (will be updated after v5.3).

Any commands entered after the sniffer macro will be lost.

Pins that are normally output become inputs in sniffer node. MOSI and CLOCK are inputs in I2C sniffer mode.

The I2C sniffer maximum speed is around 100kHz.

### ACK/NACK management
These examples read and write from the RAM of a DS1307 RTC chip.
```
I2C> [0xd1 rrrr]
I2C START CONDITION
WRITE: 0xD1 GOT ACK: YES<<<read address
READ: 0×07 ACK <<<sent ACK[
READ: 0x06 ACK
READ: 0x05 ACK
READ: 0x04 NACK <<<last read before STOP, sent NACK
I2C STOP CONDITION
I2C>
```

I2C read operations must be ACKed or NACKed by the host (the Buzzpirat). The Buzzpirat automates this, but you should know a few rules about how it works.

The I2C library doesn't ACK/NACK a read operation until the following command. If the next command is a STOP (or START) the Buzzpirat sends a NACK bit. On all other commands it sends an ACK bit. The terminal output displays the (N)ACK status.

```
I2C> [0xd1 r:5]
I2C START CONDITION
WRITE: 0xD1 GOT ACK: YES
BULK READ 0×05 BYTES:
0×07 ACK 0×06 ACK 0×05 ACK 0×04 ACK 0×03 NACK
I2C STOP CONDITION
I2C>
```

Nothing changes for write commands because the slave ACKs to the Buzzpirat during writes. Here’s an example using the bulk read command (r:5).

```
I2C>[0xd1 r <<<setup and read one byte
I2C START CONDITION
WRITE: 0xD1 GOT ACK: YES
READ: 0x07 *(N)ACK PENDING <<<no ACK sent yet
I2C>r<<<read another byte
ACK <<<ACK for previous byte
READ: 0x06 *(N)ACK PENDING <<<no ACK yet
I2C>] <<<STOP command
NACK <<<next command is STOP, so NACK
I2C STOP CONDITION
I2C>
```

A consequence of the delayed ACK/NACK system is that partial transactions will leave read operations incomplete.

Here, we setup a read operation ([0xd1) and read a byte (r). Since the Buzzpirat has no way of knowing if the next operation will be another read (r) or a stop condition (]), it leaves the ninth bit hanging. The warning “*(N)ACK PENDING” alerts you to this state.

Our next command is another read (r), so the Buzzpirat ACKs the previous read and gets another byte. Again, it leaves the (N)ACK bit pending until the next command.

The final command is STOP (]). The Buzzpirat ends the read with a NACK and then sends the stop condition.

### Connections

| Buzzpirat | Dir. | Circuit | Description |
| --- | --- | --- | --- |
| MOSI | ↔ | SDA | Serial Data |
| CLK | → | SCL | Serial Clock |
| GND | ⏚ | GND | Signal Ground |

## SPI

- **Bus:** [SPI (serial peripheral interface)](http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus).
- **Connections:** Four pins (MOSI/MISO/CLOCK/CS) and ground.
- **Output type:** 3.3 volt normal, or [open collector](http://en.wikipedia.org/wiki/High_impedence) pull-up resistors required.
- **Pull-up resistors:** Required for open drain output mode (2K – 10K).
- **Maximum voltage:** 5.5 volts (5 volt safe).
- **Last documentation update:** v5.8.

### Configuration options

- _Speed:_ 30, 125, 250 kHz; 1, 2, 2.6, 4, 8 MHz
- _Clock polarity:_ Idle low, idle high.
- _Output clock edge:_ Idle to active, active to idle.
- _Input sample phase:_ Middle, end.
- _Output type:_ Open drain/open collector (high=Hi-Z, low=ground), normal (high=3.3 volts, low=ground). Use open drain/open collector output types with pull-up resistors for multi-voltage interfacing.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `[` | Chip select (CS) active (low). |
| `{` | CS active (low), show the SPI read byte after every write. |
| `]` or `}` | CS disable (high). |
| `r` | Read one byte by sending dummy byte (0xff). (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value. Format is `0x01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#) `| Run macro, `(0)` for macro list |

### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | SPI bus sniffer, sniff when CS is low (hardware CS filter) |
| `2` | SPI bus sniffer, sniff all traffic (no CS filter) |
| `3` | <s>SPI bus sniffer, sniff when CS is high (software CS filter)</s> Temporarily removed to increase speed. |
| `10` | Change clock polarity to 0 without re-entering SPI mode |
| `11` | Change clock polarity to 1 without re-entering SPI mode |
| `12` | Change clock edge to 0 without re-entering SPI mode |
| `13` | Change clock edge to 1 without re-entering SPI mode |
| `14` | Change sample phase to 0 without re-entering SPI mode |
| `15` | Change sample phase to 1 without re-entering SPI mode |

### SPI Bus sniffer

The Buzzpirat can read the traffic on an SPI bus.

Warning! Enter sniffer mode before connecting the target!!
The Buzzpirat SPI CLOCK or DATA lines could be grounded and ruin the target device!
Reset with the CS pin to clear garbage if needed


Pin connections are the same as normal SPI mode. Connect the Buzzpirat clock to the clock on the SPI bus you want to sniff. The data pins MOSI and MISO are both inputs, connect them to the SPI bus data lines. Connect the CS pin to the SPI bus CS pin.

- `[/]` – CS enable/disable
- `0xXX` – MOSI read
- `(0xXX)` – MISO read

SPI CS pin transitions are represented by the normal Buzzpirat syntax. The byte sniffed on the MISO pin is displayed inside `()`.

```
SPI> (0)
0.Macro menu
1.Sniff CS low
2.Sniff all traffic
SPI> (1)
Sniffer
Any key to exit
[0x30(0x00)0xff(0x12)0xff(0x50)][0x40(0x00)]
```

The SPI sniffer can read all traffic, or filter by the state of the CS pin. The byte sniffed on the MOSI pin is displayed as a HEX formatted value, the byte sniffed on the MISO pin is inside the ().

There may be an issue in the sniffer terminal mode from v5.2+.
Try the binary mode sniffer utility for best results.
Notes

The sniffer uses a 4096byte output ring buffer. Sniffer output goes into the ring buffer and gets pushed to the PC when the UART is free. This should eliminate problems with dropped bytes, regardless of UART speed or display mode.

Warning! Enter sniffer mode before connecting the target!!
The Buzzpirat SPI CLOCK or DATA lines could be grounded and ruin the target device!
Reset with the CS pin to clear garbage if needed

- A long enough stream of data will eventually overtake the buffer, after which the MODE LED turns off (v5.2+). No data can be trusted if the MODE LED is off - this will be improved in a future firmware.
- The SPI hardware has a 4 byte buffer. If it fills before we can transfer the data to the ring buffer, then the terminal will display "Can't keep up" and drop back to the SPI prompt. This error and the ring buffer error will be combined in a future update.
- Any commands entered after the sniffer macro will be lost.
- Pins that are normally output become inputs in sniffer mode. MOSI, CLOCK, MISO, and CS are all inputs in SPI sniffer mode.
- Since v5.3 the SPI sniffer uses hardware chip select for the CS low sniffer mode. The minimum time between CS falling and the first clock is 120ns theoretical, and less than 1.275us in tests. The software CS detect (CS high sniffer mode) requires between 27usec and 50usec minimum delay between the transition of the CS line and the start of data. Thanks to Peter Klammer for testing and updates.
- The sniffer follows the output clock edge and output polarity settings of the SPI mode, but not the input sample phase.

### Clock edge/clock polarity/sample phase macros

Macros 10-15 change SPI settings without disabling the SPI module. These macros were added at a user's request, but they never reported if it worked. 


```
SPI> (10)(11)(12)(13)(14)(15)
SPI (spd ckp ske smp csl hiz)=( 3 0 1 0 1 1 )
SPI (spd ckp ske smp csl hiz)=( 3 1 1 0 1 1 )
SPI (spd ckp ske smp csl hiz)=( 3 1 0 0 1 1 )
SPI (spd ckp ske smp csl hiz)=( 3 1 1 0 1 1 )
SPI (spd ckp ske smp csl hiz)=( 3 1 1 0 1 1 )
SPI (spd ckp ske smp csl hiz)=( 3 1 1 1 1 1 )
SPI>
```

### Connections

| Buzzpirat | Dir. | Circuit | Description |
| --- | --- | --- | --- |
| MOSI | → | MOSI | Master Out, Slave In |
| MISO | ← | MISO | Master In, Slave Out |
| CS | → | CS | Chip Select |
| CLK | → | CLK | Clock signal |
| GND | ⏚ | GND | Signal Ground |

## Raw 2-wire

- **Bus:** General purpose 2-wire library with bitwise pin control.
- **Connections:** Two pins (SDA/SCL) and ground.
- **Output type:** 3.3 volt normal, or [open collector](http://en.wikipedia.org/wiki/High_impedence) pull-up resistors required.
- **Pull-up resistors:** Required for open drain output mode (2K – 10K).
- **Maximum voltage:** 5.5 volts (5 volt safe).
- **Last documentation update:** v5.6.

The raw 2 wire library is similar to I2C, but it doesn’t handle acknowledge bits and it has bitwise pin control. I2C could be built using the basic elements in the raw2wire library.

### Configuration options

- **Speed:** High (~50kHz) and low (~5kHz).
- **Output type:** Open drain/open collector (high=Hi-Z, low=ground), normal (high=3.3 volts, low=ground). Use open drain/open collector output types with pull-up resistors for multi-voltage interfacing.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `{ or [` | Issue I2C-style start condition. |
| `] or }` | Issue I2C-style stop condition. |
| `r` | Read one byte. (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value. Format is `0×01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |
| _Bitwise_ |
| `^` | Send one clock tick. (`^:1…255` for multiple clock ticks) |
| `/ or \` | Toggle clock level high (`/`) and low (`\`). Includes clock delay (100uS). |
| `- or _` | Toggle data state high (`-`) and low (`_`). Includes data setup delay (20uS). |
| `!` | Read one bit with clock. |
| `.` | Read data pin state (no clock). |

### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | ISO7813-3 ATR for smart cards, parses reply bytes. |
| `2` | ISO7813-3 parse only (provide your own ATR command). |

### Connections

| Buzzpirat | Dir. | Circuit | Description |
| --- | --- | --- | --- |
| MOSI | ↔ | SDA | Serial Data |
| CLK | → | SCL | Serial Clock |
| GND | ⏚ | GND | Signal Ground |

## Raw 3-wire

- **Bus:** General purpose 3-wire library with bitwise pin control.
- **Connections:** Four pins (MOSI/MISO/CLOCK/CS) and ground.
- **Output types:** 3.3 volt normal, or [open drain/open collector](http://en.wikipedia.org/wiki/High_impedence) pull-up resistors required.
- **Pull-up resistors:** Required for open drain output mode (2K – 10K).
- **Maximum voltage:** 5.5 volts (5 volt safe).
- **Last documentation update:** v5.6.

The raw 3 wire library is like SPI, but includes bitwise pin control.

### Configuration options

- **Speed:** High (~50kHz) and low (~5kHz).
- **Output type:** Open drain/open collector (high=Hi-Z, low=ground), normal (high=3.3 volts, low=ground). Use open drain/open collector output types with pull-up resistors for multi-voltage interfacing.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `[` | Chip select (CS) active (low). |
| `{` | CS active (low), show the SPI read byte after every write. |
| `]` or `}` | CS disable (high). |
| `r` | Read one byte by sending dummy byte (0xff). (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value. Format is `0x01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |
| _Bitwise_ |
| `^` | Send one clock tick. (`^:1…255` for multiple clock ticks) |
| `/` or `\` | Toggle clock level high (`/`) and low (`\`). Includes clock delay (100uS). |
| `-` or `_` | Toggle data state high (`-`) and low (`_`). Includes data setup delay (20uS). |
| `!` | Read one bit with clock. |
| `.` | Read data pin state (no clock). |

### Connections

| Buzzpirat | Dir. | Circuit | Description |
| --- | --- | --- | --- |
| MOSI | → | MOSI | Master Out, Slave In |
| MISO | ← | MISO | Master In, Slave Out |
| CS | → | CS | Chip Select |
| CLK | → | CLK | Clock signal |
| GND | ↔ | GND | Signal Ground |

## HD44780 LCDs

- **Bus:** [HD44780 LCD](http://ouwehand.net/%7Epeter/lcd/lcd.shtml) test library.
- **Adapter:** 74HCT595-based LCD adapter board

The Buzzpirat can test HD44780 LCDs but it needs an IO expander chip. Currently, it uses a simple 74HCT595 adapter

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `{` or `[` | RS low. Next read/write is a COMMAND. |
| `]` or `}` | RS high. Next read/write is TEXT/DATA. |
| `r` | Read one byte (`r:1…255` for bulk reads). |
| `0b` | Write this binary value. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value. Format is `0x01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `"xxx"` | Write the ASCII text `xxx` to the LCD. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |


### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | LCD reset. |
| `2` | Init LCD. |
| `3` | Clear LCD. |
| `4` | Cursor position ex: `(4:0)`. |
| `5` | Write test text. (deprecated) |
| `6` | Write `:number` test numbers ex: `(6:80)`. |
| `7` | Write `:number` test characters ex: `(7:80)`. |

## PC keyboard

- **Bus:** PC keyboard interface library.
- **Connections:** Two pins (KBD/KBC) and ground.
- **Output type:** [Open drain/open collector](http://en.wikipedia.org/wiki/High_impedence).
- **Pull-up resistors:** _None_, keyboard has internal pull-ups.
- **Maximum voltage:** 5 volts.

This library interfaces PC keyboards. A PC keyboard operates at 5 volts and has its own internal pull-up resistors to 5 volts. The keyboard issues a clock signal that drives all transactions, the library includes a time-out (v0h+) so the Buzzpirat won’t freeze if the keyboard doesn’t respond.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `r` | Read one byte with timeout. (`r:1…255` for bulk reads) |
| `0b` | Write this binary value with timeout. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value with timeout. Format is `0x01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value with timeout. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0xaF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |

### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | Live keyboard monitor (v0h+) |

## DIO

This mode gives the user 100% control over the Buzzpirat IO pins from the terminal.

Send same command values as the binary bitbang mode to set pin direction and state.

## JTAG

- **Bus:** [JTAG](http://en.wikipedia.org/wiki/Joint_Test_Action_Group)
- **Connections:** 4 connections (TDI, TCK, TDO, TMS) and ground.
- **Output type:** 3.3 volt normal, or [open collector](http://en.wikipedia.org/wiki/High_impedence) pull-up resistors required.
- **Pull-up resistors:** Required for open collector output mode (2K – 10K).
- **Maximum voltage:** 5.5 volts (5 volt safe).

JTAG is actually a protocol over SPI. This library performs common JTAG functions and manages the JTAG state machine.

### Configuration options

- **Output type:** Open drain/open collector (high=Hi-Z, low=ground), normal (high=3.3 volts, low=ground). Use open drain/open collector output types with pull-up resistors for multi-voltage interfacing.

### Syntax

| Command | Description |
| --- | --- |
| `A/a/@` | Toggle auxiliary pin. Capital “A” sets AUX high, small “a” sets to ground. `@` sets aux to input (high impedance mode) and reads the pin value. |
| `D/d` | Measure voltage on the ADC pin (v1+ hardware only). |
| `W/w` | Capital ‘W’ enables the on-board power supplies. Small ‘w’ disables them. (v1+ hardware only). |
| `[` | Move JTAG state machine (SM) to INSTRUCTION register. Last bit of byte writes is delayed until leaving the INSTRUCTION register. |
| `{` | Move JTAG SM to DATA register. |
| `]` or `}` | Move JTAG SM to IDLE register. |
| `r` | Read one byte. (`r:1…255` for bulk reads) |
| `0b` | Write this binary value. Format is `0b00000000` for a byte, but partial bytes are also fine: `0b1001`. |
| `0x` | Write this HEX value. Format is `0x01`. Partial bytes are fine: `0xA`. A-F can be lower-case or capital letters. |
| `0-255` | Write this decimal value. Any number not preceded by `0x` or `0b` is interpreted as a decimal value. |
| `,` | Value delimiter. Use a comma or space to separate numbers. Any combination is fine, no delimiter is required between non-number values: `{0xa6,0, 0 16 5 0b111 0haF}`. |
| `&` | Delay 1uS. (`&:1…255` for multiple delays) |
| `(#)` | Run macro, `(0)` for macro list |
| _Bitwise_ |
| `^` | Send one clock tick. (`^:1…255` for multiple clock ticks) |
| `/` or `\` | Toggle clock level high (`/`) and low (`\`). Includes clock delay (100uS). |
| `-` or `_` | Toggle data state high (`-`) and low (`_`). Includes data setup delay (20uS). |
| `!` | Read one bit with clock. |
| `.` | Read data pin state (no clock). |

### Macro

| Command | Description |
| --- | --- |
| `0` | Macro menu |
| `1` | Reset chain |
| `2` | Probe chain |

## BASIC script reference

BASIC script mode is entered by typing 's' at the Buzzpirat commandline. You need to take care of entering the correct mode and set it up (things like speed, Hiz, etc.).

This isn't intended as a guide in learning how to program. General programming knowledge is assumed. Be aware that only basic checking is done and there are no warnings printed to the terminal (except those intended by the program with print statements). The editor is very rudimentary and does not check if the syntax is right. The language is loosely based on BASIC.

Enter script mode:
```
HiZ> s
HiZ(BASIC)>
```

### NEW
The memory is cleared by entering the NEW command.
```
HiZ(BASIC)> new
Ready.
HiZ(BASIC)>
```

NOTE: With firmware before version 5.8 this command was mandatory before entering anything else in the basic editor!!

### LIST
From the basic commandline programs can be entered. The basicinterpreter uses linenumbers followed by statements. After this the program can be listed by the command 'LIST'
```
HiZ(BASIC)> list

100 REM BASICDEMO
110 PRINT "HELLO WORLD!"
120 PRINT "HELLO AGAIN"
65535 END
52 bytes.
Ready.
HiZ(BASIC)>
```
### RUN
You can also run it with the command run:
```
HiZ(BASIC)> run
HELLO WORLD!
HELLO AGAIN

Ready.
HiZ(BASIC)>
```

### Variables
A..Z (26) variables are possible. The variable are internally 16bit signed

### LET
assigns a variable. Another variable, constants or functions that returns a value (e.g. RECEIVE)

```
10 LET A=B+1
```

### IF {ifstat} THEN {truestat} ELSE {falsestat}
Evaluate the {ifstat} if it evaluate to a value that is not zero {truestat} get executed otherwise {falsestat}.

```
10 IF A=1 THEN GOTO 100 ELSE PRINT "A IS NOT 1"
```

### GOTO {line}
jumps to line {line}, without remembering where it came from (see also GOSUB)

```
10 GOTO 100
20 PRINT "line 20"
100 PRINT "line 100"
```

line 20 doesn't get executed


### GOSUB {line} and RETURN
jumps to line {line}, executes from there till a RETURN and return to the line after the GOSUB.
```
10 GOSUB 1000
20 PRINT "line 20"
30 END
1000 PRINT "line 1000"
1010 RETURN
```
Stack is 10 levels deep, so 10 nested gosubs are possible.

### REM {text}
Puts a remark into the code, but gets skipped.
```
10 REM A WONDERFULL PROGRAM
```
Don't use REM between DATA statements!

### PRINT {text}
Prints {text} to the terminal. Variable and statement can be mixed and are seperated with a ';'. A ';' at the end suppresses a newline.
```
10 PRINT "A = ";A
20 PRINT "RECEIVED: ";RECEIVE
30 PRINT "B = ";
40 PRINT B
```

### INPUT {question},{var}
Ask {question} and put the answer the user gave into {var}

```
10 INPUT "A = ",A
```

### FOR {var}={minvalue} TO {maxvalue} {stats} NEXT {var}
Assigns value {minvalue} to variable {var}, executes statements {stats} until NEXT is encountered. Variable {var} wil be increased by one, {stats} is again executed, until {var} has the value {maxvalue}.

```
10 FOR A=1 TO 10
20 PRINT "A = ";A
30 NEXT A
```

for/nexts can be nested 4 deep.

### READ {var} & DATA {val1}, {val2}, .. {val1}, {val2},
Read a value into variable {var}. The values are stored in DATA statements.
```
10 READ A
20 PRINT "A = ";A
30 READ A
40 PRINT "A = ";A
1000 DATA 10,20
```

### START
Same as the Buzzpirat '[' command

```
10 START
```

### STOP
Same as the Buzzpirat ']' command

```
10 STOP
```

###  STARTR
Same as the Buzzpirat '{' command

```
10 STARTR
```

### STOPR
Same as the Buzzpirat '}' command

```
10 STOPR
```

### SEND {val/var}
Sends a value {val} or variable {var} over the bus.

```
10 SEND 10
20 SEND A
```

Some protocols send/receive at the same time. This is also possible:

```
10 LET A=SEND 100
20 PRINT "SEND 100 GOT ";A
```

###  RECEIVE
Receives data from the bus. With some protocols it returns value >255 to signal busstates (like no data, got ACK, etc), other protocols are 16 bit (like pic).

```
10 LET A=RECEIVE
20 PRINT "A = ";A
```

### CLK {val}
Controls the CLK line, its behaviour depends on val; 0=low, 1=high, 2=pulse.

```
10 CLK 2
```

### DAT {val}
Controls the DAT line, its behaviour depends on val; 0=low, 1=high.

```
10 DAT 0
```

DAT value can also be read:
```
10 LET A=DAT
20 PRINT "A = ";A
```

### BITREAD
Same as the Buzzpirat '!' command.

```
10 LET A=BITREAD
20 PRINT "A = ";A
```

### ADC
Reads the ADC. Value returned is 10bits (no conversion!).

```
10 LET A=ADC
20 PRINT "A = ";A
```

### AUX {val}
Controls the AUX line, its behaviour depends on val; 0=low, 1=high.

```
10 AUX 1
```

AUX value can also be read:

```
10 LET A=AUX
20 PRINT "A = ";A
```

### AUXPIN {val}
Controls which pin is controlled by the AUX statement; 0=AUX; 1=CS

```
10 AUXPIN 1
```

### PSU {val}
Controls the onboard voltage regulators; 0=off, 1=on

```
10 PSU 1
```

### PULLUP {val}
Controls the onboard pullup resistors; 0=off, 1=on

```
10 PULLUP 0
```

### DELAY {var}
Delays {var} ms

```
10 DELAY 100
```

### FREQ {var} & DUTY {var}
Controls the onboard PWM generator. Frequency of 0 disables it. (same limits apply as regular PWM command ('g'))

```
10 freq 100
20 duty 25
```