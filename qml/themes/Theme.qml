pragma Singleton

import QtQuick
import EvHmi

QtObject {
    property real scale: 1.0

    readonly property int baseWidth: 1280
    readonly property int baseHeight: 800

    readonly property int smallGap: Math.round(2 * scale)
    readonly property int pageMargin: Math.round(12 * scale)
    readonly property int sectionGap: Math.round(8 * scale)
    readonly property int cardGap: Math.round(10 * scale)
    readonly property int cardPadding: Math.round(14 * scale)

    readonly property int cardRadius: Math.round(8 * scale)
    readonly property int controlRadius: Math.round(7 * scale)
    readonly property int navRadius: Math.round(10 * scale)

    readonly property int topBarHeight: Math.round(30 * scale)
    readonly property int navBarHeight: Math.round(85 * scale)
    readonly property int touchTarget: Math.round(56 * scale)

    readonly property int motionFast: 120
    readonly property int motionStandard: 180
}
