import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import EvHmi

Item {
    id: diagnosticsCoreGrid
    anchors.fill: parent

    property string batteryHealthStatus: {
        if (vehicleData.communicationFault)
            return "UNKNOWN"

        if (vehicleData.batteryOverTempWarning)
            return "OVERHEATING"

        if (vehicleData.lowBatteryWarning)
            return "LOW BATTERY"

        return "OK"
    }

    property string motorHealthStatus: {
        if (vehicleData.communicationFault)
            return "UNKNOWN"

        if (vehicleData.motorOverTempWarning)
            return "OVERHEATING"

        return "OK"
    }

    property string controllerHealthStatus: {
        return vehicleData.communicationFault
            ? "UNKNOWN"
            : "OK"
    }

    property string commsHealthStatus: {
        return vehicleData.communicationFault
            ? "COMMUNICATION FAULT"
            : "OK"
    }

    property string overallHealthStatus: {
        if (vehicleData.communicationFault)
            return "CRITICAL"

        if (vehicleData.batteryOverTempWarning)
            return "CRITICAL"

        if (vehicleData.motorOverTempWarning)
            return "WARNING"

        if (vehicleData.lowBatteryWarning)
            return "WARNING"

        if (vehicleData.lowRangeWarning)
            return "WARNING"

        return "HEALTHY"
    }

    property int healthScore: {
        var score = 100

        if (vehicleData.lowBatteryWarning)
            score -= 10

        if (vehicleData.lowRangeWarning)
            score -= 10

        if (vehicleData.motorOverTempWarning)
            score -= 20

        if (vehicleData.batteryOverTempWarning)
            score -= 30

        if (vehicleData.communicationFault)
            score -= 50

        return Math.max(0, score)
    }

    // =========================================================================
    // 🛠️ REUSABLE DASHBOARD CARD COMPONENT WITH SPEC RADII & PADDING
    // =========================================================================
    component DashboardCard : Rectangle {
        property string title: ""
        property color titleColor: Colors.textSecondary
        color: Colors.surfaceBase 
        border.color: Colors.borderSubtle 
        border.width: 1
        radius: Theme.cardRadius 

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.cardPadding 
            spacing: Math.round(8 * Theme.scale)
            
            Text {
                text: parent.parent.title.toUpperCase()
                font.family: Typography.family 
                font.pixelSize: Typography.label 
                font.weight: Font.Bold
                color: parent.parent.titleColor
                Layout.fillWidth: true
            }

            Item {
                id: contentContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        default property alias cardContent: contentContainer.data
    }

    // =========================================================================
    // 🕸️ PRIMARY VIEWPORT MONITORING GRID (MIDDLE ROW SECTION)
    // =========================================================================
    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin 
        spacing: Theme.sectionGap 

        // =====================================================================
        // LEFT COLUMN MODULE AREA (40% Dynamic Width Allocation Space)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.40
            Layout.preferredHeight: Math.round(440 * Theme.scale) 
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            // 🌟 UPGRADED CARD A: VEHICLE OVERVIEW WITH VEHICLE CHASSIS OUTLINE & SEGMENTED COMPONENT MATRIX
            DashboardCard {
                title: vehicleData.communicationFault ? "Vehicle Overview  • Unavailable" : "Vehicle Overview"
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Item {
                    anchors.fill: parent
                    
                    // =========================================================
                    // 🏎️ AUTOMOTIVE CHASSIS OUTLINE FRAME REPRESENTATION
                    // =========================================================
                    Item {
                        id: chassisFrame
                        anchors.centerIn: parent
                        width: Math.round(146 * Theme.scale)
                        height: Math.round(264 * Theme.scale)

                        // Main Cabin Body Taper Curve Layout Shell
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: Colors.borderSubtle
                            border.width: 1.5
                            topLeftRadius: 42
                            topRightRadius: 42
                            bottomLeftRadius: 28
                            bottomRightRadius: 28

                            // Rear bumper / aerodynamic stylized finish line
                            Rectangle {
                                width: parent.width * 0.65
                                height: 2
                                color: Colors.borderSubtle
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // Label indicators mapping outside the front hood and trunk bounds
                        Text { 
                            text: vehicleData.communicationFault ? "CONNECTION LOST" : "FRONT"
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: Typography.family
                            font.pixelSize: Typography.label
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.2
                            color: Colors.textMuted 
                        }
                        
                        Text { 
                            text: vehicleData.communicationFault ? "" : "REAR"
                            anchors.top: parent.bottom
                            anchors.topMargin: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: Typography.family
                            font.pixelSize: Typography.label
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.2
                            color: Colors.textMuted 
                        }

                        // Symmetrical Wheel Sub-assembly Blueprint
                        component ChassisWheel : Item {
                            width: Math.round(16 * Theme.scale)
                            height: Math.round(44 * Theme.scale)
                            
                            Rectangle {
                                anchors.fill: parent
                                color: Colors.surfaceSunken
                                border.color: Colors.borderSubtle
                                border.width: 1.5
                                radius: 5
                            }
                            Rectangle {
                                width: parent.width - 6
                                height: parent.height * 0.65
                                anchors.centerIn: parent
                                color: "transparent"
                                border.color: Colors.textMuted
                                border.width: 1
                                opacity: 0.35
                                radius: 2
                            }
                        }

                        // Wheel location tracking aligned naturally inside chassis well bounds
                        ChassisWheel { id: frontLeftWheel;  anchors.right: parent.left;  anchors.rightMargin: -5; anchors.top: parent.top;       anchors.topMargin: Math.round(30 * Theme.scale) }
                        ChassisWheel { id: frontRightWheel; anchors.left: parent.right;  anchors.leftMargin: -5; anchors.top: parent.top;       anchors.topMargin: Math.round(30 * Theme.scale) }
                        ChassisWheel { id: rearLeftWheel;   anchors.right: parent.left;  anchors.rightMargin: -5; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(34 * Theme.scale) }
                        ChassisWheel { id: rearRightWheel;  anchors.left: parent.right;  anchors.leftMargin: -5; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(34 * Theme.scale) }
                    }

                    // =========================================================
                    // 🔋 INTERNAL POWERTRAIN MOUNTS
                    // =========================================================
                    ColumnLayout {
                        anchors.centerIn: chassisFrame
                        spacing: Math.round(6 * Theme.scale)

                        // Powertrain System (Motor Block)
                        Rectangle {
                            width: Math.round(112 * Theme.scale)
                            height: Math.round(58 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius
                            Layout.alignment: Qt.AlignHCenter

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 2
                                Text { text: "Motor"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.motorTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary } 
                                }
                            }
                        }

                        // Central Main Traction Pack Array (Battery Core)
                        Rectangle {
                            id: coreBatteryBlock
                            width: Math.round(120 * Theme.scale) 
                            height: Math.round(74 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderWarm 
                            border.width: 1.5
                            radius: Theme.controlRadius

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 2
                                Text { text: "Battery Pack"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.batteryTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.titleSmall; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary } 
                                }
                            }
                        }

                        // H-Bridge Traction Controller Module
                        Rectangle {
                            width: Math.round(112 * Theme.scale)
                            height: Math.round(58 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius
                            Layout.alignment: Qt.AlignHCenter

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 2
                                Text { text: "Controller"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.controllerTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary } 
                                }
                            }
                        }
                    }

                    // Left Side Telemetry Deck Card (Pack Voltage)
                    Rectangle {
                        id: packVoltageCard
                        anchors.left: parent.left
                        anchors.leftMargin: Math.round(12 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.round(90 * Theme.scale)
                        height: Math.round(58 * Theme.scale)
                        color: "transparent"
                        border.color: Colors.borderSubtle
                        border.width: 1
                        radius: 6

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            Text { text: vehicleData.communicationFault ? "--" : "72.4 V"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.accentCity; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Pack Voltage"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    // Direct side layout path link indicator
                    Text {
                        text: "◀┈┈" 
                        font.family: Typography.family
                        font.pixelSize: 11
                        color: Colors.textSecondary
                        anchors.left: packVoltageCard.right
                        anchors.right: chassisFrame.left
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        visible: !vehicleData.communicationFault
                    }

                    // Right Side Telemetry Deck Card (Pack Current)
                    Rectangle {
                        id: packCurrentCard
                        anchors.right: parent.right
                        anchors.rightMargin: Math.round(12 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.round(90 * Theme.scale)
                        height: Math.round(58 * Theme.scale)
                        color: "transparent"
                        border.color: Colors.borderSubtle
                        border.width: 1
                        radius: 6

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            Text { text: vehicleData.communicationFault ? "--" : "18.2 A"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.accentCity; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Pack Current"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    Text {
                        text: "┈┈▶"
                        font.family: Typography.family
                        font.pixelSize: 11
                        color: Colors.textSecondary
                        anchors.left: chassisFrame.right
                        anchors.right: packCurrentCard.left
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        visible: !vehicleData.communicationFault
                    }
                }
            }

            // CARD B: METRICS MATRIX WITH INDEPENDENT SEGMENTED TRACK LAYOUTS
            DashboardCard {
                title: vehicleData.communicationFault ? "Temperature Status • Unavailable" : "Temperature Status"
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(190 * Theme.scale) 

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(8 * Theme.scale)

                    component TemperatureMetricRow : RowLayout {
                        property string moduleName: ""
                        property string currentTemp: ""
                        property int temperature: 0

                        readonly property real fillRatio:
                            vehicleData.communicationFault ? 0.0 : Math.min(temperature / 80.0, 1.0)

                        readonly property color statusColor:
                            vehicleData.communicationFault
                                ? Colors.textMuted
                                : temperature > 70
                                    ? Colors.critical
                                    : temperature >= 50
                                        ? Colors.warning
                                        : Colors.accentCity

                        Text { text: moduleName; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Medium; color: Colors.textPrimary; Layout.preferredWidth: 85 }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 3
                            Repeater {
                                model: 12
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: Math.round(10 * Theme.scale)

                                    color: vehicleData.communicationFault ? Colors.textMuted : (index / 12.0 < fillRatio)
                                        ? statusColor
                                        : Colors.surfaceSunken

                                    opacity: (index / 12.0 < fillRatio)
                                            ? 1.0
                                            : 0.35

                                    Behavior on color { ColorAnimation { duration: 250 } }
                                    Behavior on opacity { NumberAnimation { duration: 250 } }
                                }
                            }
                        }
                        
                        Text {
                            text: vehicleData.communicationFault ? "--" : currentTemp
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall
                            font.weight: Font.Bold
                            color: Colors.textPrimary
                            Layout.preferredWidth: 45
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    TemperatureMetricRow { moduleName: "Motor"; temperature: vehicleData.motorTemp; currentTemp: vehicleData.communicationFault ? "--" : vehicleData.motorTemp + "°C" }
                    TemperatureMetricRow { moduleName: "Battery"; temperature: vehicleData.batteryTemp; currentTemp: vehicleData.communicationFault ? "--" : vehicleData.batteryTemp + "°C" }
                    TemperatureMetricRow { moduleName: "Controller"; temperature: vehicleData.controllerTemp; currentTemp: vehicleData.communicationFault ? "--" : vehicleData.controllerTemp + "°C" } 
                    
                    Item { Layout.preferredHeight: 2 }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.accentCity } Text { text: "< 50°C Normal";font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary } }
                        Item { Layout.fillWidth: true }
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.warning } Text { text: "50°C - 70°C Elevated";font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary } }
                        Item { Layout.fillWidth: true }
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.critical } Text { text: "> 70°C High";font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary } }
                    }
                }
            }
        }

        // =====================================================================
        // RIGHT COLUMN MODULE AREA (60% Dynamic Width Allocation Space)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.60
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            RowLayout {
                Layout.preferredHeight: Math.round(268 * Theme.scale)
                spacing: Theme.sectionGap
                Layout.fillWidth: true
                Layout.fillHeight: true

                // CARD C: VEHICLE OPERATIONAL HEALTH SCORES
                DashboardCard {
                    title: vehicleData.communicationFault ? "Vehicle Health • Critical" : "Vehicle Health"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Overall Score"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                color: Colors.textPrimary
                                font.weight: Font.DemiBold
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: vehicleData.communicationFault ? "--" : healthScore + "%"
                                font.family: Typography.family
                                font.pixelSize: Typography.titleMedium
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault ? Colors.textMuted :
                                    overallHealthStatus === "HEALTHY" ? Colors.accentCity :
                                    overallHealthStatus === "WARNING" ? Colors.warning : Colors.critical
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Status"
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                color: Colors.textPrimary
                                font.weight: Font.DemiBold
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: vehicleData.communicationFault ? "OFFLINE" : overallHealthStatus
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault ? Colors.textMuted :
                                    overallHealthStatus === "HEALTHY" ? Colors.accentCity :
                                    overallHealthStatus === "WARNING" ? Colors.warning : Colors.critical
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }
                        
                        component DiagnosticLineItem : RowLayout {
                            property string itemLabel: ""
                            property string itemStatus: "OK"
                            Rectangle {
                                width: 8; height: 8; radius: 4
                                color:
                                    itemStatus === "OK" ? Colors.accentEco :
                                    itemStatus === "LOW BATTERY" ? Colors.warning :
                                    itemStatus === "OVERHEATING" ? Colors.critical :
                                    itemStatus === "COMMUNICATION FAULT" ? Colors.critical :
                                    itemStatus === "FAULT" ? Colors.critical :
                                    itemStatus === "CRITICAL" ? Colors.critical :
                                    itemStatus === "UNKNOWN" ? Colors.textMuted : Colors.textMuted
                            }
                            Text { text: itemLabel; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; color: Colors.textPrimary }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: itemStatus
                                font.family: Typography.family
                                font.pixelSize: Typography.titleSmall
                                font.weight: Font.Bold
                                color:
                                    itemStatus === "OK" ? Colors.accentEco :
                                    itemStatus === "WARNING" ? Colors.warning :
                                    itemStatus === "FAULT" ? Colors.critical :
                                    itemStatus === "OVERHEATING" ? Colors.critical :
                                    itemStatus === "LOW BATTERY" ? Colors.warning :
                                    itemStatus === "COMMUNICATION FAULT" ? Colors.critical :
                                    itemStatus === "CRITICAL" ? Colors.critical :
                                    itemStatus === "UNKNOWN" ? Colors.textMuted : Colors.textMuted
                            }
                        }
                        
                        DiagnosticLineItem { itemLabel: "Battery"; itemStatus: batteryHealthStatus }
                        DiagnosticLineItem { itemLabel: "Motor"; itemStatus: motorHealthStatus }
                        DiagnosticLineItem { itemLabel: "Controller"; itemStatus: controllerHealthStatus }
                        DiagnosticLineItem { itemLabel: "Comms"; itemStatus: commsHealthStatus }        
                    }
                }

                // CARD D: ACTIVE WARNINGS LOG REGISTRY
                DashboardCard {
                    id: activeWarningsCard
                    property int activeWarnings:
                        (vehicleData.communicationFault ? 1 : 0) +
                        (vehicleData.lowBatteryWarning ? 1 : 0) +
                        (vehicleData.lowRangeWarning ? 1 : 0) +
                        (vehicleData.motorOverTempWarning ? 1 : 0) +
                        (vehicleData.batteryOverTempWarning ? 1 : 0)
                    title: vehicleData.communicationFault ? "Inactive Warnings" : "ACTIVE WARNINGS"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 2
                        spacing: 7
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 6

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 36; height: 36; radius: 18; color: "transparent"
                                border.color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity
                                border.width: 2

                                Text {
                                    anchors.centerIn: parent
                                    text: vehicleData.communicationFault ? "X" : vehicleData.hasWarning ? "!" : "✓"
                                    color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity
                                    font.pixelSize: 20
                                    font.bold: true
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: vehicleData.communicationFault ? "COMMUNICATION FAULT" : vehicleData.hasWarning ? "ACTIVE WARNINGS" : "NO ACTIVE WARNINGS"
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyMedium
                                font.bold: true
                                font.letterSpacing: 0.5
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: vehicleData.communicationFault ? "Telemetry connection lost. Diagnostic data unavailable." : vehicleData.hasWarning ? "One or more vehicle alerts require attention." : "All systems are functioning normally."
                                color: Colors.textSecondary
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                            }
                        }
                                                                                                
                        Rectangle { 
                            Layout.fillWidth: true; height: 1; color: Colors.borderSubtle 
                            Layout.topMargin: 3; Layout.bottomMargin: 3
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: activeWarningsCard.activeWarnings > 0 ? "Current Fault" : "Last Fault (Historical)"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.DemiBold
                                color: Colors.textSecondary
                            }
                            
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40; radius: Theme.controlRadius
                                color: Qt.rgba(1, 1, 1, 0.02)
                                border.color: Colors.borderSubtle; border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 2

                                    Text { 
                                        text: vehicleData.communicationFault ? "X" : vehicleData.hasWarning ? "⚠" : "✓"
                                        font.pixelSize: 20
                                        color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    ColumnLayout {
                                        spacing: 2; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                                        Text {
                                            text: vehicleData.communicationFault ? "Communication Fault" : vehicleData.hasWarning ? vehicleData.warningMessage : "No active faults"
                                            font.family: Typography.family; font.pixelSize: Typography.bodySmall
                                            font.weight: Font.Medium; color: Colors.textPrimary
                                        }
                                        Text { 
                                            text: vehicleData.warningTimestamp; font.family: Typography.family
                                            font.pixelSize: Typography.bodySmall; color: Colors.textMuted 
                                        }
                                    }

                                    Text { 
                                        text: vehicleData.communicationFault ? "Critical" : vehicleData.hasWarning ? "Active" : "Resolved"
                                        font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Medium
                                        color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true; Layout.topMargin: 4; spacing: 12
                            
                            Text {
                                text: vehicleData.communicationFault ? "1 Critical" : vehicleData.hasWarning ? activeWarningsCard.activeWarnings + " Active" : "Resolved"
                                font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.DemiBold
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                            }

                            Rectangle { width: 1; height: 12; color: Colors.borderSubtle; Layout.alignment: Qt.AlignVCenter }

                            Text { 
                                text: vehicleData.communicationFault ? "Connection Lost" : vehicleData.historicalWarnings + " Historical" 
                                font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.DemiBold
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity 
                            }
                        }
                    }
                }
            }

            // QUAD AGGREGATED TELEMETRY BADGES
            RowLayout {
                Layout.preferredHeight: Math.round(161 * Theme.scale)
                Layout.preferredWidth: parent.width * 0.63
                spacing: Theme.sectionGap

                component QuadMiniBadge : DashboardCard {
                    property string mainValue: ""
                    property string mainLabel: ""
                    property string subLabel: ""
                    property string secondaryValue: ""
                    property string statusText: "NORMAL"
                    property color statusColor: Colors.accentCity
                    property color accentEco: Colors.accentEco
                    property string symbolChar: ""
                    property bool isBattery: false
                    property string cardType: ""

                    titleColor: Colors.textPrimary
                    
                    Layout.fillWidth: true; Layout.fillHeight: true

                    Loader {
                        anchors.fill: parent
                        sourceComponent: isBattery ? batteryLayout : normalLayout
                    }
                    Component {
                        id: batteryLayout
                        ColumnLayout {
                            anchors.fill: parent; spacing: 4
                            RowLayout {
                                spacing: 2; Layout.alignment: Qt.AlignTop; Layout.fillWidth: true
                                Item {
                                    width: 78; height: 26
                                    BatteryGraphic {
                                        anchors.verticalCenter: parent.verticalCenter
                                        percentage: vehicleData.communicationFault ? 0 : vehicleData.batteryPercent
                                    }
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: mainValue; Layout.alignment: Qt.AlignTop; color: Colors.textPrimary
                                    font.family: Typography.family; font.pixelSize: Typography.titleLarge; font.bold: true
                                }
                                Text {
                                    text: mainLabel; font.family: Typography.family; font.pixelSize: Typography.titleSmall; color: Colors.textSecondary
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "Range"; width: 50; color: Colors.textSecondary; font.pixelSize: Typography.bodySmall }
                                Item { Layout.fillWidth: true }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.rangeKm + " km"; color: Colors.textPrimary; font.pixelSize: Typography.bodySmall }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "SOH"; color: Colors.textSecondary; font.pixelSize: Typography.bodySmall }
                                Item { Layout.fillWidth: true }
                                Text { text: vehicleData.communicationFault ? "--" : "96%"; color: Colors.textPrimary; font.pixelSize: Typography.bodySmall }
                            }

                            Item { Layout.fillHeight: true }

                            RowLayout {
                                spacing: 4; Layout.alignment: Qt.AlignBottom; Layout.fillHeight: true
                                Rectangle { width: 6; height: 6; radius: 3; color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentEco }
                                Text {
                                    text: vehicleData.communicationFault ? "DATA UNAVAILABLE" : vehicleData.lowBatteryWarning ? "Low Battery" : statusText
                                    color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentCity
                                    font.family: Typography.family; font.bold: true; font.pixelSize: Typography.label
                                }
                            }
                        }
                    }

                    Component {
                        id: normalLayout
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: Math.round(12 * Theme.scale)

                                    Item {
                                        Layout.preferredWidth: Math.round(44 * Theme.scale)
                                        Layout.preferredHeight: Math.round(44 * Theme.scale)
                                        Layout.alignment: Qt.AlignVCenter

                                        PowertrainIcon {
                                            anchors.centerIn: parent
                                            visible: cardType === "powertrain"
                                        }

                                        ThermalIcon {
                                            anchors.centerIn: parent
                                            visible: cardType === "thermal"
                                        }

                                        Item {
                                            anchors.fill: parent
                                            visible: cardType === "communication"

                                            Rectangle {
                                                id: signalMast
                                                width: Math.max(1.2, 1.5 * Theme.scale)
                                                height: Math.round(22 * Theme.scale)
                                                color: "#00d2ff"
                                                anchors.bottom: parent.bottom
                                                anchors.bottomMargin: Math.round(1 * Theme.scale)
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                            Rectangle {
                                                id: signalNode
                                                width: Math.round(5 * Theme.scale)
                                                height: Math.round(5 * Theme.scale)
                                                radius: width / 2
                                                color: "#00d2ff"
                                                anchors.bottom: signalMast.top
                                                anchors.bottomMargin: -1
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                            Repeater {
                                                model: 3
                                                Rectangle {
                                                    anchors.centerIn: signalNode
                                                    width: Math.round((12 + index * 9) * Theme.scale)
                                                    height: width
                                                    radius: width / 2
                                                    color: "transparent"
                                                    border.color: "#00d2ff"
                                                    border.width: Math.max(1, 1.2 * Theme.scale)
                                                    opacity: 1.0 - (index * 0.3)
                                                }
                                            }
                                        }
                                    }

                                    ColumnLayout {
                                        spacing: Math.round(2 * Theme.scale)
                                        Layout.alignment: Qt.AlignVCenter

                                        RowLayout {
                                            spacing: Math.round(4 * Theme.scale)
                                            visible: cardType !== "communication"

                                            Text {
                                                font.pixelSize: Math.round(26 * Theme.scale)
                                                font.family: Typography.family
                                                font.weight: Font.Bold
                                                color: Colors.textPrimary
                                                text: mainValue
                                                Layout.alignment: Qt.AlignBottom
                                            }

                                            Text {
                                                font.pixelSize: Math.round(14 * Theme.scale)
                                                font.family: Typography.family
                                                font.weight: Font.Normal
                                                color: Colors.textPrimary
                                                text: mainLabel
                                                visible: mainLabel !== ""
                                                Layout.alignment: Qt.AlignBottom
                                                Layout.bottomMargin: Math.round(3 * Theme.scale)
                                            }
                                        }

                                        Text {
                                            font.pixelSize: Math.round(26 * Theme.scale)
                                            font.family: Typography.family
                                            font.weight: Font.Bold
                                            color: Colors.textPrimary
                                            text: mainValue
                                            visible: cardType === "communication"
                                        }

                                        Text {
                                            font.pixelSize: Math.round(11 * Theme.scale)
                                            font.family: Typography.family
                                            color: Colors.textMuted
                                            text: subLabel
                                            visible: subLabel !== ""
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Math.round(4 * Theme.scale)

                                Rectangle {
                                    width: Math.round(6 * Theme.scale)
                                    height: Math.round(6 * Theme.scale)
                                    radius: width / 2
                                    color: vehicleData.communicationFault
                                        ? Colors.textMuted
                                        : vehicleData.lowBatteryWarning
                                            ? Colors.warning
                                            : Colors.accentEco
                                }
                                Text {
                                    text: vehicleData.communicationFault
                                        ? "DATA UNAVAILABLE"
                                        : vehicleData.lowBatteryWarning
                                            ? "Low Battery"
                                            : statusText
                                    color: vehicleData.communicationFault
                                        ? Colors.textMuted
                                        : vehicleData.lowBatteryWarning
                                            ? Colors.warning
                                            : Colors.accentCity
                                    font.family: Typography.family
                                    font.bold: true
                                    font.pixelSize: Typography.label
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }
                }

                QuadMiniBadge {
                    title: "Battery"
                    isBattery: true
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.batteryPercent
                    mainLabel: vehicleData.communicationFault ? "" : "%"
                }
                // 2. Powertrain Component Card Matrix Badge
                QuadMiniBadge {
                    title: "Powertrain"
                    cardType: "powertrain"
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorPower.toFixed(1)
                    mainLabel: vehicleData.communicationFault ? "" : "kW"
                    subLabel: "Motor Power"
                    statusText: "NORMAL"
                    statusColor: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco
                }

                // 3. Thermal Configuration Heat Registry Badge
                QuadMiniBadge {
                    title: "Thermal"
                    cardType: "thermal"
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorTemp
                    mainLabel: vehicleData.communicationFault ? "" : "°C"
                    subLabel: "Max Temp"
                    statusText: "NORMAL"
                    statusColor: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco
                }

                // 4. Telemetry Signal Connectivity Badge
                QuadMiniBadge {
                    title: "Communication"
                    cardType: "communication"
                    mainValue: vehicleData.communicationFault ? "OFFLINE" : "CONNECTED"
                    mainLabel: ""
                    subLabel: ""
                    statusText: vehicleData.communicationFault ? "FAULT" : "STABLE"
                    statusColor: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                }
            }

            // RowLayout 3 (Powertrain Data / Fault History) unchanged as requested
            RowLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.63
                spacing: Theme.sectionGap

                // DETAILED STREAM POWERTRAIN MATRIX RAW VIEWPORT
                DashboardCard {
                    title: vehicleData.communicationFault ? "POWERTRAIN DATA • OFFLINE" : "POWERTRAIN DATA"
                    Layout.fillHeight: true
                    Layout.preferredHeight: Math.round(201 * Theme.scale)
                    Layout.preferredWidth: 364

                    ListView {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: Math.round(4 * Theme.scale)
                        
                        interactive: false
                        clip: true 
                        spacing: 0
                        
                        model: ListModel {
                            id: powertrainModel
                            ListElement { metric: "Battery Voltage"; reading: "72.4 V"; iconType: "voltage" }
                            ListElement { metric: "Battery Current"; reading: "18.2 A"; iconType: "current" }
                            ListElement { metric: "Motor Power"; reading: "4.8 kW"; iconType: "power" }
                            ListElement { metric: "Regen Level"; reading: "2"; iconType: "regen" }
                        }
                        
                        delegate: ColumnLayout {
                            width: parent ? parent.width : 0
                            spacing: 0
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(34 * Theme.scale) 
                                
                                Item {
                                    id: iconContainer
                                    Layout.preferredWidth: Math.round(28 * Theme.scale)
                                    Layout.preferredHeight: Math.round(28 * Theme.scale)
                                    Layout.rightMargin: Math.round(12 * Theme.scale)
                                    
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 20; height: 14; radius: 2
                                        color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
                                        border.width: 1.5
                                        visible: model.iconType === "voltage"
                                        
                                        Row {
                                            anchors.centerIn: parent
                                            spacing: 3
                                            Rectangle { width: 3; height: 6; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity }
                                            Rectangle { width: 3; height: 6; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity }
                                        }
                                    }
                                    
                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 1
                                        visible: model.iconType === "current"
                                        Repeater {
                                            model: 4
                                            Rectangle {
                                                width: 2
                                                height: index === 0 ? 6 : index === 1 ? 16 : index === 2 ? 10 : 8
                                                radius: 1
                                                color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
                                            }
                                        }
                                    }
                                    
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 18; height: 18; radius: 3
                                        color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
                                        border.width: 1.5
                                        visible: model.iconType === "power"
                                        
                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 2
                                            Rectangle { width: 10; height: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity }
                                            Rectangle { width: 10; height: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity }
                                        }
                                    }
                                    
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 16; height: 16; radius: 8
                                        color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
                                        border.width: 1.5
                                        visible: model.iconType === "regen"
                                        
                                        Rectangle {
                                            width: 6; height: 6; radius: 3
                                            color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                        }
                                    }
                                }
                                
                                Text { 
                                    text: model.metric
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium
                                    color: Colors.textSecondary 
                                }
                                
                                Item { Layout.fillWidth: true }
                                
                                Text { 
                                    text: vehicleData.communicationFault ? "--" : model.reading
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium
                                    font.weight: Font.Bold
                                    color: Colors.textPrimary 
                                }
                            }
                            
                            Rectangle { 
                                Layout.fillWidth: true
                                height: 1
                                color: Colors.surfaceSunken
                                visible: index < 3 
                            }
                        }
                    }
                }

                DashboardCard {
                    title: vehicleData.communicationFault ? "Fault History • OFFLINE" : "Fault History • " + telemetryLogger.recentWarnings.length
                    Layout.fillWidth: true; Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent; spacing: 8

                        Item {
                            Layout.fillWidth: true; Layout.fillHeight: true

                            ListView {
                                id: historyView
                                anchors.fill: parent; clip: true; spacing: 4
                                model: telemetryLogger.recentWarnings
                                visible: telemetryLogger.recentWarnings.length > 0 && !vehicleData.communicationFault

                                delegate: Rectangle {
                                    property var parts: modelData ? modelData.split(",") : []
                                    property string timestamp: parts.length > 0 ? parts[0] : ""
                                    property var tsParts: timestamp ? timestamp.split(" ") : []
                                    property string datePart: tsParts.length > 0 ? tsParts[0] : ""
                                    property string timePart: tsParts.length > 1 ? tsParts[1] : ""
                                    property string warningText: parts.length > 1 ? parts[1] : ""
                                    
                                    width: historyView.width; height: 42; radius: Theme.controlRadius
                                    color: Qt.rgba(1, 1, 1, 0.02); border.color: Colors.borderSubtle; border.width: 1

                                    RowLayout {
                                        anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10; spacing: 8
                                        Text { text: "⚠"; color: Colors.warning; font.pixelSize: Typography.bodyMedium }

                                        ColumnLayout {
                                            spacing: 1; Layout.fillWidth: true
                                            Text { text: warningText; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Medium }
                                            Row {
                                                spacing: 8
                                                Text { text: datePart; color: Colors.textMuted; font.pixelSize: Typography.label }
                                                Text { text: "•"; color: Colors.borderSubtle; font.family: Typography.family; font.pixelSize: Typography.label }
                                                Text { text: timePart; color: Colors.textMuted; font.pixelSize: Typography.label }
                                            }
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                    contentItem: Rectangle { radius: 3; color: Colors.borderSubtle }
                                    width: 6; background: Rectangle { color: "transparent" }
                                }
                            }

                            Column {
                                anchors.centerIn: parent; visible: vehicleData.communicationFault; spacing: 4
                                Rectangle {
                                    width: 32; height: 32; radius: 16
                                    color: Qt.rgba(Colors.critical.r, Colors.critical.g, Colors.critical.b, 0.10)
                                    border.color: Colors.critical; border.width: 1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: "X"; color: Colors.critical; font.pixelSize: 20; font.bold: true }
                                }
                                Text { text: "Communication Fault"; color: Colors.critical; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: "Telemetry stream unavailable"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: "History updates paused"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.horizontalCenter: parent.horizontalCenter }
                            }

                            Column {
                                anchors.centerIn: parent
                                visible: telemetryLogger.recentWarnings.length === 0 && !vehicleData.communicationFault
                                spacing: 6; width: parent.width

                                Rectangle {
                                    width: 42; height: 42; radius: 21
                                    color: Qt.rgba(Colors.accentEco.r, Colors.accentEco.g, Colors.accentEco.b, 0.10)
                                    border.color: Colors.accentEco; border.width: 1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: "✓"; color: Colors.accentEco; font.pixelSize: 22; font.bold: true }
                                }
                                Text { text: "No Recent Faults"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.alignment: Qt.AlignHCenter }
                                Text { text: "System operating normally"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.alignment: Qt.AlignHCenter }
                            }    
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }

                        Rectangle {
                            id: clearButton; Layout.alignment: Qt.AlignRight; width: 110; height: 34; radius: Theme.controlRadius
                            opacity: vehicleData.communicationFault ? 0.5 : 1.0
                            color: Qt.rgba(Colors.accentCity.r, Colors.accentCity.g, Colors.accentCity.b, 0.10)
                            border.color: Colors.borderSubtle; border.width: 1

                            Text { anchors.centerIn: parent; text: "ACKNOWLEDGE"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                            MouseArea { anchors.fill: parent; enabled: !vehicleData.communicationFault; onClicked: telemetryLogger.clearWarnings() }
                        }
                    }
                }
            }
        }
    }
}