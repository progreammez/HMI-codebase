import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: telemetryPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(14 * Theme.scale) 

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
        ListElement { label: "Charging Status";         unit: "-";     key: "chgstat" }
        ListElement { label: "Charging Power";          unit: "kW";    key: "pwr" }
        ListElement { label: "Charge Time Remaining";   unit: "min";   key: "chgtime" }
        ListElement { label: "Odometer";                unit: "km";    key: "odo" }
        ListElement { label: "Trip Distance";           unit: "km";    key: "trip" }
        ListElement { label: "Left Indicator";          unit: "-";     key: "indl" }
        ListElement { label: "Right Indicator";         unit: "-";     key: "indr" }
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
            Layout.preferredHeight: 480 
            spacing: telemetryPage.paddingSize

            // -----------------------------------------------------------------
            // LEFT PANEL: LIVE PARAMETERS + SIMULATOR SETTINGS SPLIT
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 58 
                spacing: telemetryPage.paddingSize

                // --- CARD A: LIVE PARAMETERS TABLE ---
                BaseCard {
                    id: liveParamsCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 380 
                    title: "LIVE PARAMETERS"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Math.round(6 * Theme.scale)
                        spacing: Math.round(32 * Theme.scale) 

                        // ==========================================
                        // LEFT TABLE PILLAR
                        // ==========================================
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 2

                            // Pillar Header
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(28 * Theme.scale)
                                Text { text: "  PARAMETER"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { text: "VALUE"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: "UNIT "; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: leftParamModel
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true 
                                    color: index % 2 === 0 ? "transparent" : Colors.surfaceSunken
                                    opacity: Colors.isLightMode ? 0.35 : 0.95 // Dynamic transparency calculation to combat washout on bright grounds
                                    radius: 4
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8
                                        
                                        Text { text: model.label; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "soc" || model.key === "range" || model.key === "speed" || model.key === "rpm") ? Colors.borderActive : Colors.textPrimary
                                            font.family: "Courier New" 
                                            font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(95 * Theme.scale)
                                            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                                            renderType: Text.QtRendering
                                        }
                                        Text { text: model.unit; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
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
                            spacing: 2

                            // Pillar Header
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(28 * Theme.scale)
                                Text { text: "  PARAMETER"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { text: "VALUE"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: "UNIT "; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: rightParamModel
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true 
                                    color: index % 2 === 0 ? "transparent" : Colors.surfaceSunken
                                    opacity: Colors.isLightMode ? 0.35 : 0.95
                                    radius: 4
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8
                                        
                                        Text { text: model.label; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "mtmp" || model.key === "btmp" || model.key === "ctmp" || model.key === "odo" || model.key === "trip") ? Colors.borderActive : Colors.textPrimary
                                            font.family: "Courier New"
                                            font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(95 * Theme.scale)
                                            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                                            renderType: Text.QtRendering
                                        }
                                        Text { text: model.unit; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
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
                            color: vehicleData.simulationActive ? Colors.surfaceSunken : "transparent"
                            radius: Theme.controlRadius
                            border.color: vehicleData.simulationActive ? Colors.success : Colors.borderSubtle
                            border.width: 1.5 

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Math.round(6 * Theme.scale)
                                anchors.rightMargin: Math.round(6 * Theme.scale)
                                anchors.topMargin: Math.round(8 * Theme.scale)
                                anchors.bottomMargin: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { text: "SIMULATION ENGINE"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.max(9, Typography.label * 0.9); font.weight: Font.Bold; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                                Text { text: vehicleData.simulationActive ? "RUNNING" : "STOPPED"; color: vehicleData.simulationActive ? Colors.success : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                            }
                            MouseArea { anchors.fill: parent; onClicked: vehicleData.simulationActive = !vehicleData.simulationActive }
                        }

                        // Toggle 2: Communication Network Fault
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: vehicleData.communicationFault ? Colors.surfaceSunken : "transparent"
                            radius: Theme.controlRadius
                            border.color: vehicleData.communicationFault ? Colors.critical : Colors.borderSubtle
                            border.width: 1.5

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Math.round(6 * Theme.scale)
                                anchors.rightMargin: Math.round(6 * Theme.scale)
                                anchors.topMargin: Math.round(8 * Theme.scale)
                                anchors.bottomMargin: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { 
                                    text: "COMMUNICATION FAULT"
                                    color: Colors.textSecondary
                                    font.family: Typography.family
                                    font.pixelSize: Math.max(9, Typography.label * 0.9)
                                    font.weight: Font.Bold
                                    Layout.fillWidth: true 
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight 
                                }
                                
                                Text { 
                                    text: vehicleData.communicationFault ? "FAULT ACTIVE" : "NOMINAL"
                                    color: vehicleData.communicationFault ? Colors.critical : Colors.success
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium
                                    font.weight: Font.Bold
                                    Layout.alignment: Qt.AlignHCenter 
                                }
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
                Layout.preferredWidth: 42
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
                        rowSpacing: Math.round(10 * Theme.scale)
                        columnSpacing: Math.round(10 * Theme.scale)

                        Repeater {
                            model: [
                                { name: "CORE DATA", count: "10 Params", icon: "⏰" },
                                { name: "POWERTRAIN", count: "6 Params", icon: "⚙" },
                                { name: "THERMAL", count: "3 Params", icon: "🌡" },
                                { name: "CHARGING", count: "3 Params", icon: "🔋" },
                                { name: "DRIVE INFO", count: "2 Params", icon: "🛞" },
                                { name: "TRIP INFO", count: "2 Params", icon: "🗺" },
                                { name: "INDICATORS", count: "5 Params", icon: "💡" },
                                { name: "WARNINGS", count: "5 Params", icon: "⚠" }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Colors.surfaceSunken
                                radius: Theme.controlRadius
                                border.color: modelData.name === "WARNINGS" && vehicleData.communicationFault ? Colors.critical : Colors.borderSubtle
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Math.round(8 * Theme.scale)
                                    spacing: Math.round(8 * Theme.scale)

                                    Text { text: modelData.icon; font.pixelSize: Typography.titleMedium; Layout.alignment: Qt.AlignVCenter }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter 
                                        spacing: 2
                                        Text { text: modelData.name; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.count; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                        Item { Layout.fillWidth: true; Layout.fillHeight: true } 
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
                        spacing: Math.round(6 * Theme.scale)

                        Repeater {
                            model: [
                                { title: "TOTAL", val: "36", col: Colors.textPrimary },
                                { title: "UPDATING", val: "100%", col: Colors.success },
                                { title: "NO CHANGE", val: "0%", col: Colors.warning },
                                { title: "INVALID", val: "0%", col: Colors.critical },
                                { title: "INTERVAL", val: "20 ms", col: Colors.borderActive }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumWidth: Math.round(55 * Theme.scale) 
                                color: Colors.surfaceSunken
                                radius: Theme.controlRadius
                                border.color: Colors.borderSubtle
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.topMargin: Math.round(4 * Theme.scale)
                                    anchors.bottomMargin: Math.round(4 * Theme.scale)
                                    anchors.leftMargin: Math.round(2 * Theme.scale)
                                    anchors.rightMargin: Math.round(2 * Theme.scale)
                                    spacing: 1

                                    Text { 
                                        text: modelData.title
                                        color: Colors.textSecondary
                                        font.family: Typography.family
                                        font.pixelSize: Math.max(9, Typography.label * 0.8)
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        horizontalAlignment: Text.AlignHCenter 
                                    }
                                    
                                    Text { 
                                        text: modelData.val
                                        color: modelData.col
                                        font.family: "Courier New"
                                        font.pixelSize: Math.max(11, Typography.bodyMedium * 0.9)
                                        font.weight: Font.Bold
                                        elide: Text.ElideNone 
                                        Layout.fillWidth: true
                                        horizontalAlignment: Text.AlignHCenter 
                                    }
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
                        columnSpacing: Math.round(24 * Theme.scale)

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Telemetry Rate"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true }
                            Text { text: "50 Hz"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Last Frame"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true }
                            Text { text: "14:32:11.020"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Frame Interval"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true }
                            Text { text: "20 ms"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Uptime"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true }
                            Text { text: "02:14:37"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold }
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
            Layout.preferredHeight: Math.round(85 * Theme.scale) 
            title: "RAW TELEMETRY FRAME (Latest)"

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 12
                
                text: "SPD=" + vehicleData.speed + "  RPM=" + vehicleData.rpm + "  SOC=" + vehicleData.batteryPercent + "  RNG=" + vehicleData.rangeKm + "  VBAT=72.4  IBAT=18.2  PMOT=" + vehicleData.motorPower.toFixed(1) + "  REGEN=" + vehicleData.regenLevel + "  MTMP=" + vehicleData.motorTemp + "  BTMP=" + vehicleData.batteryTemp + "  CTMP=" + vehicleData.controllerTemp + "  GEAR=" + vehicleData.gearState + "  MODE=" + vehicleData.driveMode + "  COMMFLT=" + (vehicleData.communicationFault ? "1" : "0")
                color: vehicleData.communicationFault ? Colors.critical : (Colors.isLightMode ? "#1A6E13" : "#00FF66") 
                font.family: "Courier New" 
                font.pixelSize: Typography.bodyMedium
                font.bold: true
                elide: Text.ElideRight
                renderType: Text.QtRendering
            }
        }
    }
}