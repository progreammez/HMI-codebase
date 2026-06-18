import QtQuick
import EvHmi

Item {
    id: root

    property color strokeColor: Colors.borderActive
    property real lineWidth: Math.max(1.2, 1.5 * Theme.scale)

    implicitWidth: Math.round(44 * Theme.scale)
    implicitHeight: Math.round(44 * Theme.scale)

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var w = width
            var h = height
            var cx = w / 2
            var cy = h / 2
            var r = Math.min(w, h) / 2 - Math.max(2, 2.5 * Theme.scale)
            var s = Math.min(w, h) / 40

            ctx.strokeStyle = root.strokeColor
            ctx.fillStyle = root.strokeColor
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            ctx.lineWidth = root.lineWidth
            ctx.beginPath()
            ctx.arc(cx, cy, r, Math.PI * 0.75, Math.PI * 0.25, false)
            ctx.stroke()

            ctx.beginPath()
            ctx.moveTo(cx + 1.2 * s, cy - 8.5 * s)
            ctx.lineTo(cx - 3.8 * s, cy + 0.8 * s)
            ctx.lineTo(cx - 0.6 * s, cy + 0.8 * s)
            ctx.lineTo(cx - 2.8 * s, cy + 8.5 * s)
            ctx.lineTo(cx + 4.8 * s, cy - 1.5 * s)
            ctx.lineTo(cx + 1.6 * s, cy - 1.5 * s)
            ctx.lineTo(cx + 3.6 * s, cy - 8.5 * s)
            ctx.closePath()
            ctx.fill()
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        Connections {
            target: root
            function onStrokeColorChanged() { canvas.requestPaint() }
            function onLineWidthChanged() { canvas.requestPaint() }
        }
    }
}
