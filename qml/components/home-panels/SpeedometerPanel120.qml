import QtQuick
import EvHmi

BaseCard {
    id: root

    // Dynamically switches card title based on global language selection
    title: root.translations["title"][Typography.currentLanguage]

    // =====================================================
    // ⚙️ WIRE THIS TO YOUR SETTINGS VARIABLE
    // =====================================================
    // Change "Typography.currentUnit" here to your exact settings variable if needed 
    // (e.g., settingsState.units, or vehicleData.units)
    property string unitSystem: Typography.unitSystem 

    // Flexible check: catches "metric", "km", or "km/h" dynamically
    readonly property bool isMetric: unitSystem === "metric" || unitSystem === "km/h" || unitSystem === "km"
    
    // Set dynamic automotive dial limits based on active unit system
    readonly property real maxSpeedLimit: isMetric ? 200 : 120

    // Automatically converts raw incoming speed data to mph if system goes imperial
    readonly property real targetedSpeed: isMetric ? vehicleData.speed : (vehicleData.speed * 0.621371)

    property real displayedSpeed: root.targetedSpeed
    property real displayedRpm: vehicleData.rpm

    // Automatically triggers repaint loops when speed changes or units toggle
    onDisplayedSpeedChanged: gaugeCanvas.requestPaint()
    onUnitSystemChanged: gaugeCanvas.requestPaint() 

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title": { "en": "Speedometer", "de": "Tachometer", "es": "Velocímetro" },
        "kmh":   { "en": "km/h",        "de": "km/h",        "es": "km/h" },
        "mph":   { "en": "mph",         "de": "mph",         "es": "mph" },
        "rpm":   { "en": "RPM",         "de": "U/min",       "es": "RPM" }
    }

    Behavior on displayedSpeed {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
        }
    }

    Behavior on displayedRpm {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    Canvas {
        id: gaugeCanvas

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        anchors.topMargin: -32 * Theme.scale 
        anchors.leftMargin: 12 * Theme.scale
        anchors.rightMargin: 12 * Theme.scale
        anchors.bottomMargin: 12 * Theme.scale

        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var w = width
            var h = height

            var cx = w / 2
            var cy = h * 0.65
            var radius = h * 0.50

            var startAngle = Math.PI * 0.80
            var endAngleMax = Math.PI * 2.20
            var totalAngleRange = endAngleMax - startAngle

            var speedProgress = Math.min(root.displayedSpeed, root.maxSpeedLimit) / root.maxSpeedLimit
            var activeEnd = startAngle + (totalAngleRange * speedProgress)

            // Outer track arc
            ctx.beginPath()
            ctx.arc(cx, cy, radius, startAngle, endAngleMax)
            ctx.lineWidth = 9 * Theme.scale
            ctx.strokeStyle = Qt.rgba(Colors.surfaceSunken.r, Colors.surfaceSunken.g, Colors.surfaceSunken.b, 0.3)
            ctx.stroke()

            // Active glow progress arc
            ctx.beginPath()
            ctx.arc(cx, cy, radius, startAngle, activeEnd)
            ctx.lineWidth = 11 * Theme.scale
            ctx.shadowColor = Colors.borderActive
            ctx.shadowBlur = 16 * Theme.scale 
            ctx.strokeStyle = Colors.borderActive
            ctx.stroke()
            ctx.shadowBlur = 0 

            // Inner ticks engine
            ctx.strokeStyle = Qt.rgba(Colors.textMuted.r, Colors.textMuted.g, Colors.textMuted.b, 0.4)
            ctx.lineWidth = 1.5 * Theme.scale
            
            ctx.font = "bold " + Math.round(13 * Theme.scale) + "px " + Typography.family
            ctx.fillStyle = Colors.textSecondary
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            var outerTickRadius = radius - (12 * Theme.scale)
            var labelRadius = radius - (32 * Theme.scale)

            var totalTicks = root.isMetric ? 20 : 24
            var tickValueStep = root.maxSpeedLimit / totalTicks 

            for (var i = 0; i <= totalTicks; i++) {
                var angle = startAngle + (totalAngleRange * (i / totalTicks))
                var cosA = Math.cos(angle)
                var sinA = Math.sin(angle)

                var isMajor = (i % 2 === 0)
                var tStart = outerTickRadius - (isMajor ? (12 * Theme.scale) : (7 * Theme.scale))
                var tEnd = outerTickRadius

                ctx.beginPath()
                ctx.moveTo(cx + cosA * tStart, cy + sinA * tStart)
                ctx.lineTo(cx + cosA * tEnd, cy + sinA * tEnd)
                ctx.stroke()

                if (isMajor) {
                    var speedLabel = Math.round(i * tickValueStep).toString()
                    var tx = cx + cosA * labelRadius
                    var ty = cy + sinA * labelRadius
                    ctx.fillText(speedLabel, tx, ty)
                }
            }
        }
    }

    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 30 * Theme.scale
        spacing: 1 * Theme.scale

        Text {
            id: speedText
            text: Math.round(root.displayedSpeed)
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colors.textPrimary

            font.family: Typography.family
            font.pixelSize: Typography.displayLarge * 1.35
            font.bold: true

            scale: 1.0 + (root.displayedSpeed / root.maxSpeedLimit) * 0.03
            Behavior on scale { NumberAnimation { duration: 200 } }
        }

        Text {
            text: root.isMetric ? root.translations["kmh"][Typography.currentLanguage] : root.translations["mph"][Typography.currentLanguage]
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colors.textSecondary

            font.family: Typography.family
            font.pixelSize: Typography.bodyLarge
            font.weight: Font.Medium
        }

        Item {
            width: Math.round(110 * Theme.scale)
            height: Math.round(14 * Theme.scale)
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(Colors.borderSubtle.r, Colors.borderSubtle.g, Colors.borderSubtle.b, 0.2)
                anchors.centerIn: parent
            }
        }

        Text {
            text: root.translations["rpm"][Typography.currentLanguage]
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colors.borderActive 

            font.family: Typography.family
            font.pixelSize: Typography.label 
            font.bold: true
            font.letterSpacing: 1.5
        }

        Text {
            text: Math.round(root.displayedRpm)
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colors.textPrimary

            font.family: Typography.family
            font.pixelSize: Typography.displaySmall * 0.8
            font.weight: Font.DemiBold
        }
    }
}