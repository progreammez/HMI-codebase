import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import EvHmi

Item {
    id: diagnosticsCoreGrid
    anchors.fill: parent

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
        // LEFT COLUMN MODULE AREA (34% Dynamic Width Allocation Space)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.34
            Layout.preferredHeight: Math.round(440 * Theme.scale) // Aspect ratio locked
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            // CARD A: VEHICLE OVERVIEW CHASSIS WIREFRAME MODEL
            DashboardCard {
                title: "Vehicle Overview"
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
                        
                        Text { text: "FRONT"; anchors.bottom: parent.top; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottomMargin: 6; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textMuted }
                        Text { text: "REAR"; anchors.top: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.topMargin: 6; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textMuted }
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
                                Text { text: vehicleData.motorTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: "OK"; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
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
                                Text { text: vehicleData.batteryTemp + "°C"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: "OK"; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
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
                                Text { text: "41°C"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: Colors.accentEco } 
                                    Text { text: "OK"; font.family: Typography.family; font.pixelSize: 9; font.weight: Font.Bold; color: Colors.accentEco } 
                                }
                            }
                        }
                    }

                    // Voltage & Current Vectors (Absolute Margin Symmetrical Offsets)
                    Column {
                        x: Math.round(10 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text { text: "72.4 V"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.accentCity }
                        Text { text: "Pack Voltage"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted }
                    }

                    Column {
                        anchors.right: parent.right
                        anchors.rightMargin: Math.round(10 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text { text: "18.2 A"; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; color: Colors.accentCity; horizontalAlignment: Text.AlignRight }
                        Text { text: "Pack Current"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted; horizontalAlignment: Text.AlignRight }
                    }
                }
            }

            // CARD B: METRICS MATRIX WITH INDEPENDENT SEGMENTED TRACK LAYOUTS
            DashboardCard {
                title: "Temperature Status"
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(190   * Theme.scale) // Aspect ratio locked

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(8 * Theme.scale)

                    // Inline Custom Segmented Progress Component Template
                    component TemperatureMetricRow : RowLayout {
                        property string moduleName: ""
                        property string currentTemp: ""
                        property real fillRatio: 0.5
                        property color statusColor: Colors.accentCity

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
                                    radius: 1.5
                                    color: (index / 12.0 < fillRatio) ? statusColor : Colors.surfaceSunken
                                    opacity: (index / 12.0 < fillRatio) ? 1.0 : 0.35
                                }
                            }
                        }
                        
                        Text { text: currentTemp; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; Layout.preferredWidth: 45; horizontalAlignment: Text.AlignRight }
                    }

                    TemperatureMetricRow { moduleName: "Motor"; currentTemp: vehicleData.motorTemp + "°C"; fillRatio: 0.75; statusColor: Colors.accentCity }
                    TemperatureMetricRow { moduleName: "Battery"; currentTemp: vehicleData.batteryTemp + "°C"; fillRatio: 0.45; statusColor: Colors.accentCity }
                    TemperatureMetricRow { moduleName: "Controller"; currentTemp: "41°C"; fillRatio: 0.60; statusColor: Colors.warning } 

                    Item { Layout.preferredHeight: 2 }

                    // Status Color Explanatory Legend Footer
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.accentCity } Text { text: "< 50°C Normal"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted } }
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.warning } Text { text: "50°C - 70°C Elevated"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted } }
                        RowLayout { spacing: 5; Rectangle { width: 8; height: 8; radius: 4; color: Colors.critical } Text { text: "> 70°C High"; font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted } }
                    }
                }
            }
        }

        // =====================================================================
        // RIGHT COLUMN MODULE AREA (63% Dynamic Width Allocation Space)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.63
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
                    title: "Vehicle Health"
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
                                Text { text: itemLabel; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textSecondary }
                                Item { Layout.fillWidth: true }
                                Text { text: "OK"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.accentEco }
                            }
                            
                            DiagnosticLineItem { itemLabel: "Battery" }
                            DiagnosticLineItem { itemLabel: "Motor" }
                            DiagnosticLineItem { itemLabel: "Controller" }
                            DiagnosticLineItem { itemLabel: "Comms" }
                            
                            Text { text: "Last Check: 12:42:31"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.topMargin: 4 }
                        }
                        
                        ColumnLayout {
                            Layout.preferredWidth: Math.round(95 * Theme.scale)
                            spacing: 2
                            Layout.alignment: Qt.AlignVCenter // ✅ Attached property layout resolution
                            Text { text: "98%"; font.family: Typography.family; font.pixelSize: Typography.titleMedium; font.weight: Font.Bold; color: Colors.accentCity; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "HEALTHY"; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.accentCity; Layout.alignment: Qt.AlignHCenter }
                        }
                    }
                }

                // CARD D: ACTIVE WARNINGS LOG REGISTRY
                DashboardCard {
                    title: "Active Warnings"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 5
                        
                        RowLayout {
                            spacing: 8
                            Rectangle { 
                                width: 18; height: 18; radius: 9; color: "transparent"; border.color: Colors.accentCity; border.width: 1
                                Text { text: "✓"; color: Colors.accentCity; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; anchors.centerIn: parent }
                            }
                            Text { text: "NO ACTIVE WARNINGS"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.accentCity }
                        }
                        
                        Text { text: "All diagnostic systems operating normal."; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                        
                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle; Layout.topMargin: 2; Layout.bottomMargin: 2 }
                        
                        Text { text: "Last Fault (Historical):"; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textSecondary }
                        
                        RowLayout {
                            spacing: 6
                            Text { text: "⚠  BMS Overtemp — 02-Jun-2026 | Resolved"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.warning; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        
                        RowLayout {
                            Layout.topMargin: 1
                            spacing: 10
                            Text { text: "0 Active"; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.textMuted }
                            Text { text: "2 Historical"; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; color: Colors.accentCity }
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
                            spacing: 5

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
                                        percentage: vehicleData.batteryPercent
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
                                    text: vehicleData.rangeKm + " km"
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
                                    text: "96%"
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
                                    color: vehicleData.batteryOverTempWarning || vehicleData.lowBatteryWarning ? Colors.critical : Colors.accentEco
                                }

                                Text {
                                    text: vehicleData.batteryOverTempWarning || vehicleData.lowBatteryWarning ? "Warning" : statusText
                                    color: vehicleData.batteryOverTempWarning || vehicleData.lowBatteryWarning ? Colors.critical : Colors.accentCity
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
                                    color: accentEco // Fixed: Using statusColor to match the green text indicator
                                }

                                Text {
                                    text: statusText
                                    color: statusColor
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

                    mainValue: vehicleData.batteryPercent
                    mainLabel: "%"

                }
                QuadMiniBadge {
                    title: "Powertrain"
                    symbolChar: "⚡"

                    mainValue: vehicleData.motorPower.toFixed(1)
                    mainLabel: " kW"

                    subLabel: "Motor Power"
                }
                QuadMiniBadge {
                    title: "Thermal"
                    symbolChar: "🌡"

                    mainValue: vehicleData.motorTemp
                    mainLabel: "°C"

                    subLabel: "Max Temp"
                }
                QuadMiniBadge {
                    title: "Communication"
                    symbolChar: "📡"

                    mainLabel: "CONNECTED"
                    subLabel: ""

                    statusText: "STABLE"
                }
            }

            // DETAILED STREAM POWERTRAIN MATRIX RAW VIEWPORT
            DashboardCard {
                title: "Powertrain Data"
                Layout.fillHeight: true
                Layout.preferredHeight: Math.round(201 * Theme.scale)
                Layout.fillWidth: true

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
        }
    }
}