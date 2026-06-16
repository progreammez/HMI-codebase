pragma Singleton

import QtQuick
import EvHmi

QtObject {

    property real scale: 1.0

    readonly property string family: Fonts.rajdhani

    readonly property int displayLarge: Math.round(92 * scale)
    readonly property int displayMedium: Math.round(56 * scale)
    readonly property int displaySmall: Math.round(42 * scale)
    readonly property int titleLarge: Math.round(28 * scale)
    readonly property int titleMedium: Math.round(21 * scale)
    readonly property int titleSmall: Math.round(16 * scale)
    readonly property int bodyLarge: Math.round(18 * scale)
    readonly property int bodyMedium: Math.round(15 * scale)
    readonly property int bodySmall: Math.round(13 * scale)
    readonly property int label: Math.round(12 * scale)
    readonly property int labelTab: Math.round(15 * scale)

    property string currentLanguage: "en"
    property string timeFormat: "HH:mm"
    property string unitSystem: "metric"

}
