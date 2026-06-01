import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvHmi

Item {

    Row {
        anchors.fill: parent
        spacing: Theme.cardGap

        BaseCard {
            width: parent.width * 0.72
            height: parent.height

            title: "Now Playing"

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                Image {
                    width: 140
                    height: 140

                    anchors.horizontalCenter: parent.horizontalCenter

                    source: musicPlayer.albumArtUrl
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    width: parent.width

                    text: musicPlayer.trackTitle

                    color: Colors.textPrimary

                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap

                    font.pixelSize: 40
                }

                Text {
                    width: parent.width

                    text: musicPlayer.artistName

                    color: Colors.textSecondary

                    horizontalAlignment: Text.AlignHCenter

                    font.pixelSize: 22
                }

                Text {
                    width: parent.width

                    text: musicPlayer.albumName

                    color: Colors.textSecondary

                    horizontalAlignment: Text.AlignHCenter

                    font.pixelSize: 16
                }

                Slider {
                    id: progressSlider

                    width: parent.width

                    from: 0
                    to: musicPlayer.duration

                    value: pressed
                           ? value
                           : musicPlayer.position

                    onMoved: {
                        musicPlayer.seek(value)
                    }
                }

                RowLayout {
                    width: parent.width

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

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Button {
                        width: 80
                        text: "<<"
                        onClicked: musicPlayer.previousTrack()
                    }

                    Button {
                        width: 100

                        text: musicPlayer.isPlaying
                              ? "||"
                              : "▶"

                        onClicked: musicPlayer.togglePlayback()
                    }

                    Button {
                        width: 80
                        text: ">>"
                        onClicked: musicPlayer.nextTrack()
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Button {
                        text: musicPlayer.shuffleEnabled
                              ? "Shuffle ON"
                              : "Shuffle OFF"

                        onClicked: musicPlayer.toggleShuffle()
                    }

                    Button {
                        text: musicPlayer.repeatEnabled
                              ? "Repeat ON"
                              : "Repeat OFF"

                        onClicked: musicPlayer.toggleRepeat()
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "Volume: "
                          + Math.round(musicPlayer.volume)
                          + "%"

                    color: Colors.textSecondary

                    font.pixelSize: 16
                }

                Slider {
                    width: parent.width * 0.7

                    anchors.horizontalCenter: parent.horizontalCenter

                    from: 0
                    to: 100

                    value: musicPlayer.volume

                    onMoved: {
                        musicPlayer.volume = value
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: musicPlayer.muted
                          ? "Unmute"
                          : "Mute"

                    onClicked: musicPlayer.toggleMute()
                }
            }
        }

        BaseCard {
            width: parent.width * 0.28
            height: parent.height

            title: "Playback Info"

            Column {
                anchors.centerIn: parent
                spacing: 16

                Text {
                    text: "Current Time"
                    color: Colors.textSecondary
                    font.pixelSize: 20
                }

                Text {
                    text: musicPlayer.currentTime
                    color: Colors.textPrimary
                    font.pixelSize: 42
                }

                Text {
                    text: "Total Time"
                    color: Colors.textSecondary
                    font.pixelSize: 20
                }

                Text {
                    text: musicPlayer.totalTime
                    color: Colors.textPrimary
                    font.pixelSize: 42
                }

                Text {
                    text: "Volume"
                    color: Colors.textSecondary
                    font.pixelSize: 20
                }

                Text {
                    text: Math.round(musicPlayer.volume) + "%"
                    color: Colors.textPrimary
                    font.pixelSize: 42
                }

                Rectangle {
                    width: parent.width * 0.8
                    height: 1
                    color: Colors.textSecondary
                    opacity: 0.3
                }

                Text {
                    text: "Track "
                          + musicPlayer.currentTrackIndex
                          + " / "
                          + musicPlayer.trackCount

                    color: Colors.textSecondary
                    font.pixelSize: 18
                }

                Text {
                    text: musicPlayer.shuffleEnabled
                          ? "Shuffle ON"
                          : "Shuffle OFF"

                    color: Colors.textSecondary
                    font.pixelSize: 16
                }

                Text {
                    text: musicPlayer.repeatEnabled
                          ? "Repeat ON"
                          : "Repeat OFF"

                    color: Colors.textSecondary
                    font.pixelSize: 16
                }
            }
        }
    }
}