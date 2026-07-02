# EV_HMI Telemetry API

## Overview

The Telemetry API defines every vehicle-related property exposed by the backend to the Qt Quick (QML) frontend.

All telemetry is provided through a single backend object:

```cpp
vehicleData
```

Every dashboard page should obtain vehicle information exclusively through this object.

---

# Design Philosophy

The project follows a strict separation between **vehicle telemetry** and **media playback**.

| Category | Backend Object |
|----------|----------------|
| Vehicle Telemetry | `vehicleData` |
| Music Playback | `musicPlayer` |

Vehicle-related information must never be added to the media subsystem, and media metadata must never be exposed through `VehicleData`.

---

# Backend Data Flow

## Development Mode

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

---

## Production Mode

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

---

# Context Property

The telemetry object is registered inside `main.cpp`.

```cpp
engine.rootContext()->setContextProperty(
    "vehicleData",
    &vehicleData
);
```

---

# Core Vehicle Information

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| speed | int | km/h | Current vehicle speed |
| rpm | int | RPM | Motor RPM |
| batteryPercent | int | % | Battery State of Charge |
| rangeKm | int | km | Estimated remaining driving range |

---

# Temperature Information

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| motorTemp | int | °C | Motor temperature |
| batteryTemp | int | °C | Battery temperature |
| controllerTemp | int | °C | Motor controller temperature |

---

# Drive Information

| Property | Type | Description |
|----------|------|-------------|
| driveMode | QString | ECO / CITY / SPORT |
| gearState | QString | P / N / R / D |

---

# Charging

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| charging | bool | — | Charging status |
| chargingPower | float | kW | Current charging power |
| chargeTimeRemaining | int | minutes | Estimated charging time remaining |

---

# Powertrain

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| batteryVoltage | float | V | Battery voltage |
| batteryCurrent | float | A | Battery current |
| motorPower | float | kW | Motor output power |
| regenLevel | int | Level | Regenerative braking level |

---

# Indicators

| Property | Type | Description |
|----------|------|-------------|
| leftIndicator | bool | Left turn signal |
| rightIndicator | bool | Right turn signal |
| hazardLights | bool | Hazard lights |
| headlights | bool | Headlights |
| highBeam | bool | High beam |

---

# Trip Information

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| odometer | float | km | Total vehicle distance |
| tripDistance | float | km | Current trip distance |

---

# Warning System

| Property | Type | Description |
|----------|------|-------------|
| warningMessage | QString | Current warning message |
| lowBatteryWarning | bool | Battery below threshold |
| motorOverTempWarning | bool | Motor overheating |
| batteryOverTempWarning | bool | Battery overheating |
| communicationFault | bool | Communication timeout |

---

# Example Usage

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

## Drive Mode

```qml
Text {
    text: vehicleData.driveMode
}
```

---

## Warning Banner

```qml
Rectangle {

    visible: vehicleData.communicationFault

    Text {
        text: vehicleData.warningMessage
    }

}
```

---

# Property Update Flow

Whenever telemetry changes, the backend updates VehicleData.

```text
STM32 / Simulator
        │
        ▼
VehicleData Property
        │
        ▼
Qt Property Notification
        │
        ▼
QML Binding
        │
        ▼
Dashboard Updates Automatically
```

No polling is required inside QML.

---

# Engineering Mode

Engineering Mode consumes the same `vehicleData` object as the dashboard.

Additional pages simply expose more telemetry simultaneously.

Examples include:

- Overview
- Live Telemetry
- Thermal
- Powertrain
- Communication
- Fault Monitoring

No special telemetry interface exists for Engineering Mode.

---

# Best Practices

## Use Property Bindings

Preferred:

```qml
Text {
    text: vehicleData.speed
}
```

Avoid repeatedly querying values inside timers.

---

## Do Not Modify VehicleData From QML

VehicleData is a read-only interface from the frontend.

All updates originate from:

- SerialManager
- STM32
- Simulators

---

## Keep Telemetry Separate From Media

Correct:

```qml
vehicleData.speed
musicPlayer.trackTitle
```

Incorrect:

```qml
vehicleData.trackTitle
```

Music metadata belongs exclusively to `musicPlayer`.

---

# Related APIs

## Vehicle Telemetry

```text
vehicleData
```

Contains:

- Vehicle Status
- Battery
- Charging
- Powertrain
- Indicators
- Trip Information
- Warnings

---

## Media Playback

```text
musicPlayer
```

Contains:

- Track Metadata
- Playback Controls
- Playlist
- Album Artwork
- Playback State

See:

```
mediaAPI.md
```

---

# Summary

VehicleData serves as the single source of truth for all vehicle telemetry inside EV_HMI. By exposing a stable Qt property interface to QML while isolating communication inside the backend, the project maintains a clean separation between presentation and hardware, simplifying development, testing, and future expansion.