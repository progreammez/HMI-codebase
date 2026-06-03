import QtQuick
import QtQuick.Controls
import EvHmi

Item {
    property int activeTab: 0
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
                        width: 110
                        height: 110

                        radius: 12

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
                            font.pixelSize: 46
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

                            source: Colors.dayNightMode === "day"
                                     ? "qrc:/assets/icons/Light/MusicPage/previous.png"
                                     : "qrc:/assets/icons/Dark/MusicPage/previous.png"
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
                                    ? Colors.dayNightMode === "day"
                                      ? "qrc:/assets/icons/Light/MusicPage/pause.png"
                                      : "qrc:/assets/icons/Dark/MusicPage/pause.png"
                                    : Colors.dayNightMode === "day"
                                      ? "qrc:/assets/icons/Light/MusicPage/play.png"
                                      : "qrc:/assets/icons/Dark/MusicPage/play.png"
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

                            source: Colors.dayNightMode === "day"
                                     ? "qrc:/assets/icons/Light/MusicPage/next.png"
                                     : "qrc:/assets/icons/Dark/MusicPage/next.png"
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

                                source: Colors.dayNightMode === "day"
                                         ? "qrc:/assets/icons/Light/MusicPage/shuffle.png"
                                         : "qrc:/assets/icons/Dark/MusicPage/shuffle.png"
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

                                source: Colors.dayNightMode === "day"
                                         ? "qrc:/assets/icons/Light/MusicPage/repeat.png"
                                         : "qrc:/assets/icons/Dark/MusicPage/repeat.png"
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

            title: ""

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Row {
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: ["Playback", "Search", "Queue", "Lyrics"]

                        delegate: Rectangle {
                            width: (parent.width - 16) / 4
                            height: 34

                            radius: 8

                            color: activeTab === index
                                ? Colors.surfacePressed
                                : Colors.surfaceRaised

                            border.width: 1
                            border.color: activeTab === index
                                        ? Colors.borderActive
                                        : Colors.borderWarm

                            Text {
                                anchors.centerIn: parent
                                text: modelData

                                color: Colors.textPrimary

                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: activeTab = index
                            }
                        }
                    }
                }

                Loader {
                    width: parent.width
                    height: parent.height - 50

                    sourceComponent:
                        activeTab === 0
                        ? playbackTab
                        : activeTab === 1
                        ? searchTab
                        : activeTab === 2
                            ? queueTab
                            : lyricsTab
                }
            }

            Component {
                id: playbackTab

                Column {
                    width: parent.width
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
                        spacing: 12

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
                                width: 46
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
                                            ? Colors.dayNightMode === "day"
                                            ? "qrc:/assets/icons/Light/MusicPage/volume-mute.png"
                                            : "qrc:/assets/icons/Dark/MusicPage/volume-mute.png"
                                            : Colors.dayNightMode === "night"
                                            ? "qrc:/assets/icons/Dark/MusicPage/volume-loud.png"
                                            : "qrc:/assets/icons/Light/MusicPage/volume-loud.png"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: musicPlayer.toggleMute()
                                }
                            }
                        }

                        Slider {
                            orientation: Qt.Vertical

                            width: 36
                            height: 100

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

                    Row {
                        width: parent.width
                        spacing: 60

                        Column {
                            spacing: 2

                            Text {
                                text: "Shuffle"
                                color: Colors.textSecondary
                            }

                            Text {
                                text: musicPlayer.shuffleEnabled
                                    ? "ON"
                                    : "OFF"

                                color: Colors.textPrimary
                            }
                        }

                        Column {
                            spacing: 2

                            Text {
                                text: "Repeat"
                                color: Colors.textSecondary
                            }

                            Text {
                                text: musicPlayer.repeatEnabled
                                    ? "ON"
                                    : "OFF"

                                color: Colors.textPrimary
                            }
                        }
                    }
                }
            }

            Component {
                id: searchTab

                Column {
                    width: parent.width
                    spacing: 10

                    TextField {
                        width: parent.width
                        placeholderText: "Search Spotify..."
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Colors.borderSubtle
                    }

                    Text {
                        text: "Spotify search results will appear here"

                        color: Colors.textSecondary

                        wrapMode: Text.WordWrap

                        width: parent.width
                    }
                }
            }

            Component {
                id: queueTab

                Item {
                    anchors.fill: parent

                    Text {
                        id: queueTitle

                        text: "Playback Queue"

                        anchors.top: parent.top
                        anchors.left: parent.left

                        color: Colors.textPrimary

                        font.family: Typography.family
                        font.pixelSize: Typography.bodyLarge
                    }

                    Rectangle {
                        id: queueDivider

                        anchors.top: queueTitle.bottom
                        anchors.topMargin: 8

                        width: parent.width
                        height: 1

                        color: Colors.borderSubtle
                    }

                    ListView {
                        id: queueList

                        anchors.top: queueDivider.bottom
                        anchors.topMargin: 8

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        clip: true

                        spacing: 4

                        model: musicPlayer.playlistTitles

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 56

                            color: index === musicPlayer.currentTrackIndex - 1
                                ? Colors.surfacePressed
                                : Colors.surfaceRaised

                            border.width: index === musicPlayer.currentTrackIndex - 1
                                ? 1
                                : 0.5

                            border.color: index === musicPlayer.currentTrackIndex - 1
                                ? Colors.borderActive
                                : Colors.borderWarm

                            Row {
                                anchors.fill: parent
                                anchors.margins: 8

                                spacing: 10

                                Rectangle {
                                    width: 32
                                    height: 32

                                    radius: 4

                                    color: Colors.surfacePressed

                                    Text {
                                        anchors.centerIn: parent

                                        text: index === musicPlayer.currentTrackIndex - 1
                                            ? "▶"
                                            : "♪"

                                        color: Colors.textPrimary

                                        font.family: Typography.family
                                        font.pixelSize: Typography.bodyMedium
                                    }
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter

                                    width: parent.width - 60

                                    text: modelData

                                    color: Colors.textPrimary

                                    font.family: Typography.family

                                    font.pixelSize:
                                        index === musicPlayer.currentTrackIndex - 1
                                        ? Typography.bodyMedium
                                        : Typography.bodySmall

                                    font.bold:
                                        index === musicPlayer.currentTrackIndex - 1

                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    musicPlayer.playTrack(index)
                                }
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }
                    }
                }
            }

            Component {
                id: lyricsTab

                Column {
                    anchors.fill: parent

                    spacing: 20

                    Text {
                        text: "Lyrics"

                        color: Colors.textPrimary

                        font.family: Typography.family
                        font.pixelSize: Typography.titleLarge
                    }

                    Item {
                        width: parent.width
                        height: 20
                    }

                    Text {
                        text: musicPlayer.previousLyric
                        opacity: 0.4
                        width: parent.width

                        horizontalAlignment: Text.AlignHCenter

                        color: Colors.textMuted

                        font.family: Typography.family
                        font.pixelSize: Typography.bodyLarge

                        wrapMode: Text.WordWrap
                    }

                    Text {
                        text: musicPlayer.currentLyric

                        width: parent.width

                        horizontalAlignment: Text.AlignHCenter

                        color: Colors.textPrimary

                        font.family: Typography.family
                        font.pixelSize: 22

                        font.bold: true

                        wrapMode: Text.WordWrap
                    }

                    Text {
                        text: musicPlayer.nextLyric
                        opacity: 0.4
                        width: parent.width

                        horizontalAlignment: Text.AlignHCenter

                        color: Colors.textMuted

                        font.family: Typography.family
                        font.pixelSize: Typography.bodyLarge

                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}