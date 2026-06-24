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

    // Master Page Layout Architecture Container
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: thermalPage.gridSpacing
        spacing: thermalPage.gridSpacing

        // =========================================================================
        // ROW 1: TOP LAYER (CURRENT TEMPERATURES [46%] + TEMPERATURE TRENDS [54%])
        // =========================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 240 
            spacing: thermalPage.gridSpacing

            // --- 1. CURRENT TEMPERATURES CARD ---
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 46
                title: "CURRENT TEMPERATURES"

                RowLayout {
                    anchors.fill: parent
                    spacing: Math.round(10 * Theme.scale)

                    Repeater {
                        model: [
                            { title: "MOTOR TEMP", val: vehicleData.motorTemp, max: 120, col: thermalPage.motorColor, icon: "⚙" },
                            { title: "BATTERY TEMP", val: vehicleData.batteryTemp, max: 60, col: thermalPage.batteryColor, icon: "🔋" },
                            { title: "CONTROLLER TEMP", val: vehicleData.controllerTemp, max: 100, col: thermalPage.controllerColor, icon: "🎛" }
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: Colors.borderSubtle
                            border.width: 1

                            Item {
                                anchors.fill: parent
                                anchors.margins: Math.round(12 * Theme.scale)

                                Text { id: tLabel; text: modelData.title; color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold; anchors.top: parent.top; anchors.left: parent.left }
                                Text { text: modelData.icon; color: modelData.col; font.pixelSize: Math.round(32 * Theme.scale); anchors.centerIn: parent; anchors.verticalCenterOffset: Math.round(-12 * Theme.scale) }
                                
                                Row {
                                    id: numValueRow
                                    anchors.bottom: pTrack.top
                                    anchors.bottomMargin: Math.round(6 * Theme.scale)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 2
                                    Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.titleLarge; font.weight: Font.Bold; renderType: Text.QtRendering }
                                    Text { text: "°C"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(4 * Theme.scale) }
                                }

                                Text { text: "0"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; anchors.left: parent.left; anchors.bottom: parent.bottom }
                                Text { text: modelData.max; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; anchors.right: parent.right; anchors.bottom: parent.bottom }

                                Rectangle {
                                    id: pTrack
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: Math.round(14 * Theme.scale)
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: Math.round(4 * Theme.scale)
                                    color: Colors.surfaceBase
                                    radius: 2
                                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: parent.width * (Math.min(modelData.val, modelData.max) / modelData.max); color: modelData.col; radius: 2 }
                                }
                            }
                        }
                    }
                }
            }

            // --- 2. TEMPERATURE TRENDS LIVE GRAPH CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 54
                title: "TEMPERATURE TRENDS (LIVE)"

                ColumnLayout {
                    anchors.fill: parent; spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Row {
                            spacing: Math.round(12 * Theme.scale)
                            Text { text: "— Motor"; color: thermalPage.motorColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Text { text: "— Battery"; color: thermalPage.batteryColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Text { text: "— Controller"; color: thermalPage.controllerColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
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
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 28; title: "THERMAL STATUS"
                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(4 * Theme.scale)
                    Repeater {
                        model: [
                            { name: "MOTOR", status: vehicleData.motorOverTempWarning ? "OVERTEMP" : "NORMAL", col: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success, limit: "< 90 °C" },
                            { name: "BATTERY", status: vehicleData.batteryOverTempWarning ? "OVERTEMP" : "NORMAL", col: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success, limit: "< 60 °C" },
                            { name: "CONTROLLER", status: "NORMAL", col: Colors.success, limit: "< 80 °C" }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: Theme.controlRadius; border.color: Colors.borderSubtle; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: Math.round(8 * Theme.scale)
                                Text { text: modelData.name; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { text: modelData.status; color: modelData.col; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                                Text { text: modelData.limit; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 10; Layout.preferredWidth: Math.round(50 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }
                        }
                    }
                }
            }

            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 42; title: "COOLING SYSTEM"
                RowLayout {
                    anchors.fill: parent; spacing: Math.round(20 * Theme.scale)
                    
                    Item {
                        Layout.preferredWidth: Math.round(90 * Theme.scale)
                        Layout.preferredHeight: Math.round(90 * Theme.scale)
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
                            Text { text: "FAN SPEED"; font.family: Typography.family; font.pixelSize: 8; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter } 
                            Text { text: "68 %"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; anchors.horizontalCenter: parent.horizontalCenter } 
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: Math.round(4 * Theme.scale)
                        Repeater {
                            model: [ 
                                { p: "Coolant Temp", v: "38 °C" }, 
                                { p: "Coolant Flow", v: "12.4 L/min" }, 
                                { p: "Pump Status", v: "ON" }, 
                                { p: "Radiator Status", v: "NORMAL" } 
                            ]
                            delegate: Item { 
                                Layout.fillWidth: true
                                Layout.preferredHeight: Math.round(18 * Theme.scale)
                                Text { text: modelData.p; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter } 
                                Text { text: modelData.v; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter } 
                            }
                        }
                    }
                }
            }

            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 30; title: "THERMAL WARNINGS"
                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(6 * Theme.scale)
                    RowLayout { 
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? "1 ACTIVE" : "0 ACTIVE"
                            color: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? Colors.critical : Colors.success
                            font.family: Typography.family
                            font.pixelSize: 10
                            font.weight: Font.Bold 
                        } 
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 0
                        
                        RowLayout { 
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { text: vehicleData.motorOverTempWarning ? "⚠  Motor Over Temp" : "✓  Motor Over Temp"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label } 
                            Item { Layout.fillWidth: true } 
                            Text { text: vehicleData.motorOverTempWarning ? "FAIL" : "OK"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { text: vehicleData.batteryOverTempWarning ? "⚠  Battery Over Temp" : "✓  Battery Over Temp"; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label } 
                            Item { Layout.fillWidth: true } 
                            Text { text: vehicleData.batteryOverTempWarning ? "FAIL" : "OK"; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { text: "✓  Controller Over Temp"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label } 
                            Item { Layout.fillWidth: true } 
                            Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold } 
                        }
                        RowLayout { 
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { text: "✓  High Temp Derate"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label } 
                            Item { Layout.fillWidth: true } 
                            Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold } 
                        }
                    }
                }
            }
        }

        // =========================================================================
        // ROW 3: TEMPERATURE HISTORY CONTAINER (FULLY REACTIVE SPARKLINE CELLS)
        // =========================================================================
        BaseCard {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredHeight: 150; title: "TEMPERATURE HISTORY"

            RowLayout {
                anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                Repeater {
                    model: [
                        { label: "MOTOR TEMP", maxLimit: 120, minLimit: 0, col: thermalPage.motorColor },
                        { label: "BATTERY TEMP", maxLimit: 60, minLimit: 0, col: thermalPage.batteryColor },
                        { label: "CONTROLLER TEMP", maxLimit: 100, minLimit: 0, col: thermalPage.controllerColor }
                    ]

                    delegate: ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 4

                        readonly property var dataPool: index === 0 ? thermalPage.motorHistory : 
                                                        (index === 1 ? thermalPage.batteryHistory : thermalPage.controllerHistory)
                                                        
                        readonly property real calculatedMin: dataPool.length > 0 ? Math.min.apply(null, dataPool) : 0
                        readonly property real calculatedMax: dataPool.length > 0 ? Math.max.apply(null, dataPool) : 0
                        readonly property real calculatedAvg: thermalPage.calculateAverage(dataPool)

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: modelData.label; color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: "Max: " + Math.round(calculatedMax) + "°C  Min: " + Math.round(calculatedMin) + "°C  Avg: " + Math.round(calculatedAvg) + "°C"
                                color: Colors.textMuted
                                font.family: Typography.family
                                font.pixelSize: 9 
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