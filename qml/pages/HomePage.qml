import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: root

    readonly property color modeColor: vehicleData.driveMode === "SPORT" ? Colors.accentSport
        : vehicleData.driveMode === "CITY" ? Colors.accentCity
        : Colors.accentEco
    readonly property bool activeWarning: vehicleData.communicationFault
        || vehicleData.warningMessage.length > 0
        || vehicleData.lowBatteryWarning
        || vehicleData.motorOverTempWarning
        || vehicleData.batteryOverTempWarning

    GridLayout {
        anchors.fill: parent
        columns: 12
        rows: 8
        columnSpacing: Theme.cardGap
        rowSpacing: Theme.cardGap

        BaseCard {
            Layout.column: 0
            Layout.row: 0
            Layout.columnSpan: 8
            Layout.rowSpan: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: Math.round(18 * Theme.scale)
            baseColor: Colors.surfaceSunken
            outlineColor: root.modeColor

            Item {
                anchors.fill: parent

                Row {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Math.round(18 * Theme.scale)

                    IndicatorLamp {
                        label: "L"
                        active: vehicleData.leftIndicator || vehicleData.hazardLights
                    }

                    Row {
                        spacing: Math.round(8 * Theme.scale)
                        Repeater {
                            model: ["P", "R", "N", "D"]
                            Rectangle {
                                width: Math.round(46 * Theme.scale)
                                height: Math.round(36 * Theme.scale)
                                radius: Theme.controlRadius
                                color: vehicleData.gearState === modelData ? root.modeColor : Colors.surfaceRaised
                                border.color: vehicleData.gearState === modelData ? root.modeColor : Colors.borderSubtle

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: vehicleData.gearState === modelData ? Colors.backgroundPrimary : Colors.textSecondary
                                    font.family: Typography.family
                                    font.pixelSize: Typography.bodyMedium
                                    font.weight: Font.DemiBold
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: vehicleData.gearState = modelData
                                }
                            }
                        }
                    }

                    IndicatorLamp {
                        label: "R"
                        active: vehicleData.rightIndicator || vehicleData.hazardLights
                    }
                }

                Canvas {
                    id: speedArc
                    anchors.fill: parent
                    anchors.topMargin: Math.round(42 * Theme.scale)
                    anchors.bottomMargin: Math.round(34 * Theme.scale)
                    onPaint: {
                        var ctx = getContext("2d")
                        var cx = width / 2
                        var cy = height * 0.66
                        var r = Math.min(width * 0.36, height * 0.52)
                        var start = Math.PI * 0.78
                        var end = Math.PI * 2.22
                        var valueEnd = start + (end - start) * Math.min(1, vehicleData.speed / 140)
                        ctx.clearRect(0, 0, width, height)
                        ctx.lineCap = "round"
                        ctx.lineWidth = Math.max(10, 16 * Theme.scale)
                        ctx.strokeStyle = Colors.borderSubtle
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, start, end)
                        ctx.stroke()
                        ctx.strokeStyle = root.modeColor
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, start, valueEnd)
                        ctx.stroke()
                    }

                    Connections {
                        target: vehicleData
                        function onTelemetryChanged() {
                            speedArc.requestPaint()
                        }
                    }

                    Connections {
                        target: Colors
                        function onThemeNameChanged() {
                            speedArc.requestPaint()
                        }
                    }
                }

                Column {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: Math.round(14 * Theme.scale)
                    width: parent.width
                    spacing: Math.round(2 * Theme.scale)

                    Text {
                        width: parent.width
                        text: vehicleData.speed
                        color: root.modeColor
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Typography.family
                        font.pixelSize: Math.round(118 * Theme.scale)
                        font.weight: Font.DemiBold
                    }

                    Text {
                        width: parent.width
                        text: "km/h"
                        color: Colors.textMuted
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyLarge
                        font.weight: Font.Medium
                    }
                }

                Row {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Math.round(10 * Theme.scale)

                    StatusPill {
                        label: vehicleData.headlights ? "HEAD" : "HEAD"
                        active: vehicleData.headlights
                    }

                    StatusPill {
                        label: "HIGH"
                        active: vehicleData.highBeam
                    }

                    StatusPill {
                        label: "HAZ"
                        active: vehicleData.hazardLights
                        alert: true
                    }
                }
            }
        }

        BaseCard {
            Layout.column: 8
            Layout.row: 0
            Layout.columnSpan: 4
            Layout.rowSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Energy"

            ColumnLayout {
                anchors.fill: parent
                spacing: Math.round(10 * Theme.scale)

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: vehicleData.batteryPercent + "%"
                        color: vehicleData.lowBatteryWarning ? Colors.warning : Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.displaySmall
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: vehicleData.rangeKm + " km"
                        color: Colors.textSecondary
                        font.family: Typography.family
                        font.pixelSize: Typography.titleMedium
                        font.weight: Font.DemiBold
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.round(12 * Theme.scale)
                    radius: height / 2
                    color: Colors.surfacePressed
                    Rectangle {
                        width: parent.width * Math.max(0, Math.min(1, vehicleData.batteryPercent / 100))
                        height: parent.height
                        radius: parent.radius
                        color: vehicleData.lowBatteryWarning ? Colors.warning : root.modeColor
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: "Motor " + vehicleData.motorPower.toFixed(1) + " kW"
                        color: Colors.textMuted
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                    }
                    Text {
                        text: "Regen " + vehicleData.regenLevel
                        color: Colors.textMuted
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                    }
                }
            }
        }

        BaseCard {
            Layout.column: 8
            Layout.row: 3
            Layout.columnSpan: 4
            Layout.rowSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Drive Mode"

            ColumnLayout {
                anchors.fill: parent
                spacing: Math.round(8 * Theme.scale)

                Repeater {
                    model: ["ECO", "CITY", "SPORT"]
                    ModeButton {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: modelData
                        selected: vehicleData.driveMode === modelData
                        accentColor: modelData === "SPORT" ? Colors.accentSport
                            : modelData === "CITY" ? Colors.accentCity
                            : Colors.accentEco
                        onClicked: vehicleData.driveMode = modelData
                    }
                }
            }
        }

        BaseCard {
            Layout.column: 0
            Layout.row: 6
            Layout.columnSpan: 4
            Layout.rowSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Temperature"

            RowLayout {
                anchors.fill: parent
                spacing: Theme.cardGap

                MetricReadout {
                    label: "MOTOR"
                    value: vehicleData.motorTemp + " C"
                    alert: vehicleData.motorOverTempWarning
                }

                MetricReadout {
                    label: "BATTERY"
                    value: vehicleData.batteryTemp + " C"
                    alert: vehicleData.batteryOverTempWarning
                }
            }
        }

        BaseCard {
            Layout.column: 4
            Layout.row: 6
            Layout.columnSpan: 4
            Layout.rowSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Trip"

            RowLayout {
                anchors.fill: parent
                spacing: Theme.cardGap

                MetricReadout {
                    label: "ODOMETER"
                    value: vehicleData.odometer.toFixed(1) + " km"
                }

                MetricReadout {
                    label: "TRIP"
                    value: vehicleData.tripDistance.toFixed(1) + " km"
                }
            }
        }

        BaseCard {
            Layout.column: 8
            Layout.row: 6
            Layout.columnSpan: 4
            Layout.rowSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "System"
            outlineColor: root.activeWarning ? Colors.critical : Colors.borderSubtle

            ColumnLayout {
                anchors.fill: parent
                spacing: Math.round(6 * Theme.scale)

                Text {
                    Layout.fillWidth: true
                    text: vehicleData.communicationFault ? "COMMUNICATION FAULT"
                        : vehicleData.warningMessage.length > 0 ? vehicleData.warningMessage.toUpperCase()
                        : "READY"
                    color: root.activeWarning ? Colors.critical : Colors.accentEco
                    elide: Text.ElideRight
                    font.family: Typography.family
                    font.pixelSize: Typography.titleMedium
                    font.weight: Font.DemiBold
                }

                Text {
                    Layout.fillWidth: true
                    text: "RPM " + vehicleData.rpm + "  |  " + (vehicleData.charging ? "CHARGING" : "NOT CHARGING")
                    color: Colors.textMuted
                    elide: Text.ElideRight
                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }
            }
        }
    }

    component IndicatorLamp: Rectangle {
        property string label: ""
        property bool active: false

        width: Math.round(46 * Theme.scale)
        height: Math.round(36 * Theme.scale)
        radius: Theme.controlRadius
        color: active ? Qt.rgba(Colors.warning.r, Colors.warning.g, Colors.warning.b, 0.18) : Colors.surfaceRaised
        border.color: active ? Colors.warning : Colors.borderSubtle

        Text {
            anchors.centerIn: parent
            text: parent.label
            color: parent.active ? Colors.warning : Colors.textMuted
            font.family: Typography.family
            font.pixelSize: Typography.bodySmall
            font.weight: Font.DemiBold
        }
    }

    component StatusPill: Rectangle {
        property string label: ""
        property bool active: false
        property bool alert: false

        width: Math.round(68 * Theme.scale)
        height: Math.round(30 * Theme.scale)
        radius: Theme.controlRadius
        color: active ? Qt.rgba((alert ? Colors.warning : root.modeColor).r,
                                (alert ? Colors.warning : root.modeColor).g,
                                (alert ? Colors.warning : root.modeColor).b,
                                0.18)
                      : Colors.surfaceRaised
        border.color: active ? (alert ? Colors.warning : root.modeColor) : Colors.borderSubtle

        Text {
            anchors.centerIn: parent
            text: parent.label
            color: parent.active ? (parent.alert ? Colors.warning : root.modeColor) : Colors.textMuted
            font.family: Typography.family
            font.pixelSize: Typography.label
            font.weight: Font.DemiBold
        }
    }

    component MetricReadout: Item {
        property string label: ""
        property string value: ""
        property bool alert: false

        Layout.fillWidth: true
        Layout.fillHeight: true

        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: Math.round(3 * Theme.scale)

            Text {
                width: parent.width
                text: label
                color: Colors.textMuted
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: Typography.family
                font.pixelSize: Typography.label
                font.weight: Font.DemiBold
            }

            Text {
                width: parent.width
                text: value
                color: alert ? Colors.warning : Colors.textPrimary
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: Typography.family
                font.pixelSize: Typography.titleMedium
                font.weight: Font.DemiBold
            }
        }
    }
}
