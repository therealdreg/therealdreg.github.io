---
title: Getting Started
description: I have no idea about hardware hacking, where should I start?
weight: 1
---


Just bought a full Buzzpirat kit with everything included and want to start using it, but have no idea about mathematics, electronics, or hardware hacking? This is your starting point, let's go!

## What is the Buzzpirat?
The Buzzpirat is a hardware hacking tool that allows you to talk with chips. It is based on the Bus Pirate v3, a universal bus interface that talks to electronics from a computer serial terminal. The Buzzpirat is a Bus Pirate clone with a few modifications to make it more secure+complete for hardware hacking

## What is hardware hacking?
Hardware Hacking is the art of breaking and/or modifying electronics for fun, profit, and the advancement of technology. Hardware hacking is not limited to electronics, but it often is. Other examples of hardware hacking include modifying cars, bicycles, and other mechanical systems.

## Our first time communicating with a chip
Let's start with a simple example. We will use the Buzzpirat to communicate with a chip and read its content. For this example, we will use a AT24C256 I2C EEPROM 5V board. This board is included in our full kit for practice purposes. You can purchase another one on Aliexpress, Amazon, or eBay.

![](/conn/at24c256schboard.png)

Intimidated by seeing a schematic and a board with lots of strange components? Don't worry, we'll take it step by step to understand what's going on.

For this case, simply use the official Buzzpirat cables with the female Dupont connector they come with; there's no need to use SMD IC clips. Connect the Buzzpirat to the AT24C256 board by attaching the +5v(SW5V0) to VCC, CLK to SCL, MOSI(SDA) to SDA, and GND to GND, ensuring each connection is secure for proper functionality. 

{{< alert color="warning" title="Warning" >}}
**Also, connect the VPU pin to a SW5V0 pin of the Buzzpirat**.
{{< /alert >}}

| Buzzpirat | AT24C256 board |
| --- | --- |
| +5v(SW5V0) | VCC |
| CLK | SCL |
| MOSI(SDA) | SDA |
| GND | GND |

| Buzzpirat | Buzzpirat |
| --- | --- |
| +5v(SW5V0) | VPU |


![](/conn/atcconnection.png)

![](/conn/conn1.png)

<style>
  #table-buzzpirat  { max-width: 80%; border: 2px solid #333; }
  #table-buzzpirat th, #table-buzzpirat  td { border-bottom: 1px solid #ddd; text-align: center }
  #table-buzzpirat th { background-color: #403f4c; color: #fff; }
  #table-buzzpirat .lt-red { color: #dc3545;font-weight: bold;}
  #table-buzzpirat .lt-white { color: #ffffff;font-weight: bold;}
  #table-buzzpirat .lt-yellow { color: #f4f901;font-weight: bold;}
  #table-buzzpirat .lt-black { color: #070d18;font-weight: bold;}
  #table-buzzpirat .lt-green { color: #2fffab;font-weight: bold;}
  #table-buzzpirat .lt-gray { color: #8d8d8d;font-weight: bold;}
  #table-buzzpirat .bgr-red { background-color: #fff; }
  #table-buzzpirat .bgr-white { background-color: #403f4c; }
  #table-buzzpirat .bgr-yellow { background-color: #403f4c; }
  #table-buzzpirat .bgr-black { background-color: #fff; }
  #table-buzzpirat .bgr-green { background-color: #403f4c; }
  #table-buzzpirat .bgr-gray { background-color: #fff; }
