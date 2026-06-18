import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: thermalPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(10 * Theme.scale)

    // Component color references extracted directly from your design layout
    readonly property color motorColor: "#00BFFF"
    readonly property color batteryColor: "#FF8C00"
    readonly property color controllerColor: "#BA55D3"

    ColumnLayout {
        anchors.fill: parent
        spacing: thermalPage.paddingSize

        // =====================================================
        // ROW 1: CURRENT TEMPERATURES & LIVE TREND GRAPH
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(130 * Theme.scale)
            spacing: thermalPage.paddingSize

            // Current Temps Progress Blocks Panel
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 50
                color: Colors.surfaceRaised
                radius: thermalPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: thermalPage.paddingSize
                    
                    Text { 
                        text: "CURRENT TEMPERATURES"
                        color: Colors.textMuted
                        font.pixelSize: Typography.label
                        font.weight: Font.Bold 
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Math.round(10 * Theme.scale)

                        // Motor Temp Block
                        ColumnLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "MOTOR TEMP"
                                color: thermalPage.motorColor
                                font.pixelSize: 9
                                font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Text { 
                                text: vehicleData.motorTemp + " °C"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyMedium
                                font.weight: Font.Bold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Rectangle { 
                                Layout.fillWidth: true
                                height: 4
                                color: Colors.surfaceBase
                                radius: 2
                                Rectangle { 
                                    width: Math.min(parent.width, (vehicleData.motorTemp / 120) * parent.width)
                                    height: parent.height
                                    color: thermalPage.motorColor
                                    radius: 2 
                                }
                            }
                        }

                        // Battery Temp Block
                        ColumnLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "BATTERY TEMP"
                                color: thermalPage.batteryColor
                                font.pixelSize: 9
                                font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Text { 
                                text: vehicleData.batteryTemp + " °C"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyMedium
                                font.weight: Font.Bold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Rectangle { 
                                Layout.fillWidth: true
                                height: 4
                                color: Colors.surfaceBase
                                radius: 2
                                Rectangle { 
                                    width: Math.min(parent.width, (vehicleData.batteryTemp / 60) * parent.width)
                                    height: parent.height
                                    color: thermalPage.batteryColor
                                    radius: 2 
                                }
                            }
                        }

                        // Controller Temp Block
                        ColumnLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "CONTROLLER TEMP"
                                color: thermalPage.controllerColor
                                font.pixelSize: 9
                                font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Text { 
                                text: vehicleData.controllerTemp + " °C"
                                color: Colors.textPrimary
                                font.pixelSize: Typography.bodyMedium
                                font.weight: Font.Bold
                                Layout.alignment: Qt.AlignHCenter 
                            }
                            Rectangle { 
                                Layout.fillWidth: true
                                height: 4
                                color: Colors.surfaceBase
                                radius: 2
                                Rectangle { 
                                    width: Math.min(parent.width, (vehicleData.controllerTemp / 100) * parent.width)
                                    height: parent.height
                                    color: thermalPage.controllerColor
                                    radius: 2 
                                }
                            }
                        }
                    }
                }
            }

            // Temperature Trends Live Canvas Graph Panel
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 50
                color: Colors.surfaceRaised
                radius: thermalPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: thermalPage.paddingSize

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "TEMPERATURE TRENDS (LIVE)"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        
                        Row { 
                            spacing: 8
                            Row { 
                                spacing: 4
                                Rectangle { width: 8; height: 8; color: thermalPage.motorColor; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "Motor"; color: Colors.textMuted; font.pixelSize: 9 } 
                            }
                            Row { 
                                spacing: 4
                                Rectangle { width: 8; height: 8; color: thermalPage.batteryColor; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "Battery"; color: Colors.textMuted; font.pixelSize: 9 } 
                            }
                            Row { 
                                spacing: 4
                                Rectangle { width: 8; height: 8; color: thermalPage.controllerColor; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "Controller"; color: Colors.textMuted; font.pixelSize: 9 } 
                            }
                        }
                    }

                    Canvas {
                        id: trendCanvas
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = Colors.borderSubtle
                            ctx.lineWidth = 1
                            
                            for (var i = 1; i < 4; i++) {
                                var y = (height / 4) * i
                                ctx.beginPath()
                                ctx.moveTo(0, y)
                                ctx.lineTo(width, y)
                                ctx.stroke()
                            }
                        }
                    }
                }
            }
        }

        // =====================================================
        // ROW 2: THERMAL STATUS, COOLING SYSTEM & WARNINGS
        // =====================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(95 * Theme.scale)
            spacing: thermalPage.paddingSize

            // Sub Card Left: Thermal Status States
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: thermalPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: thermalPage.paddingSize
                    Text { text: "THERMAL STATUS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        spacing: 12
                        
                        ColumnLayout { 
                            Text { text: "MOTOR"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: vehicleData.motorOverTempWarning ? "HOT" : "NORMAL"
                                color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.accentEco
                                font.weight: Font.Bold 
                            } 
                        }
                        
                        ColumnLayout { 
                            Text { text: "BATTERY"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: vehicleData.batteryOverTempWarning ? "HOT" : "NORMAL"
                                color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.accentEco
                                font.weight: Font.Bold 
                            } 
                        }
                        
                        ColumnLayout { 
                            Text { text: "CONTROLLER"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: "NORMAL"
                                color: Colors.accentEco
                                font.weight: Font.Bold 
                            } 
                        }
                    }
                }
            }

            // Sub Card Middle: Cooling System Actuators 
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: thermalPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: thermalPage.paddingSize
                    Text { text: "COOLING SYSTEM"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        
                        ColumnLayout { 
                            Text { text: "COOLANT TEMP"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: "38 °C"
                                color: Colors.textPrimary
                                font.weight: Font.Bold 
                            } 
                        }
                        
                        ColumnLayout { 
                            Text { text: "COOLANT FLOW"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: "12.4 L/min"
                                color: Colors.accentCity
                                font.weight: Font.Bold 
                            } 
                        }
                        
                        ColumnLayout { 
                            Text { text: "FAN SPEED"; color: Colors.textMuted; font.pixelSize: 9 }
                            Text { 
                                text: vehicleData.motorOverTempWarning ? "100 %" : "68 %"
                                color: Colors.textPrimary
                                font.weight: Font.Bold 
                            } 
                        }
                    }
                }
            }

            // Sub Card Right: Local Diagnostic Alarms Status
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: thermalPage.cardRadius
                border.color: Colors.borderSubtle

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: thermalPage.paddingSize
                    Text { text: "THERMAL WARNINGS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    ColumnLayout {
                        spacing: 2
                        Layout.topMargin: 2
                        
                        RowLayout { 
                            Text { text: "• Motor Over Temp Alarm"; font.pixelSize: 9; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.motorOverTempWarning ? "TRIPPED" : "OK"; font.pixelSize: 9; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.accentEco } 
                        }
                        RowLayout { 
                            Text { text: "• Battery Over Temp Alarm"; font.pixelSize: 9; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.textMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.batteryOverTempWarning ? "TRIPPED" : "OK"; font.pixelSize: 9; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.accentEco } 
                        }
                    }
                }
            }
        }

        // =====================================================
        // ROW 3: TEMPERATURE HISTORY GRAPH FOOTER TRACK
        // =====================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Math.round(110 * Theme.scale)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: thermalPage.paddingSize

                Text { text: "TEMPERATURE HISTORY (10 min lookback)"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 16

                    Rectangle { 
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: 4
                        border.color: Colors.borderSubtle
                        Text { text: "Motor Historical Log Timeline"; font.pixelSize: 9; color: thermalPage.motorColor; anchors.centerIn: parent }
                    }
                    Rectangle { 
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceBase
                        radius: 4
                        border.color: Colors.borderSubtle
                        Text { text: "Battery Historical Log Timeline"; font.pixelSize: 9; color: thermalPage.batteryColor; anchors.centerIn: parent }
                    }
                }
            }
        }
    }
}