import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: powertrainPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(10 * Theme.scale)

    ColumnLayout {
        anchors.fill: parent
        spacing: powertrainPage.paddingSize

        // =====================================================
        // ROW 1: LIVE VALUES & LIVE TRENDS (VOLTAGE, CURRENT, POWER)
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(160 * Theme.scale)
            spacing: powertrainPage.paddingSize

            // Left Side Panel: Live Powertrain Telemetry Readouts
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 32
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: powertrainPage.paddingSize
                    spacing: 1

                    Text { 
                        text: "LIVE POWERTRAIN VALUES"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 2
                        Layout.topMargin: 4

                        RowLayout { 
                            Text { text: "Battery Voltage"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: "72.4 V"; color: Colors.accentCity; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                        RowLayout { 
                            Text { text: "Battery Current"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: "18.2 A"; color: Colors.accentCity; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                        RowLayout { 
                            Text { text: "Motor Power"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.motorPower.toFixed(1) + " kW"; color: Colors.accentCity; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                        RowLayout { 
                            Text { text: "Regen Level"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: String(vehicleData.regenLevel); color: Colors.textPrimary; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                        RowLayout { 
                            Text { text: "Motor RPM"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: String(vehicleData.rpm); color: Colors.textPrimary; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                        RowLayout { 
                            Text { text: "Drive Mode"; color: Colors.textPrimary; font.pixelSize: 10 }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.driveMode; color: Colors.accentEco; font.weight: Font.Bold; font.pixelSize: 11 }
                        }
                    }
                }
            }

            // Right Side Panel: Trends Waveform Track Containers
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 68
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: powertrainPage.paddingSize

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "POWERTRAIN TRENDS (LIVE)"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        Text { text: "[ 10s | 30s | 1min ]"; color: Colors.textMuted; font.pixelSize: 9; font.weight: Font.DemiBold }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8
                        Layout.topMargin: 4

                        // Sub Trend Trace 1: Voltage
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            
                            ColumnLayout { 
                                anchors.fill: parent
                                anchors.margins: 6
                                
                                RowLayout { 
                                    Text { text: "VOLTAGE TREND"; font.pixelSize: 8; color: Colors.textMuted }
                                    Item { Layout.fillWidth: true }
                                    Text { text: "72.4 V"; font.pixelSize: 8; color: "#00BFFF"; font.bold: true }
                                }
                                Canvas { 
                                    id: vCanvas
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    onPaint: { 
                                        var ctx = getContext("2d")
                                        ctx.strokeStyle = Qt.rgba(1,1,1,0.07)
                                        ctx.beginPath()
                                        ctx.moveTo(0, height/2)
                                        ctx.lineTo(width, height/2)
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        // Sub Trend Trace 2: Current
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            
                            ColumnLayout { 
                                anchors.fill: parent
                                anchors.margins: 6
                                
                                RowLayout { 
                                    Text { text: "CURRENT TREND"; font.pixelSize: 8; color: Colors.textMuted }
                                    Item { Layout.fillWidth: true }
                                    Text { text: "18.2 A"; font.pixelSize: 8; color: "#FF8C00"; font.bold: true }
                                }
                                Canvas { 
                                    id: cCanvas
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    onPaint: { 
                                        var ctx = getContext("2d")
                                        ctx.strokeStyle = Qt.rgba(1,1,1,0.07)
                                        ctx.beginPath()
                                        ctx.moveTo(0, height/2)
                                        ctx.lineTo(width, height/2)
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        // Sub Trend Trace 3: Power Output
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            
                            ColumnLayout { 
                                anchors.fill: parent
                                anchors.margins: 6
                                
                                RowLayout { 
                                    Text { text: "POWER TREND"; font.pixelSize: 8; color: Colors.textMuted }
                                    Item { Layout.fillWidth: true }
                                    Text { text: vehicleData.motorPower.toFixed(1) + " kW"; font.pixelSize: 8; color: "#BA55D3"; font.bold: true }
                                }
                                Canvas { 
                                    id: pCanvas
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    onPaint: { 
                                        var ctx = getContext("2d")
                                        ctx.strokeStyle = Qt.rgba(1,1,1,0.07)
                                        ctx.beginPath()
                                        ctx.moveTo(0, height/2)
                                        ctx.lineTo(width, height/2)
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================
        // ROW 2: POWER DISTRIBUTION, REGEN, & DRIVE SYSTEM STATUS
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: powertrainPage.paddingSize

            // Block A: Power Distribution Circle Summary
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 35
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: powertrainPage.paddingSize

                    Text { text: "POWER DISTRIBUTION"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10

                        Rectangle { 
                            width: 50
                            height: 50
                            radius: 25
                            color: "transparent"
                            border.color: Colors.accentCity
                            border.width: 4
                            
                            Text { 
                                text: vehicleData.motorPower.toFixed(1) + "\nkW"
                                font.pixelSize: 9
                                font.bold: true
                                color: Colors.textPrimary
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter 
                            }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text { text: "• Motor Output: " + vehicleData.motorPower.toFixed(1) + " kW"; font.pixelSize: 9; color: Colors.textPrimary }
                            Text { text: "• Auxiliary Load: 0.2 kW"; font.pixelSize: 9; color: Colors.textMuted }
                            Text { text: "• Losses: 0.1 kW"; font.pixelSize: 9; color: Colors.textMuted }
                        }
                    }
                }
            }

            // Block B: Regeneration Energy Tracking Status
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 35
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: powertrainPage.paddingSize

                    Text { text: "REGENERATION STATUS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Layout.topMargin: 2

                        RowLayout { 
                            Text { text: "Regen Level:"; font.pixelSize: 10; color: Colors.textMuted }
                            Text { text: String(vehicleData.regenLevel); font.pixelSize: 10; font.bold: true; color: Colors.accentEco } 
                        }
                        RowLayout { 
                            Text { text: "Regen State:"; font.pixelSize: 10; color: Colors.textMuted }
                            Text { text: vehicleData.regenLevel > 0 ? "ACTIVE" : "INACTIVE"; font.pixelSize: 10; font.bold: true; color: vehicleData.regenLevel > 0 ? Colors.accentEco : Colors.textMuted } 
                        }
                        RowLayout { 
                            Text { text: "Energy Recovered:"; font.pixelSize: 10; color: Colors.textMuted }
                            Text { text: "0.72 kWh"; font.pixelSize: 10; font.bold: true; color: Colors.textPrimary } 
                        }
                    }
                }
            }

            // Block C: Drive System Power Bus Alarms States
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 30
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: powertrainPage.paddingSize

                    Text { text: "DRIVE SYSTEM STATUS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Layout.topMargin: 2

                        RowLayout { 
                            Text { text: "Inverter State"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "NORMAL"; font.pixelSize: 9; color: Colors.accentEco; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "DC-DC Converter"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: "NORMAL"; font.pixelSize: 9; color: Colors.accentEco; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "BMS Status"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.lowBatteryWarning ? "WARNING" : "NORMAL"; font.pixelSize: 9; color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentEco; font.bold: true }
                        }
                        RowLayout { 
                            Text { text: "Motor Controller"; font.pixelSize: 9; color: Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.motorOverTempWarning ? "HOT" : "NORMAL"; font.pixelSize: 9; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.accentEco; font.bold: true }
                        }
                    }
                }
            }
        }
    }
}