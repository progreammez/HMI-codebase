# EV_HMI Architecture

## Overview

EV_HMI follows a layered architecture that separates presentation, business logic, and hardware communication. The project is designed to keep the user interface independent of hardware-specific implementations, allowing the application to run seamlessly in both development and production environments.

The architecture is centered around a **Qt/C++ backend** that exposes application state to the **Qt Quick (QML)** frontend through context properties.

---

# High-Level Architecture

```text
                        ┌──────────────────────────────┐
                        │        Qt Quick UI           │
                        │                              │
                        │ Dashboard                    │
                        │ Music                        │
                        │ Diagnostics                  │
                        │ Engineering Mode             │
                        │ Settings                     │
                        └──────────────┬───────────────┘
                                       │
                        Context Properties
                                       │
            ┌──────────────────────────┴──────────────────────────┐
            │                                                     │
            ▼                                                     ▼

     VehicleData                                       LocalMusicPlayer
     (Telemetry)                                         (Media)

            │                                                     │
            └──────────────────────┬──────────────────────────────┘
                                   │
                        Backend Services
                                   │
    ┌─────────────────────────────────────────────────────────────┐
    │                                                             │
    │  SerialManager          SpotifyAPIManager                   │
    │  BluetoothManager       TelemetryLogger                     │
    │  WarningManager         DriverInput                         │
    │  VirtualVehicle         STMDataSimulator                    │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘
                                   │
                     Hardware / Simulation Layer
                                   │
          ┌────────────────────────┴──────────────────────┐
          │                                               │
     STM32 Controller                         Virtual Simulator
```

---

# Software Layers

## 1. User Interface Layer

Implemented entirely using **Qt Quick (QML)**.

Responsibilities include:

- Digital instrument cluster
- Music player
- Spotify interface
- Diagnostics
- Engineering pages
- Theme management
- Settings
- Navigation between pages

The frontend never communicates directly with hardware.

Instead, it consumes properties exposed by backend objects.

---

## 2. Backend Layer

Implemented in **C++** using Qt.

The backend performs all application logic including:

- Vehicle telemetry processing
- Music playback
- Spotify communication
- Bluetooth management
- Serial communication
- Diagnostics
- Warning generation
- Telemetry logging
- Vehicle simulation

Only this layer communicates with hardware.

---

## 3. Communication Layer

Responsible for exchanging information with external devices.

Current communication includes:

- UART communication with STM32
- Spotify Web API
- Bluetooth Audio
- Local media playback

The communication layer is isolated from the UI.

---

# Backend Components

## VehicleData

Central telemetry object exposed to QML.

Provides:

- Speed
- Battery
- Temperatures
- Charging
- Powertrain
- Warnings
- Indicators

All vehicle information flows through this class.

---

## LocalMusicPlayer

Provides media playback functionality.

Responsible for:

- Local MP3 playback
- Playlist management
- Playback state
- Metadata extraction
- Volume control

Exposed to QML as:

```cpp
musicPlayer
```

---

## SpotifyAPIManager

Handles Spotify integration.

Responsibilities:

- User authentication
- Token management
- Playback polling
- Track metadata
- Playback controls
- Album artwork

Spotify data remains separate from vehicle telemetry.

---

## BluetoothManager

Manages Bluetooth media connectivity.

Responsibilities include:

- Device discovery
- Connection management
- Audio routing

---

## SerialManager

Handles UART communication with the STM32.

Responsible for:

- Receiving telemetry packets
- Parsing serial data
- Updating VehicleData
- Detecting communication faults

---

## WarningManager

Monitors telemetry values and generates warnings including:

- Low battery
- Overtemperature
- Communication failures
- Charging warnings

---

## TelemetryLogger

Records telemetry for debugging and diagnostics.

Engineering Mode allows exporting collected logs.

---

## VirtualVehicle

Provides a software-based vehicle simulator.

Allows development without physical hardware.

---

## DriverInput

Generates simulated driver inputs such as:

- Accelerator
- Brake
- Gear changes
- Indicator state

---

## STMDataSimulator

Simulates STM32 telemetry packets.

Useful for frontend development and testing.

---

# Context Properties

The backend exposes objects directly to QML.

```cpp
vehicleData
musicPlayer
```

The UI reads data through property bindings.

Example:

```qml
Text {
    text: vehicleData.speed + " km/h"
}

Text {
    text: musicPlayer.trackTitle
}
```

---

# Application Modes

## Development Mode

Used during software development.

```text
DriverInput
        │
        ▼
VirtualVehicle
        │
        ▼
STMDataSimulator
        │
        ▼
VehicleData
        │
        ▼
QML Dashboard
```

No STM32 hardware is required.

---

## Production Mode

Used on the Raspberry Pi inside the vehicle.

```text
STM32
   │
UART
   │
SerialManager
   │
VehicleData
   │
QML Dashboard
```

Telemetry is received directly from the vehicle controller.

---

# Engineering Mode

Engineering Mode extends the standard dashboard with developer tools.

Available pages include:

- Vehicle Overview
- Live Telemetry
- Thermal Monitoring
- Powertrain Analysis
- Communication Status
- Fault History

Additional capabilities:

- Telemetry log export
- Simulator enable/disable
- Communication fault simulation

Engineering Mode is intended for development, testing, and vehicle diagnostics.

---

# Design Principles

The project follows several architectural principles:

### Separation of Concerns

- UI contains no hardware logic.
- Backend contains no presentation logic.

---

### Single Source of Truth

Vehicle information exists only in:

```text
VehicleData
```

Media information exists only in:

```text
LocalMusicPlayer
```

---

### Hardware Independence

The frontend is unaware whether data originates from:

- STM32
- Simulator
- Virtual vehicle

Only backend components determine the data source.

---

### Modular Design

Each backend component has a single responsibility.

Examples:

- SerialManager handles UART
- SpotifyAPIManager handles Spotify
- LocalMusicPlayer handles local playback
- WarningManager handles vehicle warnings

This keeps the project maintainable and easy to extend.

---

# Future Scalability

The architecture allows future integration of:

- CAN Bus
- GPS Navigation
- Cloud Services
- OTA Updates
- Voice Assistant
- Apple CarPlay
- Android Auto

without requiring major changes to the frontend.

---

# Summary

The EV_HMI architecture is designed around a modular Qt-based backend that exposes clean interfaces to a Qt Quick frontend. By separating telemetry, media, communication, and presentation into independent components, the project remains scalable, maintainable, and suitable for deployment on embedded Linux systems such as the Raspberry Pi.