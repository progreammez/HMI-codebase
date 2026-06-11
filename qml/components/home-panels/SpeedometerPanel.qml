import QtQuick
import EvHmi

BaseCard {
    id: root

    title: "SPEEDOMETER"

    property real displayedSpeed: vehicleData.speed
    property real displayedRpm: vehicleData.rpm

    // Automatically repaint canvas only when the animated speed value changes
    onDisplayedSpeedChanged: gaugeCanvas.requestPaint()

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

        anchors.fill: parent
        anchors.margins: 12 * Theme.scale 

        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var w = width
            var h = height

            var cx = w / 2
            var cy = h * 0.65
            var radius = h * 0.56

            var startAngle = Math.PI * 0.80
            var endAngleMax = Math.PI * 2.20
            var totalAngleRange = endAngleMax - startAngle

            var speedProgress = Math.min(root.displayedSpeed, 200) / 200
            var activeEnd = startAngle + (totalAngleRange * speedProgress)

            // =====================================================
            // 1. MAIN OUTER TRACK ARC (SPEED PROGRESS)
            // =====================================================
            ctx.beginPath()
            ctx.arc(cx, cy, radius, startAngle, endAngleMax)
            ctx.lineWidth = 9 * Theme.scale
            ctx.strokeStyle = Qt.rgba(Colors.surfaceSunken.r, Colors.surfaceSunken.g, Colors.surfaceSunken.b, 0.3)
            ctx.stroke()

            ctx.beginPath()
            ctx.arc(cx, cy, radius, startAngle, activeEnd)
            ctx.lineWidth = 11 * Theme.scale
            ctx.shadowColor = Colors.borderActive
            ctx.shadowBlur = 16 * Theme.scale 
            ctx.strokeStyle = Colors.borderActive
            ctx.stroke()
            ctx.shadowBlur = 0 

            // =====================================================
            // 2. INNER TICK MARKS & SPEED STEPS (0 - 200)
            // =====================================================
            ctx.strokeStyle = Qt.rgba(Colors.textMuted.r, Colors.textMuted.g, Colors.textMuted.b, 0.4)
            ctx.lineWidth = 1.5 * Theme.scale
            
            ctx.font = "bold " + Math.round(13 * Theme.scale) + "px " + Typography.family
            ctx.fillStyle = Colors.textSecondary
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            var outerTickRadius = radius - (12 * Theme.scale)
            var labelRadius = radius - (32 * Theme.scale)

            for (var i = 0; i <= 20; i++) {
                var angle = startAngle + (totalAngleRange * (i / 20))
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
                    var speedLabel = Math.round(i * 10).toString()
                    var tx = cx + cosA * labelRadius
                    var ty = cy + sinA * labelRadius
                    ctx.fillText(speedLabel, tx, ty)
                }
            }
        }
    }

    // =====================================================
    // CENTER DATA READOUTS (MATCHES REFERENCE DESIGN)
    // =====================================================
    Column {
        anchors.centerIn: parent
        // FIXED: Increased vertical offset from 6 to 38 to cleanly drop the text 
        // down away from the upper ticks and align it beautifully inside the new arc center.
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

            scale: 1.0 + (root.displayedSpeed / 200) * 0.03
            Behavior on scale { NumberAnimation { duration: 200 } }
        }

        Text {
            text: "km/h"
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
            text: "RPM"
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