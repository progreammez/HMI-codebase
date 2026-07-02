import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: telemetryPage
    anchors.fill: parent

    readonly property int cardRadius: Theme.controlRadius
    readonly property int paddingSize: Math.round(14 * Theme.scale) 

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_live_params":     { "en": "Live Parameters",       "de": "Live-Parameter",          "es": "Parámetros en Vivo" },
        "title_sim_settings":    { "en": "Simulator Settings",    "de": "Simulator-Einstellungen", "es": "Ajustes del Simulador" },
        "title_param_groups":    { "en": "Parameter Groups",      "de": "Parametergruppen",        "es": "Grupo de Parámetros" },
        "title_param_stats":     { "en": "Parameter Statistics",  "de": "Parameter-Statistik",     "es": "Estadísticas de Parámetros" },
        "title_update_info":     { "en": "Update Information",    "de": "Aktualisierungs-Info",    "es": "Información de Actualización" },
        "title_raw_frame":       { "en": "Raw Telemetry Frame (Latest)", "de": "Roh-Telemetrieframe (Aktuell)", "es": "Trama de Telemetría Raw (Última)" },
        
        "head_parameter":        { "en": "  PARAMETER",           "de": "  PARAMETER",             "es": "  PARÁMETRO" },
        "head_value":            { "en": "VALUE",                 "de": "WERT",                    "es": "VALOR" },
        "head_unit":             { "en": "UNIT ",                 "de": "EINHEIT ",                "es": "UNIDAD " },
        
        "sim_engine":            { "en": "SIMULATION ENGINE",     "de": "SIMULATIONSMOTOR",        "es": "MOTOR DE SIMULACIÓN" },
        "running":               { "en": "RUNNING",               "de": "LÄUFT",                   "es": "EN MARCHA" },
        "stopped":               { "en": "STOPPED",               "de": "ANGEHALTEN",              "es": "DETENIDO" },
        "comm_fault":            { "en": "COMMUNICATION FAULT",   "de": "KOMMUNIKATIONSFEHLER",    "es": "FALLO DE COMUNICACIÓN" },
        "fault_active":          { "en": "FAULT ACTIVE",          "de": "FEHLER AKTIV",            "es": "FALLO ACTIVO" },
        "nominal":               { "en": "NOMINAL",               "de": "NOMINAL",                 "es": "NOMINAL" },

        "lbl_telemetry_rate":    { "en": "Telemetry Rate",        "de": "Telemetrierate",          "es": "Tasa de Telemetría" },
        "lbl_last_frame":        { "en": "Last Frame",            "de": "Letzter Frame",           "es": "Última Trama" },
        "lbl_frame_interval":    { "en": "Frame Interval",        "de": "Frame-Intervall",         "es": "Intervalo de Trama" },
        "lbl_uptime":            { "en": "Uptime",                "de": "Betriebszeit",            "es": "Tiempo Activo" },
        "params_suffix":         { "en": " Params",               "de": " Parameter",              "es": " Parám." },

        "speed":                 { "en": "Speed",                 "de": "Geschwindigkeit",         "es": "Velocidad" },
        "rpm":                   { "en": "RPM",                   "de": "U/min",                   "es": "RPM" },
        "soc":                   { "en": "Battery SOC",           "de": "Batterie-SOC",            "es": "SOC de Batería" },
        "range":                 { "en": "Range",                 "de": "Reichweite",              "es": "Autonomía" },
        "vbat":                  { "en": "Battery Voltage",       "de": "Batteriespannung",        "es": "Voltaje de Batería" },
        "ibat":                  { "en": "Battery Current",       "de": "Batteriestrom",           "es": "Corriente de Batería" },
        "pmot":                  { "en": "Motor Power",           "de": "Motorleistung",           "es": "Potencia del Motor" },
        "regen":                 { "en": "Regen Level",           "de": "Regenerationsstufe",      "es": "Nivel Regeneración" },
        "mode":                  { "en": "Drive Mode",            "de": "Fahrmodus",               "es": "Modo Conducción" },
        "gear":                  { "en": "Gear State",            "de": "Gangstufe",               "es": "Estado de Marcha" },
        "mtmp":                  { "en": "Motor Temp",            "de": "Motortemperatur",         "es": "Temp. del Motor" },
        "btmp":                  { "en": "Battery Temp",          "de": "Batterietemperatur",      "es": "Temp. de Batería" },
        "ctmp":                  { "en": "Controller Temp",       "de": "Steuergerättemp.",        "es": "Temp. Controlador" },
        "chgstat":               { "en": "Charging Status",       "de": "Ladezustand",             "es": "Estado de Carga" },
        "pwr":                   { "en": "Charging Power",        "de": "Ladeleistung",            "es": "Potencia de Carga" },
        "chgtime":               { "en": "Charge Time Remaining", "de": "Verbleibende Ladezeit",    "es": "Tiempo Carga Restante" },
        "odo":                   { "en": "Odometer",              "de": "Kilometerzähler",         "es": "Odómetro" },
        "trip":                  { "en": "Trip Distance",         "de": "Trip-Distanz",            "es": "Distancia de Viaje" },
        "indl":                  { "en": "Left Indicator",        "de": "Blinker links",           "es": "Indicador Izquierdo" },
        "indr":                  { "en": "Right Indicator",       "de": "Blinker rechts",          "es": "Indicador Derecho" },

        "group_core":            { "en": "CORE DATA",             "de": "KERNDATEN",               "es": "DATOS CLAVE" },
        "group_powertrain":      { "en": "POWERTRAIN",            "de": "ANTRIEBSSTRANG",          "es": "TREN MOTRIZ" },
        "group_thermal":         { "en": "THERMAL",               "de": "THERMISCH",               "es": "TÉRMICO" },
        "group_charging":        { "en": "CHARGING",              "de": "LADEVORGANG",             "es": "CARGA" },
        "group_drive":           { "en": "DRIVE INFO",            "de": "FAHR-INFO",               "es": "INFO DE MANEJO" },
        "group_trip":            { "en": "TRIP INFO",             "de": "TRIP-INFO",               "es": "INFO DE VIAJE" },
        "group_indicators":      { "en": "INDICATORS",            "de": "LEUCHTEN",                "es": "INDICADORES" },
        "group_warnings":        { "en": "WARNINGS",              "de": "WARNUNGEN",               "es": "ADVERTENCIAS" },

        "stat_total":            { "en": "TOTAL",                 "de": "GESAMT",                  "es": "TOTAL" },
        "stat_updating":         { "en": "UPDATING",              "de": "AKTUALISIERUNG",          "es": "ACTUALIZANDO" },
        "stat_no_change":        { "en": "NO CHANGE",             "de": "UNVERÄNDERT",             "es": "SIN CAMBIOS" },
        "stat_invalid":          { "en": "INVALID",               "de": "UNGÜLTIG",                "es": "INVÁLIDO" },
        "stat_interval":         { "en": "INTERVAL",              "de": "INTERVALL",               "es": "INTERVALO" },

        "unit_level":            { "en": "Level",                 "de": "Stufe",                   "es": "Nivel" }
    }

    // =====================================================
    // TELEMETRY VALUE BINDINGS CONTROLLER MODEL (TRANSLATED)
    // =====================================================
    ListModel {
        id: leftParamModel
        ListElement { labelKey: "speed";   unit: "km/h";   key: "speed" }
        ListElement { labelKey: "rpm";     unit: "RPM";    key: "rpm" }
        ListElement { labelKey: "soc";     unit: "%";      key: "soc" }
        ListElement { labelKey: "range";   unit: "km";     key: "range" }
        ListElement { labelKey: "vbat";    unit: "V";      key: "vbat" }
        ListElement { labelKey: "ibat";    unit: "A";      key: "ibat" }
        ListElement { labelKey: "pmot";    unit: "kW";     key: "pmot" }
        ListElement { labelKey: "regen";   unitKey: "unit_level"; key: "regen" } // Localized dynamic unit text evaluation
        ListElement { labelKey: "mode";    unit: "-";      key: "mode" }
        ListElement { labelKey: "gear";    unit: "-";      key: "gear" }
    }

    ListModel {
        id: rightParamModel
        ListElement { labelKey: "mtmp";    unit: "°C";    key: "mtmp" }
        ListElement { labelKey: "btmp";    unit: "°C";    key: "btmp" }
        ListElement { labelKey: "ctmp";    unit: "°C";    key: "ctmp" }
        ListElement { labelKey: "chgstat"; unit: "-";     key: "chgstat" }
        ListElement { labelKey: "pwr";     unit: "kW";    key: "pwr" }
        ListElement { labelKey: "chgtime"; unit: "min";   key: "chgtime" }
        ListElement { labelKey: "odo";     unit: "km";    key: "odo" }
        ListElement { labelKey: "trip";    unit: "km";    key: "trip" }
        ListElement { labelKey: "indl";    unit: "-";     key: "indl" }
        ListElement { labelKey: "indr";    unit: "-";     key: "indr" }
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
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 480 
            spacing: telemetryPage.paddingSize

            // -----------------------------------------------------------------
            // LEFT PANEL: LIVE PARAMETERS + SIMULATOR SETTINGS SPLIT
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 58 
                spacing: telemetryPage.paddingSize

                // --- CARD A: LIVE PARAMETERS TABLE ---
                BaseCard {
                    id: liveParamsCard
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 380 
                    title: telemetryPage.translations["title_live_params"][Typography.currentLanguage]

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Math.round(6 * Theme.scale)
                        spacing: Math.round(32 * Theme.scale) 

                        // Left Table Pillar
                        ColumnLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2

                            RowLayout {
                                Layout.fillWidth: true; Layout.preferredHeight: Math.round(28 * Theme.scale); spacing: 4
                                Text { text: telemetryPage.translations["head_parameter"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: telemetryPage.translations["head_value"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: telemetryPage.translations["head_unit"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: leftParamModel
                                delegate: Rectangle {
                                    Layout.fillWidth: true; Layout.fillHeight: true 
                                    color: index % 2 === 0 ? "transparent" : Colors.surfaceSunken
                                    opacity: Colors.isLightMode ? 0.35 : 0.95 
                                    radius: 4
                                    
                                    RowLayout {
                                        anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8; spacing: 4
                                        Text { text: telemetryPage.translations[model.labelKey][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "soc" || model.key === "range" || model.key === "speed" || model.key === "rpm") ? Colors.borderActive : Colors.textPrimary
                                            font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter; renderType: Text.QtRendering
                                            elide: Text.ElideRight
                                        }
                                        Text { text: model.unitKey ? telemetryPage.translations[model.unitKey][Typography.currentLanguage] : model.unit; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }

                        // Right Table Pillar
                        ColumnLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2

                            RowLayout {
                                Layout.fillWidth: true; Layout.preferredHeight: Math.round(28 * Theme.scale); spacing: 4
                                Text { text: telemetryPage.translations["head_parameter"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: telemetryPage.translations["head_value"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight }
                                Text { text: telemetryPage.translations["head_unit"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }

                            Repeater {
                                model: rightParamModel
                                delegate: Rectangle {
                                    Layout.fillWidth: true; Layout.fillHeight: true 
                                    color: index % 2 === 0 ? "transparent" : Colors.surfaceSunken
                                    opacity: Colors.isLightMode ? 0.35 : 0.95; radius: 4
                                    
                                    RowLayout {
                                        anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8; spacing: 4
                                        Text { text: telemetryPage.translations[model.labelKey][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; Layout.fillWidth: true; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                                        Text { 
                                            text: telemetryPage.resolveValue(model.key)
                                            color: (model.key === "mtmp" || model.key === "btmp" || model.key === "ctmp" || model.key === "odo" || model.key === "trip") ? Colors.borderActive : Colors.textPrimary
                                            font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold
                                            Layout.preferredWidth: Math.round(95 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter; renderType: Text.QtRendering
                                            elide: Text.ElideRight
                                        }
                                        Text { text: model.unit; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.preferredWidth: Math.round(65 * Theme.scale); horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                    }
                }

                // --- CARD B: SIMULATOR SETTINGS ---
                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 100
                    title: telemetryPage.translations["title_sim_settings"][Typography.currentLanguage]

                    RowLayout {
                        anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                        // Toggle 1: Simulation Engine
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; radius: Theme.controlRadius
                            color: vehicleData.simulationActive ? Colors.surfaceSunken : "transparent"
                            border.color: vehicleData.simulationActive ? Colors.success : Colors.borderSubtle
                            border.width: 1.5 

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Math.round(6 * Theme.scale); anchors.rightMargin: Math.round(6 * Theme.scale)
                                anchors.topMargin: Math.round(8 * Theme.scale); anchors.bottomMargin: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { text: telemetryPage.translations["sim_engine"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.max(9, Typography.label * 0.9); font.weight: Font.Bold; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                                Text { text: vehicleData.simulationActive ? telemetryPage.translations["running"][Typography.currentLanguage] : telemetryPage.translations["stopped"][Typography.currentLanguage]; color: vehicleData.simulationActive ? Colors.success : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            }
                            MouseArea { anchors.fill: parent; onClicked: vehicleData.simulationActive = !vehicleData.simulationActive }
                        }

                        // Toggle 2: Communication Network Fault
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; radius: Theme.controlRadius
                            color: vehicleData.communicationFault ? Colors.surfaceSunken : "transparent"
                            border.color: vehicleData.communicationFault ? Colors.critical : Colors.borderSubtle
                            border.width: 1.5

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Math.round(6 * Theme.scale); anchors.rightMargin: Math.round(6 * Theme.scale)
                                anchors.topMargin: Math.round(8 * Theme.scale); anchors.bottomMargin: Math.round(8 * Theme.scale)
                                spacing: 4

                                Text { text: telemetryPage.translations["comm_fault"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.max(9, Typography.label * 0.9); font.weight: Font.Bold; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                                Text { text: vehicleData.communicationFault ? telemetryPage.translations["fault_active"][Typography.currentLanguage] : telemetryPage.translations["nominal"][Typography.currentLanguage]; color: vehicleData.communicationFault ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
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
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 42
                spacing: telemetryPage.paddingSize

                // --- 1. PARAMETER GROUPS GRID ---
                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 260
                    title: telemetryPage.translations["title_param_groups"][Typography.currentLanguage]

                    GridLayout {
                        anchors.fill: parent; columns: 3
                        rowSpacing: Math.round(10 * Theme.scale); columnSpacing: Math.round(10 * Theme.scale)

                        Repeater {
                            model: [
                                { nameKey: "group_core", count: "10", icon: "⏰" },
                                { nameKey: "group_powertrain", count: "6", icon: "⚙" },
                                { nameKey: "group_thermal", count: "3", icon: "🌡" },
                                { nameKey: "group_charging", count: "3", icon: "🔋" },
                                { nameKey: "group_drive", count: "2", icon: "🛞" },
                                { nameKey: "group_trip", count: "2", icon: "🗺" },
                                { nameKey: "group_indicators", count: "5", icon: "💡" },
                                { nameKey: "group_warnings", count: "5", icon: "⚠" }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true; radius: Theme.controlRadius
                                color: Colors.surfaceSunken; border.width: 1
                                border.color: modelData.nameKey === "group_warnings" && vehicleData.communicationFault ? Colors.critical : Colors.borderSubtle

                                RowLayout {
                                    anchors.fill: parent; anchors.margins: Math.round(8 * Theme.scale); spacing: Math.round(8 * Theme.scale)
                                    Text { text: modelData.icon; font.pixelSize: Typography.titleMedium; Layout.alignment: Qt.AlignVCenter }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; spacing: 2
                                        Text { text: telemetryPage.translations[modelData.nameKey][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.count + telemetryPage.translations["params_suffix"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                        Item { Layout.fillWidth: true; Layout.fillHeight: true } 
                    }
                }

                // --- 2. PARAMETER STATISTICS ---
                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 90
                    title: telemetryPage.translations["title_param_stats"][Typography.currentLanguage]

                    RowLayout {
                        anchors.fill: parent; spacing: Math.round(6 * Theme.scale)

                        Repeater {
                            model: [
                                { titleKey: "stat_total", val: "36", col: Colors.textPrimary },
                                { titleKey: "stat_updating", val: "100%", col: Colors.success },
                                { titleKey: "stat_no_change", val: "0%", col: Colors.warning },
                                { titleKey: "stat_invalid", val: "0%", col: Colors.critical },
                                { titleKey: "stat_interval", val: "20 ms", col: Colors.borderActive }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true
                                Layout.minimumWidth: Math.round(55 * Theme.scale); radius: Theme.controlRadius
                                color: Colors.surfaceSunken; border.color: Colors.borderSubtle; border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.topMargin: Math.round(4 * Theme.scale); anchors.bottomMargin: Math.round(4 * Theme.scale)
                                    anchors.leftMargin: Math.round(2 * Theme.scale); anchors.rightMargin: Math.round(2 * Theme.scale)
                                    spacing: 1

                                    Text { 
                                        text: telemetryPage.translations[modelData.titleKey][Typography.currentLanguage]
                                        color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.max(9, Typography.label * 0.8); font.weight: Font.Bold
                                        elide: Text.ElideRight; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter 
                                    }
                                    Text { 
                                        text: modelData.val; color: modelData.col; font.family: "Courier New"
                                        font.pixelSize: Math.max(11, Typography.bodyMedium * 0.9); font.weight: Font.Bold
                                        Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; renderType: Text.QtRendering
                                    }
                                }
                            }
                        }
                    }
                }

                // --- 3. UPDATE INFORMATION ---
                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 90
                    title: telemetryPage.translations["title_update_info"][Typography.currentLanguage]

                    GridLayout {
                        anchors.fill: parent; columns: 2
                        rowSpacing: Math.round(4 * Theme.scale); columnSpacing: Math.round(24 * Theme.scale)

                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: telemetryPage.translations["lbl_telemetry_rate"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "50 Hz"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: telemetryPage.translations["lbl_last_frame"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "14:32:11.020"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: telemetryPage.translations["lbl_frame_interval"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "20 ms"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: telemetryPage.translations["lbl_uptime"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "02:14:37"; color: Colors.borderActive; font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        }
                    }
                }
            }
        }

        // -----------------------------------------------------------------
        // BOTTOM TRACK: RAW TELEMETRY FRAME LOGGER
        // -----------------------------------------------------------------
        BaseCard {
            Layout.fillWidth: true; Layout.preferredHeight: Math.round(85 * Theme.scale) 
            title: telemetryPage.translations["title_raw_frame"][Typography.currentLanguage]

            Text {
                anchors.left: parent.left; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; anchors.leftMargin: 12
                text: "SPD=" + vehicleData.speed + "  RPM=" + vehicleData.rpm + "  SOC=" + vehicleData.batteryPercent + "  RNG=" + vehicleData.rangeKm + "  VBAT=72.4  IBAT=18.2  PMOT=" + vehicleData.motorPower.toFixed(1) + "  REGEN=" + vehicleData.regenLevel + "  MTMP=" + vehicleData.motorTemp + "  BTMP=" + vehicleData.batteryTemp + "  CTMP=" + vehicleData.controllerTemp + "  GEAR=" + vehicleData.gearState + "  MODE=" + vehicleData.driveMode + "  COMMFLT=" + (vehicleData.communicationFault ? "1" : "0")
                color: vehicleData.communicationFault ? Colors.critical : (Colors.isLightMode ? "#1A6E13" : "#00FF66") 
                font.family: "Courier New"; font.pixelSize: Typography.bodyMedium; font.bold: true
                elide: Text.ElideRight; renderType: Text.QtRendering
            }
        }
    }
}