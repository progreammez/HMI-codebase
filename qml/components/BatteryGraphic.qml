import QtQuick
import EvHmi

Item {
    id: root

    property int percentage: 84
    property color activeColor: vehicleData.communicationFault ? Colors.textMuted : Colors.accentCity
    property color inactiveColor:
    Colors.isLightMode
        ? Qt.rgba(
            Colors.borderSubtle.r,
            Colors.borderSubtle.g,
            Colors.borderSubtle.b,
            0.45
          )
        : Qt.rgba(1,1,1,0.08)

    readonly property int filledSegments: Math.max(0, Math.min(8, Math.ceil(percentage / 12.5)))

    Rectangle {
        id: body

        width: parent.width - 10
        height: parent.height

        radius: 3
        color: "transparent"

        border.width: 1
        border.color: activeColor
    }

    Rectangle {
        width: 4
        height: 12

        anchors.left: body.right
        anchors.leftMargin: 1
        anchors.verticalCenter: body.verticalCenter

        radius: 1.5
        color: activeColor
    }

    Row {
        anchors.fill: body
        anchors.margins: 4

        spacing: 2

        Repeater {
            model: 8

            Rectangle {
                width: (parent.width - 14) / 8
                radius: 1
                height: parent.height

                color: index < root.filledSegments
                       ? root.activeColor
                       : root.inactiveColor
            }
        }
    }
}