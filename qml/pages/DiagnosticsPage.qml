import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
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
        return vehicleData.communicationFault ? "UNKNOWN" : "OK"
    }

    property string commsHealthStatus: {
        return vehicleData.communicationFault ? "COMMUNICATION FAULT" : "OK"
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
        if (vehicleData.lowBatteryWarning) score -= 10
        if (vehicleData.lowRangeWarning) score -= 10
        if (vehicleData.motorOverTempWarning) score -= 20
        if (vehicleData.batteryOverTempWarning) score -= 30
        if (vehicleData.communicationFault) score -= 50
        return Math.max(0, score)
    }

    readonly property bool isMetric: Typography.unitSystem === "metric"

    readonly property real unitSpeedFactor: isMetric ? 1 : 0.62137

    readonly property string unitSpeedLabel: isMetric ? " km" : " mi"
    readonly property string unitTempLabel: isMetric ? "°C" : "°F"

    function displayTemp(celsius) {
        return isMetric
                ? celsius
                : ((celsius * 9 / 5) + 32)
    }

    function displayDistance(km) {
        return isMetric
                ? km
                : (km * 0.62137)
    }

    // =====================================================
    // HARDCODED TRANSLATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "vehicle_overview":   { "en": "Vehicle Overview",   "de": "Fahrzeugübersicht",      "es": "Descripción del Vehículo" },
        "unavailable":        { "en": "Unavailable",        "de": "Nicht verfügbar",        "es": "No Disponible" },
        "temperature_status": { "en": "Temperature Status", "de": "Temperaturstatus",       "es": "Estado de la Temperatura" },
        "vehicle_health":     { "en": "Vehicle Health",     "de": "Fahrzeuggesundheit",     "es": "Salud del Vehículo" },
        "inactive_warnings":  { "en": "Inactive Warnings",  "de": "Inaktive Warnungen",     "es": "Advertencias Inactivas" },
        "active_warnings":    { "en": "Active Warnings",    "de": "Aktive Warnungen",       "es": "Advertencias Activas" },
        "powertrain_data":    { "en": "Powertrain Data",    "de": "Antriebsstrangdaten",    "es": "Datos del Tren Motriz" },
        "fault_history":      { "en": "Fault History",      "de": "Fehlerhistorie",         "es": "Historial de Fallos" },
        
        "front":              { "en": "FRONT",              "de": "VORNE",                  "es": "DELANTERO" },
        "rear":               { "en": "REAR",               "de": "HINTEN",                 "es": "TRASERO" },
        "motor":              { "en": "Motor",              "de": "Motor",                  "es": "Motor" },
        "battery_pack":       { "en": "Battery Pack",       "de": "Batteriepack",           "es": "Paquete de Baterías" },
        "controller":         { "en": "Controller",         "de": "Steuergerät",            "es": "Controlador" },
        "comms":              { "en": "Comms",              "de": "Kommunikation",          "es": "Comunicaciones" },
        "pack_voltage":       { "en": "Pack Voltage",       "de": "Pack-Spannung",          "es": "Voltaje del Paquete" },
        "pack_current":       { "en": "Pack Current",       "de": "Pack-Strom",             "es": "Corriente del Paquete" },
        
        "legend_normal":      { "en": "< 50°C Normal",      "de": "< 50°C Normal",          "es": "< 50°C Normal" },
        "legend_elevated":    { "en": "50°C - 70°C Elevated","de": "50°C - 70°C Erhöht",     "es": "50°C - 70°C Elevado" },
        "legend_high":        { "en": "> 70°C High",        "de": "> 70°C Hoch",            "es": "> 70°C Alto" },

        "overall_score":      { "en": "Overall Score",      "de": "Gesamtwertung",          "es": "Puntuación General" },
        "status":             { "en": "Status",             "de": "Status",                 "es": "Estado" },
        "acknowledge":        { "en": "ACKNOWLEDGE",        "de": "BESTÄTIGEN",             "es": "RECONOCER" },
        
        "OK":                 { "en": "OK",                 "de": "OK",                     "es": "OK" },
        "UNKNOWN":            { "en": "UNKNOWN",            "de": "UNBEKANNT",              "es": "DESCONOCIDO" },
        "OVERHEATING":        { "en": "OVERHEATING",        "de": "ÜBERHITZUNG",            "es": "SOBRECALENTAMIENTO" },
        "LOW BATTERY":        { "en": "LOW BATTERY",        "de": "SCHWACHE BATTERIE",      "es": "BATERÍA BAJA" },
        "COMMUNICATION FAULT":{ "en": "COMMUNICATION FAULT","de": "KOMMUNIKATIONSFEHLER",    "es": "FALLO DE COMUNICACIÓN" },
        "FAULT":              { "en": "FAULT",              "de": "FEHLER",                 "es": "FALLO" },
        "CRITICAL":           { "en": "CRITICAL",           "de": "KRITISCH",               "es": "CRÍTICO" },
        "WARNING":            { "en": "WARNING",            "de": "WARNUNG",                "es": "ADVERTENCIA" },
        "HEALTHY":            { "en": "HEALTHY",            "de": "GESUND",                 "es": "SALUDABLE" },
        "OFFLINE":            { "en": "OFFLINE",            "de": "OFFLINE",                "es": "FUERA DE LÍNEA" },
        "CONNECTED":          { "en": "CONNECTED",          "de": "VERBUNDEN",              "es": "CONECTADO" },
        "NORMAL":             { "en": "NORMAL",             "de": "NORMAL",                 "es": "NORMAL" },
        "STABLE":             { "en": "STABLE",             "de": "STABIL",                 "es": "ESTABLE" },
        "NO ACTIVE WARNINGS": { "en": "NO ACTIVE WARNINGS", "de": "KEINE AKTIVEN WARNUNGEN", "es": "SIN ADVERTENCIAS ACTIVAS" },
        
        "comms_fault_desc":   { "en": "Telemetry connection lost. Diagnostic data unavailable.", "de": "Telemetrieverbindung verloren. Diagnosedaten nicht verfügbar.", "es": "Conexión de telemetría perdida. Datos de diagnóstico no disponibles." },
        "active_warnings_desc":{ "en": "One or more vehicle alerts require attention.", "de": "Eine oder mehrere Fahrzeugwarnungen erfordern Aufmerksamkeit.", "es": "Una o más alertas del vehículo requieren atención." },
        "healthy_desc":       { "en": "All systems are functioning normally.", "de": "Alle Systeme funktionieren normal.", "es": "Todos los sistemas funcionan normalmente." },
        "current_fault":      { "en": "Current Fault",      "de": "Aktueller Fehler",       "es": "Fallo Actual" },
        "last_fault":         { "en": "Last Fault (Historical)", "de": "Letzter Fehler (Historisch)", "es": "Último Fallo (Histórico)" },
        "no_active_faults":   { "en": "No active faults",   "de": "Keine aktiven Fehler",    "es": "Sin fallos activos" },
        
        "active_label":       { "en": "Active",             "de": "Aktiv",                  "es": "Activo" },
        "resolved_label":     { "en": "Resolved",           "de": "Gelöst",                 "es": "Resuelto" },
        "connection_lost":    { "en": "Connection Lost",    "de": "Verbindung unterbrochen","es": "Conexión Perdida" },
        "historical_label":   { "en": "Historical",         "de": "Historisch",             "es": "Histórico" },
        
        "metric_voltage":     { "en": "Battery Voltage",    "de": "Batteriespannung",       "es": "Voltaje de la Batería" },
        "metric_current":     { "en": "Battery Current",    "de": "Batteriestrom",          "es": "Corriente de la Batería" },
        "metric_power":       { "en": "Motor Power",        "de": "Motorleistung",          "es": "Potencia del Motor" },
        "metric_regen":       { "en": "Regen Level",        "de": "Regenerationsstufe",     "es": "Nivel de lluvia" },
        
        "no_recent_faults":   { "en": "No Recent Faults",   "de": "Keine aktuellen Fehler", "es": "Sin Fallos Recientes" },
        "stream_unavailable": { "en": "Telemetry stream unavailable", "de": "Telemetriestream nicht verfügbar", "es": "Flujo de telemetría no disponible" },
        "history_paused":     { "en": "History updates paused", "de": "Verlaufsaktualisierungen angehalten", "es": "Actualizaciones de historial pausadas" },
        "sys_normal":         { "en": "System operating normally", "de": "System läuft normal", "es": "El sistema funciona con normalidad." },
        
        "badge_battery":      { "en": "Battery",            "de": "Batterie",               "es": "Batería" },
        "badge_powertrain":   { "en": "Powertrain",         "de": "Antriebsstrang",         "es": "Tren Motriz" },
        "badge_thermal":      { "en": "Thermal",            "de": "Thermisch",              "es": "Térmico" },
        "badge_communication":{ "en": "Communication",     "de": "Kommunikation",          "es": "Comunicación" },
        "sub_range":          { "en": "Range",              "de": "Reichweite",             "es": "Rango" },
        "sub_motor_power":    { "en": "Motor Power",        "de": "Motorleistung",          "es": "Potencia del Motor" },
        "sub_max_temp":       { "en": "Max Temp",           "de": "Max. Temp.",             "es": "Temp Máx" }
    }

    property int cardSpacing: Theme.cardGap ? Theme.cardGap : 10
    property int innerMargin: Theme.cardPadding ? Theme.cardPadding : 14

    QtObject {
        id: settingsState
        property int brightness: typeof root !== 'undefined' ? root.globalBrightness : 70
        property int contrast: 55
        property int alertVolume: 66
        property int indicatorVolume: 40
        property int masterVolume: Math.round((alertVolume + indicatorVolume) / 2)

        property string fontStyle: typeof root !== 'undefined' ? root.globalFont : "Rajdhani"
        property string language: Typography.currentLanguage         
        property string dayNightMode: Colors.dayNightMode

        property string units: "metric"     
        property int clockFormat: Typography.timeFormat === "HH:mm" ? 24 : 12          
        property string dateFormat: "dd"        
    }

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
                elide: Text.ElideRight 
            }

            Item {
                id: contentContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        default property alias cardContent: contentContainer.data
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin 
        spacing: Theme.sectionGap 

        // =====================================================================
        // LEFT COLUMN MODULE AREA (40%)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.40
            Layout.preferredHeight: Math.round(440 * Theme.scale) 
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            DashboardCard {
                title: vehicleData.communicationFault 
                       ? (diagnosticsCoreGrid.translations["vehicle_overview"][Typography.currentLanguage] + "  • " + diagnosticsCoreGrid.translations["unavailable"][Typography.currentLanguage]) 
                       : diagnosticsCoreGrid.translations["vehicle_overview"][Typography.currentLanguage]
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Item {
                    anchors.fill: parent
                    
                    Item {
                        id: chassisFrame
                        anchors.centerIn: parent
                        width: Math.round(146 * Theme.scale)
                        height: Math.round(264 * Theme.scale)

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: Colors.borderSubtle
                            border.width: 1.5
                            topLeftRadius: 42
                            topRightRadius: 42
                            bottomLeftRadius: 28
                            bottomRightRadius: 28

                            Rectangle {
                                width: parent.width * 0.65
                                height: 2
                                color: Colors.borderSubtle
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Text { 
                            text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["connection_lost"][Typography.currentLanguage].toUpperCase() : diagnosticsCoreGrid.translations["front"][Typography.currentLanguage]
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
                            text: vehicleData.communicationFault ? "" : diagnosticsCoreGrid.translations["rear"][Typography.currentLanguage]
                            anchors.top: parent.bottom
                            anchors.topMargin: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: Typography.family
                            font.pixelSize: Typography.label
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.2
                            color: Colors.textMuted 
                        }

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

                        ChassisWheel { id: frontLeftWheel;  anchors.right: parent.left;  anchors.rightMargin: -5; anchors.top: parent.top;       anchors.topMargin: Math.round(30 * Theme.scale) }
                        ChassisWheel { id: frontRightWheel; anchors.left: parent.right;  anchors.leftMargin: -5; anchors.top: parent.top;       anchors.topMargin: Math.round(30 * Theme.scale) }
                        ChassisWheel { id: rearLeftWheel;   anchors.right: parent.left;  anchors.rightMargin: -5; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(34 * Theme.scale) }
                        ChassisWheel { id: rearRightWheel;  anchors.left: parent.right;  anchors.leftMargin: -5; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(34 * Theme.scale) }
                    }

                    ColumnLayout {
                        anchors.centerIn: chassisFrame
                        spacing: Math.round(6 * Theme.scale)

                        Rectangle {
                            width: Math.round(112 * Theme.scale)
                            height: Math.round(58 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius
                            Layout.alignment: Qt.AlignHCenter

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(4 * Theme.scale)
                                spacing: 2
                                Text { 
                                    text: diagnosticsCoreGrid.translations["motor"][Typography.currentLanguage]
                                    font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary
                                    Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter 
                                }
                                Text { text: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.motorTemp)) + unitTempLabel; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco; Layout.alignment: Qt.AlignVCenter } 
                                    Text { text: vehicleData.communicationFault ? "--" : diagnosticsCoreGrid.translations["OK"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } 
                                }
                            }
                        }

                        Rectangle {
                            id: coreBatteryBlock
                            width: Math.round(120 * Theme.scale) 
                            height: Math.round(74 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderWarm 
                            border.width: 1.5
                            radius: Theme.controlRadius

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(4 * Theme.scale)
                                spacing: 2
                                Text { 
                                    text: diagnosticsCoreGrid.translations["battery_pack"][Typography.currentLanguage]
                                    font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary
                                    Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter 
                                }
                                Text { text: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.batteryTemp)) + unitTempLabel; font.family: Typography.family; font.pixelSize: Typography.titleSmall; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco; Layout.alignment: Qt.AlignVCenter } 
                                    Text { text: vehicleData.communicationFault ? "--" : diagnosticsCoreGrid.translations["OK"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } 
                                }
                            }
                        }

                        Rectangle {
                            width: Math.round(112 * Theme.scale)
                            height: Math.round(58 * Theme.scale)
                            color: Colors.surfaceSunken
                            border.color: Colors.borderSubtle
                            radius: Theme.controlRadius
                            Layout.alignment: Qt.AlignHCenter

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(4 * Theme.scale)
                                spacing: 2
                                Text { 
                                    text: diagnosticsCoreGrid.translations["controller"][Typography.currentLanguage]
                                    font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textSecondary
                                    Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter 
                                }
                                Text { text: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.controllerTemp)) + unitTempLabel; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Normal; color: Colors.textPrimary; Layout.alignment: Qt.AlignHCenter }
                                RowLayout { 
                                    spacing: 4; Layout.alignment: Qt.AlignHCenter
                                    Rectangle { width: 4; height: 4; radius: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco; Layout.alignment: Qt.AlignVCenter } 
                                    Text { text: vehicleData.communicationFault ? "--" : diagnosticsCoreGrid.translations["OK"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.DemiBold; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } 
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: packVoltageCard
                        anchors.left: parent.left
                        anchors.leftMargin: Math.round(12 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.round(115 * Theme.scale) // FIXED: Expanded box boundaries for longer language strings
                        height: Math.round(58 * Theme.scale)
                        color: "transparent"
                        border.color: Colors.borderSubtle
                        border.width: 1
                        radius: 6

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Math.round(4 * Theme.scale)
                            spacing: 2
                            
                            Text { 
                                text: vehicleData.communicationFault ? "--" : "72.4 V"
                                font.family: Typography.family; font.pixelSize: Typography.bodyLarge
                                font.weight: Font.Normal; color: Colors.accentCity
                                Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { 
                                text: diagnosticsCoreGrid.translations["pack_voltage"][Typography.currentLanguage]
                                font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter // FIXED: Forces elision safe clips
                            }
                        }
                    }

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

                    Rectangle {
                        id: packCurrentCard
                        anchors.right: parent.right
                        anchors.rightMargin: Math.round(12 * Theme.scale)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.round(115 * Theme.scale) // FIXED: Symmetrical box width adaptations
                        height: Math.round(58 * Theme.scale)
                        color: "transparent"
                        border.color: Colors.borderSubtle
                        border.width: 1
                        radius: 6

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Math.round(4 * Theme.scale)
                            spacing: 2
                            
                            Text { 
                                text: vehicleData.communicationFault ? "--" : "18.2 A"
                                font.family: Typography.family; font.pixelSize: Typography.bodyLarge
                                font.weight: Font.Normal; color: Colors.accentCity
                                Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { 
                                text: diagnosticsCoreGrid.translations["pack_current"][Typography.currentLanguage]
                                font.family: Typography.family; font.pixelSize: 10; color: Colors.textMuted
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter // FIXED: Bounded text row protection
                            }
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

            DashboardCard {
                title: vehicleData.communicationFault 
                       ? (diagnosticsCoreGrid.translations["temperature_status"][Typography.currentLanguage] + " • " + diagnosticsCoreGrid.translations["unavailable"][Typography.currentLanguage]) 
                       : diagnosticsCoreGrid.translations["temperature_status"][Typography.currentLanguage]
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(190 * Theme.scale) 

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Math.round(8 * Theme.scale)

                    component TemperatureMetricRow : RowLayout {
                        property string moduleName: ""
                        property string currentTemp: ""
                        property int temperature: 0

                        readonly property real fillRatio: vehicleData.communicationFault ? 0.0 : Math.min(temperature / 80.0, 1.0)
                        readonly property color statusColor: vehicleData.communicationFault
                                                                    ? Colors.textMuted
                                                                    : temperature > 70
                                                                        ? Colors.critical
                                                                        : temperature >= 50
                                                                            ? Colors.warning
                                                                            : Colors.accentCity

                        Text { 
                            text: moduleName; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Medium; color: Colors.textPrimary
                            Layout.preferredWidth: Math.round(112 * Theme.scale) 
                            Layout.alignment: Qt.AlignVCenter
                            elide: Text.ElideRight 
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 3
                            Layout.alignment: Qt.AlignVCenter
                            Repeater {
                                model: 12
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: Math.round(10 * Theme.scale)
                                    color: vehicleData.communicationFault ? Colors.textMuted : (index / 12.0 < fillRatio) ? statusColor : Colors.surfaceSunken
                                    opacity: (index / 12.0 < fillRatio) ? 1.0 : 0.35
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
                            Layout.preferredWidth: Math.round(55 * Theme.scale)
                            Layout.minimumWidth: Math.round(55 * Theme.scale)
                            Layout.rightMargin: Math.round(10 * Theme.scale) // FIXED: Adds custom right spacing buffer from panel frame border
                            horizontalAlignment: Text.AlignRight
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    TemperatureMetricRow { moduleName: diagnosticsCoreGrid.translations["motor"][Typography.currentLanguage]; temperature: vehicleData.motorTemp; currentTemp: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.motorTemp)) + unitTempLabel }
                    TemperatureMetricRow { moduleName: diagnosticsCoreGrid.translations["battery_pack"][Typography.currentLanguage]; temperature: vehicleData.batteryTemp; currentTemp: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.batteryTemp)) + unitTempLabel }
                    TemperatureMetricRow { moduleName: diagnosticsCoreGrid.translations["controller"][Typography.currentLanguage]; temperature: vehicleData.controllerTemp; currentTemp: vehicleData.communicationFault ? "--" : Math.round(displayTemp(vehicleData.controllerTemp)) + unitTempLabel } 
                    
                    Item { Layout.preferredHeight: 2 }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        RowLayout { spacing: 5; Layout.alignment: Qt.AlignVCenter; Rectangle { width: 8; height: 8; radius: 4; color: Colors.accentCity; Layout.alignment: Qt.AlignVCenter } Text { text: diagnosticsCoreGrid.translations["legend_normal"][Typography.currentLanguage]; font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } }
                        Item { Layout.fillWidth: true }
                        RowLayout { spacing: 5; Layout.alignment: Qt.AlignVCenter; Rectangle { width: 8; height: 8; radius: 4; color: Colors.warning; Layout.alignment: Qt.AlignVCenter } Text { text: diagnosticsCoreGrid.translations["legend_elevated"][Typography.currentLanguage]; font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } }
                        Item { Layout.fillWidth: true }
                        RowLayout { spacing: 5; Layout.alignment: Qt.AlignVCenter; Rectangle { width: 8; height: 8; radius: 4; color: Colors.critical; Layout.alignment: Qt.AlignVCenter } Text { text: diagnosticsCoreGrid.translations["legend_high"][Typography.currentLanguage]; font.weight: Font.DemiBold; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary; Layout.alignment: Qt.AlignVCenter } }
                    }
                }
            }
        }

        // =====================================================================
        // RIGHT COLUMN MODULE AREA (60%)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.60
            Layout.fillHeight: true
            spacing: Theme.sectionGap

            // ROW 1: HEALTH & WARNINGS
            RowLayout {
                Layout.preferredHeight: Math.round(268 * Theme.scale)
                spacing: Theme.sectionGap
                Layout.fillWidth: true
                Layout.fillHeight: true

                DashboardCard {
                    title: vehicleData.communicationFault 
                           ? (diagnosticsCoreGrid.translations["vehicle_health"][Typography.currentLanguage] + " • " + diagnosticsCoreGrid.translations["CRITICAL"][Typography.currentLanguage]) 
                           : diagnosticsCoreGrid.translations["vehicle_health"][Typography.currentLanguage]
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            Text {
                                text: diagnosticsCoreGrid.translations["overall_score"][Typography.currentLanguage]
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                color: Colors.textPrimary
                                font.weight: Font.DemiBold
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? "--" : healthScore + "%"
                                font.family: Typography.family
                                font.pixelSize: Typography.titleMedium
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault ? Colors.textMuted :
                                       overallHealthStatus === "HEALTHY" ? Colors.accentCity :
                                       overallHealthStatus === "WARNING" ? Colors.warning : Colors.critical
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            Text {
                                text: diagnosticsCoreGrid.translations["status"][Typography.currentLanguage]
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                color: Colors.textPrimary
                                font.weight: Font.DemiBold
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["OFFLINE"][Typography.currentLanguage] : diagnosticsCoreGrid.translations[overallHealthStatus][Typography.currentLanguage]
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyLarge
                                font.weight: Font.Bold
                                color: vehicleData.communicationFault ? Colors.textMuted :
                                       overallHealthStatus === "HEALTHY" ? Colors.accentCity :
                                       overallHealthStatus === "WARNING" ? Colors.warning : Colors.critical
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }
                        
                        component DiagnosticLineItem : RowLayout {
                            property string itemLabel: ""
                            property string itemStatus: "OK"
                            property string itemStatusKey: "OK"
                            spacing: 8
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            Rectangle {
                                width: 8; height: 8; radius: 4; Layout.alignment: Qt.AlignVCenter
                                color: itemStatusKey === "OK" ? Colors.accentEco :
                                       itemStatusKey === "LOW BATTERY" ? Colors.warning :
                                       itemStatusKey === "OVERHEATING" ? Colors.critical :
                                       itemStatusKey === "COMMUNICATION FAULT" ? Colors.critical :
                                       itemStatusKey === "FAULT" ? Colors.critical :
                                       itemStatusKey === "CRITICAL" ? Colors.critical : Colors.textMuted
                            }
                            Text { 
                                text: itemLabel; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; color: Colors.textPrimary
                                Layout.fillWidth: true
                                elide: Text.ElideRight 
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                text: itemStatus
                                font.family: Typography.family
                                font.pixelSize: Typography.titleSmall
                                font.weight: Font.Bold
                                color: itemStatusKey === "OK" ? Colors.accentEco :
                                       itemStatusKey === "WARNING" ? Colors.warning :
                                       itemStatusKey === "FAULT" ? Colors.critical :
                                       itemStatusKey === "OVERHEATING" ? Colors.critical :
                                       itemStatusKey === "LOW BATTERY" ? Colors.warning :
                                       itemStatusKey === "COMMUNICATION FAULT" ? Colors.critical :
                                       itemStatusKey === "CRITICAL" ? Colors.critical : Colors.textMuted
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                        
                        DiagnosticLineItem { itemLabel: diagnosticsCoreGrid.translations["battery_pack"][Typography.currentLanguage]; itemStatus: diagnosticsCoreGrid.translations[batteryHealthStatus][Typography.currentLanguage]; itemStatusKey: batteryHealthStatus }
                        DiagnosticLineItem { itemLabel: diagnosticsCoreGrid.translations["motor"][Typography.currentLanguage]; itemStatus: diagnosticsCoreGrid.translations[motorHealthStatus][Typography.currentLanguage]; itemStatusKey: motorHealthStatus }
                        DiagnosticLineItem { itemLabel: diagnosticsCoreGrid.translations["controller"][Typography.currentLanguage]; itemStatus: diagnosticsCoreGrid.translations[controllerHealthStatus][Typography.currentLanguage]; itemStatusKey: controllerHealthStatus }
                        DiagnosticLineItem { itemLabel: diagnosticsCoreGrid.translations["comms"][Typography.currentLanguage]; itemStatus: diagnosticsCoreGrid.translations[commsHealthStatus][Typography.currentLanguage]; itemStatusKey: commsHealthStatus }        
                    }
                }

                DashboardCard {
                    id: activeWarningsCard
                    property int activeWarnings: (vehicleData.communicationFault ? 1 : 0) +
                                                 (vehicleData.lowBatteryWarning ? 1 : 0) +
                                                 (vehicleData.lowRangeWarning ? 1 : 0) +
                                                 (vehicleData.motorOverTempWarning ? 1 : 0) +
                                                 (vehicleData.batteryOverTempWarning ? 1 : 0)
                    title: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["inactive_warnings"][Typography.currentLanguage] : diagnosticsCoreGrid.translations["active_warnings"][Typography.currentLanguage]
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
                                text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["COMMUNICATION FAULT"][Typography.currentLanguage] : vehicleData.hasWarning ? diagnosticsCoreGrid.translations["active_warnings"][Typography.currentLanguage].toUpperCase() : diagnosticsCoreGrid.translations["NO ACTIVE WARNINGS"][Typography.currentLanguage]
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity
                                font.family: Typography.family
                                font.pixelSize: Typography.bodyMedium
                                font.bold: true
                                font.letterSpacing: 0.5
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["comms_fault_desc"][Typography.currentLanguage] : vehicleData.hasWarning ? diagnosticsCoreGrid.translations["active_warnings_desc"][Typography.currentLanguage] : diagnosticsCoreGrid.translations["healthy_desc"][Typography.currentLanguage]
                                color: Colors.textSecondary
                                font.family: Typography.family
                                font.pixelSize: Typography.bodySmall
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
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
                                text: activeWarningsCard.activeWarnings > 0 ? diagnosticsCoreGrid.translations["current_fault"][Typography.currentLanguage] : diagnosticsCoreGrid.translations["last_fault"][Typography.currentLanguage]
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.DemiBold
                                color: Colors.textSecondary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40; radius: Theme.controlRadius
                                color: Qt.rgba(1, 1, 1, 0.02)
                                border.color: Colors.borderSubtle; border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 8

                                    Text { 
                                        text: vehicleData.communicationFault ? "X" : vehicleData.hasWarning ? "⚠" : "✓"
                                        font.pixelSize: 20
                                        color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    ColumnLayout {
                                        spacing: 2; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                                        Text {
                                            text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["COMMUNICATION FAULT"][Typography.currentLanguage] : vehicleData.warningMessage
                                            font.family: Typography.family; font.pixelSize: Typography.bodySmall
                                            font.weight: Font.Medium; color: Colors.textPrimary
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight 
                                        }
                                        Text { 
                                            text: vehicleData.warningTimestamp; font.family: Typography.family
                                            font.pixelSize: Typography.bodySmall; color: Colors.textMuted 
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Text { 
                                        text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["CRITICAL"][Typography.currentLanguage] : vehicleData.hasWarning ? diagnosticsCoreGrid.translations["active_label"][Typography.currentLanguage] : diagnosticsCoreGrid.translations["resolved_label"][Typography.currentLanguage]
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
                                text: vehicleData.communicationFault ? ("1 " + diagnosticsCoreGrid.translations["CRITICAL"][Typography.currentLanguage]) : vehicleData.hasWarning ? (activeWarningsCard.activeWarnings + " " + diagnosticsCoreGrid.translations["active_label"][Typography.currentLanguage]) : diagnosticsCoreGrid.translations["resolved_label"][Typography.currentLanguage]
                                font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.DemiBold
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentEco
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Rectangle { width: 1; height: 12; color: Colors.borderSubtle; Layout.alignment: Qt.AlignVCenter }

                            Text { 
                                text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["connection_lost"][Typography.currentLanguage] : (vehicleData.historicalWarnings + " " + diagnosticsCoreGrid.translations["historical_label"][Typography.currentLanguage])
                                font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.DemiBold
                                color: vehicleData.communicationFault ? Colors.critical : vehicleData.hasWarning ? Colors.warning : Colors.accentCity 
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }
                }
            }

            // ROW 2: QUAD AGGREGATED TELEMETRY BADGES
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
                    property color statusColor2: Colors.accentEco
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
                            anchors.fill: parent
                            spacing: 4

                            RowLayout {
                                spacing: 4 
                                Layout.alignment: Qt.AlignTop
                                Layout.fillWidth: true

                                Item {
                                    width: 78; height: 26
                                    Layout.alignment: Qt.AlignVCenter
                                    BatteryGraphic {
                                        width: 78; height: 26
                                        anchors.centerIn: parent
                                        percentage: vehicleData.communicationFault ? 0 : vehicleData.batteryPercent
                                    }
                                }
                                Text {
                                    text: mainValue
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignRight
                                    color: Colors.textPrimary
                                    font.family: Typography.family
                                    font.pixelSize: Typography.titleLarge
                                    font.bold: true
                                    elide: Text.ElideRight
                                    Layout.alignment: Qt.AlignVCenter
                                }
                                Text {
                                    text: mainLabel
                                    font.family: Typography.family
                                    font.pixelSize: Typography.titleSmall
                                    color: Colors.textSecondary
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                Text { text: diagnosticsCoreGrid.translations["sub_range"][Typography.currentLanguage]; color: Colors.textSecondary; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: vehicleData.communicationFault ? "--" : Math.round(displayDistance(vehicleData.rangeKm)) + unitSpeedLabel; color: Colors.textPrimary; font.pixelSize: Typography.bodySmall }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                Text { text: "SOH"; color: Colors.textSecondary; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: vehicleData.communicationFault ? "--" : "96%"; color: Colors.textPrimary; font.pixelSize: Typography.bodySmall }
                            }

                            Item { Layout.fillHeight: true }

                            RowLayout {
                                spacing: 4; Layout.alignment: Qt.AlignBottom; Layout.fillWidth: true
                                Rectangle { width: 6; height: 6; radius: 3; color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentEco; Layout.alignment: Qt.AlignVCenter }
                                Text {
                                    text: vehicleData.communicationFault ? diagnosticsCoreGrid.translations["OFFLINE"][Typography.currentLanguage] : vehicleData.lowBatteryWarning ? diagnosticsCoreGrid.translations["LOW BATTERY"][Typography.currentLanguage] : diagnosticsCoreGrid.translations[statusText][Typography.currentLanguage]
                                    color: vehicleData.communicationFault ? Colors.textMuted : vehicleData.lowBatteryWarning ? Colors.warning : Colors.accentCity
                                    font.family: Typography.family; font.bold: true; font.pixelSize: Typography.label
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }
                    }

                    Component {
                        id: normalLayout
                        ColumnLayout {
                            anchors.fill: parent; spacing: 0

                            Item {
                                Layout.fillWidth: true; Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: Math.round(8 * Theme.scale)

                                    Item {
                                        Layout.preferredWidth: Math.round(44 * Theme.scale); Layout.preferredHeight: Math.round(44 * Theme.scale); Layout.alignment: Qt.AlignVCenter
                                        PowertrainIcon { anchors.centerIn: parent; visible: cardType === "powertrain" }
                                        ThermalIcon { anchors.centerIn: parent; visible: cardType === "thermal" }
                                        Item {
                                            anchors.fill: parent; visible: cardType === "communication"
                                            Rectangle { id: signalMast; width: Math.max(1.2, 1.5 * Theme.scale); height: Math.round(22 * Theme.scale); color: Colors.borderActive; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(1 * Theme.scale); anchors.horizontalCenter: parent.horizontalCenter }
                                            Rectangle { id: signalNode; width: Math.round(5 * Theme.scale); height: Math.round(5 * Theme.scale); radius: width / 2; color: Colors.accentCity; anchors.bottom: signalMast.top; anchors.bottomMargin: -1; anchors.horizontalCenter: parent.horizontalCenter }
                                            Repeater {
                                                model: 3
                                                Rectangle { anchors.centerIn: signalNode; width: Math.round((12 + index * 9) * Theme.scale); height: width; radius: width / 2; color: "transparent"; border.color: Colors.borderActive ; border.width: Math.max(1, 1.2 * Theme.scale); opacity: 1.0 - (index * 0.3) }
                                            }
                                        }
                                    }

                                    ColumnLayout {
                                        spacing: Math.round(2 * Theme.scale); Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                                        RowLayout {
                                            spacing: Math.round(4 * Theme.scale); visible: cardType !== "communication"; Layout.fillWidth: true
                                            Text { font.pixelSize: Math.round(22 * Theme.scale); font.family: Typography.family; font.weight: Font.Bold; color: Colors.textPrimary; text: mainValue; Layout.fillWidth: true; elide: Text.ElideRight; Layout.alignment: Qt.AlignBottom }
                                            Text { font.pixelSize: Math.round(14 * Theme.scale); font.family: Typography.family; font.weight: Font.Normal; color: Colors.textPrimary; text: mainLabel; visible: mainLabel !== ""; Layout.alignment: Qt.AlignBottom; Layout.bottomMargin: Math.round(3 * Theme.scale) }
                                        }
                                        Text { 
                                            font.pixelSize: Math.round(16 * Theme.scale); font.family: Typography.family; font.weight: Font.Bold; color: Colors.textPrimary; 
                                            text: diagnosticsCoreGrid.translations[mainValue] ? diagnosticsCoreGrid.translations[mainValue][Typography.currentLanguage] : mainValue; 
                                            visible: cardType === "communication"; Layout.fillWidth: true; elide: Text.ElideRight 
                                        }
                                        Text { font.pixelSize: Math.round(11 * Theme.scale); font.family: Typography.family; color: Colors.textMuted; text: subLabel; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true; spacing: Math.round(4 * Theme.scale)
                                Rectangle { width: Math.round(6 * Theme.scale); height: Math.round(6 * Theme.scale); radius: width / 2; color: statusColor2; Layout.alignment: Qt.AlignVCenter }
                                Text { text: diagnosticsCoreGrid.translations[statusText] ? diagnosticsCoreGrid.translations[statusText][Typography.currentLanguage] : statusText; color: statusColor; font.family: Typography.family; font.bold: true; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight; Layout.alignment: Qt.AlignVCenter }
                            }
                        }
                    }
                }

                QuadMiniBadge {
                    title: diagnosticsCoreGrid.translations["badge_battery"][Typography.currentLanguage]
                    isBattery: true
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.batteryPercent
                    mainLabel: vehicleData.communicationFault ? "" : "%"
                }

                QuadMiniBadge {
                    title: diagnosticsCoreGrid.translations["badge_powertrain"][Typography.currentLanguage]
                    cardType: "powertrain"
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorPower.toFixed(1)
                    mainLabel: vehicleData.communicationFault ? "" : "kW"
                    subLabel: diagnosticsCoreGrid.translations["sub_motor_power"][Typography.currentLanguage]
                    statusText: vehicleData.communicationFault ? "UNAVAILABLE" : vehicleData.motorOverTempWarning ? "OVERHEATING" : "NORMAL"
                    statusColor: vehicleData.communicationFault ? Colors.textMuted : vehicleData.motorOverTempWarning ? Colors.warning : Colors.accentCity
                    statusColor2: vehicleData.communicationFault ? Colors.textMuted : vehicleData.motorOverTempWarning ? Colors.warning : Colors.accentEco
                }

                QuadMiniBadge {
                    title: diagnosticsCoreGrid.translations["badge_thermal"][Typography.currentLanguage]
                    cardType: "thermal"
                    mainValue: vehicleData.communicationFault ? "--" : vehicleData.motorTemp
                    mainLabel: vehicleData.communicationFault ? "" : "°C"
                    subLabel: diagnosticsCoreGrid.translations["sub_max_temp"][Typography.currentLanguage]
                    statusText: vehicleData.communicationFault ? "UNAVAILABLE" : vehicleData.batteryOverTempWarning ? "OVERHEATING" : vehicleData.motorOverTempWarning ? "OVERHEATING" : "NORMAL"
                    statusColor: vehicleData.communicationFault ? Colors.textMuted : vehicleData.batteryOverTempWarning ? Colors.warning : vehicleData.motorOverTempWarning ? Colors.warning : Colors.accentCity
                    statusColor2: vehicleData.communicationFault ? Colors.textMuted : vehicleData.motorOverTempWarning ? Colors.warning : vehicleData.motorOverTempWarning ? Colors.warning : Colors.accentEco
                }

                QuadMiniBadge {
                    title: diagnosticsCoreGrid.translations["badge_communication"][Typography.currentLanguage]
                    cardType: "communication"
                    mainValue: vehicleData.communicationFault ? "OFFLINE" : "CONNECTED"
                    mainLabel: ""
                    subLabel: ""
                    statusText: vehicleData.communicationFault ? "OFFLINE" : "STABLE"
                    statusColor: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                    statusColor2: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                }
            }

            // ROW 3: POWERTRAIN DATA & FAULT HISTORY
            RowLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.63
                spacing: Theme.sectionGap

                DashboardCard {
                    title: vehicleData.communicationFault 
                           ? (diagnosticsCoreGrid.translations["powertrain_data"][Typography.currentLanguage].toUpperCase() + " • " + diagnosticsCoreGrid.translations["OFFLINE"][Typography.currentLanguage]) 
                           : diagnosticsCoreGrid.translations["powertrain_data"][Typography.currentLanguage].toUpperCase()
                    Layout.fillHeight: true
                    Layout.preferredHeight: Math.round(201 * Theme.scale)
                    Layout.preferredWidth: 364

                    ListView {
                        anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.topMargin: Math.round(4 * Theme.scale)
                        interactive: false; clip: true; spacing: 0
                        
                        model: ListModel {
                            id: powertrainModel
                            ListElement { metricKey: "metric_voltage"; reading: "72.4 V"; iconType: "voltage" }
                            ListElement { metricKey: "metric_current"; reading: "18.2 A"; iconType: "current" }
                            ListElement { metricKey: "metric_power";   reading: "4.8 kW"; iconType: "power" }
                            ListElement { metricKey: "metric_regen";   reading: "2";      iconType: "regen" }
                        }
                        
                        delegate: ColumnLayout {
                            width: parent ? parent.width : 0; spacing: 0
                            
                            RowLayout {
                                Layout.fillWidth: true; Layout.preferredHeight: Math.round(34 * Theme.scale) 
                                spacing: 8
                                
                                Item {
                                    id: iconContainer; Layout.preferredWidth: Math.round(28 * Theme.scale); Layout.preferredHeight: Math.round(28 * Theme.scale); Layout.alignment: Qt.AlignVCenter
                                    
                                    Rectangle {
                                        anchors.centerIn: parent; width: 20; height: 14; radius: 2; color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity; border.width: 1.5; visible: model.iconType === "voltage"
                                        Row { anchors.centerIn: parent; spacing: 3; Rectangle { width: 3; height: 6; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity } Rectangle { width: 3; height: 6; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity } }
                                    }
                                    
                                    Row {
                                        anchors.centerIn: parent; spacing: 1; visible: model.iconType === "current"
                                        Repeater { model: 4; Rectangle { width: 2; height: index === 0 ? 6 : index === 1 ? 16 : index === 2 ? 10 : 8; radius: 1; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity } }
                                    }
                                    
                                    Rectangle {
                                        anchors.centerIn: parent; width: 18; height: 18; radius: 3; color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity; border.width: 1.5; visible: model.iconType === "power"
                                        Column { anchors.centerIn: parent; spacing: 2; Rectangle { width: 10; height: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity } Rectangle { width: 10; height: 2; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity } }
                                    }
                                    
                                    Rectangle {
                                        anchors.centerIn: parent; width: 16; height: 16; radius: 8; color: "transparent"
                                        border.color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity; border.width: 1.5; visible: model.iconType === "regen"
                                        Rectangle { width: 6; height: 6; radius: 3; color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity; anchors.right: parent.right; anchors.top: parent.top }
                                    }
                                }
                                
                                Text { 
                                    text: diagnosticsCoreGrid.translations[model.metricKey][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textSecondary
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight 
                                    Layout.alignment: Qt.AlignVCenter
                                }
                                Text { text: vehicleData.communicationFault ? "--" : model.reading; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; color: Colors.textPrimary; Layout.alignment: Qt.AlignVCenter }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Colors.surfaceSunken; visible: index < 3 }
                        }
                    }
                }

                DashboardCard {
                    title: vehicleData.communicationFault 
                           ? (diagnosticsCoreGrid.translations["fault_history"][Typography.currentLanguage] + " • " + diagnosticsCoreGrid.translations["OFFLINE"][Typography.currentLanguage]) 
                           : (diagnosticsCoreGrid.translations["fault_history"][Typography.currentLanguage] + " • " + telemetryLogger.recentWarnings.length)
                    Layout.fillWidth: true; Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent; spacing: 8

                        Item {
                            Layout.fillWidth: true; Layout.fillHeight: true

                            ListView {
                                id: historyView; anchors.fill: parent; clip: true; spacing: 4
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
                                        Text { text: "⚠"; color: Colors.warning; font.pixelSize: Typography.bodyMedium; Layout.alignment: Qt.AlignVCenter }

                                        ColumnLayout {
                                            spacing: 1; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                                            Text { 
                                                text: warningText; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Medium 
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight 
                                            }
                                            RowLayout {
                                                spacing: 8; Layout.fillWidth: true
                                                Text { text: datePart; color: Colors.textMuted; font.pixelSize: Typography.label }
                                                Text { text: "•"; color: Colors.borderSubtle; font.family: Typography.family; font.pixelSize: Typography.label }
                                                Text { text: timePart; color: Colors.textMuted; font.pixelSize: Typography.label }
                                                Item { Layout.fillWidth: true }
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
                                    border.color: Colors.critical; border.width: 1; anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: "X"; color: Colors.critical; font.pixelSize: 20; font.bold: true }
                                }
                                Text { text: diagnosticsCoreGrid.translations["COMMUNICATION FAULT"][Typography.currentLanguage]; color: Colors.critical; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: diagnosticsCoreGrid.translations["stream_unavailable"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: diagnosticsCoreGrid.translations["history_paused"][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.horizontalCenter: parent.horizontalCenter }
                            }

                            Column {
                                anchors.centerIn: parent; visible: telemetryLogger.recentWarnings.length === 0 && !vehicleData.communicationFault
                                spacing: 6; width: parent.width

                                Rectangle {
                                    width: 42; height: 42; radius: 21
                                    color: Qt.rgba(Colors.accentEco.r, Colors.accentEco.g, Colors.accentEco.b, 0.10)
                                    border.color: Colors.accentEco; border.width: 1; anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: "✓"; color: Colors.accentEco; font.pixelSize: 22; font.bold: true }
                                }
                                Text { text: diagnosticsCoreGrid.translations["no_recent_faults"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: diagnosticsCoreGrid.translations["sys_normal"][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.horizontalCenter: parent.horizontalCenter }
                            }    
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Colors.borderSubtle }

                        Rectangle {
                            id: clearButton; Layout.alignment: Qt.AlignRight; width: 110; height: 34; radius: Theme.controlRadius
                            opacity: vehicleData.communicationFault ? 0.5 : 1.0
                            color: Qt.rgba(Colors.accentCity.r, Colors.accentCity.g, Colors.accentCity.b, 0.10)
                            border.color: Colors.borderSubtle; border.width: 1

                            Text { anchors.centerIn: parent; text: diagnosticsCoreGrid.translations["acknowledge"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                            MouseArea { anchors.fill: parent; enabled: !vehicleData.communicationFault; onClicked: telemetryLogger.clearWarnings() }
                        }
                    }
                }
            }
        }
    }
}