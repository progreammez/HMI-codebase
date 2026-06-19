import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: overviewPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: overviewPage.gridSpacing
        spacing: overviewPage.gridSpacing

        // =========================================================================
        // ROW 1: TOP ROW (SYSTEM SUMMARY [62%] + ACTIVE WARNINGS [38%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 230 // Acts as a vertical weight ratio now
            spacing: overviewPage.gridSpacing

            // SYSTEM SUMMARY CARD
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 62 
                title: "SYSTEM SUMMARY"

                RowLayout {
                    anchors.fill: parent
                    spacing: overviewPage.gridSpacing

                    Repeater {
                        model: [
                            { title: "CONNECTION", val: vehicleData.communicationFault ? "DISCONNECTED" : "UART CONNECTED", desc: "/dev/ttyUSB0", sub: vehicleData.communicationFault ? "• OFFLINE" : "• LIVE", isAlert: vehicleData.communicationFault },
                            { title: "PARSER STATUS", val: "ACTIVE", desc: "Protocol: EV_CAN_V1", sub: "• OK", isAlert: false },
                            { title: "TELEMETRY RATE", val: vehicleData.communicationFault ? "0 Hz" : "50 Hz", desc: "20 ms / frame", sub: "• STABLE", isAlert: vehicleData.communicationFault },
                            { title: "LOGGER STATUS", val: "RECORDING", desc: "File: log_2024_05_28.csv", sub: "• ON", isAlert: false }
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: Colors.borderSubtle
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(12 * Theme.scale)
                                spacing: Math.round(2 * Theme.scale)

                                Text { text: modelData.title; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                                Text { text: modelData.val; color: modelData.isAlert ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                                Text { text: modelData.desc; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; elide: Text.ElideRight; Layout.fillWidth: true }
                                
                                Item { Layout.fillHeight: true } // Keeps layout tight by pushing status flag down

                                Text {
                                    text: modelData.sub
                                    color: modelData.isAlert ? Colors.critical : Colors.success
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label
                                    font.weight: Font.Bold
                                }
                            }
                        }
                    }
                }
            }

            // ACTIVE WARNINGS CARD
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 38
                title: "⚠ ACTIVE WARNINGS"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(6 * Theme.scale)

                    RowLayout {
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: root.hasWarning ? "1 ACTIVE" : "0 ACTIVE"
                            color: root.hasWarning ? Colors.critical : Colors.success
                            font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold 
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Math.round(4 * Theme.scale)

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "⚠  MOTOR TEMPERATURE HIGH"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.DemiBold }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.motorTemp + " °C"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "✓  LOW BATTERY WARNING"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.lowBatteryWarning ? "WARN" : "OK"; color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "✓  COMMUNICATION FAULT"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.communicationFault ? "FAULT" : "OK"; color: vehicleData.communicationFault ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                        }
                        
                        Item { Layout.fillHeight: true } // Prevents list items from awkwardly stretching vertically
                    }
                }
            }
        }

        // =========================================================================
        // ROW 2: MIDDLE ROW (VEHICLE HEALTH - BAR)
        // =========================================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100 // Visual weight allocation
            title: "VEHICLE HEALTH"

            RowLayout {
                anchors.fill: parent
                spacing: Math.round(10 * Theme.scale)

                Repeater {
                    model: [
                        { name: "BATTERY", ok: !vehicleData.batteryOverTempWarning },
                        { name: "MOTOR", ok: !vehicleData.motorOverTempWarning },
                        { name: "CONTROLLER", ok: true },
                        { name: "COMMUNICATION", ok: !vehicleData.communicationFault },
                        { name: "THERMAL", ok: !(vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning) }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.surfaceSunken
                        radius: Theme.controlRadius
                        border.color: Colors.borderSubtle
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Math.round(10 * Theme.scale)
                            spacing: Math.round(12 * Theme.scale)

                            Rectangle {
                                width: Math.round(4 * Theme.scale)
                                Layout.fillHeight: true
                                radius: 2
                                color: modelData.ok ? Colors.success : Colors.critical
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: Math.round(2 * Theme.scale)

                                Text { text: modelData.name; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                                Text { text: "Normal"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: modelData.ok ? "OK" : "FAIL"
                                color: modelData.ok ? Colors.success : Colors.critical
                                font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                            }
                        }
                    }
                }
            }
        }

        // =========================================================================
        // ROW 3: LOWER ROW (QUICK STATS [54%] + SYSTEM CHECKS [46%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true 
            Layout.preferredHeight: 160 // Allocated space ratio to allow text grids breathing room
            spacing: overviewPage.gridSpacing

            // QUICK STATS CARD
            // QUICK STATS CARD
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 54
                title: "QUICK STATS"

                GridLayout {
                    anchors.fill: parent
                    columns: 4
                    rowSpacing: Math.round(8 * Theme.scale)
                    columnSpacing: Math.round(14 * Theme.scale)

                    Repeater {
                        model: [
                            { label: "SPEED", val: vehicleData.speed, unit: "km/h", highlight: true },
                            { label: "RPM", val: vehicleData.rpm, unit: "RPM", highlight: true },
                            { label: "SOC", val: Math.round(vehicleData.batteryPercent), unit: "%", highlight: true },
                            { label: "RANGE", val: vehicleData.rangeKm, unit: "km", highlight: true },
                            { label: "VOLTAGE", val: "72.4", unit: "V", highlight: false },
                            { label: "CURRENT", val: "18.2", unit: "A", highlight: false },
                            { label: "POWER", val: vehicleData.motorPower.toFixed(1), unit: "kW", highlight: false },
                            { label: "DRIVE MODE", val: vehicleData.driveMode, unit: vehicleData.gearState, highlight: false }
                        ]
                        
                        delegate: ColumnLayout {
                            spacing: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            // CRUCIAL: Forcing preferredWidth to 0 locks the grid columns 
                            // to perfectly equal widths, preventing dynamic layout twitching.
                            Layout.preferredWidth: 0 

                            Text { 
                                text: modelData.label
                                color: Colors.textMuted
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                Layout.fillWidth: true
                            }
                            Text { 
                                text: modelData.val
                                color: Colors.textWarm
                                font.family: Typography.family
                                font.pixelSize: modelData.highlight ? Typography.displaySmall : Typography.bodyMedium
                                font.weight: Font.Bold 
                                Layout.fillWidth: true
                                
                            
                                renderType: Text.QtRendering 
                            }
                            Text { 
                                text: modelData.unit
                                color: Colors.textMuted
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }

            // SYSTEM CHECKS CARD
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 46
                title: "SYSTEM CHECKS"

                GridLayout {
                    anchors.fill: parent
                    columns: 3 
                    rowSpacing: Math.round(6 * Theme.scale)
                    columnSpacing: Math.round(6 * Theme.scale)

                    Repeater {
                        model: ["BATTERY PACK", "MOTOR SYSTEM", "CONTROLLER", "SENSORS", "BMS", "VCU"]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: Colors.borderSubtle
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(8 * Theme.scale)
                                spacing: 0

                                Text { text: modelData; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                                
                                Item { Layout.fillHeight: true } 

                                Text { 
                                    text: "All parameters normal"
                                    color: Colors.textMuted
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label
                                    elide: Text.ElideRight
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}