import QtQuick
import EvHmi

Item {
    Grid {
        anchors.fill: parent
        columns: 2
        spacing: Theme.cardGap

        BaseCard {
            width: (parent.width - Theme.cardGap) * 0.58
            height: parent.height
            title: "Now Playing"
            baseColor: Colors.surfaceRaised

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "Spotify"
                color: Colors.textPrimary
                horizontalAlignment: Text.AlignHCenter
                font.family: Typography.family
                font.pixelSize: Typography.displayMedium
                font.weight: Font.Light
            }
        }

        BaseCard {
            width: (parent.width - Theme.cardGap) * 0.42
            height: parent.height
            title: "Queue"

            Text {
                anchors.centerIn: parent
                text: "Media"
                color: Colors.textSecondary
                font.family: Typography.family
                font.pixelSize: Typography.titleLarge
                font.weight: Font.DemiBold
            }
        }
    }
}
