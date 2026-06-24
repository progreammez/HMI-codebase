import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: faultsPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(10 * Theme.scale)

    ColumnLayout {
        anchors.fill: parent
        spacing: faultsPage.paddingSize

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 70
            spacing: faultsPage.paddingSize

            // -------------------------------------------------
            // LEFT COLUMN CONTAINER: FAULTS OVERVIEW TABLES
            // -------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                spacing: faultsPage.paddingSize

                // Active Faults Array Tracker Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Colors.surfaceRaised
                    radius: faultsPage.cardRadius
                    border.color: Colors.borderSubtle

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: faultsPage.paddingSize

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "ACTIVE FAULTS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: vehicleData.hasWarning ? "2 ACTIVE" : "0 ACTIVE"; font.weight: Font.Bold; color: vehicleData.hasWarning ? Colors.critical : Colors.accentEco; font.pixelSize: 9 }
                        }

                        // Table Structure
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 2
                            
                            RowLayout {
                                Text { text: "PRIORITY"; color: Colors.textMuted; font.pixelSize: 9; font.weight: Font.DemiBold; Layout.preferredWidth: 20 }
                                Text { text: "FAULT CODE"; color: Colors.textMuted; font.pixelSize: 9; font.weight: Font.DemiBold; Layout.preferredWidth: 35 }
                                Text { text: "DESCRIPTION"; color: Colors.textMuted; font.pixelSize: 9; font.weight: Font.DemiBold; Layout.preferredWidth: 45 }
                            }
                            // Row Item 1: Motor Temperature High
                            RowLayout {
                                visible: vehicleData.motorOverTempWarning
                                Text { text: "HIGH"; color: Colors.critical; font.bold: true; font.pixelSize: 9; Layout.preferredWidth: 20 }
                                Text { text: "MOT_TEMP_HIGH"; color: Colors.critical; font.bold: true; font.pixelSize: 9; Layout.preferredWidth: 35 }
                                Text { text: "Motor Temperature Over Limits"; color: Colors.textPrimary; font.pixelSize: 9; Layout.preferredWidth: 45 }
                            }
                            // Row Item 2: Telemetry Timeout Comms Loss
                            RowLayout {
                                visible: vehicleData.communicationFault
                                Text { text: "MEDIUM"; color: Colors.warning; font.bold: true; font.pixelSize: 9; Layout.preferredWidth: 20 }
                                Text { text: "COMM_LOSS"; color: Colors.warning; font.bold: true; font.pixelSize: 9; Layout.preferredWidth: 35 }
                                Text { text: "Telemetry Data Stream Timed Out"; color: Colors.textPrimary; font.pixelSize: 9; Layout.preferredWidth: 45 }
                            }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                // Historic Log Track
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Colors.surfaceRaised
                    radius: faultsPage.cardRadius
                    border.color: Colors.borderSubtle

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: faultsPage.paddingSize

                        Text { text: "FAULT HISTORY LOGS"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            Text { text: "14:12:05"; font.pixelSize: 9; color: Colors.textMuted; Layout.preferredWidth: 20 }
                            Text { text: "LOW_BATT_WARN"; font.pixelSize: 9; color: Colors.textMuted; Layout.preferredWidth: 35 }
                            Text { text: "Low Battery Threshold Warning"; font.pixelSize: 9; color: Colors.textMuted; Layout.preferredWidth: 35 }
                            Text { text: "CLEARED"; font.pixelSize: 9; color: Colors.accentEco; font.bold: true; Layout.preferredWidth: 10; horizontalAlignment: Text.AlignRight }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // -------------------------------------------------
            // RIGHT COLUMN CONTAINER: DETAILED FAULT DIAGNOSTICS
            // -------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 40
                spacing: faultsPage.paddingSize

                // Detailed selected item breakdown
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Colors.surfaceRaised
                    radius: faultsPage.cardRadius
                    border.color: Colors.borderSubtle

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: faultsPage.paddingSize

                        Text { text: "FAULT DETAILS BREAKDOWN"; color: Colors.textMuted; font.pixelSize: Typography.label; font.weight: Font.Bold }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 3
                            
                            RowLayout { 
                                Text { text: "Target Code:"; color: Colors.textMuted; font.pixelSize: 9 }
                                Text { text: vehicleData.motorOverTempWarning ? "MOT_TEMP_HIGH" : "NONE"; font.bold: true; font.pixelSize: 9; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textMuted } 
                            }
                            RowLayout { 
                                Text { text: "Current Reading:"; color: Colors.textMuted; font.pixelSize: 9 }
                                Text { text: vehicleData.motorTemp + " °C"; font.bold: true; font.pixelSize: 9; color: Colors.textPrimary } 
                            }
                            RowLayout { 
                                Text { text: "Trigger Threshold:"; color: Colors.textMuted; font.pixelSize: 9 }
                                Text { text: "90 °C"; font.pixelSize: 9; color: Colors.textMuted } 
                            }
                            RowLayout { 
                                Text { text: "Possible Roots:"; color: Colors.textMuted; font.pixelSize: 9 }
                                Text { text: "• Cooling Pump Inoperative\n• Excess Continuous Torque Load Profiles"; font.pixelSize: 9; color: Colors.textMuted } 
                            }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                // Action buttons panel
                Rectangle {
                    Layout.fillWidth: true
                    height: Math.round(50 * Theme.scale)
                    color: Colors.surfaceRaised
                    radius: faultsPage.cardRadius
                    border.color: Colors.borderSubtle

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "🗑 CLEAR FAULTS"; font.pixelSize: 9; font.bold: true; color: Colors.critical; anchors.centerIn: parent }
                            MouseArea { anchors.fill: parent; onClicked: { vehicleData.motorOverTempWarning = false; vehicleData.batteryOverTempWarning = false; } }
                        }
                        Rectangle { 
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceBase
                            radius: 4
                            border.color: Colors.borderSubtle
                            Text { text: "🔄 RUN SELF TEST"; font.pixelSize: 9; font.bold: true; color: Colors.accentCity; anchors.centerIn: parent }
                        }
                    }
                }
            }
        }
    }
}