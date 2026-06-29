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

    readonly property string currentFaultRoots: vehicleData.motorOverTempWarning ? faultsPage.translations["roots_mot_temp"][Typography.currentLanguage] :
                                                vehicleData.batteryOverTempWarning ? faultsPage.translations["roots_batt_temp"][Typography.currentLanguage] :
                                                vehicleData.communicationFault ? faultsPage.translations["roots_comm_loss"][Typography.currentLanguage] :
                                                vehicleData.lowBatteryWarning ? faultsPage.translations["roots_low_batt"][Typography.currentLanguage] :
                                                vehicleData.lowRangeWarning ? faultsPage.translations["roots_low_range"][Typography.currentLanguage] : faultsPage.translations["roots_none"][Typography.currentLanguage]

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_active_faults":    { "en": "Active Faults",         "de": "Aktive Fehler",           "es": "Fallos Activos" },
        "title_fault_history":    { "en": "Fault History Logs",    "de": "Fehlerhistorie-Logs",     "es": "Historial de Fallos" },
        "title_self_test":        { "en": "System Self Test",      "de": "System-Selbsttest",       "es": "Autocomprobación del Sistema" },
        "title_breakdown":        { "en": "Fault Details Breakdown","de": "Fehleraufschlüsselung",   "es": "Desglose de Detalles" },
        "title_statistics":       { "en": "Fault Statistics",      "de": "Fehlerstatistik",         "es": "Estadísticas de Fallos" },
        "title_actions":          { "en": "Actions",               "de": "Aktionen",                "es": "Acciones" },
        
        "head_priority":          { "en": "PRIORITY",              "de": "PRIORITÄT",               "es": "PRIORIDAD" },
        "head_fault_code":        { "en": "FAULT CODE",            "de": "FEHLERCODE",              "es": "CÓDIGO DE FALLO" },
        "head_description":       { "en": "DESCRIPTION",           "de": "BESCHREIBUNG",            "es": "DESCRIPCIÓN" },
        "head_status":            { "en": "STATUS",                "de": "STATUS",                  "es": "ESTADO" },
        "head_since":             { "en": "SINCE",                 "de": "SEIT",                    "es": "DESDE" },
        "head_time":              { "en": "TIME",                  "de": "ZEIT",                    "es": "HORA" },
        "head_severity":          { "en": "SEVERITY",              "de": "SCHWEREGRAD",             "es": "SEVERIDAD" },
        
        "status_active_tag":      { "en": " ACTIVE",               "de": " AKTIV",                  "es": " ACTIVO" }, // Counter badge title context strings
        "status_active":          { "en": "ACTIVE",                "de": "AKTIV",                   "es": "ACTIVO" },
        "status_cleared":         { "en": "CLEARED",               "de": "GEKLÄRT",                 "es": "CORREGIDO" },
        "status_total_tag":       { "en": " TOTAL",                "de": " GESAMT",                 "es": " TOTAL" },
        "status_ok":              { "en": "OK",                    "de": "OK",                      "es": "OK" },
        "status_fault":           { "en": "FAULT",                 "de": "FEHLER",                  "es": "FALLO" },
        
        "sev_high":               { "en": "⚠️ HIGH",               "de": "⚠️ HOCH",                 "es": "⚠️ ALTA" },
        "sev_medium":             { "en": "⚠️ MEDIUM",             "de": "⚠️ MITTEL",               "es": "⚠️ MEDIA" },
        "sev_low":                { "en": "⚠️ LOW",                "de": "⚠️ NIEDRIG",              "es": "⚠️ BAJA" },
        
        "lbl_target_code":        { "en": "Target Code:",          "de": "Zielcode:",               "es": "Código Destino:" },
        "lbl_current_reading":    { "en": "Current Reading:",      "de": "Aktueller Wert:",         "es": "Lectura Actual:" },
        "lbl_trigger_threshold":  { "en": "Trigger Threshold:",    "de": "Auslöseschwelle:",        "es": "Umbral de Activación:" },
        "lbl_possible_roots":     { "en": "Possible Roots:",       "de": "Mögliche Ursachen:",      "es": "Posibles Causas Raíz:" },
        
        "lbl_total":              { "en": "TOTAL",                 "de": "GESAMT",                  "es": "TOTAL" },
        "lbl_active":             { "en": "ACTIVE",                "de": "AKTIV",                   "es": "ACTIVO" },
        "lbl_cleared":            { "en": "CLEARED",               "de": "GEKLÄRT",                 "es": "CORREGIDO" },
        
        "btn_clear_faults":       { "en": "CLEAR FAULTS",          "de": "FEHLER LÖSCHEN",          "es": "LIMPIAR FALLOS" },
        "btn_run_self_test":      { "en": "RUN SELF TEST",         "de": "SELBSTTEST STARTEN",      "es": "EJECUTAR TEST" },
        
        "test_thermal":           { "en": "THERMAL SENSORS",       "de": "THERMISCHE SENSOREN",     "es": "SENSORES TÉRMICOS" },
        "test_voltage":           { "en": "VOLTAGE SENSORS",       "de": "SPANNUNGSSENSOREN",       "es": "SENSORES DE VOLTAJE" },
        "test_current":           { "en": "CURRENT SENSORS",       "de": "STROMSENSOREN",           "es": "SENSORES DE CORRIENTE" },
        "test_comm":              { "en": "COMM MODULE",           "de": "KOMM-MODUL",              "es": "MÓDULO DE COMUNICACIÓN" },
        "test_all_online":        { "en": "All sensors online",    "de": "Alle Sensoren online",    "es": "Sensores en línea" },
        "test_comm_lost":         { "en": "Uart link lost",        "de": "Uart-Verbindung verloren", "es": "Enlace UART perdido" },
        "test_comm_stable":       { "en": "Uart link stable",      "de": "Uart-Verbindung stabil",  "es": "Enlace UART estable" },
        
        "msg_no_active":          { "en": "No active powertrain or system diagnostics faults detected.", "de": "Keine aktiven Antriebsstrang- oder Systemdiagnosefehler erkannt.", "es": "No se detectaron fallos activos." },
        "msg_no_history":         { "en": "No historical log warnings registered inside tracking metrics.", "de": "Keine historischen Protokollwarnungen in den Tracking-Metriken registriert.", "es": "No hay advertencias históricas registradas." },
        "msg_link_dropped":       { "en": "Telemetry link dropped. Log database indexing sequence paused.", "de": "Telemetrieverbindung unterbrochen. Protokolldatenbank-Indizierung pausiert.", "es": "Enlace de telemetría perdido. Indexación pausada." },
        
        "desc_mot_temp":          { "en": "Motor Temperature Over Safe Limits", "de": "Motortemperatur über Sicherheitsgrenzwert", "es": "Temperatura del motor sobre límites seguros" },
        "desc_batt_temp":         { "en": "Battery Cell Temperature Critical", "de": "Batteriezellentemperatur kritisch", "es": "Temperatura crítica de celda de batería" },
        "desc_comm_loss":         { "en": "Telemetry Data Link Communication Lost", "de": "Telemetrie-Datenverbindung verloren", "es": "Comunicación de enlace de datos perdida" },
        "desc_low_batt":          { "en": "Main Battery Charge State Depleted", "de": "Hauptbatterieladezustand erschöpft", "es": "Estado de carga de batería principal agotado" },
        "desc_low_range":         { "en": "Remaining Operational Range Critical", "de": "Verbleibende Reichweite kritisch", "es": "Autonomía operativa restante crítica" },
        
        "roots_none":             { "en": "No active systemic errors detected.", "de": "Keine aktiven systemischen Fehler erkannt.", "es": "No se detectaron errores sistémicos activos." },
        "roots_mot_temp":         { "en": "• Cooling Pump Inoperative Subsystem Fault\n• Excess Continuous High Torque Profile Duty Cycles", "de": "• Kühlmittelpumpe außer Betrieb / Subsystemfehler\n• Übermäßige kontinuierliche Zyklen mit hohem Drehmoment", "es": "• Fallo de bomba de refrigeración\n• Exceso de ciclos continuos de alto par" },
        "roots_batt_temp":        { "en": "• Cell Internal Resistance High\n• Thermal Management Fluid Restriction", "de": "• Interner Zellwiderstand hoch\n• Flüssigkeitsrestriktion im Thermomanagement", "es": "• Resistencia interna de celda alta\n• Restricción de fluido térmico" },
        "roots_comm_loss":        { "en": "• Noise/Corrupted CAN Bus Packet Frames\n• Disconnected Hardware UART Link Interface", "de": "• Rauschen/Korrupte CAN-Bus-Paketframes\n• Getrennte Hardware-UART-Verbindungsschnittstelle", "es": "• Tramas de bus CAN corruptas\n• Interfaz de enlace UART desconectada" },
        "roots_low_batt":         { "en": "• Battery Energy Fully Depleted\n• Charger Inoperable or Disconnected", "de": "• Batterieenergie vollständig erschöpft\n• Ladegerät unbrauchbar oder getrennt", "es": "• Energía de la batería agotada\n• Cargador inoperable o desconectado" },
        "roots_low_range":        { "en": "• High Auxiliary Load Power Draw\n• Extreme Environmental Temperature Impact", "de": "• Hohe Leistungsaufnahme der Nebenverbraucher\n• Extreme Umgebungstemperaturbelastung", "es": "• Alto consumo de carga auxiliar\n• Impacto por temperatura ambiental extrema" }
    }

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
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 5
                baseColor: Colors.surfaceRaised
                title: faultsPage.translations["title_active_faults"][Typography.currentLanguage]

                Text {
                    text: faultsPage.activeFaultsCount + faultsPage.translations["status_active_tag"][Typography.currentLanguage]
                    color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.accentEco
                    font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium
                    anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: -22
                }

                ColumnLayout {
                    anchors.fill: parent; spacing: 6

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: faultsPage.translations["head_priority"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_fault_code"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight } // FIXED: Bumped from 130 to 160 + Scale allocation
                        Text { text: faultsPage.translations["head_description"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_status"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_since"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(80 * Theme.scale); elide: Text.ElideRight }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8; visible: vehicleData.motorOverTempWarning
                        Text { text: faultsPage.translations["sev_high"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "MOT_TEMP_HIGH"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["desc_mot_temp"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_active"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "14:28:45"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: Math.round(80 * Theme.scale) }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8; visible: vehicleData.batteryOverTempWarning
                        Text { text: faultsPage.translations["sev_high"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "BATT_TEMP_HIGH"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["desc_batt_temp"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_active"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "14:31:02"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: Math.round(80 * Theme.scale) }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8; visible: vehicleData.communicationFault
                        Text { text: faultsPage.translations["sev_medium"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "COMM_LOSS"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["desc_comm_loss"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_active"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "14:30:12"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: Math.round(80 * Theme.scale) }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8; visible: vehicleData.lowBatteryWarning
                        Text { text: faultsPage.translations["sev_medium"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "LOW_BATT_WARN"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.warning; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["desc_low_batt"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_active"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "14:32:00"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: Math.round(80 * Theme.scale) }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8; visible: vehicleData.lowRangeWarning
                        Text { text: faultsPage.translations["sev_low"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(100 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "LOW_RANGE_WARN"; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["desc_low_range"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_active"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: "14:33:15"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.preferredWidth: Math.round(80 * Theme.scale) }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: faultsPage.activeFaultsCount === 0
                        Text { text: faultsPage.translations["msg_no_active"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true }
                    }
                    Item { Layout.fillHeight: true }
                }
            }

            // 2. FAULT HISTORY LOG TABLE (Stretch Weight: 8)
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 8
                baseColor: Colors.surfaceRaised
                title: faultsPage.translations["title_fault_history"][Typography.currentLanguage]

                Text {
                    text: faultsPage.totalFaultsHistory + faultsPage.translations["status_total_tag"][Typography.currentLanguage]
                    color: Colors.textMuted; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium
                    anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: -22
                }

                ColumnLayout {
                    anchors.fill: parent; spacing: 6

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: faultsPage.translations["head_time"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_fault_code"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight } // FIXED: Coordinated 160 width allocation layout grid symmetry
                        Text { text: faultsPage.translations["head_description"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_severity"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                        Text { text: faultsPage.translations["head_status"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.preferredWidth: Math.round(80 * Theme.scale); elide: Text.ElideRight }
                    }

                    ListView {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        model: telemetryLogger.recentWarnings
                        interactive: true; clip: true; spacing: 4
                        visible: faultsPage.totalFaultsHistory > 0 && !vehicleData.communicationFault

                        delegate: RowLayout {
                            width: parent ? parent.width : 0; spacing: 8
                            
                            readonly property var stringTokens: modelData ? modelData.split(",") : []
                            readonly property string rawTimestamp: stringTokens.length > 0 ? stringTokens[0] : ""
                            readonly property var timestampTokens: rawTimestamp ? rawTimestamp.split(" ") : []
                            readonly property string parsedTime: timestampTokens.length > 1 ? timestampTokens[1] : rawTimestamp
                            
                            readonly property string rawMessageText: stringTokens.length > 1 ? stringTokens[1] : ""
                            readonly property string faultCodeMnemonic: faultsPage.parseMnemonicCode(rawMessageText)
                            
                            readonly property string computedSeverity: faultsPage.getFaultSeverity(faultCodeMnemonic)
                            readonly property bool computedActive: faultsPage.isFaultActive(faultCodeMnemonic)

                            Text { text: parsedTime; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(90 * Theme.scale) }
                            Text { text: faultCodeMnemonic; font.family: Typography.family; font.weight: Font.DemiBold; font.pixelSize: Typography.bodyMedium; color: computedActive ? Colors.critical : Colors.textMuted; Layout.preferredWidth: Math.round(160 * Theme.scale); elide: Text.ElideRight }
                            Text { text: faultsPage.translations["desc_" + faultCodeMnemonic.toLowerCase()] ? faultsPage.translations["desc_" + faultCodeMnemonic.toLowerCase()][Typography.currentLanguage] : rawMessageText; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight } // FIXED: Automatically outputs translated runtime trace logs cleanly
                            Text { text: computedSeverity === "HIGH" ? faultsPage.translations["status_fault"][Typography.currentLanguage] : faultsPage.translations["status_ok"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: computedSeverity === "HIGH" ? Colors.critical : (computedSeverity === "MEDIUM" ? Colors.warning : Colors.textMuted); Layout.preferredWidth: Math.round(90 * Theme.scale); elide: Text.ElideRight }
                            Text { text: computedActive ? faultsPage.translations["status_active"][Typography.currentLanguage] : faultsPage.translations["status_cleared"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: computedActive ? Colors.critical : Colors.accentEco; Layout.preferredWidth: Math.round(80 * Theme.scale); elide: Text.ElideRight }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true; visible: faultsPage.totalFaultsHistory === 0 && !vehicleData.communicationFault
                        Text { text: faultsPage.translations["msg_no_history"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true }
                    }

                    RowLayout {
                        Layout.fillWidth: true; visible: vehicleData.communicationFault
                        Text { text: faultsPage.translations["msg_link_dropped"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.fillWidth: true }
                    }
                }
            }

            // 3. SYSTEM SELF TEST SUMMARY (Stretch Weight: 3)
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 3
                baseColor: Colors.surfaceRaised
                title: faultsPage.translations["title_self_test"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: faultsPage.paddingSize

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["test_thermal"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_ok"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: faultsPage.translations["test_all_online"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["test_voltage"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_ok"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: faultsPage.translations["test_all_online"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["test_current"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.translations["status_ok"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco }
                        Text { text: faultsPage.translations["test_all_online"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["test_comm"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: vehicleData.communicationFault ? faultsPage.translations["status_fault"][Typography.currentLanguage] : faultsPage.translations["status_ok"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco }
                        Text { text: vehicleData.communicationFault ? faultsPage.translations["test_comm_lost"][Typography.currentLanguage] : faultsPage.translations["test_comm_stable"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }
        }

        // =====================================================
        // RIGHT COLUMN: DIAGNOSTICS & ACTIONS SUMMARY PANEL (35%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 350
            spacing: faultsPage.paddingSize

            // 1. FAULT DETAILS BREAKDOWN MATRIX (Stretch Weight: 8)
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 8
                baseColor: Colors.surfaceRaised
                title: faultsPage.translations["title_breakdown"][Typography.currentLanguage]

                ColumnLayout {
                    anchors.fill: parent; spacing: 6

                    RowLayout {
                        spacing: faultsPage.paddingSize; Layout.fillWidth: true
                        Text {
                            text: "⚠️"; font.pixelSize: Typography.displayMedium
                            color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted
                            Layout.alignment: Qt.AlignVCenter
                        }
                        ColumnLayout {
                            spacing: 1; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: faultsPage.translations["lbl_target_code"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(135 * Theme.scale); elide: Text.ElideRight }
                                Text { text: faultsPage.currentFaultCode; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: faultsPage.translations["lbl_current_reading"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(135 * Theme.scale); elide: Text.ElideRight }
                                Text { text: faultsPage.currentFaultReading; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: faultsPage.translations["lbl_trigger_threshold"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.preferredWidth: Math.round(135 * Theme.scale); elide: Text.ElideRight }
                                Text { text: faultsPage.currentFaultThreshold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 2
                        Text { text: faultsPage.translations["lbl_possible_roots"][Typography.currentLanguage]; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: faultsPage.currentFaultRoots; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textPrimary; Layout.fillWidth: true; Layout.rightMargin: Math.round(10 * Theme.scale) } // FIXED: Safe margin spacing steps strings back away from outer panel framing lines
                    }
                    Item { Layout.fillHeight: true }
                }
            }

            // 2. FAULT STATISTICS METRIC CARDS (Stretch Weight: 4)
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 4
                baseColor: Colors.surfaceRaised
                title: faultsPage.translations["title_statistics"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: faultsPage.paddingSize

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["lbl_total"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.totalFaultsHistory; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["lbl_active"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.activeFaultsCount; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.accentEco; Layout.alignment: Qt.AlignHCenter }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: faultsPage.translations["lbl_cleared"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.alignment: Qt.AlignHCenter }
                        Text { text: faultsPage.clearedFaultsCount; font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.titleLarge; color: Colors.accentEco; Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }

            // 3. ACTION CONTROLS PANEL (Stretch Weight: 4)
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 4
                title: faultsPage.translations["title_actions"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: faultsPage.paddingSize

                    BaseCard {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        interactive: faultsPage.activeFaultsCount > 0; baseColor: Colors.surfaceBase; title: ""
                        
                        Text { 
                            text: faultsPage.translations["btn_clear_faults"][Typography.currentLanguage]
                            font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                            color: faultsPage.activeFaultsCount > 0 ? Colors.critical : Colors.textMuted 
                            anchors.fill: parent; anchors.margins: 4; elide: Text.ElideRight; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onTapped: if (!vehicleData.communicationFault) telemetryLogger.clearWarnings()
                    }

                    BaseCard {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        interactive: true; baseColor: Colors.surfaceBase; title: ""
                        
                        Text { 
                            text: faultsPage.translations["btn_run_self_test"][Typography.currentLanguage]
                            font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                            color: Colors.accentCity 
                            anchors.fill: parent; anchors.margins: 4; elide: Text.ElideRight; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onTapped: if (!vehicleData.communicationFault) console.log("System diagnostic routine initialized")
                    }
                }
            }
        }
    }
}