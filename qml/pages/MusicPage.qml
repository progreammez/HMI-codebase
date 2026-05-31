import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvHmi

Item {

    Row {
        anchors.fill: parent
        spacing: Theme.cardGap

        BaseCard {
            width: parent.width * 0.65
            height: parent.height

            title: "Now Playing"

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                Text {
                    text: musicPlayer.trackTitle
                    wrapMode: Text.WordWrap
                    color: Colors.textPrimary

                    font.family: Typography.family
                    font.pixelSize: Typography.displayMedium
                }

                Text {
                    text: "Track "
                          + musicPlayer.currentTrackIndex
                          + " / "
                          + musicPlayer.trackCount

                    color: Colors.textSecondary
                }

                Text {
                    text: musicPlayer.isPlaying
                          ? "▶ Playing"
                          : "⏸ Paused"

                    color: Colors.accentEco
                }

                Slider {
                    id: progressSlider

                    from: 0
                    to: musicPlayer.duration

                    value: musicPlayer.position

                    onMoved: {
                        musicPlayer.seek(value)
                    }
                }

                RowLayout {
                    width: parent.width - 40

                    Text {
                        text: musicPlayer.currentTime
                        color: Colors.textSecondary
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: musicPlayer.totalTime
                        color: Colors.textSecondary
                    }
                }

                Text {
                    text: "Volume"

                    color: Colors.textPrimary
                }

                Slider {
                    width: parent.width - 40

                    from: 0
                    to: 1

                    value: musicPlayer.volume

                    onMoved: {
                        musicPlayer.volume = value
                    }
                }

                Row {
                    spacing: 10

                    Button {
                        text: "<<"

                        onClicked: {
                            musicPlayer.previousTrack()
                        }
                    }

                    Button {
                        text: musicPlayer.isPlaying
                              ? "||"
                              : "▶"

                        onClicked: {
                            musicPlayer.togglePlayback()
                        }
                    }

                    Button {
                        text: ">>"

                        onClicked: {
                            musicPlayer.nextTrack()
                        }
                    }
                }

                Row {
                    spacing: 10

                    Button {
                        text: musicPlayer.shuffleEnabled
                              ? "Shuffle ON"
                              : "Shuffle OFF"

                        onClicked: {
                            musicPlayer.toggleShuffle()
                        }
                    }

                    Button {
                        text: musicPlayer.repeatEnabled
                              ? "Repeat ON"
                              : "Repeat OFF"

                        onClicked: {
                            musicPlayer.toggleRepeat()
                        }
                    }
                }
            }
        }

        BaseCard {
            width: parent.width * 0.35
            height: parent.height

            title: "Playback Info"

            Column {
                anchors.centerIn: parent
                spacing: 18

                Text {
                    text: "Current Time"

                    color: Colors.textSecondary
                    font.pixelSize: Typography.titleLarge
                }

                Text {
                    text: musicPlayer.currentTime

                    color: Colors.textPrimary
                    font.pixelSize: Typography.displaySmall
                }

                Text {
                    text: "Total Time"

                    color: Colors.textSecondary
                    font.pixelSize: Typography.titleLarge
                }

                Text {
                    text: musicPlayer.totalTime

                    color: Colors.textPrimary
                    font.pixelSize: Typography.displaySmall
                }

                Text {
                    text: "Volume"

                    color: Colors.textSecondary
                    font.pixelSize: Typography.titleLarge
                }

                Text {
                    text: Math.round(
                              musicPlayer.volume * 100
                          ) + "%"

                    color: Colors.textPrimary
                    font.pixelSize: Typography.displaySmall
                }
            }
        }
    }
}