import QtQuick
import EvHmi

BaseCard {
    id: root

    // Dynamically switches card title based on global language selection
    title: root.translations["title"][Typography.currentLanguage]

    // =====================================================
    // ⚙️ GLOBAL UNIT CONFIGURATION READOUTS
    // =====================================================
    readonly property bool isMetric: Typography.unitSystem === "metric"
    readonly property real unitFactor: isMetric ? 1.0 : 0.621371
    readonly property string unitLabel: isMetric ? " km" : " mi"

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title":    { "en": "Odometer & Trips", "de": "Kilometerzähler & Trips", "es": "Odómetro y Viajes" },
        "odometer": { "en": "ODOMETER",          "de": "GESAMTKM",               "es": "ODÓMETRO" },
        "trip_a":   { "en": "TRIP A",            "de": "TRIP A",                 "es": "VIAJE A" },
        "trip_b":   { "en": "TRIP B",            "de": "TRIP B",                 "es": "VIAJE B" }
    }

    Row {
        anchors.fill: parent

        // COLUMN 1: ODOMETER
        Item {
            width: parent.width / 3
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 4 * Theme.scale

                Text {
                    text: root.translations["odometer"][Typography.currentLanguage]
                    color: Colors.textMuted
                    font.family: Typography.family
                    font.pixelSize: Typography.label
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    // Automatically recalculates output strings dynamically based on active units
                    text: (vehicleData.odometer * root.unitFactor).toFixed(1) + root.unitLabel
                    color: Colors.textPrimary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            width: 1
            height: parent.height * 0.45
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.borderSubtle
        }

        // COLUMN 2: TRIP A
        Item {
            width: parent.width / 3
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 4 * Theme.scale

                Text {
                    text: root.translations["trip_a"][Typography.currentLanguage]
                    color: Colors.textMuted
                    font.family: Typography.family
                    font.pixelSize: Typography.label
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: (vehicleData.tripA * root.unitFactor).toFixed(1) + root.unitLabel
                    color: Colors.textPrimary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            width: 1
            height: parent.height * 0.45
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.borderSubtle
        }

        // COLUMN 3: TRIP B
        Item {
            width: parent.width / 3
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 4 * Theme.scale

                Text {
                    text: root.translations["trip_b"][Typography.currentLanguage]
                    color: Colors.textMuted
                    font.family: Typography.family
                    font.pixelSize: Typography.label
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: (vehicleData.tripB * root.unitFactor).toFixed(1) + root.unitLabel
                    color: Colors.textPrimary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}