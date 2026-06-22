import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import EvHmi

Item {
    id: faultsPage
    anchors.fill: parent

    readonly property int paddingSize: Math.round(10 * Theme.scale)
    readonly property int innerRadius: 4

    // Live Warning Calculations from Backend Properties
    readonly property int activeFaultsCount: (vehicleData.motorOverTempWarning ? 1 : 0) +
                                             (vehicleData.communicationFault ? 1 : 0) +
                                             (vehicleData.batteryOverTempWarning ? 1 : 0) +
                                             (vehicleData.lowBatteryWarning ? 1 : 0) +
                                             (vehicleData.lowRangeWarning ? 1 : 0)

    readonly property int totalFaultsHistory: telemetryLogger.recentWarnings.length
    readonly property int clearedFaultsCount: Math.max(0, faultsPage.totalFaultsHistory - faultsPage.activeFaultsCount)

    // Context Shifting Logic for Fault Breakdown Matrix
    readonly property string currentFaultCode: vehicleData.motorOverTempWarning ? "MOT_TEMP_HIGH" :
                                               vehicleData.batteryOverTempWarning ? "BATT_TEMP_HIGH" :
                                               vehicleData.communicationFault ? "COMM_LOSS" :
                                               vehicleData.lowBatteryWarning ? "LOW_BATT_WARN" :
                                               vehicleData.lowRangeWarning ? "LOW_RANGE_WARN" : "NONE"

    readonly property string currentFaultReading: vehicleData.motorOverTempWarning ? vehicleData.motorTemp + " °C" :
                                                  vehicleData.batteryOverTempWarning ? vehicleData.batteryTemp + " °C" :
                                                  vehicleData.communicationFault ? "TIMEOUT" :
                                                  vehicleData.lowBatteryWarning ? vehicleData.batteryPercent + " %" :
                                                  vehicleData.lowRangeWarning ? vehicleData.rangeKm + " km" : "--"

    readonly property string currentFaultThreshold: vehicleData.motorOverTempWarning ? "90 °C" :
                                                    vehicleData.batteryOverTempWarning ? "60 °C" :
                                                    vehicleData.communicationFault ? "> 200 ms" :
                                                    vehicleData.lowBatteryWarning ? "< 20 %" :
                                                    vehicleData.lowRangeWarning ? "< 50 km" : "--"

    readonly property string currentFaultRoots: vehicleData.motorOverTempWarning ? "• Cooling Pump Inoperative Subsystem Fault\n• Excess Continuous High Torque Profile Duty Cycles" :
                                                vehicleData.batteryOverTempWarning ? "• Cell Internal Resistance High\n• Thermal Management Fluid Restriction" :
                                                vehicleData.communicationFault ? "• Noise/Corrupted CAN Bus Packet Frames\n• Disconnected Hardware UART Link Interface" :
                                                vehicleData.lowBatteryWarning ? "• Battery Energy Fully Depleted\n• Charger Inoperable or Disconnected" :
                                                vehicleData.lowRangeWarning ? "• High Auxiliary Load Power Draw\n• Extreme Environmental Temperature Impact" : "No active systemic errors detected."

    // Helper functions to systematically generate clean metadata from raw log string messages
    function parseMnemonicCode(messageText) {
        if (!messageText) return "SYS_FAULT"
        var lower = messageText.toLowerCase()
        if (lower.indexOf("motor temp") !== -1 || lower.indexOf("mot_temp") !== -1) return "MOT_TEMP_HIGH"
        if (lower.indexOf("battery temp") !== -1 || lower.indexOf("batt_temp") !== -1) return "BATT_TEMP_HIGH"
        if (lower.indexOf("communication") !== -1 || lower.indexOf("comm") !== -1 || lower.indexOf("bus") !== -1) return "COMM_LOSS"
        if (lower.indexOf("low battery") !== -1 || lower.indexOf("low_batt") !== -1) return "LOW_BATT_WARN"
        if (lower.indexOf("range") !== -1) return "LOW_RANGE_WARN"
        if (lower.indexOf("current") !== -1) return "OVER_CURRENT"
        return "SYS_DIAG_EVT"
    }

    function getFaultSeverity(code) {
        if (code === "MOT_TEMP_HIGH" || code === "BATT_TEMP_HIGH" || code === "OVER_CURRENT") return "HIGH"
        if (code === "COMM_LOSS") return "MEDIUM"
        return "LOW"
    }

    function isFaultActive(code) {
        if (code === "MOT_TEMP_HIGH") return vehicleData.motorOverTempWarning
        if (code === "BATT_TEMP_HIGH") return vehicleData.batteryOverTempWarning
        if (code === "COMM_LOSS") return vehicleData.communicationFault
        if (code === "LOW_BATT_WARN") return vehicleData.lowBatteryWarning
        if (code === "LOW_RANGE_WARN") return vehicleData.lowRangeWarning
        return false
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: faultsPage.paddingSize
        spacing: faultsPage.paddingSize

        // =====================================================
        // LEFT COLUMN: FAULT TRACKING & LOGS SYSTEMS (65%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 650
            spacing: faultsPage.paddingSize

            // 1. ACTIVE FAULTS TABLE (Stretch Weight: 5)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 5
                baseColor: Colors.surfaceRaised
                title: "ACTIVE FAULTS"

                Text {
                    text: faultsPage.activeFaultsCount + " ACTIVE"
                    color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.accentEco
                    font.family: Typography.family
                    font.weight: Font.Bold
                    font.pixelSize: Typography.bodyMedium
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: -22
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "PRIORITY"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 90 }
                        Text { text: "FAULT CODE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 130 }
                        Text { text: "DESCRIPTION"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true }
                        Text { text: "STATUS"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 80 }
                        Text { text: "SINCE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.motorOverTempWarning
                        Text { text: "⚠️ HIGH"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 90 }
                        Text { text: "MOT_TEMP_HIGH"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 130 }
                        Text { text: "Motor Temperature Over Safe Limits"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true }
                        Text { text: "ACTIVE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 80 }
                        Text { text: "14:28:45"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.batteryOverTempWarning
                        Text { text: "⚠️ HIGH"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 90 }
                        Text { text: "BATT_TEMP_HIGH"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 130 }
                        Text { text: "Battery Cell Temperature Critical"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true }
                        Text { text: "ACTIVE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 80 }
                        Text { text: "14:31:02"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.communicationFault
                        Text { text: "⚠️ MEDIUM"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: 90 }
                        Text { text: "COMM_LOSS"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: 130 }
                        Text { text: "Telemetry Data Link Communication Lost"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true }
                        Text { text: "ACTIVE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 80 }
                        Text { text: "14:30:12"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.lowBatteryWarning
                        Text { text: "⚠️ MEDIUM"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: 90 }
                        Text { text: "LOW_BATT_WARN"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: 130 }
                        Text { text: "Main Battery Charge State Depleted"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true }
                        Text { text: "ACTIVE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 80 }
                        Text { text: "14:32:00"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.lowRangeWarning
                        Text { text: "⚠️ LOW"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: 90 }
                        Text { text: "LOW_RANGE_WARN"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: 130 }
                        Text { text: "Remaining Operational Range Critical"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true }
                        Text { text: "ACTIVE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: 80 }
                        Text { text: "14:33:15"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: 80 }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: faultsPage.activeFaultsCount === 0
                        Text { text: "No active powertrain or system diagnostics faults detected."; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // 2. FAULT HISTORY LOG TABLE (Stretch Weight: 8)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 8
                baseColor: Colors.surfaceRaised
                title: "FAULT HISTORY LOGS"

                Text {
                    text: faultsPage.totalFaultsHistory + " TOTAL"
                    color: Colors.textMuted
                    font.family: Typography.family
                    font.weight: Font.Bold
                    font.pixelSize: Typography.bodyMedium
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: -22
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "TIME"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 90 }
                        Text { text: "FAULT CODE"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 130 }
                        Text { text: "DESCRIPTION"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true }
                        Text { text: "SEVERITY"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 80 }
                        Text { text: "STATUS"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: 80 }
                    }

                    // Native ListView rendering the string array without overlaps
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: telemetryLogger.recentWarnings
                        interactive: true
                        clip: true
                        spacing: 4
                        visible: faultsPage.totalFaultsHistory > 0 && !vehicleData.communicationFault

                        delegate: RowLayout {
                            width: parent ? parent.width : 0
                            
                            readonly property var stringTokens: modelData ? modelData.split(",") : []
                            readonly property string rawTimestamp: stringTokens.length > 0 ? stringTokens[0] : ""
                            readonly property var timestampTokens: rawTimestamp ? rawTimestamp.split(" ") : []
                            readonly property string parsedTime: timestampTokens.length > 1 ? timestampTokens[1] : rawTimestamp
                            
                            // Extract raw text message string and map cleanly to columns
                            readonly property string rawMessageText: stringTokens.length > 1 ? stringTokens[1] : ""
                            readonly property string faultCodeMnemonic: faultsPage.parseMnemonicCode(rawMessageText)
                            
                            readonly property string computedSeverity: faultsPage.getFaultSeverity(faultCodeMnemonic)
                            readonly property bool computedActive: faultsPage.isFaultActive(faultCodeMnemonic)

                            Text { text: parsedTime; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: 90 }
                            Text { text: faultCodeMnemonic; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: computedActive ? Colors.critical : Colors.textMuted; Layout.preferredWidth: 130 }
                            Text { text: rawMessageText; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: computedSeverity; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: computedSeverity === "HIGH" ? Colors.critical : (computedSeverity === "MEDIUM" ? Colors.warning : Colors.textMuted); Layout.preferredWidth: 80 }
                            Text { text: computedActive ? "ACTIVE" : "CLEARED"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: computedActive ? Colors.critical : Colors.accentEco; Layout.preferredWidth: 80 }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: faultsPage.totalFaultsHistory === 0 && !vehicleData.communicationFault
                        Text { text: "No historical log warnings registered inside tracking metrics."; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: vehicleData.communicationFault
                        Text { text: "Telemetry link dropped. Log database indexing sequence paused."; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.fillWidth: true }
                    }
                }
            }

            // 3. SYSTEM SELF TEST SUMMARY (Stretch Weight: 3)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 3
                baseColor: Colors.surfaceRaised
                title: "SYSTEM SELF TEST"

                RowLayout {
                    anchors.fill: parent
                    spacing: faultsPage.paddingSize

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "THERMAL SENSORS"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                        Text { text: "OK"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: "All sensors online"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "VOLTAGE SENSORS"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                        Text { text: "OK"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: "All sensors online"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "CURRENT SENSORS"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                        Text { text: "OK"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: "All sensors online"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "COMM MODULE"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                        Text { text: vehicleData.communicationFault ? "FAULT" : "OK"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco }
                        Text { text: vehicleData.communicationFault ? "Uart link lost" : "Uart link stable"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted }
                    }
                }
            }
        }

        // =====================================================
        // RIGHT COLUMN: DIAGNOSTICS & ACTIONS SUMMARY PANEL (35%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 350
            spacing: faultsPage.paddingSize

            // 1. FAULT DETAILS BREAKDOWN MATRIX (Stretch Weight: 8)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 8
                baseColor: Colors.surfaceRaised
                title: "FAULT DETAILS BREAKDOWN"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 6

                    RowLayout {
                        spacing: faultsPage.paddingSize
                        Text {
                            text: "⚠️"
                            font.pixelSize: Typography.displayMedium
                            color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted
                        }
                        ColumnLayout {
                            spacing: 1
                            RowLayout {
                                Text { text: "Target Code:"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                                Text { text: faultsPage.currentFaultCode; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted }
                            }
                            RowLayout {
                                Text { text: "Current Reading:"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                                Text { text: faultsPage.currentFaultReading; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary }
                            }
                            RowLayout {
                                Text { text: "Trigger Threshold:"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                                Text { text: faultsPage.currentFaultThreshold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "Possible Roots:"; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted }
                        Text { text: faultsPage.currentFaultRoots; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textPrimary }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // 2. FAULT STATISTICS METRIC CARDS (Stretch Weight: 4)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 4
                baseColor: Colors.surfaceRaised
                title: "FAULT STATISTICS"

                RowLayout {
                    anchors.fill: parent
                    spacing: faultsPage.paddingSize

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "TOTAL"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.totalFaultsHistory; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "ACTIVE"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.activeFaultsCount; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.accentEco; Layout.alignment: Qt.AlignHCenter }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text { text: "CLEARED"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.clearedFaultsCount; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: Colors.accentEco; Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }

            // 3. ACTION CONTROLS PANEL (Stretch Weight: 4)
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 4
                title: "ACTIONS"

                RowLayout {
                    anchors.fill: parent
                    spacing: faultsPage.paddingSize

                    BaseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        interactive: faultsPage.activeFaultsCount > 0
                        baseColor: Colors.surfaceBase
                        title: ""
                        
                        Text { 
                            text: "CLEAR FAULTS"
                            font.family: Typography.family 
                            font.pixelSize: Typography.bodyMedium
                            font.weight: Font.Bold
                            color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted 
                            anchors.centerIn: parent 
                            horizontalAlignment: Text.AlignHCenter 
                        }
                        
                       MouseArea { anchors.fill: parent; enabled: !vehicleData.communicationFault; onClicked: telemetryLogger.clearWarnings() }
                    }

                    BaseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        interactive: true
                        baseColor: Colors.surfaceBase
                        title: ""
                        
                        Text { 
                            text: "RUN SELF TEST" 
                            font.family: Typography.family 
                            font.pixelSize: Typography.bodyMedium
                            font.weight: Font.Bold
                            color: Colors.accentCity 
                            anchors.centerIn: parent 
                            horizontalAlignment: Text.AlignHCenter 
                        }
                        
                       MouseArea { anchors.fill: parent; enabled: !vehicleData.communicationFault; onClicked: console.log("System diagnostic routine initialized") }
                    }
                }
            }
        }
    }
}