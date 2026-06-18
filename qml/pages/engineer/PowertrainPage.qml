import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: powertrainPage
    anchors.fill: parent

    readonly property int gridSpacing: Math.round(12 * Theme.scale)
    readonly property int cardRadius: Theme.controlRadius
    
    // Height bounding metric for Row 1
    readonly property int topRowHeight: Math.round(340 * Theme.scale)
    
    // Domain Specific Theme Tokens
    readonly property color voltColor: "#00D1FF"       // Cyan
    readonly property color currentColor: "#FF9F0A"   // Orange
    readonly property color powerColor: "#BF5AF2"      // Purple
    readonly property color greenEco: "#00FF66"        // Bright Eco Green

    ColumnLayout {
        anchors.fill: parent
        spacing: powertrainPage.gridSpacing

        // =========================================================================
        // ROW 1: TOP LAYER (LIVE POWERTRAIN VALUES [30%] + POWERTRAIN TRENDS [70%])
        // =========================================================================
        Item {
            id: topRow
            Layout.fillWidth: true
            Layout.preferredHeight: powertrainPage.topRowHeight

            // --- 1. LIVE POWERTRAIN VALUES CARD ---
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width * 0.30 - (powertrainPage.gridSpacing / 2)
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.round(14 * Theme.scale)
                    spacing: Math.round(6 * Theme.scale)

                    Text { 
                        text: "LIVE POWERTRAIN VALUES"
                        color: Colors.textPrimary // Reverted to adaptive framework color
                        font.family: Typography.family
                        font.pixelSize: Math.round(13 * Theme.scale)
                        font.weight: Font.Bold
                        Layout.bottomMargin: 4 
                    }

                    Repeater {
                        model: [
                            { icon: "🔋", p: "BATTERY VOLTAGE", v: "72.4", u: "V", col: powertrainPage.voltColor },
                            { icon: "⚡", p: "BATTERY CURRENT", v: "18.2", u: "A", col: powertrainPage.voltColor },
                            { icon: "⚙", p: "MOTOR POWER", v: vehicleData.motorPower.toFixed(1), u: "kW", col: powertrainPage.voltColor },
                            { icon: "🔄", p: "REGEN LEVEL", v: vehicleData.regenLevel, u: "Level", col: powertrainPage.voltColor },
                            { icon: "⏱", p: "MOTOR RPM", v: vehicleData.rpm, u: "RPM", col: powertrainPage.voltColor },
                            { icon: "🛣", p: "DRIVE MODE", v: vehicleData.driveMode, u: "", col: powertrainPage.voltColor },
                            { icon: "🕹", p: "GEAR STATE", v: vehicleData.gearState, u: "", col: powertrainPage.voltColor }
                        ]

                        delegate: RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 0
                            
                            Text { text: modelData.icon; font.pixelSize: Math.round(13 * Theme.scale); color: modelData.col; Layout.preferredWidth: Math.round(26 * Theme.scale) }
                            Text { text: modelData.p; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold; Layout.fillWidth: true }
                            Text { text: modelData.v; color: modelData.col; font.family: Typography.family; font.pixelSize: Math.round(14 * Theme.scale); font.weight: Font.Bold; Layout.preferredWidth: Math.round(75 * Theme.scale); horizontalAlignment: Text.AlignRight }
                            Text { text: modelData.u; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); Layout.preferredWidth: Math.round(40 * Theme.scale); horizontalAlignment: Text.AlignRight }
                        }
                    }
                }
            }

            // --- 2. POWERTRAIN TRENDS LIVE GRAPH CARD ---
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: parent.width * 0.70 - (powertrainPage.gridSpacing / 2)
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.round(14 * Theme.scale)
                    spacing: Math.round(6 * Theme.scale)

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "POWERTRAIN TRENDS (LIVE)"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(13 * Theme.scale); font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                        
                        Row {
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
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Math.round(16 * Theme.scale)

                        // --- Sub-Graph 1: VOLTAGE TREND ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100 
                            Layout.fillHeight: true
                            spacing: 4

                            RowLayout { Layout.fillWidth: true
                                Text { text: "VOLTAGE TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                                Item { Layout.fillWidth: true }
                                Text { text: "(V)"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                            }
                            Text { text: "72.4 V"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                            
                            Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4
                                Canvas {
                                    anchors.fill: parent; anchors.margins: 4
                                    onPaint: {
                                        var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                        // Uses dynamic alpha mapping based on your frame color to stay crisp in light mode
                                        ctx.strokeStyle = Qt.alpha(Colors.textPrimary, 0.08); ctx.lineWidth = 1;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                        ctx.strokeStyle = powertrainPage.voltColor; ctx.lineWidth = 2;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.4); ctx.lineTo(width*0.3, height*0.38); ctx.lineTo(width*0.7, height*0.42); ctx.lineTo(width, height*0.35); ctx.stroke();
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MIN"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "70.1 V"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MAX"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "74.2 V"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "AVG"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "72.3 V"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.voltColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                            }
                        }

                        // --- Sub-Graph 2: CURRENT TREND ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            spacing: 4

                            RowLayout { Layout.fillWidth: true
                                Text { text: "CURRENT TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                                Item { Layout.fillWidth: true }
                                Text { text: "(A)"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                            }
                            Text { text: "18.2 A"; color: powertrainPage.currentColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                            
                            Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4
                                Canvas {
                                    anchors.fill: parent; anchors.margins: 4
                                    onPaint: {
                                        var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                        ctx.strokeStyle = Qt.alpha(Colors.textPrimary, 0.08); ctx.lineWidth = 1;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                        ctx.strokeStyle = powertrainPage.currentColor; ctx.lineWidth = 2;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.6); ctx.lineTo(width*0.4, height*0.7); ctx.lineTo(width*0.8, height*0.4); ctx.lineTo(width, height*0.5); ctx.stroke();
                                    }
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MIN"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "-6.3 A"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MAX"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "28.7 A"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "AVG"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "16.8 A"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.currentColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                            }
                        }

                        // --- Sub-Graph 3: POWER TREND ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            spacing: 4

                            RowLayout { Layout.fillWidth: true
                                Text { text: "POWER TREND"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale); font.weight: Font.Bold }
                                Item { Layout.fillWidth: true }
                                Text { text: "(kW)"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(10 * Theme.scale) }
                            }
                            Text { text: vehicleData.motorPower.toFixed(1) + " kW"; color: powertrainPage.powerColor; font.family: Typography.family; font.pixelSize: Math.round(20 * Theme.scale); font.weight: Font.Bold }
                            
                            Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true; color: Colors.surfaceSunken; radius: 4
                                Canvas {
                                    anchors.fill: parent; anchors.margins: 4
                                    onPaint: {
                                        var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                                        ctx.strokeStyle = Qt.alpha(Colors.textPrimary, 0.08); ctx.lineWidth = 1;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.5); ctx.lineTo(width, height*0.5); ctx.stroke();
                                        ctx.strokeStyle = powertrainPage.powerColor; ctx.lineWidth = 2;
                                        ctx.beginPath(); ctx.moveTo(0, height*0.65); ctx.lineTo(width*0.3, height*0.5); ctx.lineTo(width*0.6, height*0.7); ctx.lineTo(width, height*0.45); ctx.stroke();
                                    }
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MIN"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "-1.2 kW"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "MAX"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "8.6 kW"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "AVG"; font.pixelSize: Math.round(9 * Theme.scale); color: Colors.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "4.3 kW"; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold; color: powertrainPage.powerColor; anchors.horizontalCenter: parent.horizontalCenter }
                                }
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: powertrainPage.gridSpacing

            // --- 3. POWER DISTRIBUTION CARD ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 34
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                    spacing: Math.round(6 * Theme.scale)

                    Text { text: "POWER DISTRIBUTION"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(13 * Theme.scale); font.weight: Font.Bold }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Math.round(16 * Theme.scale)
                        Layout.alignment: Qt.AlignVCenter

                        Item {
                            Layout.preferredWidth: Math.round(100 * Theme.scale)
                            Layout.preferredHeight: Math.round(100 * Theme.scale)
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
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: Math.round(4 * Theme.scale)
                            
                            Repeater {
                                model: [
                                    { name: "MOTOR OUTPUT", val: vehicleData.motorPower.toFixed(1) + " kW", pct: "100%", col: powertrainPage.voltColor },
                                    { name: "REGENERATIVE", val: "0.0 kW", pct: "0%", col: powertrainPage.greenEco },
                                    { name: "AUXILIARY LOAD", val: "0.0 kW", pct: "0%", col: powertrainPage.currentColor },
                                    { name: "LOSSES", val: "0.0 kW", pct: "0%", col: powertrainPage.powerColor }
                                ]
                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    spacing: Math.round(6 * Theme.scale)
                                    
                                    Rectangle { width: 6; height: 6; radius: 3; color: modelData.col; Layout.alignment: Qt.AlignVCenter }
                                    Text { text: modelData.name; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold; Layout.alignment: Qt.AlignVCenter }
                                    
                                    Item { Layout.fillWidth: true }
                                    
                                    Text { text: modelData.val; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); font.weight: Font.Bold; Layout.alignment: Qt.AlignVCenter }
                                    Text { text: modelData.pct; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(11 * Theme.scale); Layout.preferredWidth: Math.round(36 * Theme.scale); horizontalAlignment: Text.AlignRight; Layout.alignment: Qt.AlignVCenter }
                                }
                            }
                        }
                    }
                }
            }

            // --- 4. REGENERATION STATUS CARD ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 33
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                    spacing: Math.round(6 * Theme.scale)

                    Text { text: "REGENERATION STATUS"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(13 * Theme.scale); font.weight: Font.Bold }

                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: Math.round(6 * Theme.scale)

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "REGEN LEVEL"; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale) }
                            Text { text: vehicleData.regenLevel + " Level"; color: powertrainPage.voltColor; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                            Item { Layout.fillWidth: true }
                            
                            Row {
                                spacing: 2
                                Repeater {
                                    model: 5
                                    Rectangle {
                                        width: Math.round(14 * Theme.scale); height: Math.round(8 * Theme.scale); radius: 1
                                        color: index <= vehicleData.regenLevel ? powertrainPage.greenEco : Colors.surfaceSunken
                                    }
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
            }

            // --- 5. DRIVE SYSTEM STATUS CARD ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 33
                Layout.fillHeight: true
                color: Colors.surfaceRaised
                radius: powertrainPage.cardRadius
                border.color: Colors.borderSubtle
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: Math.round(14 * Theme.scale)
                    spacing: Math.round(6 * Theme.scale)

                    Text { text: "DRIVE SYSTEM STATUS"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Math.round(13 * Theme.scale); font.weight: Font.Bold }

                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 0
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
                                Text { text: modelData.k; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                                Item { Layout.fillWidth: true }
                                Text { text: modelData.v; color: modelData.c; font.family: Typography.family; font.pixelSize: Math.round(12 * Theme.scale); font.weight: Font.Bold }
                            }
                        }
                    }
                }
            }
        }
    }
}