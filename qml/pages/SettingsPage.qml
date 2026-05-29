import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: root

    GridLayout {
        anchors.fill: parent
        columns: 12
        rows: 6
        columnSpacing: Theme.cardGap
        rowSpacing: Theme.cardGap

        BaseCard {
            Layout.column: 0
            Layout.row: 0
            Layout.columnSpan: 5
            Layout.rowSpan: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Display Theme"

            ColumnLayout {
                anchors.fill: parent
                spacing: Math.round(12 * Theme.scale)

                Repeater {
                    model: [
                        { name: "ICE", accent: Colors.accentBlue },
                        { name: "COPPER", accent: Colors.accentCopper },
                        { name: "AMBER", accent: Colors.warning }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.round(70 * Theme.scale)
                        radius: Theme.controlRadius
                        color: Colors.themeName === modelData.name ? modelData.accent : Colors.surfaceRaised
                        border.color: Colors.themeName === modelData.name ? modelData.accent : Colors.borderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Math.round(12 * Theme.scale)
                            spacing: Math.round(12 * Theme.scale)

                            Rectangle {
                                Layout.preferredWidth: Math.round(38 * Theme.scale)
                                Layout.preferredHeight: Math.round(38 * Theme.scale)
                                radius: Math.round(5 * Theme.scale)
                                color: modelData.accent
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.name
                                color: Colors.themeName === modelData.name ? Colors.backgroundPrimary : Colors.textPrimary
                                font.family: Typography.family
                                font.pixelSize: Typography.titleMedium
                                font.weight: Font.DemiBold
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Colors.themeName = modelData.name
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        BaseCard {
            Layout.column: 5
            Layout.row: 0
            Layout.columnSpan: 7
            Layout.rowSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Units"

            RowLayout {
                anchors.fill: parent
                spacing: Theme.cardGap

                ModeButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.round(46 * Theme.scale)
                    text: "KM / C"
                    selected: true
                    accentColor: Colors.accentCity
                }

                ModeButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.round(46 * Theme.scale)
                    text: "MI / F"
                    selected: false
                    accentColor: Colors.accentCity
                }
            }
        }

        BaseCard {
            Layout.column: 5
            Layout.row: 3
            Layout.columnSpan: 7
            Layout.rowSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Telemetry"

            GridLayout {
                anchors.fill: parent
                columns: 2
                columnSpacing: Theme.cardGap
                rowSpacing: Theme.cardGap

                MetricTile {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    label: "GEAR"
                    value: vehicleData.gearState
                    valueColor: Colors.accentCity
                }

                MetricTile {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    label: "COMMUNICATION"
                    value: vehicleData.communicationFault ? "FAULT" : "ONLINE"
                    valueColor: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                }
            }
        }
    }
}
