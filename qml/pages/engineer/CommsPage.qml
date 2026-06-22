import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: commsPage
    anchors.fill: parent

    readonly property int paddingSize: Math.round(10 * Theme.scale)
    readonly property int innerRadius: 4

    // Live Telemetry Math Calculations (Protects against Division by Zero)
    readonly property int totalFrames: vehicleData.framesReceived
    readonly property int goodFrames: Math.max(0, commsPage.totalFrames - vehicleData.invalidFrames - vehicleData.checksumErrors)
    
    readonly property int goodPercent: commsPage.totalFrames > 0 ? Math.round((commsPage.goodFrames / commsPage.totalFrames) * 100) : 0
    readonly property int invalidPercent: commsPage.totalFrames > 0 ? Math.round((vehicleData.invalidFrames / commsPage.totalFrames) * 100) : 0
    readonly property int checksumPercent: commsPage.totalFrames > 0 ? Math.round((vehicleData.checksumErrors / commsPage.totalFrames) * 100) : 0

    RowLayout {
        anchors.fill: parent
        anchors.margins: commsPage.paddingSize
        spacing: commsPage.paddingSize

        // =====================================================
        // LEFT COLUMN: MAIN DASHBOARD & MONITORING PIPELINE (65%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 650
            spacing: commsPage.paddingSize

            // 1. STATUS OVERVIEW
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 4
                baseColor: Colors.surfaceRaised
                title: "STATUS OVERVIEW"

                RowLayout {
                    anchors.fill: parent
                    spacing: commsPage.paddingSize

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: commsPage.innerRadius
                        border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "🔌 UART"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "OFFLINE" : "CONNECTED"
                                font.family: Typography.family
                                font.weight: Font.Bold
                                font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "/dev/ttyUSB0"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "0 bps" : "115200 bps"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: commsPage.innerRadius
                        border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "</> PARSER"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "ERROR ●" : "ACTIVE ●"
                                font.family: Typography.family
                                font.weight: Font.Bold
                                font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Protocol: EV_CAN_V1"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "● FAULT" : "● OK"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: commsPage.innerRadius
                        border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "📄 LOGGER"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "HALTED" : "RECORDING"
                                font.family: Typography.family
                                font.weight: Font.Bold
                                font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "File: log_2026_06_21.csv"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "● 12.4 MB"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: commsPage.innerRadius
                        border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "📦 SIMULATOR"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.simulationActive ? "RUNNING" : "DISABLED"
                                font.family: Typography.family
                                font.weight: Font.Bold
                                font.pixelSize: Typography.bodyLarge
                                color: vehicleData.simulationActive ? Colors.accentEco : Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Live Data Source"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: vehicleData.simulationActive ? "● ACTIVE" : "● OFF"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                color: vehicleData.simulationActive ? Colors.accentEco : Colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            // 2. DATA RATE MONITOR (Stretch Weight: 11)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 11
                baseColor: Colors.surfaceRaised
                title: "DATA RATE MONITOR"

                Text {
                    text: vehicleData.communicationFault ? "Current: 0 Hz" : "Current: 50 Hz"
                    color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: -22
                }

                Item {
                    anchors.fill: parent

                    Canvas {
                        id: waveCanvas
                        anchors.fill: parent
                        anchors.bottomMargin: 20
                        
                        Connections {
                            target: vehicleData
                            function onCommunicationFaultChanged() { waveCanvas.requestPaint() }
                        }

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = vehicleData.communicationFault ? Colors.borderSubtle : Colors.accentCity
                            ctx.lineWidth = 1.5
                            ctx.beginPath()
                            
                            if (vehicleData.communicationFault) {
                                ctx.moveTo(0, height - 5)
                                ctx.lineTo(width, height - 5)
                            } else {
                                ctx.moveTo(0, height * 0.4)
                                for(var x = 0; x <= width; x += 15) {
                                    var y = (height * 0.4) + (Math.sin(x / 12) * 5) + (Math.random() * 3 - 1.5)
                                    ctx.lineTo(x, y)
                                }
                            }
                            ctx.stroke()
                        }
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        Text { text: "60s ago"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "45s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "30s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "15s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "Now"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                    }
                }
            }

            // 3. LOWER METADATA FIELDS (Stretch Weight: 5)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 5
                spacing: commsPage.paddingSize

                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "PORT INFORMATION"
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            Text { text: "Driver"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "FTDI USB Serial"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity }
                        }
                        RowLayout {
                            Text { text: "Firmware"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "v2.12.36"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Buffer Size"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "4096 bytes"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Rx / Tx Buffer"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "0% / 0%"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "PROTOCOL INFORMATION"
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            Text { text: "Protocol"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "EV_CAN_V1"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity }
                        }
                        RowLayout {
                            Text { text: "Version"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "1.0.3"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Message Count"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "36"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Protocol Status"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "FAULT" : "OK"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco; font.bold: true }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }

        // =====================================================
        // RIGHT COLUMN: METRICS SIDEBAR & QUICK ACTION PANEL (35%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 350
            spacing: commsPage.paddingSize

            // 1. STATS TWIN PAIR (Stretch Weight: 9)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 9
                spacing: commsPage.paddingSize

                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "COMMUNICATION STATS"
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 4
                        RowLayout {
                            Text { text: "Telemetry Rate"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "0 Hz" : "50 Hz"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity }
                        }
                        RowLayout {
                            Text { text: "Frame Interval"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "--" : "20 ms"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Packet Loss"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "100 %" : "0 %"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco; font.bold: true }
                        }
                        RowLayout {
                            Text { text: "Frames Recv"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.framesReceived; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity }
                        }
                        RowLayout {
                            Text { text: "Invalid Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.invalidFrames; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Checksum Errors"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.checksumErrors; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "CONNECTION DETAILS"
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 4
                        RowLayout {
                            Text { text: "Interface"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "UART"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; font.bold: true }
                        }
                        RowLayout {
                            Text { text: "Baud Rate"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "115200"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity }
                        }
                        RowLayout {
                            Text { text: "Data / Stop Bits"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "8 / 1"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "Parity / Flow"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "None"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                        }
                        RowLayout {
                            Text { text: "Status"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "Disconnected" : "Connected"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco }
                        }
                        RowLayout {
                            Text { text: "Uptime"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "02:14:37"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // 2. FRAME QUALITY COMPONENT (Stretch Weight: 7)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 7
                title: "FRAME QUALITY"

                RowLayout {
                    anchors.fill: parent
                    spacing: 16

                    Rectangle {
                        id: progressRing
                        width: 64
                        height: 64
                        radius: 32
                        color: "transparent"
                        border.color: vehicleData.communicationFault ? Colors.critical : (commsPage.totalFrames === 0 ? Colors.borderSubtle : Colors.accentEco)
                        border.width: 4
                        Layout.alignment: Qt.AlignVCenter
                        Text {
                            text: vehicleData.communicationFault ? "0%\nBAD" : (commsPage.totalFrames === 0 ? "0%\nEMPTY" : commsPage.goodPercent + "%\nGOOD")
                            font.family: Typography.family
                            font.bold: true
                            font.pixelSize: Typography.bodySmall
                            color: Colors.textPrimary
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true
                        RowLayout {
                            Text { text: "● Good Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                            Item { Layout.fillWidth: true }
                            Text { text: commsPage.goodFrames + " (" + commsPage.goodPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                        }
                        RowLayout {
                            Text { text: "● Invalid Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: "orange" }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.invalidFrames + " (" + commsPage.invalidPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                        }
                        RowLayout {
                            Text { text: "● Checksum Errors"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.checksumErrors + " (" + commsPage.checksumPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                        }
                        RowLayout {
                            Text { text: "● Lost Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: "purple" }
                            Item { Layout.fillWidth: true }
                            Text { text: "0 (0%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                        }
                    }
                }
            }

            // 3. ACTIONS PANEL WITH INTERACTIVE BUTTONS (Stretch Weight: 4)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 4
                title: "ACTIONS"

                RowLayout {
                    anchors.fill: parent
                    spacing: commsPage.paddingSize

                    BaseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        interactive: !vehicleData.communicationFault
                        baseColor: Colors.surfaceBase
                        title: ""
                        Text {
                            text: "🔄\nReset Statistics"
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium
                            color: vehicleData.communicationFault ? Colors.textMuted : Colors.textPrimary
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                        }
                        onTapped: vehicleData.resetStatistics()
                    }

                    BaseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        interactive: true
                        baseColor: Colors.surfaceBase
                        title: ""
                        Text {
                            text: "📥\nExport Log"
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium
                            color: Colors.textPrimary
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                        }
                        onTapped: vehicleData.exportLog()
                    }

                    BaseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        interactive: true
                        baseColor: Colors.surfaceBase
                        title: ""
                        Text {
                            text: "⚡\nTest Connection"
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium
                            color: Colors.textPrimary
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                        }
                        onTapped: vehicleData.testConnection()
                    }
                }
            }
        }
    }
}