import QtQuick
import EvHmi

BaseCard {
    id: root

    // FIXED: Dynamically switches card title layout configurations
    title: root.translations["title"][Typography.currentLanguage]

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title": { "en": "Drive Mode", "de": "Fahrmodus", "es": "Modo de Manejo" },
        "ECO":   { "en": "ECO",        "de": "ÖKO",       "es": "ECO" },
        "CITY":  { "en": "CITY",       "de": "STADT",     "es": "CIUDAD" },
        "SPORT": { "en": "SPORT",      "de": "SPORT",     "es": "SPORT" }
    }

    // =====================================================
    // UNIFIED DRIVE MODE SLIDER TRACK
    // =====================================================
    Rectangle {
        id: sliderContainer
        
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
                    width: (parent.width - (parent.padding * 2) - (parent.spacing * 2)) / 3
                    height: parent.height - (parent.padding * 2)
                    anchors.verticalCenter: parent.verticalCenter
                    radius: Theme.controlRadius - 2

                    readonly property bool active: vehicleData.driveMode === modelData

                    color: active
                           ? Qt.rgba(Colors.borderActive.r, Colors.borderActive.g, Colors.borderActive.b, 0.12)
                           : "transparent"

                    border.width: active ? 1.5 : 0
                    border.color: active ? Colors.borderActive : "transparent"

                    Behavior on color { ColorAnimation { duration: Theme.motionFast } }

                    Text {
                        anchors.centerIn: parent

                        // FIXED: Uses the static modelData as a key lookup to print translated button tags!
                        text: root.translations[modelData][Typography.currentLanguage]
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