import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: overviewPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_system_summary":  { "en": "System Summary",        "de": "Systemübersicht",         "es": "Resumen del Sistema" },
        "title_active_warnings": { "en": "Active Warnings",       "de": "Aktive Warnungen",        "es": "Advertencias Activas" },
        "title_vehicle_health":  { "en": "Vehicle Health",        "de": "Fahrzeuggesundheit",      "es": "Salud del Vehículo" },
        "title_quick_stats":     { "en": "Quick Stats",           "de": "Kurzstatistik",           "es": "Estadísticas Rápidas" },
        "title_system_checks":   { "en": "System Checks",         "de": "Systemprüfungen",         "es": "Comprobaciones del Sistema" },
        
        "title_connection":      { "en": "CONNECTION",            "de": "VERBINDUNG",              "es": "CONEXIÓN" },
        "title_parser_status":   { "en": "PARSER STATUS",         "de": "PARSER-STATUS",           "es": "ESTADO DEL PARSER" },
        "title_telemetry_rate":  { "en": "TELEMETRY RATE",        "de": "TELEMETRIERATE",          "es": "TASA DE TELEMETRÍA" },
        "title_logger_status":   { "en": "LOGGER STATUS",         "de": "LOGGER-STATUS",           "es": "ESTADO DEL LOGGER" },
        
        "status_connected":      { "en": "CONNECTED",             "de": "VERBUNDEN",               "es": "CONECTADO" },
        "status_disconnected":   { "en": "DISCONNECTED",          "de": "TRENNEN",                 "es": "DESCONECTADO" },
        "status_active_caps":    { "en": "ACTIVE",                "de": "AKTIV",                   "es": "ACTIVO" },
        "status_recording":      { "en": "RECORDING",             "de": "AUFZEICHNUNG",            "es": "GRABANDO" },
        "status_active":         { "en": "ACTIVE",                "de": "AKTIV",                   "es": "ACTIVO" },
        
        "status_offline":        { "en": "OFFLINE",               "de": "OFFLINE",                 "es": "FUERA DE LÍNEA" },
        "status_live":           { "en": "LIVE",                  "de": "LIVE",                    "es": "EN VIVO" },
        "status_ok":             { "en": "OK",                    "de": "OK",                      "es": "OK" },
        "status_fail":           { "en": "FAIL",                  "de": "FEHLER",                  "es": "FALLO" },
        "status_stable":         { "en": "STABLE",                "de": "STABIL",                  "es": "ESTABLE" },
        "status_on":             { "en": "ON",                    "de": "AN",                      "es": "ACTIVO" },
        
        "lbl_protocol":          { "en": "Protocol",              "de": "Protokoll",               "es": "Protocolo" },
        "lbl_file":              { "en": "File",                  "de": "Datei",                   "es": "Archivo" },
        "lbl_normal":            { "en": "Normal",                "de": "Normal",                  "es": "Normal" },
        
        "warn_motor_temp":       { "en": "MOTOR TEMPERATURE HIGH", "de": "MOTORTEMPERATUR HOCH",    "es": "TEMPERATURA MOTOR ALTA" },
        "warn_low_battery":      { "en": "LOW BATTERY WARNING",   "de": "SCHWACHE BATTERIE WARNUNG","es": "ADVERTENCIA BATERÍA BAJA" },
        "warn_comm_fault":       { "en": "COMMUNICATION FAULT",   "de": "KOMMUNIKATIONSFEHLER",    "es": "FALLO DE COMUNICACIÓN" },
        
        "check_battery":         { "en": "BATTERY",               "de": "BATTERIE",                "es": "BATERÍA" },
        "check_motor":           { "en": "MOTOR",                 "de": "MOTOR",                   "es": "MOTOR" },
        "check_controller":      { "en": "CONTROLLER",            "de": "STEUERGERÄT",             "es": "CONTROLADOR" },
        "check_communication":   { "en": "COMMUNICATION",         "de": "KOMMUNIKATION",           "es": "COMUNICACIÓN" },
        "check_thermal":         { "en": "THERMAL",               "de": "THERMISCH",               "es": "TÉRMICO" },
        
        "stat_speed":            { "en": "SPEED",                 "de": "GESCHW.",                 "es": "VELOCIDAD" },
        "stat_rpm":              { "en": "RPM",                   "de": "U/MIN",                   "es": "RPM" },
        "stat_soc":              { "en": "SOC",                   "de": "SOC",                     "es": "SOC" },
        "stat_range":            { "en": "RANGE",                 "de": "REICHWEITE",              "es": "AUTONOMÍA" },
        "stat_voltage":          { "en": "VOLTAGE",               "de": "SPANNUNG",                "es": "VOLTAJE" },
        "stat_current":          { "en": "CURRENT",               "de": "STROM",                   "es": "CORRIENTE" },
        "stat_power":            { "en": "POWER",                 "de": "LEISTUNG",                "es": "POTENCIA" },
        "stat_drive_mode":       { "en": "DRIVE MODE",            "de": "FAHRMODUS",               "es": "MODO DE MANEJO" },
        
        "check_battery_pack":    { "en": "BATTERY PACK",          "de": "BATTERIEPACK",            "es": "PAQUETE BATERÍA" },
        "check_motor_system":    { "en": "MOTOR SYSTEM",          "de": "MOTORSYSTEM",             "es": "SISTEMA MOTOR" },
        "check_current_sensors": { "en": "CURRENT SENSORS",       "de": "STROMSENSOREN",           "es": "SENS. CORRIENTE" },
        "check_comm_module":     { "en": "COMM MODULE",           "de": "KOMM-MODUL",              "es": "MÓDULO COMMS" }
    }
    
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
            Layout.preferredHeight: Math.round(200 * Theme.scale)
            spacing: overviewPage.gridSpacing

            // SYSTEM SUMMARY CARD
            BaseCard {
                id: systemSummaryCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 62
                title: overviewPage.translations["title_system_summary"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent
                    spacing: overviewPage.gridSpacing
                    anchors.margins: Theme.cardPadding // FIXED: directly access UI token instance value instead of generic parent alias mappings

                    Repeater {
                        model: [
                            { titleKey: "title_connection", val: vehicleData.communicationFault ? overviewPage.translations["status_disconnected"][Typography.currentLanguage] : "UART " + overviewPage.translations["status_connected"][Typography.currentLanguage], desc: "/dev/ttyUSB0", sub: vehicleData.communicationFault ? "• " + overviewPage.translations["status_offline"][Typography.currentLanguage] : "• " + overviewPage.translations["status_live"][Typography.currentLanguage], isAlert: vehicleData.communicationFault },
                            { titleKey: "title_parser_status", val: overviewPage.translations["status_active_caps"][Typography.currentLanguage], desc: overviewPage.translations["lbl_protocol"][Typography.currentLanguage] + ": EV_CAN_V1", sub: "• " + overviewPage.translations["status_ok"][Typography.currentLanguage], isAlert: false },
                            { titleKey: "title_telemetry_rate", val: vehicleData.communicationFault ? "0 Hz" : "50 Hz", desc: "20 ms / frame", sub: "• " + overviewPage.translations["status_stable"][Typography.currentLanguage], isAlert: vehicleData.communicationFault },
                            { titleKey: "title_logger_status", val: overviewPage.translations["status_recording"][Typography.currentLanguage], desc: overviewPage.translations["lbl_file"][Typography.currentLanguage] + ": log_2024_05_28.csv", sub: "• " + overviewPage.translations["status_on"][Typography.currentLanguage], isAlert: false }
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

                                Text { text: overviewPage.translations[modelData.titleKey][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.val; color: modelData.isAlert ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; wrapMode: Text.WordWrap; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.desc; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; elide: Text.ElideRight; Layout.fillWidth: true }
                                
                                Item { Layout.fillHeight: true } 

                                Text {
                                    text: modelData.sub
                                    color: modelData.isAlert ? Colors.critical : Colors.success
                                    font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                                    Layout.fillWidth: true; elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }

            // ACTIVE WARNINGS CARD
            BaseCard {
                id: activeWarningsCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 38
                title: "" // Keep title property empty so built-in heading components hide

                readonly property bool hasWarning: vehicleData.motorOverTempWarning || vehicleData.lowBatteryWarning || vehicleData.communicationFault
                readonly property int activeCount: (vehicleData.motorOverTempWarning ? 1 : 0) + (vehicleData.lowBatteryWarning ? 1 : 0) + (vehicleData.communicationFault ? 1 : 0)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.cardPadding // FIXED: directly access layout parameters explicitly
                    spacing: Math.round(10 * Theme.scale)

                    // Unified cleanly structured Custom Header Row
                    RowLayout {
                        Layout.fillWidth: true
                        
                        RowLayout {
                            spacing: Math.round(6 * Theme.scale)
                            Text {
                                text: "⚠️"
                                color: activeWarningsCard.hasWarning ? Colors.critical : Colors.textMuted
                                font.family: Typography.family
                                font.pixelSize: Typography.labelTab
                            }
                            Text {
                                text: overviewPage.translations["title_active_warnings"][Typography.currentLanguage]
                                color: Colors.textSecondary
                                font.family: Typography.family
                                font.pixelSize: Typography.labelTab
                                font.weight: Font.DemiBold
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: activeWarningsCard.activeCount + " " + overviewPage.translations["status_active"][Typography.currentLanguage]
                            color: activeWarningsCard.hasWarning ? Colors.critical : Colors.success
                            font.family: Typography.family
                            font.pixelSize: Typography.labelTab
                            font.weight: Font.DemiBold
                        }
                    }

                    // Separation Space matching BaseCard top margin rules
                    Item { Layout.preferredHeight: Math.round(4 * Theme.scale) }

                    // Warnings List Body
                    // 1. Motor Temperature
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Math.round(8 * Theme.scale)
                        Text {
                            text: (vehicleData.motorOverTempWarning ? "⚠️  " : "✓  ") + overviewPage.translations["warn_motor_temp"][Typography.currentLanguage]
                            color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textMuted
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            font.weight: vehicleData.motorOverTempWarning ? Font.DemiBold : Font.Normal
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: vehicleData.motorTemp + " °C"
                            color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    // 2. Low Battery
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Math.round(8 * Theme.scale)
                        Text {
                            text: (vehicleData.lowBatteryWarning ? "⚠️  " : "✓  ") + overviewPage.translations["warn_low_battery"][Typography.currentLanguage]
                            color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.textMuted
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            font.weight: vehicleData.lowBatteryWarning ? Font.DemiBold : Font.Normal
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: vehicleData.lowBatteryWarning ? overviewPage.translations["status_active"][Typography.currentLanguage] : overviewPage.translations["status_ok"][Typography.currentLanguage]
                            color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.success
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    // 3. Communication Fault
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Math.round(8 * Theme.scale)
                        Text {
                            text: (vehicleData.communicationFault ? "⚠️  " : "✓  ") + overviewPage.translations["warn_comm_fault"][Typography.currentLanguage]
                            color: vehicleData.communicationFault ? Colors.critical : Colors.textMuted
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            font.weight: vehicleData.communicationFault ? Font.DemiBold : Font.Normal
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: vehicleData.communicationFault ? overviewPage.translations["status_fail"][Typography.currentLanguage] : overviewPage.translations["status_ok"][Typography.currentLanguage]
                            color: vehicleData.communicationFault ? Colors.critical : Colors.success
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyLarge
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }

        // =========================================================================
        // ROW 2: MIDDLE ROW (VEHICLE HEALTH - BAR)
        // =========================================================================
        BaseCard {
            id: vehicleHealthCard
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Math.round(120 * Theme.scale)
            title: overviewPage.translations["title_vehicle_health"][Typography.currentLanguage]

            RowLayout {
                anchors.fill: parent
                spacing: Math.round(10 * Theme.scale)
                anchors.margins: Theme.cardPadding // FIXED: cleared binding target tracking loop

                Repeater {
                    model: [
                        { nameKey: "check_battery", ok: !vehicleData.batteryOverTempWarning },
                        { nameKey: "check_motor", ok: !vehicleData.motorOverTempWarning },
                        { nameKey: "check_controller", ok: true },
                        { nameKey: "check_communication", ok: !vehicleData.communicationFault },
                        { nameKey: "check_thermal", ok: !(vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning) }
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

                                Text { text: overviewPage.translations[modelData.nameKey][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: overviewPage.translations["lbl_normal"][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight }
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: modelData.ok ? overviewPage.translations["status_ok"][Typography.currentLanguage] : overviewPage.translations["status_fail"][Typography.currentLanguage]
                                color: modelData.ok ? Colors.success : Colors.critical
                                font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold
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
            Layout.preferredHeight: Math.round(175 * Theme.scale)
            spacing: overviewPage.gridSpacing

            // QUICK STATS CARD
            BaseCard {
                id: quickStatsCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 54
                title: overviewPage.translations["title_quick_stats"][Typography.currentLanguage]

                GridLayout {
                    anchors.fill: parent
                    columns: 4
                    rowSpacing: Math.round(8 * Theme.scale)
                    columnSpacing: Math.round(14 * Theme.scale)
                    anchors.margins: Theme.cardPadding // FIXED: cleared runtime binding loop target evaluations

                    Repeater {
                        model: [
                            { labelKey: "stat_speed", val: vehicleData.speed, unit: "km/h", highlight: true },
                            { labelKey: "stat_rpm", val: vehicleData.rpm, unit: "RPM", highlight: true },
                            { labelKey: "stat_soc", val: Math.round(vehicleData.batteryPercent), unit: "%", highlight: true },
                            { labelKey: "stat_range", val: vehicleData.rangeKm, unit: "km", highlight: true },
                            { labelKey: "stat_voltage", val: "72.4", unit: "V", highlight: true },
                            { labelKey: "stat_current", val: "18.2", unit: "A", highlight: true },
                            { labelKey: "stat_power", val: vehicleData.motorPower.toFixed(1), unit: "kW", highlight: true },
                            { labelKey: "stat_drive_mode", val: vehicleData.driveMode, unit: vehicleData.gearState, highlight: true }
                        ]
                        
                        delegate: ColumnLayout {
                            spacing: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 0 

                            Text { 
                                text: overviewPage.translations[modelData.labelKey][Typography.currentLanguage]
                                color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                            Text { 
                                text: modelData.val
                                color: Colors.textWarm; font.family: Typography.family
                                font.pixelSize: modelData.highlight ? Typography.titleLarge : Typography.titleMedium
                                font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight
                                renderType: Text.QtRendering 
                            }
                            Text { 
                                text: modelData.unit
                                color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                        }
                    }
                }
            }

            // SYSTEM CHECKS CARD
            BaseCard {
                id: systemChecksCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 46
                title: overviewPage.translations["title_system_checks"][Typography.currentLanguage]

                GridLayout {
                    anchors.fill: parent
                    columns: 3 
                    rowSpacing: Math.round(6 * Theme.scale)
                    columnSpacing: Math.round(6 * Theme.scale)
                    anchors.margins: Theme.cardPadding // FIXED: cleared binding lookup layout traps

                    Repeater {
                        model: [
                            { checkKey: "check_battery_pack" },
                            { checkKey: "check_motor_system" },
                            { checkKey: "check_controller" },
                            { checkKey: "check_current_sensors" },
                            { checkKey: "stat_soc" },
                            { checkKey: "check_comm_module" }
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
                                anchors.margins: Math.round(8 * Theme.scale)
                                spacing: 0

                                Text { text: overviewPage.translations[modelData.checkKey][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: overviewPage.translations["status_ok"][Typography.currentLanguage]; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; elide: Text.ElideRight; Layout.fillWidth: true }
                                
                                Item { Layout.fillHeight: true } 
                            }
                        }
                    }
                }
            }
        }
    }
}