</style>
<div class="table-responsive-sm">
<table id="table-buzzpirat" class="td-initial table table-dark">
  <thead>
    <tr>
      <th class="bgr-red lt-red display-6">MODE</th>
      <th class="bgr-white lt-white display-6">MOSI</th>
      <th class="bgr-yellow lt-yellow display-6">CLK</th>
      <th class="bgr-black lt-black display-6">MISO</th>
      <th class="bgr-green lt-green display-6">CS</th>
      <th class="bgr-gray lt-gray display-6">AUX</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="lt-red bgr-red">HiZ</td>
      <td class="lt-white bgr-white">-</td>
      <td class="lt-yellow bgr-yellow">-</td>
      <td class="lt-black bgr-black">-</td>
      <td class="lt-green bgr-green">-</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">1-Wire</td>
      <td class="lt-white bgr-white">OWD</td>
      <td class="lt-yellow bgr-yellow">-</td>
      <td class="lt-black bgr-black">-</td>
      <td class="lt-green bgr-green">-</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">UART</td>
      <td class="lt-white bgr-white">TX</td>
      <td class="lt-yellow bgr-yellow">-</td>
      <td class="lt-black bgr-black">RX</td>
      <td class="lt-green bgr-green">-</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">I2C</td>
      <td class="lt-white bgr-white">SDA</td>
      <td class="lt-yellow bgr-yellow">SCL</td>
      <td class="lt-black bgr-black">-</td>
      <td class="lt-green bgr-green">-</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">SPI</td>
      <td class="lt-white bgr-white">MOSI</td>
      <td class="lt-yellow bgr-yellow">CLK</td>
      <td class="lt-black bgr-black">MISO</td>
      <td class="lt-green bgr-green">CS</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">JTAG</td>
      <td class="lt-white bgr-white">TDI</td>
      <td class="lt-yellow bgr-yellow">TCK</td>
      <td class="lt-black bgr-black">TDO</td>
      <td class="lt-green bgr-green">TMS</td>
      <td class="lt-gray bgr-gray">-</td>
    </tr>
    <tr>
      <td class="lt-red bgr-red">AVR</td>
      <td class="lt-white bgr-white">MOSI</td>
      <td class="lt-yellow bgr-yellow">SCK</td>
      <td class="lt-black bgr-black">MISO</td>
      <td class="lt-green bgr-green">RESET</td>
      <td class="lt-gray bgr-gray">XTAL1</td>
    <tr>
    <tr>
      <td class="lt-red bgr-red">PIC</td>
      <td class="lt-white bgr-white">PGD</td>
      <td class="lt-yellow bgr-yellow">PGC</td>
      <td class="lt-black bgr-black">-</td>
      <td class="lt-green bgr-green">MCLR</td>
      <td class="lt-gray bgr-gray">-</td>
    <tr>
    <tr>
      <td class="lt-red bgr-red">2-Wire</td>
      <td class="lt-white bgr-white">OWD1</td>
      <td class="lt-yellow bgr-yellow">OWD2</td>
      <td class="lt-black bgr-black">-</td>
      <td class="lt-green bgr-green">-</td>
      <td class="lt-gray bgr-gray">-</td>
    <tr>
    <tr>
      <td class="lt-red bgr-red">3-Wire</td>
      <td class="lt-white bgr-white">MOSI</td>
      <td class="lt-yellow bgr-yellow">CLK</td>
      <td class="lt-black bgr-black">MISO</td>
      <td class="lt-green bgr-green">CS</td>
      <td class="lt-gray bgr-gray">-</td>
    <tr>
  </tbody>
</table>
</div>

| Pin Name       | Description (Buzzpirat is the master) |
|----------------|----------------------------------------|
| MOSI           | Master data out, slave in (SPI, JTAG), Serial data (1-Wire, I2C, KB), TX* (UART) |
| CLK            | Clock signal (I2C, SPI, JTAG, KB)      |
| MISO           | Master data in, slave out (SPI, JTAG) RX (UART) |
| CS             | Chip select (SPI), TMS (JTAG)          |
| AUX            | Auxiliary IO, frequency probe, pulse-width modulator |
| AUX-R          | AUX-R is the AUX signal, but with a variable resistor of 10K+1K before reaching the pin |
| ADC            | Voltage measurement probe (max 6volts) |
| VPU            | Voltage input for on-board pull-up resistors (0-5volts). |
| TP0            | Auxiliary PIN connected to VPU |
| +1.8v(SW1V8)   | +1.8volt switchable power supply       |
| +2.5v(SW2V5)   | +2.5volt switchable power supply       |
| +3.3v(SW3V3)   | +3.3volt switchable power supply       |
| +5.0v(SW5V0)   | +5volt switchable power supply         |
| GND            | Ground, connect to ground of test circuit |


{{< alert color="warning" title="Warning" >}}
Use short & high-quality USB&Dupont cables. Long or low-quality cables can cause communication issues.
{{< /alert >}}

{{< alert color="warning" title="Warning" >}}
Use VMs is not recommended, as it can cause communication issues.
{{< /alert >}}
