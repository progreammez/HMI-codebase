import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: overviewPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    readonly property int cardRadius: Theme.controlRadius
    
    // Adjusted row layout constants to balance vertical real estate
    readonly property int topRowHeight: Math.round(230 * Theme.scale)
    readonly property int barRowHeight: Math.round(110 * Theme.scale) // Increased for text breathing room

    // =========================================================================
    // ROW 1: TOP ROW (SYSTEM SUMMARY [62%] + ACTIVE WARNINGS [38%])
    // =========================================================================
    Item {
        id: row1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: overviewPage.topRowHeight

        // --- SYSTEM SUMMARY CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width * 0.62 - (overviewPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: overviewPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(12 * Theme.scale)

                Text {
                    text: "SYSTEM SUMMARY"
                    color: Colors.textSecondary
                    font.family: Typography.family
                    font.pixelSize: Typography.label
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Math.round(12 * Theme.scale)

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

                            Column {
                                anchors.fill: parent
                                anchors.margins: Math.round(12 * Theme.scale)
                                spacing: Math.round(4 * Theme.scale)

                                Text { text: modelData.title; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                                Text { text: modelData.val; color: modelData.isAlert ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; wrapMode: Text.WordWrap; width: parent.width }
                                Text { text: modelData.desc; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; elide: Text.ElideRight; width: parent.width }
                            }

                            Text {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.margins: Math.round(12 * Theme.scale)
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

        // --- ACTIVE WARNINGS CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width * 0.38 - (overviewPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: overviewPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(10 * Theme.scale)

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "⚠ ACTIVE WARNINGS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    Item { Layout.fillWidth: true }
                    Text { text: root.hasWarning ? "1 ACTIVE" : "0 ACTIVE"; color: root.hasWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: "⚠  MOTOR TEMPERATURE HIGH"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.DemiBold }
                        Item { Layout.fillWidth: true }
                        Text { text: vehicleData.motorTemp + " °C"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                    }
                    RowLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: "✓  LOW BATTERY WARNING"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        Item { Layout.fillWidth: true }
                        Text { text: vehicleData.lowBatteryWarning ? "WARN" : "OK"; color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                    }
                    RowLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: "✓  COMMUNICATION FAULT"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        Item { Layout.fillWidth: true }
                        Text { text: vehicleData.communicationFault ? "FAULT" : "OK"; color: vehicleData.communicationFault ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                    }
                }
            }
        }
    }

    // =========================================================================
    // ROW 2: MIDDLE ROW (VEHICLE HEALTH - BAR)
    // =========================================================================
    Rectangle {
        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: overviewPage.gridSpacing
        anchors.left: parent.left
        anchors.right: parent.right
        height: overviewPage.barRowHeight
        color: Colors.surfaceRaised
        radius: overviewPage.cardRadius
        border.color: Colors.borderSubtle
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Math.round(12 * Theme.scale)
            spacing: Math.round(8 * Theme.scale)

            Text { 
                text: "VEHICLE HEALTH"
                color: Colors.textSecondary
                font.family: Typography.family
                font.pixelSize: Typography.label
                font.weight: Font.Bold
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
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

                            // Status color accent bar indicator
                            Rectangle {
                                width: Math.round(4 * Theme.scale)
                                Layout.fillHeight: true
                                radius: 2
                                color: modelData.ok ? Colors.success : Colors.critical
                            }

                            // Clean anchored canvas container
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                // LEFT STACK: Name and Subtitle
                                Column {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: Math.round(2 * Theme.scale)

                                    Text {
                                        text: modelData.name
                                        color: Colors.textMuted
                                        font.family: Typography.family
                                        font.pixelSize: Typography.label
                                        font.weight: Font.Bold
                                    }

                                    Text {
                                        text: "Normal"
                                        color: Colors.textMuted
                                        font.family: Typography.family
                                        font.pixelSize: Typography.label
                                    }
                                }

                                // RIGHT VALUE: High-visibility Status Callout
                                Text {
                                    anchors.right: parent.right
                                    anchors.rightMargin: Math.round(4 * Theme.scale)
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    text: modelData.ok ? "OK" : "FAIL"
                                    color: modelData.ok ? Colors.success : Colors.critical
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodySmall
                                    font.weight: Font.Bold
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // =========================================================================
    // ROW 3: LOWER ROW (QUICK STATS [54%] + SYSTEM CHECKS [46%])
    // =========================================================================
    Item {
        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: overviewPage.gridSpacing
        anchors.bottom: parent.bottom // Automatically scaled down to fill the remainder cleanly
        anchors.left: parent.left
        anchors.right: parent.right

        // --- QUICK STATS CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width * 0.54 - (overviewPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: overviewPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(8 * Theme.scale)

                Text { text: "QUICK STATS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

                GridLayout {
                    columns: 4
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    rowSpacing: Math.round(14 * Theme.scale)
                    columnSpacing: Math.round(14 * Theme.scale)

                    ColumnLayout { spacing: 0; Layout.fillHeight: true
                        Text { text: "SPEED"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: vehicleData.speed; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.displaySmall; font.weight: Font.Bold }
                        Text { text: "km/h"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 0; Layout.fillHeight: true
                        Text { text: "RPM"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: vehicleData.rpm; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.displaySmall; font.weight: Font.Bold }
                        Text { text: "RPM"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 0; Layout.fillHeight: true
                        Text { text: "SOC"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: Math.round(vehicleData.batteryPercent); color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.displaySmall; font.weight: Font.Bold }
                        Text { text: "%"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 0; Layout.fillHeight: true
                        Text { text: "RANGE"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: vehicleData.rangeKm; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.displaySmall; font.weight: Font.Bold }
                        Text { text: "km"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }

                    ColumnLayout { spacing: 1
                        Text { text: "VOLTAGE"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: "72.4"; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        Text { text: "V"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 1
                        Text { text: "CURRENT"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: "18.2"; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        Text { text: "A"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 1
                        Text { text: "POWER"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: vehicleData.motorPower.toFixed(1); color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        Text { text: "kW"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                    ColumnLayout { spacing: 1
                        Text { text: "DRIVE MODE"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                        Text { text: vehicleData.driveMode; color: Colors.textWarm; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        Text { text: vehicleData.gearState; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label }
                    }
                }
            }
        }

        // --- SYSTEM CHECKS CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width * 0.46 - (overviewPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: overviewPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(10 * Theme.scale)

                Text { text: "SYSTEM CHECKS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Math.round(6 * Theme.scale)

                    Repeater {
                        model: ["BATTERY PACK", "MOTOR SYSTEM", "CONTROLLER", "SENSORS", "BMS", "VCU"]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: Colors.borderSubtle
                            border.width: 1

                            Item {
                                anchors.fill: parent
                                anchors.margins: Math.round(8 * Theme.scale)

                                Column {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    spacing: Math.round(4 * Theme.scale)

                                    Text { text: modelData; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; elide: Text.ElideRight; width: parent.width }
                                    Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold }
                                }

                                Text { 
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    text: "All parameters\nnormal"
                                    color: Colors.textMuted
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label
                                    elide: Text.ElideRight
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}