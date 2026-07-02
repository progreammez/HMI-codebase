import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: thermalPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    
    // Domain Specific Accent Colors matching reference graphics assets
    readonly property color motorColor: "#00D1FF"      // Vibrant Cyan
    readonly property color batteryColor: "#FF9F0A"    // High-vis Orange
    readonly property color controllerColor: "#BF5AF2" // Tech Purple

    // Declarative live bindings connected directly to persistent root variables
    property var motorHistory: root.persistentMotorHistory
    property var batteryHistory: root.persistentBatteryHistory
    property var controllerHistory: root.persistentControllerHistory
    
    readonly property int maxPoints: root.maxThermalPoints 

    // Auto-update triggers paint events instantly when background vectors expand
    onMotorHistoryChanged: triggerRepaint()
    onBatteryHistoryChanged: triggerRepaint()
    onControllerHistoryChanged: triggerRepaint()

    function triggerRepaint() {
        if (trendCanvas.available) trendCanvas.requestPaint()
    }

    // Safe AOT Helper function to calculate rolling stats safely without inline closures
    function calculateAverage(dataset) {
        if (!dataset || dataset.length === 0) {
            return 0;
        }
        var sum = 0;
        for (var i = 0; i < dataset.length; i++) {
            sum += dataset[i];
        }
        return sum / dataset.length;
    }

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_current_temps":   { "en": "Current Temperatures",   "de": "Aktuelle Temperaturen",   "es": "Temperaturas Actuales" },
        "title_trends":          { "en": "Temperature Trends (Live)", "de": "Temperaturverlauf (Live)", "es": "Tendencias de Temp. (Vivo)" },
        "title_status":          { "en": "Thermal Status",        "de": "Thermischer Status",      "es": "Estado Térmico" },
        "title_cooling":         { "en": "Cooling System",        "de": "Kühlsystem",              "es": "Sistema de Enfriamiento" },
        "title_warnings":        { "en": "Thermal Warnings",      "de": "Thermische Warnungen",    "es": "Advertencias Térmicas" },
        "title_history":         { "en": "Temperature History",   "de": "Temperaturhistorie",      "es": "Historial de Temperatura" },

        "lbl_motor_temp":        { "en": "MOTOR TEMP",            "de": "MOTORTEMPERATUR",         "es": "TEMP. DEL MOTOR" },
        "lbl_battery_temp":      { "en": "BATTERY TEMP",          "de": "BATTERIETEMPERATUR",      "es": "TEMP. DE BATERÍA" },
        "lbl_controller_temp":   { "en": "CONTROLLER TEMP",       "de": "STEUERGERÄTETEMP.",       "es": "TEMP. CONTROLADOR" },
        
        "legend_motor":          { "en": "— Motor",               "de": "— Motor",                 "es": "— Motor" },
        "legend_battery":        { "en": "— Battery",             "de": "— Batterie",              "es": "— Batería" },
        "legend_controller":     { "en": "— Controller",          "de": "— Steuergerät",           "es": "— Controlador" },

        "status_normal":         { "en": "NORMAL",                "de": "NORMAL",                  "es": "NORMAL" },
        "status_overtemp":       { "en": "OVERTEMP",              "de": "ÜBERTEMP.",               "es": "SOBRETEMP." },
        "status_active_tag":     { "en": " ACTIVE",               "de": " AKTIV",                  "es": " ACTIVO" },
        "status_ok":             { "en": "OK",                    "de": "OK",                      "es": "OK" },
        "status_fail":           { "en": "FAIL",                  "de": "FEHLER",                  "es": "FALLO" },
        "status_on":             { "en": "ON",                    "de": "AN",                      "es": "ENCENDIDO" },
        
        "lbl_fan_speed":         { "en": "FAN SPEED",             "de": "LÜFTERDREHZAHL",          "es": "VELOCIDAD VENTILADOR" },
        "lbl_coolant_temp":      { "en": "Coolant Temp",          "de": "Kühlmitteltemp.",         "es": "Temp. Refrigerante" },
        "lbl_coolant_flow":      { "en": "Coolant Flow",          "de": "Kühlmittelfluss",         "es": "Flujo Refrigerante" },
        "lbl_pump_status":       { "en": "Pump Status",           "de": "Pumpenstatus",            "es": "Estado de Bomba" },
        "lbl_radiator_status":   { "en": "Radiator Status",       "de": "Radiatorstatus",          "es": "Estado Radiador" },

        "warn_motor":            { "en": "Motor Over Temp",       "de": "Motor Übertemperatur",    "es": "Sobretamp. del Motor" },
        "warn_battery":          { "en": "Battery Over Temp",     "de": "Batterie Übertemperatur",  "es": "Sobretamp. de Batería" },
        "warn_controller":       { "en": "Controller Over Temp",  "de": "Steuergerät Übertemp.",   "es": "Sobretamp. Controlador" },
        "warn_derate":           { "en": "High Temp Derate",      "de": "Hochtemp.-Drosselung",    "es": "Reducción por Alta Temp." },

        // FIXED: Added missing keys utilized by Row 2 and Row 3 repeaters
        "check_motor":           { "en": "MOTOR",                 "de": "MOTOR",                   "es": "MOTOR" },
        "check_battery":         { "en": "BATTERY",               "de": "BATTERIE",                "es": "BATERÍA" },
        "check_controller":      { "en": "CONTROLLER",            "de": "STEUERGERÄT",             "es": "CONTROLADOR" },
        "lbl_min":               { "en": "MIN",                   "de": "MIN",                     "es": "MÍN" },
        "lbl_max":               { "en": "MAX",                   "de": "MAX",                     "es": "MÁX" },
        "lbl_avg":               { "en": "AVG",                   "de": "MITTEL",                  "es": "PROM" }
    }

    // Master Page Layout Architecture Container
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: thermalPage.gridSpacing
        spacing: thermalPage.gridSpacing

        // =========================================================================
        // ROW 1: TOP LAYER (CURRENT TEMPERATURES [46%] + TEMPERATURE TRENDS [54%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 240 
            spacing: thermalPage.gridSpacing

            // --- 1. CURRENT TEMPERATURES CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 46
                title: thermalPage.translations["title_current_temps"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent
                    spacing: Math.round(10 * Theme.scale)

                    Repeater {
                        model: [
                            { titleKey: "lbl_motor_temp", val: vehicleData.motorTemp, max: 120, col: thermalPage.motorColor, icon: "⚙" },
                            { titleKey: "lbl_battery_temp", val: vehicleData.batteryTemp, max: 60, col: thermalPage.batteryColor, icon: "🔋" },
                            { titleKey: "lbl_controller_temp", val: vehicleData.controllerTemp, max: 100, col: thermalPage.controllerColor, icon: "🎛" }
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            color: Colors.surfaceSunken; radius: Theme.controlRadius
                            border.color: Colors.borderSubtle; border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Math.round(12 * Theme.scale)
                                spacing: 0

                                Text { 
                                    text: thermalPage.translations[modelData.titleKey][Typography.currentLanguage]
                                    color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold
                                    Layout.fillWidth: true; elide: Text.ElideRight 
                                }
                                
                                Item { Layout.fillHeight: true }
                                Text { text: modelData.icon; color: modelData.col; font.pixelSize: Math.round(32 * Theme.scale); Layout.alignment: Qt.AlignHCenter }
                                Item { Layout.fillHeight: true }
                                
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter; spacing: 2
                                    Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.titleLarge; font.weight: Font.Bold; renderType: Text.QtRendering }
                                    Text { text: "°C"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.alignment: Qt.AlignBottom; Layout.bottomMargin: Math.round(4 * Theme.scale) }
                                }

                                Item { Layout.preferredHeight: Math.round(4 * Theme.scale) }

                                Rectangle {
                                    Layout.fillWidth: true; height: Math.round(4 * Theme.scale); color: Colors.surfaceBase; radius: 2
                                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: parent.width * (Math.min(modelData.val, modelData.max) / modelData.max); color: modelData.col; radius: 2 }
                                }

                                Item { Layout.preferredHeight: Math.round(2 * Theme.scale) }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "0"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                                    Item { Layout.fillWidth: true }
                                    Text { text: modelData.max; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; Layout.alignment: Qt.AlignRight }
                                }
                            }
                        }
                    }
                }
            }

            // --- 2. TEMPERATURE TRENDS LIVE GRAPH CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 54
                title: thermalPage.translations["title_trends"][Typography.currentLanguage]

                ColumnLayout {
                    anchors.fill: parent; spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Row {
                            spacing: Math.round(12 * Theme.scale)
                            Text { text: thermalPage.translations["legend_motor"][Typography.currentLanguage]; color: thermalPage.motorColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Text { text: thermalPage.translations["legend_battery"][Typography.currentLanguage]; color: thermalPage.batteryColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Text { text: thermalPage.translations["legend_controller"][Typography.currentLanguage]; color: thermalPage.controllerColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                        }
                    }

                    Item {
                        Layout.fillWidth: true; Layout.fillHeight: true

                        Item {
                            id: yAxisLabels
                            anchors.left: parent.left; anchors.top: trendCanvas.top; anchors.bottom: trendCanvas.bottom; width: Math.round(26 * Theme.scale)
                            Repeater {
                                model: ["125", "100", "75", "50", "25"]
                                delegate: Text { text: modelData; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width; horizontalAlignment: Text.AlignLeft; y: (index * (trendCanvas.height / 4)) - (height / 2) }
                            }
                        }

                        Row {
                            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: Math.round(28 * Theme.scale); anchors.right: parent.right
                            Text { text: "60s ago"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33 }
                            Text { text: "45s"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33; horizontalAlignment: Text.AlignHCenter }
                            Text { text: "30s"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33; horizontalAlignment: Text.AlignHCenter }
                            Text { text: "Now"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        }

                        Canvas {
                            id: trendCanvas; anchors.fill: parent; anchors.leftMargin: Math.round(28 * Theme.scale); anchors.bottomMargin: Math.round(14 * Theme.scale)
                            readonly property real minY: 25.0
                            readonly property real maxY: 125.0

                            function drawLiveLine(ctx, dataset, color) {
                                if (!dataset || dataset.length < 2) return;
                                ctx.strokeStyle = color; 
                                ctx.lineWidth = 2; 
                                ctx.beginPath();
                                for (var i = 0; i < dataset.length; i++) {
                                    var x = (i / (thermalPage.maxPoints - 1)) * width;
                                    var ratio = (dataset[i] - minY) / (maxY - minY);
                                    var y = height - (Math.max(0.02, Math.min(0.98, ratio)) * height);
                                    if (i === 0) {
                                        ctx.moveTo(x, y);
                                    } else {
                                        ctx.lineTo(x, y);
                                    }
                                }
                                ctx.stroke();
                            }

                            onPaint: {
                                var ctx = getContext("2d"); 
                                ctx.clearRect(0, 0, width, height);
                                ctx.strokeStyle = Qt.rgba(255,255,255,0.04); 
                                ctx.lineWidth = 1;
                                for (var i = 0; i <= 4; i++) { 
                                    var y = (height / 4) * i; 
                                    ctx.beginPath(); 
                                    ctx.moveTo(0, y); 
                                    ctx.lineTo(width, y); 
                                    ctx.stroke(); 
                                }
                                drawLiveLine(ctx, thermalPage.motorHistory, thermalPage.motorColor);
                                drawLiveLine(ctx, thermalPage.controllerHistory, thermalPage.controllerColor);
                                drawLiveLine(ctx, thermalPage.batteryHistory, thermalPage.batteryColor);
                            }
                        }
                    }
                }
            }
        }

        // =========================================================================
        // ROW 2: MIDDLE LAYER (STATUS [28%] + COOLING SYSTEM [42%] + WARNINGS [30%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 160
            spacing: thermalPage.gridSpacing

            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 28
                title: thermalPage.translations["title_status"][Typography.currentLanguage]
                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(4 * Theme.scale)
                    Repeater {
                        model: [
                            { nameKey: "check_motor", statusKey: vehicleData.motorOverTempWarning ? "status_overtemp" : "status_normal", col: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success, limit: "< 90 °C" },
                            { nameKey: "check_battery", statusKey: vehicleData.batteryOverTempWarning ? "status_overtemp" : "status_normal", col: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success, limit: "< 60 °C" },
                            { nameKey: "check_controller", statusKey: "status_normal", col: Colors.success, limit: "< 80 °C" }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: Theme.controlRadius; border.color: Colors.borderSubtle; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: Math.round(8 * Theme.scale); spacing: 8
                                Text { text: thermalPage.translations[modelData.nameKey][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: thermalPage.translations[modelData.statusKey][Typography.currentLanguage]; color: modelData.col; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight }
                                Text { text: modelData.limit; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 10; Layout.preferredWidth: Math.round(50 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }
                        }
                    }
                }
            }

            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 42
                title: thermalPage.translations["title_cooling"][Typography.currentLanguage]
                RowLayout {
                    anchors.fill: parent; spacing: Math.round(20 * Theme.scale)
                    
                    Item {
                        Layout.preferredWidth: Math.round(90 * Theme.scale)
                        Layout.preferredHeight: Math.round(90 * Theme.scale)
                        Layout.alignment: Qt.AlignVCenter
                        Canvas { 
                            anchors.fill: parent
                            onPaint: { 
                                var ctx = getContext("2d"); 
                                ctx.clearRect(0, 0, width, height); 
                                var cx = width / 2; 
                                var cy = height / 2; 
                                var r = width / 2 - 6; 
                                 
                                ctx.strokeStyle = Colors.surfaceBase; 
                                ctx.lineWidth = 6; 
                                ctx.beginPath(); 
                                ctx.arc(cx, cy, r, 0, 2 * Math.PI); 
                                ctx.stroke(); 
                                 
                                ctx.strokeStyle = Colors.borderActive; 
                                ctx.lineWidth = 6; 
                                ctx.beginPath(); 
                                ctx.arc(cx, cy, r, -Math.PI / 2, (2 * Math.PI * 0.68) - Math.PI / 2); 
                                ctx.stroke(); 
                            } 
                        }
                        Column { 
                            anchors.centerIn: parent
                            spacing: 1 
                            Text { text: thermalPage.translations["lbl_fan_speed"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: 8; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter } 
                            Text { text: "68 %"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; anchors.horizontalCenter: parent.horizontalCenter } 
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; spacing: Math.round(4 * Theme.scale)
                        Repeater {
                            model: [ 
                                { pKey: "lbl_coolant_temp", v: "38 °C" }, 
                                { pKey: "lbl_coolant_flow", v: "12.4 L/min" }, 
                                { pKey: "lbl_pump_status", vKey: "status_on" }, 
                                { pKey: "lbl_radiator_status", vKey: "status_normal" } 
                            ]
                            delegate: RowLayout { 
                                Layout.fillWidth: true; spacing: 8
                                Text { text: thermalPage.translations[modelData.pKey][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight; Layout.alignment: Qt.AlignVCenter } 
                                // FIXED: Wrapped vKey lookup behind an explicit ternary to block undefined lookups
                                Text { text: modelData.vKey ? thermalPage.translations[modelData.vKey][Typography.currentLanguage] : modelData.v; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight } 
                            }
                        }
                    }
                }
            }

            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 30
                title: thermalPage.translations["title_warnings"][Typography.currentLanguage]
                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(6 * Theme.scale)
                    RowLayout { 
                        Layout.fillWidth: true
                        Text { 
                            text: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? "1 " + thermalPage.translations["status_active_tag"][Typography.currentLanguage] : "0 " + thermalPage.translations["status_active_tag"][Typography.currentLanguage]
                            color: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? Colors.critical : Colors.success
                            font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold 
                            Layout.fillWidth: true; horizontalAlignment: Text.AlignRight
                        } 
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 0
                        
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 8
                            Text { text: vehicleData.motorOverTempWarning ? "⚠  " + thermalPage.translations["warn_motor"][Typography.currentLanguage] : "✓  " + thermalPage.translations["warn_motor"][Typography.currentLanguage]; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight } 
                            Text { text: vehicleData.motorOverTempWarning ? thermalPage.translations["status_fail"][Typography.currentLanguage] : thermalPage.translations["status_ok"][Typography.currentLanguage]; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 8
                            Text { text: vehicleData.batteryOverTempWarning ? "⚠  " + thermalPage.translations["warn_battery"][Typography.currentLanguage] : "✓  " + thermalPage.translations["warn_battery"][Typography.currentLanguage]; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight } 
                            Text { text: vehicleData.batteryOverTempWarning ? thermalPage.translations["status_fail"][Typography.currentLanguage] : thermalPage.translations["status_ok"][Typography.currentLanguage]; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 8
                            Text { text: "✓  " + thermalPage.translations["warn_controller"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight } 
                            Text { text: thermalPage.translations["status_ok"][Typography.currentLanguage]; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; spacing: 8
                            Text { text: "✓  " + thermalPage.translations["warn_derate"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; Layout.fillWidth: true; elide: Text.ElideRight } 
                            Text { text: thermalPage.translations["status_ok"][Typography.currentLanguage]; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.alignment: Qt.AlignRight } 
                        }
                    }
                }
            }
        }

        // =========================================================================
        // ROW 3: TEMPERATURE HISTORY CONTAINER (FULLY REACTIVE SPARKLINE CELLS)
        // =========================================================================
        BaseCard {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 150; title: thermalPage.translations["title_history"][Typography.currentLanguage]

            RowLayout {
                anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                Repeater {
                    model: [
                        { labelKey: "lbl_motor_temp", maxLimit: 120, minLimit: 0, col: thermalPage.motorColor },
                        { labelKey: "lbl_battery_temp", maxLimit: 60, minLimit: 0, col: thermalPage.batteryColor },
                        { labelKey: "lbl_controller_temp", maxLimit: 100, minLimit: 0, col: thermalPage.controllerColor }
                    ]

                    delegate: ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 4

                        readonly property var dataPool: index === 0 ? thermalPage.motorHistory : 
                                                        (index === 1 ? thermalPage.batteryHistory : thermalPage.controllerHistory)
                                                        
                        readonly property real calculatedMin: dataPool.length > 0 ? Math.min.apply(null, dataPool) : 0
                        readonly property real calculatedMax: dataPool.length > 0 ? Math.max.apply(null, dataPool) : 0
                        readonly property real calculatedAvg: thermalPage.calculateAverage(dataPool)

                        RowLayout {
                            Layout.fillWidth: true; spacing: 8
                            Text { text: thermalPage.translations[modelData.labelKey][Typography.currentLanguage]; color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { 
                                // FIXED: Translated the inline MIN/MAX/AVG row flags cleanly
                                text: thermalPage.translations["lbl_max"][Typography.currentLanguage] + ": " + Math.round(calculatedMax) + "°C  " + thermalPage.translations["lbl_min"][Typography.currentLanguage] + ": " + Math.round(calculatedMin) + "°C  " + thermalPage.translations["lbl_avg"][Typography.currentLanguage] + ": " + Math.round(calculatedAvg) + "°C"
                                color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 
                                Layout.alignment: Qt.AlignRight
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: Theme.controlRadius; border.color: Colors.borderSubtle; border.width: 1

                            Canvas {
                                id: sparklineCanvas; anchors.fill: parent
                                
                                property var renderTrigger: dataPool
                                onRenderTriggerChanged: sparklineCanvas.requestPaint()

                                onPaint: {
                                    var ctx = getContext("2d"); 
                                    ctx.clearRect(0, 0, width, height);
                                    ctx.strokeStyle = Qt.rgba(255,255,255,0.03); 
                                    ctx.lineWidth = 1;
                                    ctx.beginPath(); 
                                    ctx.moveTo(0, height / 2); 
                                    ctx.lineTo(width, height / 2); 
                                    ctx.stroke();
                                    
                                    if (!dataPool || dataPool.length < 2) return;
                                    
                                    ctx.strokeStyle = modelData.col; 
                                    ctx.lineWidth = 1.5; 
                                    ctx.beginPath();
                                    for (var i = 0; i < dataPool.length; i++) {
                                        var x = (i / (thermalPage.maxPoints - 1)) * width;
                                        var ratio = (dataPool[i] - modelData.minLimit) / (modelData.maxLimit - modelData.minLimit);
                                        var y = height - (Math.max(0.08, Math.min(0.92, ratio)) * height);
                                        if (i === 0) {
                                            ctx.moveTo(x, y);
                                        } else {
                                            ctx.lineTo(x, y);
                                        }
                                    }
                                    ctx.stroke();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}