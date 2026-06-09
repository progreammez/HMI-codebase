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
            return "FAULT"

        if (vehicleData.lowBatteryWarning)
            return "WARNING"

        return "OK"
    }

    property string motorHealthStatus: {
        if (vehicleData.communicationFault)
            return "UNKNOWN"

        return vehicleData.motorOverTempWarning
               ? "FAULT"
               : "OK"
    }

    property string controllerHealthStatus: {
        return vehicleData.communicationFault
            ? "UNKNOWN"
            : "OK"
    }

    property string commsHealthStatus: {
        return vehicleData.communicationFault
               ? "FAULT"
               : "OK"
    }

    property int healthScore: {
        var score = 100

        if (vehicleData.motorOverTempWarning)
            score -= 20

        if (vehicleData.batteryOverTempWarning)
            score -= 20

        if (vehicleData.communicationFault)
            score -= 40

        return Math.max(0, score)
    }

    // =========================================================================
    // 🛠️ REUSABLE DASHBOARD CARD COMPONENT WITH SPEC RADII & PADDING
    // =========================================================================
    component DashboardCard : 
    Rectangle {
        property string title: ""
        color: Colors.surfaceBase // Theme-mapped card surface background
        border.color: Colors.borderSubtle // Theme-mapped subtle border outline
        border.width: 1
        radius: Theme.cardRadius // Responsive border radius tracking scale

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.cardPadding // Padding standards driven by singleton
            spacing: Math.round(8 * Theme.scale)
            
            Text {
                text: parent.parent.title.toUpperCase()
                font.family: Typography.family // Unified typeface reference
                font.pixelSize: Typography.label // Design system label token sizing
                font.weight: Font.Bold
                color: Colors.textSecondary // Context/mode aware secondary text
                Layout.fillWidth: true
            }

            // Viewport target for custom layout content injection
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
        anchors.margins: Theme.pageMargin // Configurable global layout margins
        spacing: Theme.sectionGap // Standard gaps between primary UI modules

        // =====================================================================
        // LEFT COLUMN MODULE AREA (40% Dynamic Width Allocation Space)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.40
            Layout.preferredHeight: Math.round(440 * Theme.scale) // Aspect ratio locked
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            // CARD A: VEHICLE OVERVIEW CHASSIS WIREFRAME MODEL
            DashboardCard {
                title: vehicleData.communicationFault ? "Vehicle Overview  • Unavailable" : "Vehicle Overview"
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Item {
                    anchors.fill: parent
                    
                    // Structural Chassis Wireframe Model Representation
                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.round(155 * Theme.scale)
                        height: Math.round(270 * Theme.scale)
                        color: "transparent"
                        border.color: Colors.borderSubtle
                        border.width: 1.5
                        radius: 36
                        
                        Text { text: vehicleData.communicationFault ? "CONNECTION LOST" : "FRONT"; anchors.bottom: parent.top; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottomMargin: 6; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textMuted }
                        Text { text: vehicleData.communicationFault ? "" : "REAR"; anchors.top: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.topMargin: 6; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textMuted }
                    }

                    // Internal Layout Actuator & Thermal Pack Component Chain
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Math.round(10 * Theme.scale)

                        // Powertrain Actuator Component (Motor Block)
                        Rectangle {
                            width: Math.round(110 * Theme.scale)
                            height: Math.round(54 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 1
                                Text { text: "Motor"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.motorTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
                                }
                            }
                        }

                        // Central Pack Block Traction Array (Battery Core)
                        Rectangle {
                            id: coreBatteryBlock
                            width: Math.round(120 * Theme.scale)
                            height: Math.round(72 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderWarm // Highlighted pack focus boundary
                            border.width: 1
                            radius: Theme.controlRadius

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 1
                                Text { text: "Battery Pack"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.batteryTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
                                }
                            }
                        }

                        // H-Bridge Inverter Component (Controller Block)
                        Rectangle {
                            width: Math.round(110 * Theme.scale)
                            height: Math.round(54 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 1
                                Text { text: "Controller"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.alignment: Qt.AlignHCenter }
                                Text { text: vehicleData.communicationFault ? "--" : vehicleData.controllerTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: vehicleData.communicationFault ? "--" : "OK" ; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
                                }
                            }
                        }
                    }

                    // Voltage & Current Vectors (Absolute Margin Symmetrical Offsets)
                    Column {
                        x: Math.round(10 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text { text: vehicleData.communicationFault ? "--" : "72.4 V"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.accentCity }
                        Text { text: vehicleData.communicationFault ? "" : "Pack Voltage"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted }
                    }

                    Column {
                        anchors.right: parent.right
                        anchors.rightMargin: Math.round(10 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text { text: vehicleData.communicationFault ? "--" : "18.2 A"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.accentCity; horizontalAlignment: Text.AlignRight }
                        Text { text: vehicleData.communicationFault ? "" : "Pack Current"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted; horizontalAlignment: Text.AlignRight }
                    }
                }
            }

            // CARD B: METRICS MATRIX WITH INDEPENDENT SEGMENTED TRACK LAYOUTS
            DashboardCard {
                title: vehicleData.communicationFault ? "Temperature Status • Unavailable" : "Temperature Status"
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(190 * Theme.scale) // Aspect ratio locked

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(8 * Theme.scale)

                    // Inline Custom Segmented Progress Component Template
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
                        
                        // Segmented Bar Layout Track
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

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 250
                                        }
                                    }

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 250
                                        }
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: vehicleData.communicationFault
                                ? "--"
                                : currentTemp

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

                    // Status Color Explanatory Legend Footer
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

            // GRID MATRIX SPLIT ROW CONTAINER
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

                    RowLayout {
                        anchors.fill: parent
                        spacing: Theme.cardGap
                
                        ColumnLayout {
                            spacing: 3
                            Layout.fillWidth: true
                            
                            component DiagnosticLineItem : RowLayout {
                                property string itemLabel: ""
                                property string itemStatus: "OK"
                                Text { text: itemLabel; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textSecondary }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: itemStatus
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodySmall
                                    font.weight: Font.Bold
                                    color: itemStatus === "FAULT" ? Colors.critical : itemStatus === "WARNING" ? Colors.warning : itemStatus === "UNKNOWN" ? Colors.textMuted : Colors.accentEco
                                }
                            }
                            
                            DiagnosticLineItem {
                                itemLabel: "Battery"
                                itemStatus: batteryHealthStatus
                            }

                            DiagnosticLineItem {
                                itemLabel: "Motor"
                                itemStatus: motorHealthStatus
                            }

                            DiagnosticLineItem {
                                itemLabel: "Controller"
                                itemStatus: controllerHealthStatus
                            }

                            DiagnosticLineItem {
                                itemLabel: "Comms"
                                itemStatus: commsHealthStatus
                            }
                            
                            Text { text: "Last Check: 12:42:31"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.topMargin: 4 }
                        }
                        
                        ColumnLayout {
                            Layout.preferredWidth: Math.round(95 * Theme.scale)
                            spacing: 2
                            Layout.alignment: Qt.AlignVCenter

                            Text {
                                text: vehicleData.communicationFault
                                    ? "OFFLINE"
                                    : healthScore + "%"

                                font.family: Typography.family
                                font.pixelSize: Typography.titleMedium
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault
                                    ? Colors.critical
                                    : Colors.accentCity

                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: vehicleData.communicationFault
                                    ? "DATA UNAVAILABLE"
                                    : (healthScore >= 80 ? "HEALTHY"
                                                        : healthScore >= 60 ? "DEGRADED"
                                                                            : "CRITICAL")

                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault
                                    ? Colors.critical
                                    : Colors.accentCity

                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
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
                    title: vehicleData.communicationFault ? "Inacitve Warnings" : "ACTIVE WARNINGS"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 2
                        spacing: 7
                        
                        // --- Top System Status Section ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 6

                            // Checkmark Circle
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 36
                                height: 36
                                radius: 18
                                color: "transparent"
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
                                                
                        // Divider Line
                        Rectangle { 
                            Layout.fillWidth: true; 
                            height: 1; 
                            color: Colors.borderSubtle 
                            Layout.topMargin: 3
                            Layout.bottomMargin: 3
                        }
                        
                        // --- Historical Fault Section ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: activeWarningsCard.activeWarnings > 0
                                    ? "Current Fault"
                                    : "Last Fault (Historical)"

                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.DemiBold
                                color: Colors.textSecondary
                            }
                            
                            // Fault Card Container
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: Theme.controlRadius
                                color: Qt.rgba(1, 1, 1, 0.02)
                                border.color: Colors.borderSubtle
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 14
                                    anchors.rightMargin: 14
                                    spacing: 2

                                    // Warning Sign Icon
                                    Text { 
                                        text: vehicleData.communicationFault ? "X" : vehicleData.hasWarning ? "⚠" : "✓"
                                        font.pixelSize: 20
                                        color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // Fault Details Text Block
                                    ColumnLayout {
                                        spacing: 2
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            text: vehicleData.communicationFault ? "Communication Fault" : vehicleData.hasWarning ? vehicleData.warningMessage : "No active faults"

                                            font.family: Typography.family
                                            font.pixelSize: Typography.bodySmall
                                            font.weight: Font.Medium
                                            color: Colors.textPrimary
                                        }
                                        Text { 
                                            text: vehicleData.warningTimestamp
                                            font.family: Typography.family
                                            font.pixelSize: Typography.bodySmall
                                            color: Colors.textMuted 
                                        }
                                    }

                                    // Resolution Status Badge
                                    Text { 
                                        text: vehicleData.communicationFault ? "Critical" : vehicleData.hasWarning ? "Active" : "Resolved"
                                        font.family: Typography.family
                                        font.pixelSize: Typography.bodySmall
                                        font.weight: Font.Medium
                                        color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                        
                        // --- Bottom Summary Counter Section ---
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 12
                            
                            Text {
                                text: vehicleData.communicationFault ? "1 Critical" : vehicleData.hasWarning ? activeWarningsCard.activeWarnings + " Active" : "Resolved"
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.DemiBold
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                            }

                            Rectangle {
                                width: 1
                                height: 12
                                color: Colors.borderSubtle
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text { 
                                text: vehicleData.communicationFault ? "Connection Lost" : vehicleData.historicalWarnings + " Historical" 
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.DemiBold
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
                    
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Math.round(2 * Theme.scale)

                        spacing: 1
                        Loader {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            sourceComponent: isBattery ? batteryLayout : normalLayout
                        }
                    }
                    Component {
                        id: batteryLayout

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 4

                            RowLayout {
                                spacing: 2
                                Layout.alignment: Qt.AlignTop
                                Layout.fillWidth: true
                                // Custom Battery Icon with Dynamic Fill Level Representation
                                Item {
                                    width: 78
                                    height: 26
                                    BatteryGraphic {
                                        anchors.verticalCenter: parent.verticalCenter
                                        percentage: vehicleData.communicationFault ? 0 : vehicleData.batteryPercent
                                    }
                                }

                                Item { Layout.fillWidth: true }
                                
                                // Main Battery Percentage Value Display
                                Text {
                                    text: mainValue
                                    Layout.alignment: Qt.AlignTop
                                    color: Colors.textPrimary
                                    font.family: Typography.family
                                    font.pixelSize: Typography.titleLarge
                                    font.bold: true
                                }

                                Text {
                                    text: mainLabel
                                    font.family: Typography.family
                                    font.pixelSize: Typography.titleSmall
                                    color: Colors.textSecondary
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: "Range"
                                    width: 50
                                    color: Colors.textSecondary
                                    font.pixelSize: Typography.bodySmall
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: vehicleData.communicationFault ? "--" : vehicleData.rangeKm + " km"
                                    color: Colors.textPrimary
                                    font.pixelSize: Typography.bodySmall
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: "SOH"
                                    color: Colors.textSecondary
                                    font.pixelSize: Typography.bodySmall
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: vehicleData.communicationFault ? "--" : "96%"
                                    color: Colors.textPrimary
                                    font.pixelSize: Typography.bodySmall
                                }
                            }

                            Item { 
                                Layout.fillHeight: true 
                            }

                            RowLayout {
                                spacing: 4
                                Layout.alignment: Qt.AlignBottom
                                Layout.fillHeight: true

                                Rectangle {
                                    width: 6
                                    height: 6
                                    radius: 3
                                    color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentEco
                                }

                                Text {
                                    text: vehicleData.communicationFault ? "DATA UNAVAILABLE" : vehicleData.lowBatteryWarning ? "Low Battery" : statusText
                                    color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentCity
                                    font.family: Typography.family
                                    font.bold: true
                                    font.pixelSize: Typography.label
                                }
                            }
                        }
                    }

                    Component {
                        id: normalLayout

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 16

                            // --- FIX 1: Wrap Icon and Content in a RowLayout for Side-by-Side positioning ---
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignTop
                                spacing: 12 // Adjust gap between icon and text layout

                                // Icon Text Element
                                Text {
                                    text: symbolChar
                                    font.pixelSize: Typography.titleLarge // Increased size to match Image 2
                                    color: Colors.accentCity
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Item { Layout.fillWidth: true }

                                // Value, Unit, and Subtitle Column
                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    // --- FIX 2: Put Value and Unit side-by-side ---
                                    RowLayout {
                                        spacing: 4
                                        
                                        Text {
                                            text: mainValue
                                            font.family: Typography.family
                                            font.pixelSize: Typography.titleLarge
                                            font.bold: true
                                            color: Colors.textPrimary
                                        }

                                        Text {
                                            text: mainLabel
                                            font.family: Typography.family
                                            font.pixelSize: Typography.titleSmall
                                            color: Colors.textSecondary
                                            Layout.alignment: Qt.AlignBottom // Align unit to bottom of the number
                                            Layout.bottomMargin: 4
                                        }
                                    }

                                    // Bottom descriptive text (e.g., "Motor Power")
                                    Text {
                                        text: subLabel
                                        color: Colors.textSecondary
                                        font.pixelSize: Typography.bodySmall
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Item { Layout.fillHeight: true }

                            // Status Indicator Row (Normal/Stable status)
                            RowLayout {
                                spacing: 6
                                Layout.alignment: Qt.AlignBottom

                                Rectangle {
                                    width: 6
                                    height: 6
                                    radius: 3
                                    color: vehicleData.communicationFault ? Colors.textMuted : accentEco
                                }

                                Text {
                                    text: vehicleData.communicationFault ? "DATA UNAVAILABLE" : statusText
                                    color: vehicleData.communicationFault ? Colors.textMuted : statusColor
                                    font.family: Typography.family
                                    font.bold: true
                                    font.pixelSize: Typography.label
                                }
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
                QuadMiniBadge {
                    title: "Powertrain"
                    symbolChar: "⚡"

                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorPower.toFixed(1)
                    mainLabel: vehicleData.communicationFault ? "" : " kW"

                    subLabel: "Motor Power"
                }
                QuadMiniBadge {
                    title: "Thermal"
                    symbolChar: "🌡"

                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorTemp
                    mainLabel: vehicleData.communicationFault ? "" : "°C"

                    subLabel: "Max Temp"
                }
                QuadMiniBadge {
                    title: "Communication"
                    symbolChar: "📡"

                    mainLabel: vehicleData.communicationFault ? "OFFLINE" : "CONNECTED"
                    subLabel: ""

                    statusText: vehicleData.communicationFault ? "TELEMETRY LOST" : "STABLE"
                }
            }

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
                        anchors.fill: parent
                        anchors.topMargin: Math.round(4 * Theme.scale)
                        interactive: false
                        spacing: 0
                        
                        model: ListModel {
                            ListElement { metric: "Battery Voltage"; reading: "72.4 V"; symbol: "🔋" }
                            ListElement { metric: "Battery Current"; reading: "18.2 A"; symbol: "📈" }
                            ListElement { metric: "Motor Power"; reading: "4.8 kW"; symbol: "⚙" }
                            ListElement { metric: "Regen Level"; reading: "2"; symbol: "🔄" }
                        }
                        
                        delegate: ColumnLayout {
                            width: parent.width
                            spacing: 0
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(34 * Theme.scale)
                                
                                Text { text: model.symbol; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.rightMargin: 4 }
                                Text { text: model.metric; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary }
                                Item { Layout.fillWidth: true }
                                Text { text: model.reading; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary }
                            }
                            
                            Rectangle { 
                                Layout.fillWidth: true; height: 1; color: Colors.surfaceSunken
                                visible: index < 3
                            }
                        }
                    }
                }

                DashboardCard {
                    title: vehicleData.communicationFault ? "Fault History • OFFLINE" : "Fault History • " + telemetryLogger.recentWarnings.length

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 8

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ListView {
                                id: historyView

                                anchors.fill: parent

                                clip: true
                                spacing: 4

                                model: telemetryLogger.recentWarnings
                                visible: telemetryLogger.recentWarnings.length > 0 && !vehicleData.communicationFault

                                delegate: Rectangle {
                                    property var parts:  
                                        modelData ? modelData.split(",") : []

                                    property string timestamp:
                                        parts.length > 0 ? parts[0] : ""

                                    property var tsParts:
                                        timestamp ? timestamp.split(" ") : []

                                    property string datePart:
                                        tsParts.length > 0 ? tsParts[0] : ""

                                    property string timePart:
                                        tsParts.length > 1 ? tsParts[1] : ""

                                    property string warningText:
                                        parts.length > 1 ? parts[1] : ""
                                    
                                    width: historyView.width
                                    height: 42

                                    radius: Theme.controlRadius

                                    color: Qt.rgba(1, 1, 1, 0.02)
                                    border.color: Colors.borderSubtle
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10

                                        spacing: 8

                                        Text {
                                            text: "⚠"
                                            color: Colors.warning
                                            font.pixelSize: Typography.bodyMedium
                                        }

                                        ColumnLayout {
                                            spacing: 1
                                            Layout.fillWidth: true

                                            Text {
                                                text: warningText

                                                color: Colors.textPrimary
                                                font.family: Typography.family
                                                font.pixelSize: Typography.bodySmall
                                                font.weight: Font.Medium
                                            }

                                            Row {
                                                spacing: 8

                                                Text {
                                                    text: datePart
                                                    color: Colors.textMuted
                                                    font.pixelSize: Typography.label
                                                }

                                                Text {
                                                    text: "•"

                                                    color: Colors.borderSubtle
                                                    font.family: Typography.family
                                                    font.pixelSize: Typography.label
                                                }

                                                Text {
                                                    text: timePart
                                                    color: Colors.textMuted
                                                    font.pixelSize: Typography.label
                                                }
                                            }
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                    contentItem: Rectangle { radius: 3; color: Colors.borderSubtle }
                                    width: 6
                                    background: Rectangle { color: "transparent" }
                                }
                            }

                            Column {
                                anchors.centerIn: parent

                                visible: vehicleData.communicationFault

                                spacing: 4

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 16

                                    color: Qt.rgba(
                                        Colors.critical.r,
                                        Colors.critical.g,
                                        Colors.critical.b,
                                        0.10
                                    )

                                    border.color: Colors.critical
                                    border.width: 1

                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: "X"
                                        color: Colors.critical
                                        font.pixelSize: 20
                                        font.bold: true
                                    }
                                }

                                Text {
                                    text: "Communication Fault"

                                    color: Colors.critical
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium
                                    font.bold: true

                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "Telemetry stream unavailable"

                                    color: Colors.textSecondary
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label

                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "History updates paused"

                                    color: Colors.textMuted
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label

                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            Column {
                                anchors.centerIn: parent

                                visible: telemetryLogger.recentWarnings.length === 0 && !vehicleData.communicationFault

                                spacing: 6
                                width: parent.width

                                Rectangle {
                                    width: 42
                                    height: 42
                                    radius: 21

                                    color: Qt.rgba(
                                        Colors.accentEco.r,
                                        Colors.accentEco.g,
                                        Colors.accentEco.b,
                                        0.10
                                    )

                                    border.color: Colors.accentEco
                                    border.width: 1

                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        color: Colors.accentEco
                                        font.pixelSize: 22
                                        font.bold: true
                                    }
                                }

                                Text {
                                    text: "No Recent Faults"

                                    color: Colors.textPrimary
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium

                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "System operating normally"

                                    color: Colors.textMuted
                                    font.family: Typography.family
                                    font.pixelSize: Typography.label

                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }    
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: Colors.borderSubtle
                        }

                        Rectangle {
                            id: clearButton

                            Layout.alignment: Qt.AlignRight

                            width: 110
                            height: 34

                            radius: Theme.controlRadius

                            opacity: vehicleData.communicationFault ? 0.5 : 1.0

                            color: Qt.rgba(
                                Colors.accentCity.r,
                                Colors.accentCity.g,
                                Colors.accentCity.b,
                                0.10
                            )

                            border.color: Colors.borderSubtle
                            border.width: 1

                            Text {
                                anchors.centerIn: parent

                                text: "ACKNOWLEDGE"

                                color: Colors.textPrimary
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent

                                enabled: !vehicleData.communicationFault

                                onClicked: telemetryLogger.clearWarnings()
                            }
                        }
                    }
                }
            }
        }
    }
}