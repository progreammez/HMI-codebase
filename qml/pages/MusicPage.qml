import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvHmi

Item {
    property string selectedTrackId: ""
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

                spacing: 12

                Item {
                    width: parent.width
                    height: parent.height * 0.65

                    Column {
                        anchors.fill: parent
                        spacing: 8

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

                            font.pixelSize: 36
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
                            width: parent.width

                            from: 0
                            to: musicPlayer.duration

                            value: pressed
                                ? value
                                : musicPlayer.position

                            onMoved: musicPlayer.seek(value)
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
                                text: "<<"
                                width: 80
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
                                text: ">>"
                                width: 80
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
                        }

                        Slider {
                            width: parent.width * 0.7

                            anchors.horizontalCenter: parent.horizontalCenter

                            from: 0
                            to: 100

                            value: musicPlayer.volume

                            onMoved: musicPlayer.volume = value
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1

                    color: Colors.border
                    opacity: 0.5
                }

                Item {
                    width: parent.width
                    height: parent.height * 0.32

                    ListView {
                        id: lyricsView

                        anchors.fill: parent

                        model: musicPlayer.lyricList

                        interactive: false

                        spacing: 18

                        currentIndex: musicPlayer.currentLyricIndex

                        preferredHighlightBegin: height / 2
                        preferredHighlightEnd: height / 2

                        highlightRangeMode: ListView.StrictlyEnforceRange

                        clip: true
                        Text {
                            anchors.centerIn: parent

                            visible: musicPlayer.lyricList.length === 0

                            text: "♫"

                            color: "#506070"

                            font.pixelSize: 48

                            SequentialAnimation on opacity {
                                running: true
                                loops: Animation.Infinite

                                NumberAnimation {
                                    from: 0.3
                                    to: 0.8
                                    duration: 1200
                                }

                                NumberAnimation {
                                    from: 0.8
                                    to: 0.3
                                    duration: 1200
                                }
                            }
                        }
                        Behavior on contentY {
                            NumberAnimation {
                                duration: 450
                                easing.type: Easing.OutCubic
                            }
                        }

                        visible: musicPlayer.lyricList.length > 0

                        delegate: Item {
                            width: lyricsView.width
                            height: lyricText.implicitHeight + 20

                            Text {
                                id: lyricText

                                anchors.centerIn: parent

                                width: parent.width * 0.90

                                text: modelData

                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap

                                color: index === lyricsView.currentIndex
                                    ? "#6CCEFF"
                                    : "#FFFFFF"

                                opacity: {
                                    var d = Math.abs(index - lyricsView.currentIndex)

                                    if (d === 0)
                                        return 1.0

                                    if (d === 1)
                                        return 0.35

                                    if (d === 2)
                                        return 0.15

                                    return 0.05
                                }

                                font.pixelSize: {
                                    var d = Math.abs(index - lyricsView.currentIndex)

                                    if (d === 0)
                                        return 30

                                    if (d === 1)
                                        return 22

                                    return 18
                                }

                                font.bold: index === lyricsView.currentIndex

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 250
                                    }
                                }

                                Behavior on font.pixelSize {
                                    NumberAnimation {
                                        duration: 250
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        BaseCard {
            width: parent.width * 0.28
            height: parent.height

            title: "Spotify Search"

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                TextField {
                    id: searchField
                    width: 250
                    height: 40

                    onAccepted: {
                        spotifyApi.searchTracks(text)
                    }

                    placeholderText: "Search Spotify..."
                }

                Button {
                    text: "Search"

                    onClicked: {
                        spotifyApi.searchTracks(searchField.text)
                    }
                }

                Rectangle {
                    width: parent.width * 0.8
                    height: 1
                    color: Colors.textSecondary
                    opacity: 0.3
                }

                ListView {
                    width: parent.width
                    height: parent.height - 120

                    model: spotifyApi.tracks

                    clip: true

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 70

                        property bool hovered: false

                        color:
                            modelData.id === selectedTrackId
                                ? "#1A5A8A"
                                : hovered
                                    ? "#12304A"
                                    : (index % 2 === 0
                                        ? "#08131D"
                                        : "#0B1824")

                        border.color: "#1A3145"

                        Row {
                            anchors.fill: parent
                            anchors.margins: 8

                            spacing: 10

                            Image {
                                width: 50
                                height: 50

                                source: modelData.imageUrl

                                fillMode: Image.PreserveAspectFit
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: modelData.title
                                    color: "white"
                                    font.pixelSize: 16
                                    elide: Text.ElideRight
                                    width: 180
                                }

                                Text {
                                    text: modelData.artist
                                    color: "#8FA7B8"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    width: 180
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: parent.hovered = true
                            onExited: parent.hovered = false

                            onClicked: {

                                selectedTrackId = modelData.id

                                spotifyApi.selectTrack(index)

                                spotifyApi.loadLyrics(modelData.id)

                                console.log("Selected:", modelData.title, "-", modelData.artist)
                            }
                        }
                    }
                }
            }
        }
    }
}
