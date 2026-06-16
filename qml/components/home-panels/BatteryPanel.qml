import QtQuick
import EvHmi

BaseCard {
    id: root

    title: root.translations["title"][Typography.currentLanguage]

    readonly property string iconSetPath: "qrc:/assets/icons/" + (Colors.dayNightMode === "day" ? "Light" : "Dark") + "/HomePage/"
    
    // Global unit mapping hooks
    readonly property bool isMetric: Typography.unitSystem === "metric"
    readonly property real unitFactor: isMetric ? 1.0 : 0.621371
    readonly property string unitLabel: isMetric ? " km" : " mi"

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title":           { "en": "Battery",         "de": "Batterie",            "es": "Batería" },
        "capacity":        { "en": "Capacity",        "de": "Kapazität",           "es": "Capacidad" },
        "total_range":     { "en": "Total Range",     "de": "Gesamtreichweite",    "es": "Autonomía Total" },
        "estimated_range": { "en": "Estimated Range", "de": "Schätzreichweite",    "es": "Autonomía Estimada" },
        "battery_temp":    { "en": "Battery Temp",    "de": "Batterietemp.",       "es": "Temp. de Batería" }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20 * Theme.scale
        spacing: 14 * Theme.scale

        // =====================================================
        // TOP SECTION: LARGE BATTERY GRAPHIC & PERCENTAGE
        // =====================================================
        Item {
            width: parent.width
            height: 70 * Theme.scale

            BatteryGraphic {
                width: 100
                height: 32
                id: batteryGraphic

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                percentage: vehicleData.batteryPercent

                scale: 2.4
                transformOrigin: Item.Left
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: Math.round(vehicleData.batteryPercent) + "%"
                color: Colors.textPrimary

                font.family: Typography.family
                font.pixelSize: Typography.displayMedium - 4
                font.bold: true
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Colors.borderSubtle
            opacity: 0.15
        }

        // =====================================================
        // BOTTOM SECTION: TELEMETRY LIST WITH PREMIUM ICONS
        // =====================================================
        Column {
            width: parent.width
            spacing: 8 * Theme.scale

            // ROW 1: Capacity
            Rectangle {
                width: parent.width
                height: 34 * Theme.scale
                radius: 6 * Theme.scale
                color: Qt.rgba(1, 1, 1, 0.03) 

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * Theme.scale

                    Image {
                        width: 25 * Theme.scale
                        height: 25 * Theme.scale
                        source: root.iconSetPath + "battery.png"
                        fillMode: Image.PreserveAspectFit
                        antialiasing: true
                    }

                    Text {
                        text: root.translations["capacity"][Typography.currentLanguage]
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter

                    text: Math.round(vehicleData.batteryPercent) + "%"
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }

            // ROW 2: Total Range (Adaptive Metrics!)
            Rectangle {
                width: parent.width
                height: 34 * Theme.scale
                radius: 6 * Theme.scale
                color: Qt.rgba(1, 1, 1, 0.03)

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * Theme.scale

                    Image {
                        width: 25 * Theme.scale
                        height: 25 * Theme.scale
                        source: root.iconSetPath + "range.png"
                        fillMode: Image.PreserveAspectFit
                        antialiasing: true
                    }

                    Text {
                        text: root.translations["total_range"][Typography.currentLanguage]
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter

                    text: (typeof vehicleData.totalRangeKm !== 'undefined' && vehicleData.totalRangeKm !== null) 
                          ? Math.round (vehicleData.totalRangeKm * root.unitFactor) + root.unitLabel
                          : (root.isMetric ? "180 km" : "112 mi")
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }

            // ROW 3: Estimated Range (Adaptive Metrics!)
            Rectangle {
                width: parent.width
                height: 34 * Theme.scale
                radius: 6 * Theme.scale
                color: Qt.rgba(1, 1, 1, 0.03)

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * Theme.scale

                    Image {
                        width: 25 * Theme.scale
                        height: 25 * Theme.scale
                        source: root.iconSetPath + "range.png"
                        fillMode: Image.PreserveAspectFit
                        antialiasing: true
                    }

                    Text {
                        text: root.translations["estimated_range"][Typography.currentLanguage]
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter

                    text: Math.round(vehicleData.rangeKm * root.unitFactor) + root.unitLabel
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }

            // ROW 4: Battery Temp
            Rectangle {
                width: parent.width
                height: 34 * Theme.scale
                radius: 6 * Theme.scale
                color: Qt.rgba(1, 1, 1, 0.03)

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * Theme.scale

                    Image {
                        width: 25 * Theme.scale
                        height: 25 * Theme.scale
                        source: root.iconSetPath + "batterytemp.png"
                        fillMode: Image.PreserveAspectFit
                        antialiasing: true
                    }

                    Text {
                        text: root.translations["battery_temp"][Typography.currentLanguage]
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter

                    text: Math.round(isMetric ? vehicleData.batteryTemp : (vehicleData.batteryTemp * 9/5 + 32)) + "°" + (isMetric ? "C" : "F")
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }
        }
    }
}