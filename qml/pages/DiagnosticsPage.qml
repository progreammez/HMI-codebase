import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: root

    readonly property color modeColor: vehicleData.driveMode === "SPORT" ? Colors.accentSport
        : vehicleData.driveMode === "CITY" ? Colors.accentCity
        : Colors.accentEco

    GridLayout {
        anchors.fill: parent
        columns: 3
        rows: 2
        columnSpacing: Theme.cardGap
        rowSpacing: Theme.cardGap

        Repeater {
            model: [
                { title: "Speed", value: vehicleData.speed, unit: "km/h", color: root.modeColor },
                { title: "Motor RPM", value: vehicleData.rpm, unit: "rpm", color: Colors.textPrimary },
                { title: "Battery", value: vehicleData.batteryPercent, unit: "%", color: Colors.accentEco },
                { title: "Motor Temp", value: vehicleData.motorTemp, unit: "C", color: vehicleData.motorTemp > 70 ? Colors.warning : Colors.textPrimary },
                { title: "Battery Temp", value: vehicleData.batteryTemp, unit: "C", color: vehicleData.batteryTemp > 45 ? Colors.warning : Colors.textPrimary },
                { title: "Communication", value: vehicleData.communicationFault ? "Fault" : "Online", unit: "", color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco }
            ]

            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: modelData.title

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(8 * Theme.scale)

                    Item { Layout.fillHeight: true }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Math.round(8 * Theme.scale)
                        Text {
                            text: modelData.value
                            color: modelData.color
                            font.family: Typography.family
                            font.pixelSize: modelData.unit.length > 0 ? Typography.displaySmall : Typography.titleLarge
                            font.weight: Font.DemiBold
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: modelData.unit
                            visible: modelData.unit.length > 0
                            color: Colors.textMuted
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium
                            font.weight: Font.Medium
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.round(7 * Theme.scale)
                        radius: height / 2
                        color: Colors.surfaceSunken
                        Rectangle {
                            width: parent.width * (modelData.title === "Battery" ? vehicleData.batteryPercent / 100
                                : modelData.title === "Speed" ? Math.min(1, vehicleData.speed / 140)
                                : modelData.title === "Motor RPM" ? Math.min(1, vehicleData.rpm / 8200)
                                : modelData.title.indexOf("Temp") >= 0 ? Math.min(1, parseFloat(modelData.value) / 100)
                                : vehicleData.communicationFault ? 0.18 : 1)
                            height: parent.height
                            radius: parent.radius
                            color: modelData.color
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: modelData.title === "Communication" ? "Communication state mirrors the official communicationFault telemetry."
                            : "Live value from VehicleDataManager telemetry."
                        color: Colors.textMuted
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        font.family: Typography.family
                        font.pixelSize: Typography.label
                    }
                }
            }
        }
    }
}
