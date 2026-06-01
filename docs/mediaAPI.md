# EV HMI Media API

## Purpose

This document defines all media playback properties exposed by the backend to QML.

Media data must remain separate from vehicle telemetry.

Vehicle telemetry is exposed through `VehicleData`.

Media playback data is exposed through `LocalMusicPlayer`.

Frontend developers should consume media properties directly from `musicPlayer`.

---

# Backend Data Flow

```text
MP3 Files
    ↓
QMediaPlayer
    ↓
LocalMusicPlayer
    ↓
QML Music Page
```

Future sources may include:

```text
Spotify
Bluetooth Audio
USB Media
```

These sources must expose the same API to QML.

---

# Context Property

Registered in `main.cpp`:

```cpp
engine.rootContext()->setContextProperty(
    "musicPlayer",
    &musicPlayer
);
```

QML usage:

```qml
Text {
    text: musicPlayer.trackTitle
}
```

---

# Playback Metadata

## Track Information

| Property   | Type    | Description                               |
| ---------- | ------- | ----------------------------------------- |
| trackTitle | QString | Current track title                       |
| artistName | QString | Artist name extracted from media metadata |
| albumName  | QString | Album name extracted from media metadata  |

---

## Playback State

| Property       | Type | Description            |
| -------------- | ---- | ---------------------- |
| isPlaying      | bool | Current playback state |
| shuffleEnabled | bool | Shuffle mode status    |
| repeatEnabled  | bool | Repeat mode status     |

---

## Track Position

| Property    | Type    | Unit  | Description                     |
| ----------- | ------- | ----- | ------------------------------- |
| position    | qint64  | ms    | Current playback position       |
| duration    | qint64  | ms    | Total track duration            |
| currentTime | QString | mm:ss | Formatted current playback time |
| totalTime   | QString | mm:ss | Formatted track duration        |

---

## Playlist Information

| Property          | Type | Description                   |
| ----------------- | ---- | ----------------------------- |
| currentTrackIndex | int  | Current track index (1-based) |
| trackCount        | int  | Total tracks available        |

---

## Audio Controls

| Property | Type | Range | Description              |
| -------- | ---- | ----- | ------------------------ |
| volume   | int  | 0-100 | Output volume percentage |
| muted    | bool | -     | Audio muted state        |

---

# Invokable Functions

## Playback Controls

```cpp
play()
pause()
togglePlayback()
```

Description:

| Function         | Description       |
| ---------------- | ----------------- |
| play()           | Start playback    |
| pause()          | Pause playback    |
| togglePlayback() | Toggle play/pause |

---

## Track Navigation

```cpp
nextTrack()
previousTrack()
```

Description:

| Function        | Description         |
| --------------- | ------------------- |
| nextTrack()     | Load next track     |
| previousTrack() | Load previous track |

---

## Seek Control

```cpp
seek(qint64 position)
```

Description:

| Function       | Description                                 |
| -------------- | ------------------------------------------- |
| seek(position) | Jump to a playback position in milliseconds |

---

## Playlist Controls

```cpp
toggleShuffle()
toggleRepeat()
```

Description:

| Function        | Description                    |
| --------------- | ------------------------------ |
| toggleShuffle() | Enable or disable shuffle mode |
| toggleRepeat()  | Enable or disable repeat mode  |

---

## Audio Controls

```cpp
setVolume(int volume)
toggleMute()
```

Description:

| Function          | Description               |
| ----------------- | ------------------------- |
| setVolume(volume) | Set output volume (0-100) |
| toggleMute()      | Toggle mute state         |

---

# Example QML Usage

## Track Information

```qml
Text {
    text: musicPlayer.trackTitle
}

Text {
    text: musicPlayer.artistName
}

Text {
    text: musicPlayer.albumName
}
```

---

## Progress Bar

```qml
Slider {
    from: 0
    to: musicPlayer.duration

    value: musicPlayer.position

    onMoved: {
        musicPlayer.seek(value)
    }
}
```

---

## Play/Pause Button

```qml
Button {
    text: musicPlayer.isPlaying
        ? "Pause"
        : "Play"

    onClicked: musicPlayer.togglePlayback()
}
```

---

## Volume Slider

```qml
Slider {
    from: 0
    to: 100

    value: musicPlayer.volume

    onMoved: {
        musicPlayer.setVolume(value)
    }
}
```

---

# Design Rules

1. Vehicle telemetry must never be added to LocalMusicPlayer.
2. Music metadata must never be added to VehicleData.
3. QML must only communicate with LocalMusicPlayer.
4. QML must not access QMediaPlayer directly.
5. Future Spotify, Bluetooth, and USB integrations must preserve this API contract.

---

# Future Extensions

Planned properties:

| Property    | Type    | Description                    |
| ----------- | ------- | ------------------------------ |
| albumArtUrl | QString | Album artwork image path       |
| mediaSource | QString | Local, Spotify, Bluetooth, USB |
| bitrate     | int     | Audio bitrate                  |
| sampleRate  | int     | Audio sample rate              |

These are not yet implemented.
