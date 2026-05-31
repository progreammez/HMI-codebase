# MediaPlayer API Contract

## Purpose

This document defines all media playback variables exposed by the backend to QML.

Backend developers are responsible for maintaining these properties.

Frontend developers should consume these properties directly from `musicPlayer`.

Media playback data must remain separate from vehicle telemetry.

Vehicle telemetry belongs to `VehicleData`.

Media playback belongs to `LocalMusicPlayer`.

---

# LocalMusicPlayer Properties

## Playback Information

| Property   | Type    | Description                               |
| ---------- | ------- | ----------------------------------------- |
| trackTitle | QString | Current track title                       |
| duration   | qint64  | Total track duration in milliseconds      |
| position   | qint64  | Current playback position in milliseconds |
| isPlaying  | bool    | Current playback state                    |

---

## Playlist Information

| Property          | Type | Description                        |
| ----------------- | ---- | ---------------------------------- |
| currentTrackIndex | int  | Current track number (1-based)     |
| trackCount        | int  | Total number of tracks in playlist |

---

## Playback Modes

| Property       | Type | Description          |
| -------------- | ---- | -------------------- |
| shuffleEnabled | bool | Shuffle mode enabled |
| repeatEnabled  | bool | Repeat mode enabled  |

---

# Invokable Functions

## Playback Control

| Function         | Description       |
| ---------------- | ----------------- |
| play()           | Start playback    |
| pause()          | Pause playback    |
| togglePlayback() | Toggle play/pause |

---

## Playlist Navigation

| Function        | Description            |
| --------------- | ---------------------- |
| nextTrack()     | Move to next track     |
| previousTrack() | Move to previous track |

---

## Playback Position

| Function       | Description                                         |
| -------------- | --------------------------------------------------- |
| seek(position) | Jump to specified playback position in milliseconds |

---

## Playback Modes

| Function        | Description         |
| --------------- | ------------------- |
| toggleShuffle() | Toggle shuffle mode |
| toggleRepeat()  | Toggle repeat mode  |

---

# Example QML Usage

Text {
text: musicPlayer.trackTitle
}

Text {
text: musicPlayer.currentTrackIndex

- " / "
- musicPlayer.trackCount
  }

Text {
text: musicPlayer.isPlaying
? "Playing"
: "Paused"
}

Slider {
from: 0
to: musicPlayer.duration

```
value: musicPlayer.position

onMoved: {
    musicPlayer.seek(value)
}
```

}

Button {
text: "Next"

```
onClicked: {
    musicPlayer.nextTrack()
}
```

}

Button {
text: "Previous"

```
onClicked: {
    musicPlayer.previousTrack()
}
```

}

Button {
text: musicPlayer.isPlaying
? "Pause"
: "Play"

```
onClicked: {
    musicPlayer.togglePlayback()
}
```

}

---

# Architecture Rules

1. QML must never directly access QMediaPlayer.

2. QML must never access playlist internals.

3. QML must communicate only through LocalMusicPlayer.

4. Track loading, playback control, playlist management, shuffle logic, repeat logic, and seeking are backend responsibilities.

5. LocalMusicPlayer acts as the single source of truth for media playback.

---

# Current Integration Status

## Implemented

- trackTitle
- duration
- position
- isPlaying
- currentTrackIndex
- trackCount
- shuffleEnabled
- repeatEnabled
- play()
- pause()
- togglePlayback()
- nextTrack()
- previousTrack()
- seek()
- toggleShuffle()
- toggleRepeat()

## Planned

- artistName
- albumName
- albumArt
- volume
- mute
- playlistName
- metadata extraction
- Bluetooth audio source
- USB media source
