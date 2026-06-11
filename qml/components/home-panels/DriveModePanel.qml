import QtQuick
import EvHmi

BaseCard {
    id: root

    title: "DRIVE MODE"

    // =====================================================
    // UNIFIED DRIVE MODE SLIDER TRACK
    // =====================================================
    Rectangle {
        id: sliderContainer
        
        // Sized to balance perfectly within the center card layout dimensions
        width: Math.round(250 * Theme.scale)
        height: Math.round(44 * Theme.scale)
        radius: Theme.controlRadius
        anchors.centerIn: parent
        
        color: Colors.surfaceSunken
        border.width: 1
        border.color: Qt.rgba(Colors.borderSubtle.r, Colors.borderSubtle.g, Colors.borderSubtle.b, 0.25)

        Row {
            anchors.fill: parent
            padding: 4 * Theme.scale
            spacing: 4 * Theme.scale

            Repeater {
                model: ["ECO", "CITY", "SPORT"]

                Rectangle {
                    // Dynamically splits the track container evenly into thirds
                    width: (parent.width - (parent.padding * 2) - (parent.spacing * 2)) / 3
                    height: parent.height - (parent.padding * 2)
                    anchors.verticalCenter: parent.verticalCenter
                    radius: Theme.controlRadius - 2

                    readonly property bool active: vehicleData.driveMode === modelData

                    // MATCHED: Premium slider background highlight opacity blend
                    color: active
                           ? Qt.rgba(Colors.borderActive.r, Colors.borderActive.g, Colors.borderActive.b, 0.12)
                           : "transparent"

                    border.width: active ? 1.5 : 0
                    border.color: active ? Colors.borderActive : "transparent"

                    // Smooth transitions when jumping modes
                    Behavior on color { ColorAnimation { duration: Theme.motionFast } }

                    Text {
                        anchors.centerIn: parent

                        text: modelData
                        // MATCHED: Selected items pop with theme accent, unselected items sit clean in the background
                        color: parent.active ? Colors.borderActive : Colors.textMuted

                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            vehicleData.driveMode = modelData
                        }
                    }
                }
            }
        }
    }
}