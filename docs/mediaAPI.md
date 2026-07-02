# EV_HMI Media API

## Overview

The Media API defines the complete multimedia interface exposed by the backend to the Qt Quick (QML) frontend.

Unlike vehicle telemetry, media playback is handled independently through the `musicPlayer` backend object.

This separation ensures that infotainment features remain completely isolated from critical vehicle systems.

---

# Design Philosophy

The EV_HMI backend separates vehicle telemetry and multimedia into independent subsystems.

| Backend Object | Purpose |
|---------------|---------|
| `vehicleData` | Vehicle telemetry |
| `musicPlayer` | Multimedia playback |

Vehicle data must never contain media metadata, and media components must never expose vehicle information.

---

# Supported Media Sources

The current media subsystem supports multiple playback sources.

| Source | Status |
|---------|--------|
| Local Music | ✓ Implemented |
| Spotify | ✓ Implemented |
| Bluetooth Audio | ✓ Implemented |
| USB Media | Planned |

Regardless of the active source, QML interacts with the same backend interface.

---

# Architecture

```text
                Local MP3 Files
                       │
                       │
                Spotify Web API
                       │
                       │
                 Bluetooth Audio
                       │
        ───────────────┼───────────────
                       │
               LocalMusicPlayer
                       │
             Qt Context Property
                       │
                  musicPlayer
                       │
                    Qt Quick UI
```

The frontend never communicates directly with Spotify, Bluetooth, or QMediaPlayer.

All media operations pass through `LocalMusicPlayer`.

---

# Context Property

Registered inside `main.cpp`.

```cpp
engine.rootContext()->setContextProperty(
    "musicPlayer",
    &musicPlayer
);
```

Example:

```qml
Text {
    text: musicPlayer.trackTitle
}
```

---

# Playback Metadata

## Track Information

| Property | Type | Description |
|----------|------|-------------|
| trackTitle | QString | Current track title |
| artistName | QString | Artist name |
| albumName | QString | Album name |

---

## Playback State

| Property | Type | Description |
|----------|------|-------------|
| isPlaying | bool | Playback state |
| shuffleEnabled | bool | Shuffle enabled |
| repeatEnabled | bool | Repeat enabled |

---

## Playback Position

| Property | Type | Description |
|----------|------|-------------|
| position | qint64 | Current playback position |
| duration | qint64 | Total track duration |
| currentTime | QString | Formatted playback time |
| totalTime | QString | Formatted duration |

---

## Playlist

| Property | Type | Description |
|----------|------|-------------|
| currentTrackIndex | int | Current track |
| trackCount | int | Playlist size |

---

## Audio

| Property | Type | Description |
|----------|------|-------------|
| volume | int | Volume (0–100) |
| muted | bool | Audio muted |

---

# Playback Controls

```cpp
play()
pause()
togglePlayback()
```

---

# Track Navigation

```cpp
nextTrack()
previousTrack()
```

---

# Seek

```cpp
seek(position)
```

Moves playback to the requested position.

---

# Audio Controls

```cpp
setVolume(volume)

toggleMute()
```

---

# Playlist Controls

```cpp
toggleShuffle()

toggleRepeat()
```

---

# Spotify Integration

Spotify playback is handled internally through `SpotifyAPIManager`.

Responsibilities include:

- OAuth authentication
- Access token management
- Playback polling
- Album artwork
- Track metadata
- Playback control

The frontend does not interact directly with the Spotify Web API.

Instead, Spotify updates are translated into the same interface exposed by `musicPlayer`.

This allows the UI to switch seamlessly between Local Music and Spotify without requiring different QML components.

---

# Bluetooth Audio

Bluetooth audio follows the same architecture.

When Bluetooth is selected as the active source:

Bluetooth Device

↓

BluetoothManager

↓

LocalMusicPlayer

↓

musicPlayer

↓

Qt Quick UI

The dashboard remains unaware of the underlying playback source.

---

# Source Switching

Users can switch between:

- Local Music
- Spotify
- Bluetooth

The active media source is managed entirely by the backend.

The frontend continues to consume the same `musicPlayer` properties regardless of source.

---

# Example Usage

Track title

```qml
Text {
    text: musicPlayer.trackTitle
}
```

Artist

```qml
Text {
    text: musicPlayer.artistName
}
```

Progress Slider

```qml
Slider {

    from: 0
    to: musicPlayer.duration

    value: musicPlayer.position

    onMoved: musicPlayer.seek(value)

}
```

Play / Pause

```qml
Button {

    text: musicPlayer.isPlaying ? "Pause" : "Play"

    onClicked: musicPlayer.togglePlayback()

}
```

---

# Design Rules

The media subsystem follows several important rules.

## Separation of Concerns

Vehicle telemetry belongs only to:

```text
vehicleData
```

Media playback belongs only to:

```text
musicPlayer
```

---

## Backend Ownership

Only backend classes may communicate with:

- Spotify
- Bluetooth
- QMediaPlayer

QML must never access these APIs directly.

---

## Unified Interface

Every media source must expose identical properties.

This allows the frontend to remain completely independent of the playback source.

---

# Future Expansion

The current architecture allows additional sources to be added with minimal changes.

Examples include:

- USB Media
- Apple CarPlay
- Android Auto
- Internet Radio
- DAB Radio

No QML changes should be required.

---

# Summary

The EV_HMI Media API provides a unified multimedia interface that abstracts Local Music, Spotify, and Bluetooth into a single backend object. By exposing a consistent Qt property interface through `musicPlayer`, the frontend remains simple, maintainable, and independent of the underlying media source.