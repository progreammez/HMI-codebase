# EV_HMI Communication Protocol

## Overview

The EV_HMI communicates with an STM32 microcontroller over a UART serial interface to receive real-time vehicle telemetry.

The Raspberry Pi functions as the Human Machine Interface (HMI), while the STM32 acts as the vehicle controller responsible for generating telemetry data.

During development, the same communication interface can be replaced by software simulators, allowing the frontend and backend to operate without physical hardware.

---

# Communication Architecture

```text
                Development Mode

        DriverInput / VirtualVehicle
                    │
                    ▼
            STMDataSimulator
                    │
                    ▼
              VehicleData
                    │
                    ▼
               Qt Quick UI



                Production Mode

        STM32 Controller
               │
            UART (Serial)
               │
               ▼
        SerialManager
               │
               ▼
          VehicleData
               │
               ▼
           Qt Quick UI
```

The frontend never communicates directly with the STM32.

All communication passes through the backend.

---

# UART Configuration

| Parameter | Value |
|-----------|-------|
| Interface | UART |
| Baud Rate | 115200 |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |
| Flow Control | None |

UART operates using the standard **8N1** configuration.

---

# Update Frequency

Telemetry packets are transmitted approximately every:

```text
100 ms
```

Resulting in an update frequency of:

```text
10 Hz
```

The dashboard is designed to remain responsive even if packets are temporarily delayed or lost.

---

# Packet Format

Telemetry is transmitted as newline-separated packets.

```text
<field1>,<field2>,<field3>,...,<fieldN>\n
```

Each packet represents a complete snapshot of the vehicle state.

---

# Current Telemetry

The current implementation supports telemetry including (but not limited to):

- Vehicle Speed
- Motor RPM
- Battery Percentage
- Remaining Range
- Motor Temperature
- Battery Temperature
- Controller Temperature
- Drive Mode
- Gear State
- Charging Status
- Battery Voltage
- Battery Current
- Motor Power
- Regenerative Braking Level
- Indicator States
- Vehicle Warnings

The exact backend interface is documented in **TelemetryAPI.md**.

---

# Packet Processing

Incoming UART data follows this pipeline:

```text
STM32
   │
UART
   │
SerialManager
   │
Packet Parsing
   │
VehicleData Update
   │
Property Notifications
   │
Qt Quick UI
```

Whenever a property changes, Qt automatically updates all bound UI components.

No manual refresh is required.

---

# Communication Timeout

The backend continuously monitors communication health.

If no valid packet is received within the configured timeout period:

- Communication Fault is raised.
- WarningManager is notified.
- Engineering Mode displays the communication error.
- Telemetry values retain their last valid state until communication resumes.

This prevents sudden UI instability caused by temporary communication interruptions.

---

# Error Handling

Malformed packets are safely discarded.

Typical validation includes:

- Incorrect field count
- Invalid numeric values
- Corrupted packets
- Unsupported drive modes
- Invalid gear states

Invalid packets never update VehicleData.

---

# Simulation Support

The project supports development without hardware through built-in simulators.

Available simulators include:

- DriverInput
- VirtualVehicle
- STMDataSimulator

These components generate telemetry using the same backend interfaces as the STM32, allowing frontend development without modifying QML.

---

# Telemetry Logging

Engineering Mode supports telemetry logging for debugging.

Captured data can be exported for:

- Performance analysis
- Communication debugging
- Fault investigation
- Development testing

Logging is handled by the TelemetryLogger backend component.

---

# Communication Fault Simulation

For testing purposes, Engineering Mode allows developers to intentionally simulate communication failures.

This enables validation of:

- Fault detection
- Warning messages
- UI fallback behaviour
- Communication recovery

without disconnecting physical hardware.

---

# Design Principles

The communication layer follows several design principles.

## Hardware Independence

The frontend never knows whether telemetry originates from:

- STM32
- Simulator
- VirtualVehicle

Only the backend determines the data source.

---

## Single Entry Point

All telemetry enters the application through:

```text
SerialManager
```

or an equivalent simulator.

No QML component communicates directly with hardware.

---

## Safe Updates

VehicleData is updated only after packets have been successfully validated.

Invalid or incomplete packets are ignored.

---

# Future Extensions

The communication layer has been designed to support future interfaces including:

- CAN Bus
- Bluetooth Telemetry
- Ethernet Diagnostics
- Wi-Fi Diagnostics
- Remote Vehicle Monitoring

These additions can be implemented without changing the QML frontend.

---

# Summary

The EV_HMI communication protocol provides a reliable interface between the STM32 controller and the Qt-based dashboard. By isolating hardware communication inside the backend and exposing validated telemetry through VehicleData, the system remains modular, maintainable, and suitable for both simulation and real-world deployment.