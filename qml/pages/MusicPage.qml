import QtQuick
import QtQuick.Controls
import EvHmi

Item {
    Row {
        anchors.fill: parent
        spacing: Theme.cardGap

        // =====================================================
        // NOW PLAYING
        // =====================================================
        BaseCard {
            width: parent.width * 0.68
            height: parent.height

            title: "Now Playing"

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                // ==========================================
                // COVER + METADATA
                // ==========================================
                Row {
                    width: parent.width
                    spacing: 20

                    Rectangle {
                        width: 140
                        height: 140

                        radius: 14

                        color: Colors.surfaceRaised

                        border.width: 2
                        border.color: Colors.borderActive

                        Image {
                            id: albumArt

                            anchors.fill: parent
                            anchors.margins: 3

                            source: musicPlayer.albumArtUrl

                            fillMode: Image.PreserveAspectCrop

                            cache: false

                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent

                            visible: albumArt.status !== Image.Ready

                            text: "♪"

                            color: Colors.accentCity

                            font.family: Typography.family
                            font.pixelSize: 54
                        }
                    }

                    Column {
                        width: parent.width - 160

                        anchors.verticalCenter: parent.verticalCenter

                        spacing: 10

                        Text {
                            text: musicPlayer.trackTitle

                            color: Colors.textPrimary

                            font.family: Typography.family
                            font.pixelSize: Typography.titleLarge

                            font.weight: Font.DemiBold

                            wrapMode: Text.WordWrap
                        }

                        Text {
                            text: musicPlayer.artistName

                            color: Colors.textSecondary

                            font.family: Typography.family
                            font.pixelSize: Typography.titleSmall

                            wrapMode: Text.WordWrap
                        }

                        Text {
                            text: musicPlayer.albumName

                            color: Colors.textMuted

                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium

                            wrapMode: Text.WordWrap
                        }
                    }
                }

               
                // ==========================================
                // PROGRESS & TIMESTAMPS
                // ==========================================
                Item {
                    id: progressSectionContainer
                    width: parent.width
                    // Height is the slider height + gap + text height
                    height: progressSlider.height + 6 + 16 

                    Slider {
                        id: progressSlider
                        width: parent.width - 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top

                        from: 0
                        to: musicPlayer.duration
                        value: musicPlayer.position

                        onMoved: {
                            musicPlayer.seek(value)
                        }
                    }

                    // Explicitly anchored relative to the container boundaries,
                    // safe inside its own Item bubble!
                    Text {
                        id: startTimeText
                        anchors.left: progressSlider.left
                        anchors.top: progressSlider.bottom
                        anchors.topMargin: 4
                        
                        text: musicPlayer.currentTime
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                    }

                    Text {
                        id: endTimeText
                        anchors.right: progressSlider.right
                        anchors.top: progressSlider.bottom
                        anchors.topMargin: 4
                        
                        text: musicPlayer.totalTime
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                    }
                }

                // ==========================================
                // CONTROLS
                // ==========================================
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 40

                    Rectangle {
                        width: 52
                        height: 52

                        radius: 10
                        anchors.verticalCenter: parent.verticalCenter
                        

                        color: Colors.surfaceRaised

                        border.width: 1
                        border.color: Colors.borderWarm

                        Image {
                            anchors.centerIn: parent

                            width: 22
                            height: 22

                            source: "qrc:/assets/icons/previous.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: musicPlayer.previousTrack()
                        }
                    }

                    Rectangle {
                        width: 68
                        height: 68

                        radius: 34

                        color: Colors.surfaceRaised

                        border.width: 2
                        border.color: Colors.borderActive

                        Image {
                            anchors.centerIn: parent

                            width: 30
                            height: 30

                            source: musicPlayer.isPlaying
                                    ? "qrc:/assets/icons/pause.png"
                                    : "qrc:/assets/icons/play.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: musicPlayer.togglePlayback()
                        }
                    }

                    Rectangle {
                        width: 52
                        height: 52

                        radius: 10
                        anchors.verticalCenter: parent.verticalCenter

                        color: Colors.surfaceRaised

                        border.width: 1
                        border.color: Colors.borderWarm

                        Image {
                            anchors.centerIn: parent

                            width: 22
                            height: 22

                            source: "qrc:/assets/icons/next.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: musicPlayer.nextTrack()
                        }
                    }
                }

                Item {
                    width: 1
                    height: 4
                }

                // ==========================================
                // SHUFFLE + REPEAT
                // ==========================================
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 14

                    Rectangle {
                        width: 120
                        height: 36

                        radius: 8

                        color: musicPlayer.shuffleEnabled
                               ? Colors.surfacePressed
                               : Colors.surfaceRaised

                        border.width: 1
                        border.color: Colors.borderWarm

                        Row {
                            anchors.centerIn: parent

                            spacing: 8

                            Image {
                                width: 16
                                height: 16

                                source: "qrc:/assets/icons/shuffle.png"
                            }

                            Text {
                                text: "Shuffle"

                                color: Colors.textPrimary

                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: musicPlayer.toggleShuffle()
                        }
                    }

                    Rectangle {
                        width: 120
                        height: 36

                        radius: 8

                        color: musicPlayer.repeatEnabled
                               ? Colors.surfacePressed
                               : Colors.surfaceRaised

                        border.width: 1
                        border.color: Colors.borderWarm

                        Row {
                            anchors.centerIn: parent

                            spacing: 8

                            Image {
                                width: 16
                                height: 16

                                source: "qrc:/assets/icons/repeat.png"
                            }

                            Text {
                                text: "Repeat"

                                color: Colors.textPrimary

                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: musicPlayer.toggleRepeat()
                        }
                    }
                }
            }
        }

        // =====================================================
        // PLAYBACK INFO
        // =====================================================
        BaseCard {
            width: parent.width * 0.32 - Theme.cardGap
            height: parent.height

            title: "Playback"

            Column {
                anchors.fill: parent
                anchors.margins: 10

                spacing: 8

                Text {
                    text: "Track"

                    color: Colors.textSecondary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }

                Text {
                    text: musicPlayer.currentTrackIndex
                          + " / "
                          + musicPlayer.trackCount

                    color: Colors.textPrimary

                    font.family: Typography.family
                    font.pixelSize: Typography.titleMedium
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.borderSubtle
                }

                Text {
                    text: "Status"

                    color: Colors.textSecondary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }

                Text {
                    text: musicPlayer.isPlaying
                          ? "Playing"
                          : "Paused"

                    color: musicPlayer.isPlaying
                           ? Colors.accentEco
                           : Colors.textPrimary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.borderSubtle
                }

                Row {
                    spacing: 10

                    Column {
                        spacing: 4

                        Text {
                            text: "Volume"

                            color: Colors.textSecondary

                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall
                        }

                        Text {
                            text: Math.round(
                                      musicPlayer.volume
                                  ) + "%"

                            color: Colors.textPrimary

                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                        }

                        Rectangle {
                            width: 42
                            height: 42

                            radius: 8

                            color: Colors.surfaceRaised

                            border.width: 1
                            border.color: Colors.borderWarm

                            Image {
                                anchors.centerIn: parent

                                width: 20
                                height: 20

                                source: musicPlayer.muted
                                        ? "qrc:/assets/icons/volume-mute.png"
                                        : "qrc:/assets/icons/volume-loud.png"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: musicPlayer.toggleMute()
                            }
                        }
                    }

                    Slider {
                        orientation: Qt.Vertical

                        width: 28
                        height: 90

                        from: 0
                        to: 100

                        value: musicPlayer.volume

                        onValueChanged: {
                            musicPlayer.volume = value
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.borderSubtle
                }

                Text {
                    text: "Shuffle"

                    color: Colors.textSecondary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }

                Text {
                    text: musicPlayer.shuffleEnabled
                          ? "ON"
                          : "OFF"

                    color: Colors.textPrimary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.borderSubtle
                }

                Text {
                    text: "Repeat"

                    color: Colors.textSecondary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }

                Text {
                    text: musicPlayer.repeatEnabled
                          ? "ON"
                          : "OFF"

                    color: Colors.textPrimary

                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                }
            }
        }
    }
}