# EV HMI Telemetry API

## Purpose

This document defines all telemetry variables exposed by the backend to QML.

Backend developers are responsible for maintaining these properties.

Frontend developers should consume these properties directly from `vehicleData`.

Media playback information is not telemetry and must be accessed through `musicPlayer`.

---

# VehicleData Properties

## Core Vehicle Data

| Property       | Type | Unit | Description               |
| -------------- | ---- | ---- | ------------------------- |
| speed          | int  | km/h | Current vehicle speed     |
| rpm            | int  | RPM  | Motor RPM                 |
| batteryPercent | int  | %    | Battery state of charge   |
| rangeKm        | int  | km   | Estimated remaining range |

---

## Temperature Data

| Property       | Type | Unit | Description                  |
| -------------- | ---- | ---- | ---------------------------- |
| motorTemp      | int  | °C   | Motor temperature            |
| batteryTemp    | int  | °C   | Battery temperature          |
| controllerTemp | int  | °C   | Motor controller temperature |

---

## Drive Information

| Property  | Type    | Description      |
| --------- | ------- | ---------------- |
| driveMode | QString | ECO, CITY, SPORT |
| gearState | QString | P, N, R, D       |

---

## Indicators & Lighting

| Property       | Type | Description                |
| -------------- | ---- | -------------------------- |
| leftIndicator  | bool | Left turn indicator state  |
| rightIndicator | bool | Right turn indicator state |
| hazardLights   | bool | Hazard light state         |
| headlights     | bool | Headlight state            |
| highBeam       | bool | High beam state            |

---

## Charging Data

| Property            | Type  | Unit | Description             |
| ------------------- | ----- | ---- | ----------------------- |
| charging            | bool  | -    | Charging status         |
| chargingPower       | float | kW   | Charging power          |
| chargeTimeRemaining | int   | min  | Remaining charging time |

---

## Powertrain Data

| Property       | Type  | Unit  | Description                |
| -------------- | ----- | ----- | -------------------------- |
| batteryVoltage | float | V     | Battery pack voltage       |
| batteryCurrent | float | A     | Battery pack current       |
| motorPower     | float | kW    | Current motor output power |
| regenLevel     | int   | Level | Regenerative braking level |

---

## Trip Information

| Property     | Type  | Unit | Description            |
| ------------ | ----- | ---- | ---------------------- |
| odometer     | float | km   | Total vehicle distance |
| tripDistance | float | km   | Current trip distance  |

---

## Warning System

| Property               | Type    | Description                         |
| ---------------------- | ------- | ----------------------------------- |
| warningMessage         | QString | Active warning message              |
| lowBatteryWarning      | bool    | Battery below warning threshold     |
| motorOverTempWarning   | bool    | Motor temperature above threshold   |
| batteryOverTempWarning | bool    | Battery temperature above threshold |
| communicationFault     | bool    | Communication fault detected        |

---

# Backend Data Flow

## Development Mode

```text
TelemetrySimulator
        ↓
VehicleData
        ↓
QML Dashboard
```

---

## Production Mode

```text
UARTManager / CANManager
            ↓
TelemetryParser
            ↓
VehicleData
            ↓
QML Dashboard
```

---

# Context Property

Registered in `main.cpp`:

```cpp
engine.rootContext()->setContextProperty(
    "vehicleData",
    &vehicleData
);
```

---

# Example QML Usage

## Speed

```qml
Text {
    text: vehicleData.speed + " km/h"
}
```

---

## Battery Percentage

```qml
Text {
    text: vehicleData.batteryPercent + "%"
}
```

---

## Motor Temperature

```qml
Text {
    text: vehicleData.motorTemp + "°C"
}
```

---

## Drive Mode

```qml
Text {
    text: vehicleData.driveMode
}
```

---

## Warning Banner

```qml
Text {
    text: vehicleData.warningMessage
}
```

---

# Design Rules

1. QML must never communicate directly with UART, CAN, or the simulator.
2. All vehicle data must pass through `VehicleData`.
3. Music information must never be added to `VehicleData`.
4. Spotify, Bluetooth, USB, and local music data belong to `LocalMusicPlayer`.
5. Frontend code must only consume properties defined in this document.

---

# Related APIs

## Vehicle Telemetry

```text
vehicleData
```

Contains:

```text
Speed
Battery
Temperature
Warnings
Charging
Powertrain
Trip Information
Indicators
```

---

## Media Playback

```text
musicPlayer
```

Contains:

```text
Track Metadata
Playback Controls
Volume
Mute
Shuffle
Repeat
Playlist Information
Album Artwork
```

See:

```text
docs/mediaAPI.md
```
