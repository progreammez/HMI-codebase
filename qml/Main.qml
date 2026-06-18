import QtQuick
import QtQuick.Window
import QtMultimedia
import EvHmi

Window {
    id: root

    width: Theme.baseWidth
    height: Theme.baseHeight
    minimumWidth: 1280
    minimumHeight: 800
    visible: true
    title: "EV HMI"
    color: Colors.backgroundPrimary

    property bool splashFinished: false

    onWidthChanged: updateScale()
    onHeightChanged: updateScale()
    Component.onCompleted: {
        updateScale()
        bootPlayer.play()
    }

    function updateScale() {
        Theme.scale = Math.min(root.width / Theme.baseWidth,
                               root.height / Theme.baseHeight)
        Typography.scale = Theme.scale
    }

    AppShell {
        anchors.fill: parent
        visible: splashFinished
    }

    Rectangle {
        id: splashScreen

        anchors.fill: parent
        z: 999999
        visible: !splashFinished

        color: "black"
        opacity: 1

        Behavior on opacity {
            NumberAnimation {
                duration: 800
                easing.type: Easing.OutCubic
            }
        }

        

        VideoOutput {
            id: splashVideo
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
        }

        MediaPlayer {
            id: bootPlayer

            source: "qrc:/assets/Boot/Splash-screen.mp4"
            videoOutput: splashVideo

            onMediaStatusChanged: {
                if (mediaStatus === MediaPlayer.EndOfMedia)
                    fadeTimer.start()
            }
        }

        Timer {
            id: fadeTimer
            interval: 300
            repeat: false

            onTriggered: {
                splashScreen.opacity = 0
            }
        }

        onOpacityChanged: {
            if (opacity <= 0.01) {
                splashFinished = true
                splashScreen.visible = false
            }
        }
    }
}