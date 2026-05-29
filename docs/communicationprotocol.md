# EV HMI Communication Protocol

## Overview

Communication between STM32 and Raspberry Pi shall use UART.

STM32 acts as the telemetry source.

Raspberry Pi acts as the telemetry consumer.

---

## UART Configuration

| Parameter | Value  |
| --------- | ------ |
| Baud Rate | 115200 |
| Data Bits | 8      |
| Parity    | None   |
| Stop Bits | 1      |

Configuration:

8N1

---

## Update Rate

Telemetry update interval:

100 ms

Telemetry frequency:

10 Hz

---

## Packet Structure

Each packet shall be transmitted as a single line terminated by a newline character.

Format:

speed,rpm,batteryPercent,motorTemp,batteryTemp,rangeKm,driveMode,gearState

Example:

54,2800,87,41,35,120,ECO,D

---

## Field Definitions

| Field          | Type   | Unit           |
| -------------- | ------ | -------------- |
| speed          | int    | km/h           |
| rpm            | int    | RPM            |
| batteryPercent | int    | %              |
| motorTemp      | int    | °C             |
| batteryTemp    | int    | °C             |
| rangeKm        | int    | km             |
| driveMode      | string | ECO/CITY/SPORT |
| gearState      | string | P/N/R/D        |

---

## Example Packet

54,2800,87,41,35,120,ECO,D

---

## Error Handling

Malformed packets shall be discarded.

Missing fields shall be ignored.

Communication timeout:

1000 ms

If no packet is received within 1000 ms:

communicationFault = true
