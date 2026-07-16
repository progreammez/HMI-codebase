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
            var cy = h / 2 + Math.round(1 * Theme.scale)
            var s = Math.min(w, h) / 40

            ctx.strokeStyle = root.strokeColor
            ctx.fillStyle = root.strokeColor
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.lineWidth = root.lineWidth

            var bulbR = 5.2 * s
            var bulbCy = cy + 7.5 * s
            var stemHalfW = 2.8 * s
            var stemTop = cy - 9.5 * s
            var stemBottom = bulbCy - bulbR + 1.2 * s

            ctx.beginPath()
            ctx.arc(cx, bulbCy, bulbR, 0, Math.PI * 2)
            ctx.stroke()

            ctx.beginPath()
            ctx.arc(cx, bulbCy, 2.2 * s, 0, Math.PI * 2)
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx - stemHalfW, stemBottom)
            ctx.lineTo(cx - stemHalfW, stemTop + stemHalfW)
            ctx.arc(cx, stemTop + stemHalfW, stemHalfW, Math.PI, 0, false)
            ctx.lineTo(cx + stemHalfW, stemBottom)
            ctx.stroke()

            ctx.lineWidth = Math.max(1.4, 1.8 * Theme.scale)
            ctx.beginPath()
            ctx.moveTo(cx, bulbCy + 1.5 * s)
            ctx.lineTo(cx, cy - 1.5 * s)
            ctx.stroke()
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
