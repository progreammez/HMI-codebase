import QtQuick
import QtQuick.Window
import EvHmi

Window {
    id: root

    width: Theme.baseWidth
    height: Theme.baseHeight
    minimumWidth: 1280
    minimumHeight: 800
    visible: true
    title: "EV HMI"
    color: Colors.backgroundPrimary

    onWidthChanged: updateScale()
    onHeightChanged: updateScale()
    Component.onCompleted: updateScale()

    function updateScale() {
        Theme.scale = Math.min(root.width / Theme.baseWidth, root.height / Theme.baseHeight)
        Typography.scale = Theme.scale
    }

    AppShell {
        anchors.fill: parent
    }
}
