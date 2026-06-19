import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: telemetryPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(12 * Theme.scale)

    // =====================================================
    // TELEMETRY VALUE BINDINGS CONTROLLER MODEL
    // =====================================================
    ListModel {
        id: leftParamModel
        ListElement { label: "Speed";           unit: "km/h";  key: "speed" }
        ListElement { label: "RPM";             unit: "RPM";   key: "rpm" }
        ListElement { label: "Battery SOC";     unit: "%";     key: "soc" }
        ListElement { label: "Range";           unit: "km";    key: "range" }
        ListElement { label: "Battery Voltage"; unit: "V";     key: "vbat" }
        ListElement { label: "Battery Current"; unit: "A";     key: "ibat" }
        ListElement { label: "Motor Power";     unit: "kW";    key: "pmot" }
        ListElement { label: "Regen Level";     unit: "Level"; key: "regen" }
        ListElement { label: "Drive Mode";      unit: "-";     key: "mode" }
        ListElement { label: "Gear State";      unit: "-";     key: "gear" }
    }

    ListModel {
        id: rightParamModel
        ListElement { label: "Motor Temp";              unit: "°C";    key: "mtmp" }
        ListElement { label: "Battery Temp";            unit: "°C";    key: "btmp" }
        ListElement { label: "Controller Temp";         unit: "°C";    key: "ctmp" }
        ListElement { label: "Charging Status";       unit: "-";     key: "chgstat" }
        ListElement { label: "Charging Power";        unit: "kW";    key: "pwr" }
        ListElement { label: "Charge Time Remaining"; unit: "min";   key: "chgtime" }
        ListElement { label: "Odometer";              unit: "km";    key: "odo" }
        ListElement { label: "Trip Distance";         unit: "km";    key: "trip" }
        ListElement { label: "Left Indicator";        unit: "-";     key: "indl" }
        ListElement { label: "Right Indicator";       unit: "-";     key: "indr" }
    }

    function resolveValue(key) {
        if (key === "speed")    return vehicleData.speed
        if (key === "rpm")      return vehicleData.rpm
        if (key === "soc")      return vehicleData.batteryPercent
        if (key === "range")    return vehicleData.rangeKm
        if (key === "vbat")     return "72.4"
        if (key === "ibat")     return "18.2" 
        if (key === "pmot")     return vehicleData.motorPower.toFixed(1)
        if (key === "regen")    return vehicleData.regenLevel
        if (key === "mode")     return vehicleData.driveMode
        if (key === "gear")     return vehicleData.gearState
        if (key === "mtmp")     return vehicleData.motorTemp
        if (key === "btmp")     return vehicleData.batteryTemp
        if (key === "ctmp")     return vehicleData.controllerTemp
        if (key === "chgstat")  return "OFF"
        if (key === "pwr")      return "0.0"
        if (key === "chgtime")  return "0"
        if (key === "odo")      return "00124.8"
        if (key === "trip")     return "12.6"
        if (key === "indl")     return vehicleData.leftIndicator ? "ON" : "OFF"
        if (key === "indr")     return vehicleData.rightIndicator ? "ON" : "OFF"
        return "-"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: telemetryPage.paddingSize
        spacing: telemetryPage.paddingSize

        // --- UPPER SECTION: LIVE PARAMETERS vs GROUPS/METRICS ---
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 480 // Master height weight ratio for upper layout
            spacing: telemetryPage.paddingSize

            // -----------------------------------------------------------------
            // LEFT PANEL: LIVE PARAMETERS + SIMULATOR SETTINGS SPLIT
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 56
                spacing: telemetryPage.paddingSize

                // --- CARD A: LIVE PARAMETERS TABLE ---
                BaseCard {
                    id: liveParamsCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 380 // Vertical weight ratio
                    title: "LIVE PARAMETERS"

                    RowLayout {
                        anchors.fill: parent
                        spacing: Math.round(40 * Theme.scale) // Slight increase for mid-screen split breathing room

                        // ==========================================
                        // LEFT TABLE PILLAR
                        // ==========================================
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 0

                            // Pillar Header
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(32 * Theme.scale)
                                spacing: 0
                                Text { text: "PARAMETER"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { text: "VALUE"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.preferredWidth: Math.round(90 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: "UNIT"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.preferredWidth: Math.round(70 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: leftParamModel
                                delegate: Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true // Forces rows to stretch and fill the empty vertical space evenly
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.bottomMargin: Math.round(2 * Theme.scale) // Tiny gap above the line
                                        spacing: 0
                                        
                                        Text { text: model.label; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "soc" || model.key === "range" || model.key === "speed" || model.key === "rpm") ? Colors.borderActive : Colors.textPrimary
                                            font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(90 * Theme.scale)
                                            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                                            renderType: Text.QtRendering
                                        }
                                        Text { text: model.unit; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.preferredWidth: Math.round(70 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
                                    }

                                    // Subtle Grid Line Divider
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Colors.borderSubtle
                                        opacity: 0.15 // Soft, non-distracting track line
                                    }
                                }
                            }
                        }

                        // ==========================================
                        // RIGHT TABLE PILLAR
                        // ==========================================
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 0

                            // Pillar Header
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(32 * Theme.scale)
                                spacing: 0
                                Text { text: "PARAMETER"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { text: "VALUE"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.preferredWidth: Math.round(90 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: "UNIT"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.preferredWidth: Math.round(70 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: rightParamModel
                                delegate: Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true // Forces rows to stretch and fill the empty vertical space evenly
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.bottomMargin: Math.round(2 * Theme.scale)
                                        spacing: 0
                                        
                                        Text { text: model.label; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "mtmp" || model.key === "btmp" || model.key === "ctmp" || model.key === "odo" || model.key === "trip") ? Colors.borderActive : Colors.textPrimary
                                            font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(90 * Theme.scale)
                                            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                                            renderType: Text.QtRendering
                                        }
                                        Text { text: model.unit; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.preferredWidth: Math.round(70 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
                                    }

                                    // Subtle Grid Line Divider
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Colors.borderSubtle
                                        opacity: 0.15
                                    }
                                }
                            }
                        }
                    }
                }

                // --- CARD B: SIMULATOR SETTINGS ---
                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true 
                    Layout.preferredHeight: 100
                    title: "SIMULATOR SETTINGS"

                    RowLayout {
                        anchors.fill: parent
                        spacing: Math.round(16 * Theme.scale)

                        // Toggle 1: Simulation Engine
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: vehicleData.simulationActive ? Colors.borderActive : Colors.borderSubtle
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { text: "SIMULATION ENGINE"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.simulationActive ? "RUNNING" : "STOPPED"; color: vehicleData.simulationActive ? Colors.success : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                            }

                            MouseArea { anchors.fill: parent; onClicked: vehicleData.simulationActive = !vehicleData.simulationActive }
                        }

                        // Toggle 2: Communication Network Fault
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: vehicleData.communicationFault ? Colors.critical : Colors.borderSubtle
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { text: "COMMUNICATION FAULT"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "FAULT ACTIVE" : "NOMINAL"; color: vehicleData.communicationFault ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                            }

                            MouseArea { anchors.fill: parent; onClicked: vehicleData.communicationFault = !vehicleData.communicationFault }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // RIGHT PANEL: GROUPS, STATISTICS, & UPDATE INFORMATION
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 44
                spacing: telemetryPage.paddingSize

                // --- 1. PARAMETER GROUPS GRID ---
                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 260
                    title: "PARAMETER GROUPS"

                    GridLayout {
                        anchors.fill: parent
                        columns: 3
                        rowSpacing: Math.round(8 * Theme.scale)
                        columnSpacing: Math.round(8 * Theme.scale)

                        Repeater {
                            model: [
                                { name: "CORE DATA", count: "10 Parameters", icon: "⏰" },
                                { name: "POWERTRAIN", count: "6 Parameters", icon: "⚙" },
                                { name: "THERMAL", count: "3 Parameters", icon: "🌡" },
                                { name: "CHARGING", count: "3 Parameters", icon: "🔋" },
                                { name: "DRIVE INFO", count: "2 Parameters", icon: "🛞" },
                                { name: "TRIP INFO", count: "2 Parameters", icon: "🗺" },
                                { name: "INDICATORS", count: "5 Parameters", icon: "💡" },
                                { name: "WARNINGS", count: "5 Parameters", icon: "⚠" }
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
                                    anchors.margins: Math.round(6 * Theme.scale)
                                    spacing: Math.round(8 * Theme.scale)

                                    Text { text: modelData.icon; font.pixelSize: Typography.bodyLarge; color: Colors.textPrimary; Layout.alignment: Qt.AlignVCenter }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter 
                                        spacing: 1
                                        Text { text: modelData.name; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.count; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                        Item { Layout.fillWidth: true; Layout.fillHeight: true } // Balanced 9th cell grid filler
                    }
                }

                // --- 2. PARAMETER STATISTICS ---
                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 90
                    title: "PARAMETER STATISTICS"

                    RowLayout {
                        anchors.fill: parent
                        spacing: Math.round(4 * Theme.scale)

                        Repeater {
                            model: [
                                { title: "TOTAL PARAMETERS", val: "36", col: Colors.textPrimary },
                                { title: "UPDATING", val: "36 (100%)", col: Colors.success },
                                { title: "NO CHANGE", val: "0 (0%)", col: Colors.warning },
                                { title: "INVALID", val: "0 (0%)", col: Colors.critical },
                                { title: "LAST UPDATE", val: "20 ms", col: Colors.borderActive }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.preferredWidth: 0 // Assures strict equal horizontal splitting
                                color: Colors.surfaceSunken
                                radius: Theme.controlRadius
                                border.color: Colors.borderSubtle
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Math.round(8 * Theme.scale)
                                    spacing: 2

                                    Text { text: modelData.title; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; elide: Text.ElideRight; Layout.fillWidth: true }
                                    Text { text: modelData.val; color: modelData.col; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }

                // --- 3. UPDATE INFORMATION ---
                BaseCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 90
                    title: "UPDATE INFORMATION"

                    GridLayout {
                        anchors.fill: parent
                        columns: 2
                        rowSpacing: Math.round(4 * Theme.scale)
                        columnSpacing: Math.round(16 * Theme.scale)

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Telemetry Rate"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true }
                            Text { text: "50 Hz"; color: Colors.borderActive; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Last Frame Time"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true }
                            Text { text: "14:32:11.020"; color: Colors.borderActive; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Frame Interval"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true }
                            Text { text: "20 ms"; color: Colors.borderActive; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Uptime"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true }
                            Text { text: "02:14:37"; color: Colors.borderActive; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        }
                    }
                }
            }
        }

        // -----------------------------------------------------------------
        // BOTTOM TRACK: RAW TELEMETRY FRAME LOGGER
        // -----------------------------------------------------------------
        BaseCard {
            Layout.fillWidth: true
            // Increased from 58 to 85 to accommodate BaseCard headers & padding
            Layout.preferredHeight: Math.round(85 * Theme.scale) 
            title: "RAW TELEMETRY FRAME (Latest)"

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter // Centers cleanly within the slot
                
                text: "SPD=" + vehicleData.speed + "  RPM=" + vehicleData.rpm + "  SOC=" + vehicleData.batteryPercent + "  RNG=" + vehicleData.rangeKm + "  VBAT=72.4  IBAT=18.2  PMOT=" + vehicleData.motorPower.toFixed(1) + "  REGEN=" + vehicleData.regenLevel + "  MTMP=" + vehicleData.motorTemp + "  BTMP=" + vehicleData.batteryTemp + "  CTMP=" + vehicleData.controllerTemp + "  GEAR=" + vehicleData.gearState + "  MODE=" + vehicleData.driveMode + "  COMMFLT=" + (vehicleData.communicationFault ? "1" : "0")
                color: vehicleData.communicationFault ? Colors.critical : "#00FF66" 
                font.family: "Courier New" 
                font.pixelSize: Typography.label
                font.bold: true
                elide: Text.ElideRight
                renderType: Text.QtRendering
            }
        }
    }
}