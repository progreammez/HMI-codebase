import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: commsPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(10 * Theme.scale)

    ColumnLayout {
        anchors.fill: parent
        spacing: commsPage.paddingSize

        // =====================================================
        // ROW 1: STATUS OVERVIEW, STATISTICS, & CONNECTION DETAILS
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(135 * Theme.scale)
            spacing: commsPage.paddingSize

            // Left Block: Sub Status Monitors
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 55
                color: Colors.surfaceRaised
                radius: commsPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: commsPage.paddingSize
                    spacing: 4

                    Text { 
                        text: "STATUS OVERVIEW"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8

                        // UART Box Layout
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            
                            ColumnLayout { 
                                anchors.centerIn: parent
                                spacing: 2
                                
                                Text { 
                                    text: "🔌 UART"
                                    font.pixelSize: 9
                                    color: Colors.textMuted
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                                Text { 
                                    text: vehicleData.communicationFault ? "OFFLINE" : "CONNECTED"
                                    font.weight: Font.Bold
                                    font.pixelSize: 10
                                    color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                                Text { 
                                    text: "/dev/ttyUSB0"
                                    font.pixelSize: 8
                                    color: Colors.textMuted
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                            }
                        }

                        // Parser Box Layout
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            
                            ColumnLayout { 
                                anchors.centerIn: parent
                                spacing: 2
                                
                                Text { 
                                    text: "</> PARSER"
                                    font.pixelSize: 9
                                    color: Colors.textMuted
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                                Text { 
                                    text: vehicleData.communicationFault ? "ERROR" : "ACTIVE"
                                    font.weight: Font.Bold
                                    font.pixelSize: 10
                                    color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                                Text { 
                                    text: "Protocol: EV_CAN_V1"
                                    font.pixelSize: 8
                                    color: Colors.textMuted
                                    Layout.alignment: Qt.AlignHCenter 
                                }
                            }
                        }
                    }
                }
            }

            // Middle Block: Telemetry Statistics Numerical Matrix
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 22
                color: Colors.surfaceRaised
                radius: commsPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: commsPage.paddingSize

                    Text { 
                        text: "COMMUNICATION STATISTICS"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3
                        Layout.topMargin: 4
                        
                        RowLayout { 
                            Text { text: "Telemetry Rate"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "0 Hz" : "50 Hz"; font.pixelSize: 9; color: Colors.accentCity; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "Frame Interval"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "20 ms"; font.pixelSize: 9; color: Colors.textPrimary }
                        }
                        RowLayout { 
                            Text { text: "Packet Loss"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "0 %"; font.pixelSize: 9; color: Colors.accentEco; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "Checksum Errors"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "2"; font.pixelSize: 9; color: Colors.textMuted }
                        }
                    }
                }
            }

            // Right Block: Explicit Physical Port Metadata Details
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 23
                color: Colors.surfaceRaised
                radius: commsPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: commsPage.paddingSize

                    Text { 
                        text: "CONNECTION DETAILS"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3
                        Layout.topMargin: 4
                        
                        RowLayout { 
                            Text { text: "Interface"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "UART"; font.pixelSize: 9; color: Colors.textPrimary; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "Baud Rate"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "115200"; font.pixelSize: 9; color: Colors.accentCity }
                        }
                        RowLayout { 
                            Text { text: "Data Bits"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "8"; font.pixelSize: 9; color: Colors.textPrimary }
                        }
                        RowLayout { 
                            Text { text: "Flow Control"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "None"; font.pixelSize: 9; color: Colors.textMuted }
                        }
                    }
                }
            }
        }

        // =====================================================
        // ROW 2: DATA FLOW MODEL GRAPH & FRAME QUALITY SUMMARY
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: commsPage.paddingSize

            // Left Block: Signal Architecture Visual Graph Link
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 65
                color: Colors.surfaceRaised
                radius: commsPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: commsPage.paddingSize

                    Text { 
                        text: "DATA FLOW SCHEMATIC"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 10
                        Layout.topMargin: 10

                        // Node Pipeline chain representation
                        Rectangle { 
                            width: 75
                            height: 32
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "UART / CAN\n50 Hz"; font.pixelSize: 8; color: Colors.textPrimary; anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter } 
                        }
                        Text { text: "➔"; color: Colors.textMuted; font.bold: true }
                        Rectangle { 
                            width: 75
                            height: 32
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "PARSER\n50 Hz"; font.pixelSize: 8; color: Colors.textPrimary; anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter } 
                        }
                        Text { text: "➔"; color: Colors.textMuted; font.bold: true }
                        Rectangle { 
                            width: 75
                            height: 32
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "VEHICLEDATA\n50 Hz"; font.pixelSize: 8; color: Colors.textPrimary; anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter } 
                        }
                        Text { text: "➔"; color: Colors.textMuted; font.bold: true }
                        Rectangle { 
                            width: 75
                            height: 32
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "QML VIEW\n50 Hz"; font.pixelSize: 8; color: Colors.accentEco; anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter } 
                        }
                    }
                    Item { Layout.fillHeight: true }
                }
            }

            // Right Block: Circle Status Graphic Ring 
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 35
                color: Colors.surfaceRaised
                radius: commsPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: commsPage.paddingSize

                    Text { 
                        text: "FRAME QUALITY"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 12

                        Rectangle { 
                            width: 56
                            height: 56
                            radius: 28
                            color: "transparent"
                            border.color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                            border.width: 4
                            
                            Text { 
                                text: vehicleData.communicationFault ? "0%\nBAD" : "100%\nGOOD"
                                font.pixelSize: 9
                                font.bold: true
                                color: Colors.textPrimary
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter 
                            }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text { text: "• Valid Frames: 100%"; font.pixelSize: 9; color: Colors.accentEco }
                            Text { text: "• Checksum Errors: 0"; font.pixelSize: 9; color: Colors.textMuted }
                            Text { text: "• Corrupt Frames: 0"; font.pixelSize: 9; color: Colors.textMuted }
                        }
                    }
                }
            }
        }
    }
}