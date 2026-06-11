import QtQuick
import EvHmi

BaseCard {
    id: root

    title: "BATTERY"

    // FIXED: Dynamically switches asset directory strings based on system Day/Night mode state
    readonly property string iconSetPath: "qrc:/assets/icons/" + (Colors.dayNightMode === "day" ? "Light" : "Dark") + "/HomePage/"

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

        // Sleek subtle divider line
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
                        text: "Capacity"
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

            // ROW 2: Total Range
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
                        text: "Total Range"
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
                          ? vehicleData.totalRangeKm + " km" 
                          : "180 km"
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }

            // ROW 3: Estimated Range
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
                        text: "Estimated Range"
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

                    text: Math.round(vehicleData.rangeKm) + " km"
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
                        text: "Battery Temp"
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

                    text: Math.round(vehicleData.batteryTemp) + "°C"
                    color: Colors.borderActive
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                    font.weight: Font.Bold
                }
            }
        }
    }
}