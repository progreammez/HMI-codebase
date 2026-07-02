import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: powertrainPage
    anchors.fill: parent

    // Core Active Property bindings linked to the persistent global context
    property var voltHistory: root.persistentVoltHistory
    property var currentHistory: root.persistentCurrentHistory
    property var powerHistory: root.persistentPowerHistory

    // Property to track active time window filter
    property string selectedTimeWindow: "30 s"

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    readonly property int cardRadius: Theme.controlRadius
    
    readonly property color voltColor: "#00D1FF"       // Cyan
    readonly property color currentColor: "#FF9F0A"    // Orange
    readonly property color powerColor: "#BF5AF2"      // Purple
    readonly property color greenEco: "#00FF66"        // Bright Eco Green

    // Monitor input vectors to automatically rerun mathematical bounds and trigger repaints
    onVoltHistoryChanged: processTelemetryStatistics()
    onCurrentHistoryChanged: processTelemetryStatistics()
    onPowerHistoryChanged: processTelemetryStatistics()
    
    // Re-run math and redraw whenever the user changes the time frame filter
    onSelectedTimeWindowChanged: processTelemetryStatistics()

    // Helper property to map the text window string to actual array sample slices
    readonly property var windowLimits: {
        "10 s": 10,
        "30 s": 30,
        "1 min": 60,
        "5 min": 150
    }

    function processTelemetryStatistics() {
        var currentLimit = windowLimits[powertrainPage.selectedTimeWindow] || 30;

        // Slice the trailing edge of the arrays to represent our selected visual window scope
        var vList = (powertrainPage.voltHistory) ? powertrainPage.voltHistory.slice(-currentLimit) : [];
        var cList = (powertrainPage.currentHistory) ? powertrainPage.currentHistory.slice(-currentLimit) : [];
        var pList = (powertrainPage.powerHistory) ? powertrainPage.powerHistory.slice(-currentLimit) : [];

        // --- VOLTAGE MATH ---
        if (vList && vList.length > 0) {
            var vMin = Math.min.apply(null, vList)
            var vMax = Math.max.apply(null, vList)
            var vAvg = vList.reduce(function(a, b) { return a + b }, 0) / vList.length
            trendCard.vMinStr = vMin.toFixed(1) + " V"
            trendCard.vMaxStr = vMax.toFixed(1) + " V"
            trendCard.vAvgStr = vAvg.toFixed(1) + " V"
        }

        // --- CURRENT MATH ---
        if (cList && cList.length > 0) {
            var cMin = Math.min.apply(null, cList)
            var cMax = Math.max.apply(null, cList)
            var cAvg = cList.reduce(function(a, b) { return a + b }, 0) / cList.length
            trendCard.cMinStr = cMin.toFixed(1) + " A"
            trendCard.cMaxStr = cMax.toFixed(1) + " A"
            trendCard.cAvgStr = cAvg.toFixed(1) + " A"
        }

        // --- POWER MATH ---
        if (pList && pList.length > 0) {
            var pMin = Math.min.apply(null, pList)
            var pMax = Math.max.apply(null, pList)
            var pAvg = pList.reduce(function(a, b) { return a + b }, 0) / pList.length
            trendCard.pMinStr = pMin.toFixed(1) + " kW"
            trendCard.pMaxStr = pMax.toFixed(1) + " kW"
            trendCard.pAvgStr = pAvg.toFixed(1) + " kW"
        }

        // Request Canvas Redraws instantly
        if (vCanvas.available) vCanvas.requestPaint()
        if (cCanvas.available) cCanvas.requestPaint()
        if (pCanvas.available) pCanvas.requestPaint()
    }

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_live_values":     { "en": "Live Powertrain Values", "de": "Antriebsstrang-Echtzeitwerte", "es": "Valores del Tren Motriz" },
        "title_trends":          { "en": "Powertrain Trends (Live)", "de": "Antriebsstrang-Trends (Live)", "es": "Tendencias del Tren Motriz" },
        "title_power_dist":      { "en": "Power Distribution",    "de": "Leistungsverteilung",         "es": "Distribución de Potencia" },
        "title_regen_status":    { "en": "Regeneration Status",   "de": "Regenerationsstatus",         "es": "Estado de Regeneración" },
        "title_drive_status":    { "en": "Drive System Status",   "de": "Antriebssystemstatus",        "es": "Estado del Sistema" },

        "lbl_batt_volt":         { "en": "BATTERY VOLTAGE",       "de": "BATTERIESPANNUNG",            "es": "VOLTAJE DE BATERÍA" },
        "lbl_batt_curr":         { "en": "BATTERY CURRENT",       "de": "BATTERIESTROM",               "es": "CORRIENTE DE BATERÍA" },
        "lbl_motor_power":       { "en": "MOTOR POWER",           "de": "MOTORLEISTUNG",               "es": "POTENCIA DEL MOTOR" },
        "lbl_regen_level":       { "en": "REGEN LEVEL",           "de": "REGENERATIONSSTUFE",      "es": "NIVEL REGENERACIÓN" },
        "lbl_motor_rpm":         { "en": "MOTOR RPM",             "de": "MOTORDREHZAHL",               "es": "RPM DEL MOTOR" },
        "lbl_drive_mode":        { "en": "DRIVE MODE",            "de": "FAHRMODUS",                   "es": "MODO CONDUCCIÓN" },
        "lbl_gear_state":        { "en": "GEAR STATE",            "de": "GANGSTUFE",                   "es": "ESTADO DE MARCHA" },
        
        "legend_motor":          { "en": "— Motor",               "de": "— Motor",                 "es": "— Motor" },
        "legend_battery":        { "en": "— Battery",             "de": "— Batterie",              "es": "— Batería" },
        "legend_controller":     { "en": "— Controller",          "de": "— Steuergerät",           "es": "— Controlador" },

        "status_normal":         { "en": "NORMAL",                "de": "NORMAL",                      "es": "NORMAL" },
        "status_active":         { "en": "ACTIVE",                "de": "AKTIV",                       "es": "ACTIVO" },
        "status_none":           { "en": "NONE",                  "de": "KEINER",                      "es": "NINGUNO" },
        "status_on":             { "en": "ON",                    "de": "AN",                          "es": "ENCENDIDO" },
        
        "lbl_volt_trend":        { "en": "VOLTAGE TREND",         "de": "SPANNUNGSVERLAUF",            "es": "TENDENCIA DE VOLTAJE" },
        "lbl_curr_trend":        { "en": "CURRENT TREND",         "de": "STROMVERLAUF",                "es": "TENDENCIA DE CORRIENTE" },
        "lbl_power_trend":       { "en": "POWER TREND",           "de": "LEISTUNGSVERLAUF",            "es": "TENDENCIA DE POTENCIA" },
        "lbl_min":               { "en": "MIN",                   "de": "MIN",                         "es": "MÍN" },
        "lbl_max":               { "en": "MAX",                   "de": "MAX",                         "es": "MÁX" },
        "lbl_avg":               { "en": "AVG",                   "de": "MITTEL",                      "es": "PROM" },

        "lbl_motor_output":      { "en": "MOTOR OUTPUT",          "de": "MOTOR-AUSGANG",               "es": "SALIDA DEL MOTOR" },
        "lbl_regenerative":      { "en": "REGENERATIVE",          "de": "REGENERATIV",                 "es": "REGENERATIVA" },
        "lbl_aux_load":          { "en": "AUXILIARY LOAD",        "de": "NEBENVERBRAUCHER",            "es": "CARGA AUXILIAR" },
        "lbl_losses":            { "en": "LOSSES",                "de": "VERLUSTE",                    "es": "PÉRDIDAS" },

        "lbl_regen_status_str":  { "en": "REGEN STATUS",          "de": "REGEN.-STATUS",               "es": "ESTADO REGEN." },
        "lbl_regen_power":       { "en": "REGEN POWER",           "de": "REGENERATIONSOLEISTUNG",      "es": "POTENCIA DE REGEN." },
        "lbl_energy_recovered":  { "en": "ENERGY RECOVERED (TODAY)", "de": "ENERGIE RÜCKGEW. (HEUTE)",  "es": "ENERGÍA RECUPERADA (HOY)" },

        "lbl_inverter_status":   { "en": "INVERTER STATUS",       "de": "INVERTER-STATUS",             "es": "ESTADO DEL INVERSOR" },
        "lbl_dcdc_converter":    { "en": "DC-DC CONVERTER",       "de": "GLEICHSTROMWANDLER",          "es": "CONVERTIDOR DC-DC" },
        "lbl_bms_status":        { "en": "BMS STATUS",            "de": "BMS-STATUS",                  "es": "ESTADO DEL BMS" },
        "lbl_motor_controller":  { "en": "MOTOR CONTROLLER",      "de": "MOTORSTEUERUNG",              "es": "CONTROLADOR MOTOR" },
        "lbl_drive_system_fault":{ "en": "DRIVE SYSTEM FAULT",    "de": "ANTRIEBSSYSTEM-FEHLER",       "es": "FALLO DE CONECTIVIDAD" },
        
        "unit_level":            { "en": "Level",                 "de": "Stufe",                   "es": "Nivel" },
        "lbl_fan_speed":         { "en": "FAN SPEED",             "de": "LÜFTERDREHZAHL",          "es": "VELOCIDAD VENTILADOR" },
        "lbl_power_limit_state": { "en": "POWER LIMIT STATE",     "de": "LEISTUNGSBEGRENZUNG",         "es": "ESTADO LÍMITE POTENCIA" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: powertrainPage.gridSpacing
        spacing: powertrainPage.gridSpacing

        // =========================================================================
        // ROW 1: TOP LAYER (LIVE POWERTRAIN VALUES [30%] + POWERTRAIN TRENDS [70%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 340 
            spacing: powertrainPage.gridSpacing

            // --- 1. LIVE POWERTRAIN VALUES CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 30
                title: powertrainPage.translations["title_live_values"][Typography.currentLanguage]

                ColumnLayout {
                    anchors.fill: parent; spacing: 0

                    Repeater {
                        model: [
                            { icon: "🔋", pKey: "lbl_batt_volt", v: "72.4", u: "V", col: powertrainPage.voltColor },
                            { icon: "⚡", pKey: "lbl_batt_curr", v: "18.2", u: "A", col: powertrainPage.currentColor },
                            { icon: "⚙", pKey: "lbl_motor_power", v: vehicleData.motorPower.toFixed(1), u: "kW", col: powertrainPage.powerColor },
                            { icon: "🔄", pKey: "lbl_regen_level", v: vehicleData.regenLevel, uKey: "unit_level", col: powertrainPage.greenEco },
                            { icon: "⏱", pKey: "lbl_motor_rpm", v: vehicleData.rpm, u: "RPM", col: Colors.textPrimary },
                            { icon: "🛣", pKey: "lbl_drive_mode", v: vehicleData.driveMode, u: "", col: Colors.textPrimary },
                            { icon: "🕹", pKey: "lbl_gear_state", v: vehicleData.gearState, u: "", col: Colors.textPrimary }
                        ]

                        delegate: Item {
                            Layout.fillWidth: true; Layout.fillHeight: true

                            RowLayout {
                                anchors.fill: parent; anchors.bottomMargin: Math.round(2 * Theme.scale); spacing: 8
                                Text { text: modelData.icon; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: modelData.col; Layout.preferredWidth: Math.round(26 * Theme.scale) }
                                Text { 
                                    text: powertrainPage.translations[modelData.pKey][Typography.currentLanguage]
                                    color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                                    Layout.fillWidth: true; elide: Text.ElideRight 
                                }
                                Text { 
                                    text: modelData.v
                                    color: (modelData.pKey.indexOf("mode") !== -1) ? powertrainPage.voltColor : modelData.col
                                    font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold
                                    Layout.preferredWidth: Math.round(85 * Theme.scale); horizontalAlignment: Text.AlignRight; renderType: Text.QtRendering
                                    elide: Text.ElideRight
                                }
                                Text { 
                                    text: modelData.uKey ? powertrainPage.translations[modelData.uKey][Typography.currentLanguage] : modelData.u
                                    color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.preferredWidth: Math.round(40 * Theme.scale); horizontalAlignment: Text.AlignRight 
                                    elide: Text.ElideRight
                                }
                            }

                            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: Colors.borderSubtle; opacity: 0.15 }
                        }
                    }
                }
            }

            // --- 2. POWERTRAIN TRENDS LIVE GRAPH CARD ---
            BaseCard {
                id: trendCard
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 70
                title: powertrainPage.translations["title_trends"][Typography.currentLanguage]

                property string vMinStr: "72.4 V"
                property string vMaxStr: "72.4 V"
                property string vAvgStr: "72.4 V"

                property string cMinStr: "18.2 A"
                property string cMaxStr: "18.2 A"
                property string cAvgStr: "18.2 A"

                property string pMinStr: "0.0 kW"
                property string pMaxStr: "0.0 kW"
                property string pAvgStr: "0.0 kW"

                RowLayout {
                    anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: Math.round(-38 * Theme.scale)
                    spacing: Math.round(4 * Theme.scale)
                    Repeater {
                        model: ["10 s", "30 s", "1 min", "5 min"]
                        delegate: Rectangle {
                            width: Math.round(55 * Theme.scale); height: Math.round(24 * Theme.scale); radius: 4
                            color: modelData === powertrainPage.selectedTimeWindow ? Colors.surfaceSunken : "transparent"
                            border.color: modelData === powertrainPage.selectedTimeWindow ? Colors.borderActive : "transparent"
                            
                            Text { 
                                text: modelData
                                font.family: Typography.family
                                font.pixelSize: Typography.label
                                font.weight: Font.Bold
                                color: modelData === powertrainPage.selectedTimeWindow ? Colors.textPrimary : Colors.textSecondary
                                anchors.centerIn: parent 
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (powertrainPage.selectedTimeWindow !== modelData) {
                                        powertrainPage.selectedTimeWindow = modelData
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                    // GRAPH MODULE 1: VOLTAGE
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 4
                            Text { text: powertrainPage.translations["lbl_volt_trend"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "(V)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.alignment: Qt.AlignRight }
                        }
                        Text { text: "72.4 V"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Typography.titleMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: vCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                    
                                    var limit = powertrainPage.windowLimits[powertrainPage.selectedTimeWindow];
                                    var data = (powertrainPage.voltHistory) ? powertrainPage.voltHistory.slice(-limit) : [];
                                    if (!data || data.length < 2) return;
                                    
                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (limit - 1)) * width;
                                        var ratio = (data[i] - 60.0) / (80.0 - 60.0); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }
                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(0, 209, 255, 0.15)); grad.addColorStop(1, Qt.rgba(0, 209, 255, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(points[0].x, height);
                                    for (var j=0; j<points.length; j++) ctx.lineTo(points[j].x, points[j].y);
                                    ctx.lineTo(points[points.length-1].x, height); ctx.closePath(); ctx.fill();
                                    ctx.strokeStyle = powertrainPage.voltColor; ctx.lineWidth = 2; ctx.beginPath();
                                    ctx.moveTo(points[0].x, points[0].y);
                                    for (var k=1; k<points.length; k++) ctx.lineTo(points[k].x, points[k].y);
                                    ctx.stroke();
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_min"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vMinStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_max"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vMaxStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_avg"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vAvgStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }

                    // GRAPH MODULE 2: CURRENT
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 4
                            Text { text: powertrainPage.translations["lbl_curr_trend"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "(A)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.alignment: Qt.AlignRight }
                        }
                        Text { text: "18.2 A"; color: powertrainPage.currentColor; font.family: Typography.family; font.pixelSize: Typography.titleMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: cCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 159, 10, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                    
                                    var limit = powertrainPage.windowLimits[powertrainPage.selectedTimeWindow];
                                    var data = (powertrainPage.currentHistory) ? powertrainPage.currentHistory.slice(-limit) : [];
                                    if (!data || data.length < 2) return;
                                    
                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (limit - 1)) * width;
                                        var ratio = (data[i] - (-20.0)) / (60.0 - (-20.0)); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }
                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(255, 159, 10, 0.15)); grad.addColorStop(1, Qt.rgba(255, 159, 10, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(points[0].x, height);
                                    for (var j=0; j<points.length; j++) ctx.lineTo(points[j].x, points[j].y);
                                    ctx.lineTo(points[points.length-1].x, height); ctx.closePath(); ctx.fill();
                                    ctx.strokeStyle = powertrainPage.currentColor; ctx.lineWidth = 2; ctx.beginPath();
                                    ctx.moveTo(points[0].x, points[0].y);
                                    for (var k=1; k<points.length; k++) ctx.lineTo(points[k].x, points[k].y);
                                    ctx.stroke();
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_min"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cMinStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_max"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cMaxStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_avg"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cAvgStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }

                    // GRAPH MODULE 3: POWER
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 4
                            Text { text: powertrainPage.translations["lbl_power_trend"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "(kW)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.alignment: Qt.AlignRight }
                        }
                        Text { text: vehicleData.motorPower.toFixed(1) + " kW"; color: powertrainPage.powerColor; font.family: Typography.family; font.pixelSize: Typography.titleMedium; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: pCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                    
                                    var limit = powertrainPage.windowLimits[powertrainPage.selectedTimeWindow];
                                    var data = (powertrainPage.powerHistory) ? powertrainPage.powerHistory.slice(-limit) : [];
                                    if (!data || data.length < 2) return;
                                    
                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (limit - 1)) * width;
                                        var ratio = (data[i] - (-10.0)) / (100.0 - (-10.0)); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }
                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(191, 90, 242, 0.15)); grad.addColorStop(1, Qt.rgba(191, 90, 242, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(points[0].x, height);
                                    for (var j=0; j<points.length; j++) ctx.lineTo(points[j].x, points[j].y);
                                    ctx.lineTo(points[points.length-1].x, height); ctx.closePath(); ctx.fill();
                                    ctx.strokeStyle = powertrainPage.powerColor; ctx.lineWidth = 2; ctx.beginPath();
                                    ctx.moveTo(points[0].x, points[0].y);
                                    for (var k=1; k<points.length; k++) ctx.lineTo(points[k].x, points[k].y);
                                    ctx.stroke();
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true; spacing: 4
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_min"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pMinStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_max"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pMaxStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: powertrainPage.translations["lbl_avg"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pAvgStr; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }
                }
            }
        }

        // =========================================================================
        // ROW 2: LOWER LAYER (POWER DIST [34%] + REGEN [33%] + SYSTEM STATUS [33%])
        // =========================================================================
        RowLayout {
            id: botRow
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 180 
            spacing: powertrainPage.gridSpacing

            // --- 3. POWER DISTRIBUTION CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 34
                title: powertrainPage.translations["title_power_dist"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                    Item {
                        Layout.preferredWidth: Math.round(100 * Theme.scale); Layout.preferredHeight: Math.round(100 * Theme.scale)
                        Layout.alignment: Qt.AlignVCenter
                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                var cx = width/2; var cy = height/2; var r = width/2 - 6;
                                ctx.strokeStyle = powertrainPage.voltColor; ctx.lineWidth = 6;
                                ctx.beginPath(); ctx.arc(cx,cy,r,0,2*Math.PI); ctx.stroke();
                            }
                        }
                        Column {
                            anchors.centerIn: parent
                            Text { text: vehicleData.motorPower.toFixed(1); font.family: Typography.family; font.pixelSize: Typography.titleMedium; font.weight: Font.Bold; color: Colors.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "kW"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; spacing: Math.round(4 * Theme.scale)
                        Repeater {
                            model: [
                                { nameKey: "lbl_motor_output", val: vehicleData.motorPower.toFixed(1) + " kW", pct: "100%", col: powertrainPage.voltColor },
                                { nameKey: "lbl_regenerative", val: "0.0 kW", pct: "0%", col: powertrainPage.greenEco },
                                { nameKey: "lbl_aux_load", val: "0.0 kW", pct: "0%", col: powertrainPage.currentColor },
                                { nameKey: "lbl_losses", val: "0.0 kW", pct: "0%", col: powertrainPage.powerColor }
                            ]
                            delegate: RowLayout {
                                Layout.fillWidth: true; spacing: Math.round(6 * Theme.scale)
                                Rectangle { width: 6; height: 6; radius: 3; color: modelData.col; Layout.alignment: Qt.AlignVCenter }
                                Text { 
                                    text: powertrainPage.translations[modelData.nameKey][Typography.currentLanguage]
                                    color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                                    Layout.fillWidth: true; elide: Text.ElideRight 
                                }
                                Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                                Text { text: modelData.pct; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.preferredWidth: Math.round(36 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }
                        }
                    }
                }
            }

            // --- 4. REGENERATION STATUS CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 33
                title: powertrainPage.translations["title_regen_status"][Typography.currentLanguage]

                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(6 * Theme.scale)

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: powertrainPage.translations["lbl_regen_level"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: vehicleData.regenLevel + " Level"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        Row {
                            spacing: 2; Layout.alignment: Qt.AlignRight
                            Repeater {
                                model: 3
                                Rectangle { width: Math.round(18 * Theme.scale); height: Math.round(10 * Theme.scale); radius: 1; color: index < vehicleData.regenLevel ? powertrainPage.greenEco : Colors.surfaceSunken }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: powertrainPage.translations["lbl_regen_status_str"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: powertrainPage.translations["status_active"][Typography.currentLanguage]; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: powertrainPage.translations["lbl_regen_power"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: "-0.8 kW"; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { 
                            text: powertrainPage.translations["lbl_energy_recovered"][Typography.currentLanguage]
                            color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall
                            Layout.fillWidth: true; elide: Text.ElideRight 
                        }
                        Text { text: "0.72 kWh"; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                    }
                }
            }

            // --- 5. DRIVE SYSTEM STATUS CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 33
                title: powertrainPage.translations["title_drive_status"][Typography.currentLanguage]

                ColumnLayout {
                    anchors.fill: parent; spacing: 0
                    Repeater {
                        model: [
                            { kKey: "lbl_inverter_status", vKey: "status_normal", c: powertrainPage.greenEco },
                            { kKey: "lbl_dcdc_converter", vKey: "status_normal", c: powertrainPage.greenEco },
                            { kKey: "lbl_bms_status", vKey: "status_normal", c: powertrainPage.greenEco },
                            { kKey: "lbl_motor_controller", vKey: "status_normal", c: powertrainPage.greenEco },
                            { kKey: "lbl_drive_system_fault", vKey: "status_none", c: powertrainPage.greenEco },
                            { kKey: "lbl_power_limit_state", vKey: "status_none", c: powertrainPage.greenEco }
                        ]
                        delegate: RowLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 8
                            Text { 
                                text: powertrainPage.translations[modelData.kKey][Typography.currentLanguage]
                                color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold
                                Layout.fillWidth: true; elide: Text.ElideRight 
                            }
                            Text { text: powertrainPage.translations[modelData.vKey][Typography.currentLanguage]; color: modelData.c; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                        }
                    }
                }
            }
        }
    }
}