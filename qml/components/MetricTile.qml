// qml/components/MetricTile.qml
import QtQuick
import EvHmi

Item {
    id: root

    // Core Exposed Properties - Ensure all five lines are present!
    property string label: ""
    property string value: ""
    property string unit: "km"          // ◀️ FIX: Expose the unit string type property slot
    property string iconSource: ""      // ◀️ FIX: Expose the icon symbol type property slot
    property color valueColor: Colors.textPrimary

    implicitWidth: Math.round(240 * Theme.scale)
    implicitHeight: Math.round(60 * Theme.scale)

    Row {
        anchors.fill: parent
        spacing: Math.round(12 * Theme.scale)

        // Geometric Asset Housing Block
        Item {
            width: Math.round(40 * Theme.scale)
            height: parent.height
            visible: root.iconSource.length > 0

            Rectangle {
                anchors.centerIn: parent
                width: Math.round(32 * Theme.scale)
                height: Math.round(32 * Theme.scale)
                radius: width / 2
                color: "transparent"
                border.color: Colors.borderSubtle
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.iconSource 
                    color: Colors.accentCity
                    font.pixelSize: 14
                }
            }
        }

        // Dual-Line Typography Stack
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Math.round(2 * Theme.scale)

            Text {
                text: root.label.toUpperCase()
                color: Colors.textSecondary
                font.family: Typography.family
                font.pixelSize: Typography.label - 2
                font.weight: Font.Medium
                font.letterSpacing: 1
            }

            Row {
                spacing: Math.round(4 * Theme.scale)

                Text {
                    text: root.value
                    color: root.valueColor
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyLarge
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Math.round(3 * Theme.scale)
                    text: root.unit // ◀️ This now correctly evaluates the property assignment string safely
                    color: Colors.textMuted
                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                }
            }
        }
    }
}