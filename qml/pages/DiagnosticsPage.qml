import QtQuick
import QtQuick.Controls
import EvHmi

Item {
    id: root
    anchors.fill: parent

    Column {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.cardGap

        // =====================================================
        // MAIN SECTION
        // =====================================================

        Row {
            id: mainSection

            width: parent.width
            height: parent.height * 0.72

            spacing: Theme.cardGap

            // ==========================================
            // VEHICLE OVERVIEW
            // ==========================================

            BaseCard {
                id: vehicleOverviewCard

                width: parent.width * 0.37
                height: parent.height
            }

            // ==========================================
            // RIGHT SIDE
            // ==========================================

            Column {
                id: rightColumn

                width: parent.width
                       - vehicleOverviewCard.width
                       - Theme.cardGap

                height: parent.height

                spacing: Theme.cardGap

                // ==================================
                // TOP RIGHT
                // ==================================

                Row {
                    id: topRightRow

                    width: parent.width
                    height: parent.height * 0.62

                    spacing: Theme.cardGap

                    BaseCard {
                        id: vehicleHealthCard

                        width: parent.width * 0.43
                        height: parent.height

                        Column {
                            anchors.fill: parent
                            anchors.margins: Theme.cardPadding
                            spacing: 12

                            Text {
                                text: "VEHICLE HEALTH"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyLarge
                                font.bold: true
                            }

                            Item {
                                width: parent.width
                                height: 80

                                Text {
                                    anchors.right: parent.right
                                    text: "98%"
                                    color: Colors.accentBlue
                                    font.pixelSize: 44
                                    font.bold: true
                                }

                                Text {
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    text: "HEALTHY"
                                    color: Colors.accentBlue
                                    font.pixelSize: Typography.bodyLarge
                                    font.bold: true
                                }

                                Column {
                                    spacing: 8

                                    Text {
                                        text: "Overall Score"
                                        color: Colors.textSecondary
                                        font.pixelSize: Typography.bodyMedium
                                    }

                                    Text {
                                        text: "Status"
                                        color: Colors.textSecondary
                                        font.pixelSize: Typography.bodyMedium
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Colors.borderColor
                                opacity: 0.4
                            }

                            Repeater {
                                model: [
                                    ["Battery", "OK"],
                                    ["Motor", "OK"],
                                    ["Controller", "OK"],
                                    ["Comms", "OK"]
                                ]

                                delegate: Row {
                                    width: parent.width
                                    spacing: 10

                                    Text {
                                        text: modelData[0]
                                        color: Colors.textPrimary
                                        font.pixelSize: Typography.bodyLarge
                                    }

                                    Item {
                                        width: parent.width
                                        height: 1
                                    }

                                    Text {
                                        anchors.right: undefined
                                        text: modelData[1]
                                        color: "#3CFF5A"
                                        font.pixelSize: Typography.bodyLarge
                                    }
                                }
                            }

                            Item {
                                height: 1
                                width: parent.width
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Colors.borderColor
                                opacity: 0.4
                            }

                            Text {
                                text: "Last Check: 12:42:31"
                                color: Colors.textSecondary
                                font.pixelSize: Typography.bodyMedium
                            }
                        }
                    }

                    BaseCard {
                        id: activeWarningsCard

                        width: parent.width
                            - vehicleHealthCard.width
                            - Theme.cardGap

                        height: parent.height

                        Column {
                            anchors.fill: parent
                            anchors.margins: Theme.cardPadding
                            spacing: 14

                            Text {
                                text: "ACTIVE WARNINGS"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyLarge
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "✓"
                                color: Colors.accentBlue
                                font.pixelSize: 48
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "NO ACTIVE WARNINGS"
                                color: Colors.accentBlue
                                font.pixelSize: Typography.bodyLarge
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "All systems are functioning normally."
                                color: Colors.textSecondary
                                font.pixelSize: Typography.bodyMedium
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Colors.borderColor
                                opacity: 0.4
                            }

                            Text {
                                text: "Last Fault (Historical)"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyLarge
                            }

                            Rectangle {
                                width: parent.width
                                height: 70
                                radius: Theme.cardRadius
                                color: "transparent"
                                border.color: Colors.borderColor

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12

                                    Text {
                                        text: "⚠"
                                        color: "#FFC72C"
                                        font.pixelSize: 28
                                    }

                                    Column {
                                        spacing: 4

                                        Text {
                                            text: "BMS Overtemp"
                                            color: Colors.textPrimary
                                        }

                                        Text {
                                            text: "02-Jun-2026 09:14:22"
                                            color: Colors.textSecondary
                                        }
                                    }

                                    Item {
                                        anchors.horizontalCenter: undefined
                                        width: 1
                                        height: 1
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Resolved"
                                        color: "#3CFF5A"
                                    }
                                }
                            }

                            Row {
                                spacing: 20

                                Text {
                                    text: "0 Active"
                                    color: Colors.accentBlue
                                }

                                Text {
                                    text: "|"
                                    color: Colors.textSecondary
                                }

                                Text {
                                    text: "2 Historical"
                                    color: Colors.accentBlue
                                }
                            }
                        }
                    }
                }

                // ==================================
                // BOTTOM RIGHT
                // ==================================

                Row {
                    id: bottomRightRow

                    width: parent.width
                    height: parent.height
                            - topRightRow.height
                            - Theme.cardGap

                    spacing: Theme.cardGap

                    BaseCard {
                        id: batteryCard

                        width: (parent.width - Theme.cardGap * 3) / 4
                        height: parent.height
                    }

                    BaseCard {
                        id: powertrainCard

                        width: (parent.width - Theme.cardGap * 3) / 4
                        height: parent.height
                    }

                    BaseCard {
                        id: thermalCard

                        width: (parent.width - Theme.cardGap * 3) / 4
                        height: parent.height
                    }

                    BaseCard {
                        id: communicationCard

                        width: (parent.width - Theme.cardGap * 3) / 4
                        height: parent.height
                    }
                }
            }
        }

        // =====================================================
        // BOTTOM SECTION
        // =====================================================

        Row {
            id: bottomSection

            width: parent.width
            height: parent.height
                    - mainSection.height
                    - Theme.cardGap

            spacing: Theme.cardGap

            BaseCard {
                id: temperatureStatusCard

                width: (parent.width - Theme.cardGap) / 2
                height: parent.height
            }

            BaseCard {
                id: powertrainDataCard

                width: (parent.width - Theme.cardGap) / 2
                height: parent.height
            }
        }
    }
}