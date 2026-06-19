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
    readonly property int maxDataPoints: 30

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

    function processTelemetryStatistics() {
        var vList = powertrainPage.voltHistory
        var cList = powertrainPage.currentHistory
        var pList = powertrainPage.powerHistory

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
                title: "LIVE POWERTRAIN VALUES"

                ColumnLayout {
                    anchors.fill: parent; spacing: 0

                    Repeater {
                        model: [
                            { icon: "🔋", p: "BATTERY VOLTAGE", v: "72.4", u: "V", col: powertrainPage.voltColor },
                            { icon: "⚡", p: "BATTERY CURRENT", v: "18.2", u: "A", col: powertrainPage.currentColor },
                            { icon: "⚙", p: "MOTOR POWER", v: vehicleData.motorPower.toFixed(1), u: "kW", col: powertrainPage.powerColor },
                            { icon: "🔄", p: "REGEN LEVEL", v: vehicleData.regenLevel, u: "Level", col: powertrainPage.greenEco },
                            { icon: "⏱", p: "MOTOR RPM", v: vehicleData.rpm, u: "RPM", col: Colors.textPrimary },
                            { icon: "🛣", p: "DRIVE MODE", v: vehicleData.driveMode, u: "", col: Colors.textPrimary },
                            { icon: "🕹", p: "GEAR STATE", v: vehicleData.gearState, u: "", col: Colors.textPrimary }
                        ]

                        delegate: Item {
                            Layout.fillWidth: true; Layout.fillHeight: true

                            RowLayout {
                                anchors.fill: parent; anchors.bottomMargin: Math.round(2 * Theme.scale); spacing: 0
                                Text { text: modelData.icon; font.pixelSize: Math.round(13 * Theme.scale); color: modelData.col; Layout.preferredWidth: Math.round(26 * Theme.scale) }
                                Text { text: modelData.p; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold; Layout.fillWidth: true }
                                Text { 
                                    text: modelData.v
                                    color: (modelData.p.indexOf("MODE") !== -1) ? powertrainPage.voltColor : modelData.col
                                    font.family: Typography.family; font.pixelSize: Math.round(13 * Theme.scale); font.weight: Font.Bold
                                    Layout.preferredWidth: Math.round(75 * Theme.scale); horizontalAlignment: Text.AlignRight; renderType: Text.QtRendering
                                }
                                Text { text: modelData.u; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); Layout.preferredWidth: Math.round(40 * Theme.scale); horizontalAlignment: Text.AlignRight }
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
                title: "POWERTRAIN TRENDS (LIVE)"

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
                            width: Math.round(50 * Theme.scale); height: Math.round(22 * Theme.scale); radius: 4
                            color: modelData === "30 s" ? Colors.surfaceSunken : "transparent"
                            border.color: modelData === "30 s" ? Colors.borderActive : "transparent"
                            Text { text: modelData; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold; color: modelData === "30 s" ? Colors.textPrimary : Colors.textSecondary; anchors.centerIn: parent }
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent; spacing: Math.round(16 * Theme.scale)

                    // GRAPH MODULE 1: VOLTAGE
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true
                            Text { text: "VOLTAGE TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: "(V)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                        }
                        Text { text: "72.4 V"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: vCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();

                                    var data = powertrainPage.voltHistory;
                                    if (!data || data.length < 2) return;

                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (powertrainPage.maxDataPoints - 1)) * width;
                                        var ratio = (data[i] - 60.0) / (80.0 - 60.0); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }

                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(0, 209, 255, 0.15)); grad.addColorStop(1, Qt.rgba(0, 209, 255, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(0, height);
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
                            Layout.fillWidth: true
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MIN"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vMinStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MAX"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vMaxStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "AVG"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.vAvgStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }

                    // GRAPH MODULE 2: CURRENT
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true
                            Text { text: "CURRENT TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: "(A)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                        }
                        Text { text: "18.2 A"; color: powertrainPage.currentColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: cCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();

                                    var data = powertrainPage.currentHistory;
                                    if (!data || data.length < 2) return;

                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (powertrainPage.maxDataPoints - 1)) * width;
                                        var ratio = (data[i] - (-20.0)) / (60.0 - (-20.0)); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }

                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(255, 159, 10, 0.15)); grad.addColorStop(1, Qt.rgba(255, 159, 10, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(0, height);
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
                            Layout.fillWidth: true
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MIN"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cMinStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MAX"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cMaxStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "AVG"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.cAvgStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }

                    // GRAPH MODULE 3: POWER
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        RowLayout { 
                            Layout.fillWidth: true
                            Text { text: "POWER TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: "(kW)"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                        }
                        Text { text: vehicleData.motorPower.toFixed(1) + " kW"; color: powertrainPage.powerColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                        
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4; border.color: Colors.borderSubtle; border.width: 1
                            Canvas {
                                id: pCanvas; anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();

                                    var data = powertrainPage.powerHistory;
                                    if (!data || data.length < 2) return;

                                    var points = [];
                                    for (var i=0; i<data.length; i++) {
                                        var x = (i / (powertrainPage.maxDataPoints - 1)) * width;
                                        var ratio = (data[i] - (-10.0)) / (100.0 - (-10.0)); 
                                        var y = height - (Math.max(0.05, Math.min(0.95, ratio)) * height);
                                        points.push({x: x, y: y});
                                    }

                                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                                    grad.addColorStop(0, Qt.rgba(191, 90, 242, 0.15)); grad.addColorStop(1, Qt.rgba(191, 90, 242, 0.00));
                                    ctx.fillStyle = grad; ctx.beginPath(); ctx.moveTo(0, height);
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
                            Layout.fillWidth: true
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MIN"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pMinStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "MAX"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pMaxStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                            Column {
                                Layout.fillWidth: true
                                Text { text: "AVG"; font.pixelSize: 9; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: trendCard.pAvgStr; font.pixelSize: 11; font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
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
                title: "POWER DISTRIBUTION"

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
                            Text { text: vehicleData.motorPower.toFixed(1); font.family: Typography.family; font.pixelSize: Math.round(18 * Theme.scale); font.weight: Font.Bold; color: Colors.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "kW"; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; spacing: Math.round(4 * Theme.scale)
                        Repeater {
                            model: [
                                { name: "MOTOR OUTPUT", val: vehicleData.motorPower.toFixed(1) + " kW", pct: "100%", col: powertrainPage.voltColor },
                                { name: "REGENERATIVE", val: "0.0 kW", pct: "0%", col: powertrainPage.greenEco },
                                { name: "AUXILIARY LOAD", val: "0.0 kW", pct: "0%", col: powertrainPage.currentColor },
                                { name: "LOSSES", val: "0.0 kW", pct: "0%", col: powertrainPage.powerColor }
                            ]
                            delegate: RowLayout {
                                Layout.fillWidth: true; spacing: Math.round(6 * Theme.scale)
                                Rectangle { width: 6; height: 6; radius: 3; color: modelData.col; Layout.alignment: Qt.AlignVCenter }
                                Text { text: modelData.name; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold }
                                Item { Layout.fillWidth: true }
                                Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold }
                                Text { text: modelData.pct; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); Layout.preferredWidth: Math.round(36 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            }
                        }
                    }
                }
            }

            // --- 4. REGENERATION STATUS CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 33
                title: "REGENERATION STATUS"

                ColumnLayout {
                    anchors.fill: parent; spacing: Math.round(6 * Theme.scale)

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "REGEN LEVEL"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale) }
                        Text { text: vehicleData.regenLevel + " Level"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        Row {
                            spacing: 2
                            Repeater {
                                model: 3
                                Rectangle { width: Math.round(18 * Theme.scale); height: Math.round(10 * Theme.scale); radius: 1; color: index < vehicleData.regenLevel ? powertrainPage.greenEco : Colors.surfaceSunken }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "REGEN STATUS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale) }
                        Item { Layout.fillWidth: true }
                        Text { text: "ACTIVE"; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "REGEN POWER"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale) }
                        Item { Layout.fillWidth: true }
                        Text { text: "-0.8 kW"; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "ENERGY RECOVERED (TODAY)"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale) }
                        Item { Layout.fillWidth: true }
                        Text { text: "0.72 kWh"; color: powertrainPage.greenEco; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                    }
                }
            }

            // --- 5. DRIVE SYSTEM STATUS CARD ---
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 33
                title: "DRIVE SYSTEM STATUS"

                ColumnLayout {
                    anchors.fill: parent; spacing: 0
                    Repeater {
                        model: [
                            { k: "INVERTER STATUS", v: "NORMAL", c: powertrainPage.greenEco },
                            { k: "DC-DC CONVERTER", v: "NORMAL", c: powertrainPage.greenEco },
                            { k: "BMS STATUS", v: "NORMAL", c: powertrainPage.greenEco },
                            { k: "MOTOR CONTROLLER", v: "NORMAL", c: powertrainPage.greenEco },
                            { k: "DRIVE SYSTEM FAULT", v: "NONE", c: powertrainPage.greenEco },
                            { k: "POWER LIMIT STATE", v: "NONE", c: powertrainPage.greenEco }
                        ]
                        delegate: RowLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { text: modelData.k; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: modelData.v; color: modelData.c; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold }
                        }
                    }
                }
            }
        }
    }
}