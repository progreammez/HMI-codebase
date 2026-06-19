import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: thermalPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    readonly property int cardRadius: Theme.controlRadius
    
    // Strict row dimension specs calculated directly from your base HMI shell geometry
    readonly property int topRowHeight: Math.round(240 * Theme.scale)
    readonly property int midRowHeight: Math.round(160 * Theme.scale)

    // Domain Specific Accent Colors matching your reference graphics assets
    readonly property color motorColor: "#00D1FF"      // Vibrant Cyan
    readonly property color batteryColor: "#FF9F0A"    // High-vis Orange
    readonly property color controllerColor: "#BF5AF2" // Tech Purple

    // =========================================================================
    // ROW 1: TOP LAYER (CURRENT TEMPERATURES [46%] + TEMPERATURE TRENDS [54%])
    // =========================================================================
    Item {
        id: topRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: thermalPage.topRowHeight

        // --- 1. CURRENT TEMPERATURES CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width * 0.46 - (thermalPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(12 * Theme.scale)

                Text { text: "CURRENT TEMPERATURES"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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

                                // Header Label Pinned Left
                                Text { id: tLabel; text: modelData.title; color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold; anchors.top: parent.top; anchors.left: parent.left }
                                
                                // Large Styled Centered Asset Icon
                                Text { 
                                    text: modelData.icon; color: modelData.col; font.pixelSize: Math.round(32 * Theme.scale)
                                    anchors.centerIn: parent; anchors.verticalCenterOffset: Math.round(-12 * Theme.scale)
                                }
                                
                                // Precise Numeric String Callout
                                Row {
                                    id: numValueRow
                                    anchors.bottom: pTrack.top
                                    anchors.bottomMargin: Math.round(6 * Theme.scale)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 2
                                    Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.titleLarge; font.weight: Font.Bold }
                                    Text { text: "°C"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.bottom: parent.bottom; anchors.bottomMargin: Math.round(4 * Theme.scale) }
                                }

                                // Min/Max Constraints Label Marks
                                Text { text: "0"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; anchors.left: parent.left; anchors.bottom: parent.bottom }
                                Text { text: modelData.max; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; anchors.right: parent.right; anchors.bottom: parent.bottom }

                                // Bottom Progress Loading Tracker Bar
                                Rectangle {
                                    id: pTrack
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: Math.round(14 * Theme.scale)
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: Math.round(4 * Theme.scale)
                                    color: Colors.surfaceBase
                                    radius: 2

                                    Rectangle {
                                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                                        width: parent.width * (Math.min(modelData.val, modelData.max) / modelData.max)
                                        color: modelData.col; radius: 2
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // --- 2. TEMPERATURE TRENDS LIVE GRAPH CARD ---
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width * 0.54 - (thermalPage.gridSpacing / 2)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(14 * Theme.scale)
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "TEMPERATURE TRENDS (LIVE)"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    Item { Layout.fillWidth: true }
                    
                    Row {
                        spacing: Math.round(12 * Theme.scale)
                        Text { text: "— Motor"; color: thermalPage.motorColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                        Text { text: "— Battery"; color: thermalPage.batteryColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                        Text { text: "— Controller"; color: thermalPage.controllerColor; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Left Side Y-Axis Metrics Labels Marks
                    Column {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: Math.round(20 * Theme.scale)
                        spacing: (parent.height - Math.round(40 * Theme.scale)) / 4

                        Text { text: "125"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        Text { text: "100"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        Text { text: "75"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        Text { text: "50"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        Text { text: "25"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                    }

                    // Bottom X-Axis Timeline Labels Marks
                    Row {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: Math.round(24 * Theme.scale)
                        anchors.right: parent.right
                        Text { text: "60s ago"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33 }
                        Text { text: "45s"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "30s"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; width: parent.width * 0.33; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "Now"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                    }

                    Canvas {
                        anchors.fill: parent
                        anchors.leftMargin: Math.round(24 * Theme.scale)
                        anchors.bottomMargin: Math.round(14 * Theme.scale)

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            
                            // Draw ambient horizontal background tracking grid lines
                            ctx.strokeStyle = Qt.rgba(255,255,255,0.04);
                            ctx.lineWidth = 1;
                            for (var i = 0; i <= 4; i++) {
                                var y = (height / 4) * i;
                                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke();
                            }

                            ctx.lineWidth = 2;
                            // Motor Path Trend (Cyan)
                            ctx.strokeStyle = thermalPage.motorColor; ctx.beginPath();
                            ctx.moveTo(0, height * 0.52); ctx.bezierCurveTo(width*0.3, height*0.48, width*0.6, height*0.56, width, height * 0.50); ctx.stroke();

                            // Controller Path Trend (Purple)
                            ctx.strokeStyle = thermalPage.controllerColor; ctx.beginPath();
                            ctx.moveTo(0, height * 0.65); ctx.bezierCurveTo(width*0.3, height*0.60, width*0.7, height*0.68, width, height * 0.61); ctx.stroke();

                            // Battery Path Trend (Orange)
                            ctx.strokeStyle = thermalPage.batteryColor; ctx.beginPath();
                            ctx.moveTo(0, height * 0.78); ctx.bezierCurveTo(width*0.4, height*0.74, width*0.5, height*0.76, width, height * 0.75); ctx.stroke();
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // ROW 2: MIDDLE LAYER (STATUS [28%] + COOLING SYSTEM [42%] + WARNINGS [30%])
    // =========================================================================
    Item {
        id: midRow
        anchors.top: topRow.bottom
        anchors.topMargin: thermalPage.gridSpacing
        anchors.left: parent.left
        anchors.right: parent.right
        height: thermalPage.midRowHeight

        // --- 3. THERMAL STATUS CARD ---
        Rectangle {
            anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left
            width: parent.width * 0.28 - (thermalPage.gridSpacing / 3)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(8 * Theme.scale)

                Text { text: "THERMAL STATUS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

                ColumnLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; spacing: Math.round(4 * Theme.scale)
                    Repeater {
                        model: [
                            { name: "MOTOR", status: vehicleData.motorOverTempWarning ? "OVERTEMP" : "NORMAL", col: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success, limit: "< 90 °C" },
                            { name: "BATTERY", status: vehicleData.batteryOverTempWarning ? "OVERTEMP" : "NORMAL", col: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success, limit: "< 60 °C" },
                            { name: "CONTROLLER", status: "NORMAL", col: Colors.success, limit: "< 80 °C" }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: Theme.controlRadius
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
        }

        // --- 4. COOLING SYSTEM GAUGE CARD ---
        Rectangle {
            anchors.top: parent.top; anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.42 - (thermalPage.gridSpacing / 3)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(6 * Theme.scale)

                Text { text: "COOLING SYSTEM"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

                RowLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; spacing: Math.round(20 * Theme.scale)

                    Item {
                        Layout.preferredWidth: Math.round(90 * Theme.scale); Layout.preferredHeight: Math.round(90 * Theme.scale)
                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                var cx = width/2; var cy = height/2; var r = width/2 - 6;
                                ctx.strokeStyle = Colors.surfaceBase; ctx.lineWidth = 6;
                                ctx.beginPath(); ctx.arc(cx,cy,r,0,2*Math.PI); ctx.stroke();
                                ctx.strokeStyle = Colors.borderActive; ctx.beginPath();
                                ctx.arc(cx,cy,r,-Math.PI/2, (2*Math.PI*0.68) - Math.PI/2); ctx.stroke();
                            }
                        }
                        Column {
                            anchors.centerIn: parent; spacing: 1
                            Text { text: "FAN SPEED"; font.family: Typography.family; font.pixelSize: 8; color: Colors.textMuted; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "68 %"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.weight: Font.Bold; color: Colors.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: Math.round(4 * Theme.scale)
                        Repeater {
                            model: [
                                { p: "Coolant Temp", v: "38 °C" }, { p: "Coolant Flow", v: "12.4 L/min" },
                                { p: "Pump Status", v: "ON" }, { p: "Radiator Status", v: "NORMAL" }
                            ]
                            delegate: Item {
                                Layout.fillWidth: true; Layout.preferredHeight: Math.round(18 * Theme.scale)
                                Text { text: modelData.p; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.label; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: modelData.v; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                            }
                        }
                    }
                }
            }
        }

        // --- 5. THERMAL WARNINGS CARD ---
        Rectangle {
            anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right
            width: parent.width * 0.30 - (thermalPage.gridSpacing / 3)
            color: Colors.surfaceRaised
            radius: thermalPage.cardRadius
            border.color: Colors.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                spacing: Math.round(6 * Theme.scale)

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "THERMAL WARNINGS"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    Item { Layout.fillWidth: true }
                    Text { text: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? "1 ACTIVE" : "0 ACTIVE"; color: (vehicleData.motorOverTempWarning || vehicleData.batteryOverTempWarning) ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                }

                ColumnLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; spacing: 0
                    RowLayout { Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: vehicleData.motorOverTempWarning ? "⚠  Motor Over Temp" : "✓  Motor Over Temp"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label }
                        Item { Layout.fillWidth: true }
                        Text { text: vehicleData.motorOverTempWarning ? "FAIL" : "OK"; color: vehicleData.motorOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    }
                    RowLayout { Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: vehicleData.batteryOverTempWarning ? "⚠  Battery Over Temp" : "✓  Battery Over Temp"; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label }
                        Item { Layout.fillWidth: true }
                        Text { text: vehicleData.batteryOverTempWarning ? "FAIL" : "OK"; color: vehicleData.batteryOverTempWarning ? Colors.critical : Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    }
                    RowLayout { Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: "✓  Controller Over Temp"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label }
                        Item { Layout.fillWidth: true }
                        Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    }
                    RowLayout { Layout.fillWidth: true; Layout.fillHeight: true
                        Text { text: "✓  High Temp Derate"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.label }
                        Item { Layout.fillWidth: true }
                        Text { text: "OK"; color: Colors.success; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }
                    }
                }
            }
        }
    }

    // =========================================================================
    // ROW 3: TEMPERATURE HISTORY CONTAINER (RE-ANCHORED TO SCREEN BASE)
    // =========================================================================
    Rectangle {
        id: row3History
        anchors.top: midRow.bottom
        anchors.topMargin: thermalPage.gridSpacing
        anchors.bottom: parent.bottom // Explicit screen base anchoring locks down your missing metrics sparklines
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colors.surfaceRaised
        radius: thermalPage.cardRadius
        border.color: Colors.borderSubtle
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Math.round(14 * Theme.scale)
            spacing: Math.round(6 * Theme.scale)

            Text { text: "TEMPERATURE HISTORY"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.label; font.weight: Font.Bold }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Math.round(16 * Theme.scale)

                Repeater {
                    model: [
                        { label: "MOTOR TEMP", max: "61", min: "37", avg: "49", col: thermalPage.motorColor },
                        { label: "BATTERY TEMP", max: "41", min: "28", avg: "34", col: thermalPage.batteryColor },
                        { label: "CONTROLLER TEMP", max: "49", min: "31", avg: "40", col: thermalPage.controllerColor }
                    ]

                    delegate: ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: modelData.label; color: modelData.col; font.family: Typography.family; font.pixelSize: 10; font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            Text { text: "Max: " + modelData.max + "°C  Min: " + modelData.min + "°C  Avg: " + modelData.avg + "°C"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.surfaceSunken
                            radius: Theme.controlRadius
                            border.color: Colors.borderSubtle
                            border.width: 1

                            Canvas {
                                anchors.fill: parent
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                    ctx.strokeStyle = Qt.rgba(255,255,255,0.03); ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.moveTo(0, height/2); ctx.lineTo(width, height/2); ctx.stroke();
                                    
                                    // Rolling historical canvas smooth spline tracking sparkline curves simulation
                                    ctx.strokeStyle = modelData.col; ctx.lineWidth = 1.5; ctx.beginPath();
                                    ctx.moveTo(0, height*0.62); ctx.lineTo(width*0.2, height*0.58); ctx.lineTo(width*0.4, height*0.70);
                                    ctx.lineTo(width*0.6, height*0.50); ctx.lineTo(width*0.8, height*0.55); ctx.lineTo(width, height*0.60); ctx.stroke();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}