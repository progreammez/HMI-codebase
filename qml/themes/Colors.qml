pragma Singleton

import QtQuick
import EvHmi

QtObject {
    property string themeName: "ICE"

    readonly property bool isCopper: themeName === "COPPER"
    readonly property bool isAmber: themeName === "AMBER"

    readonly property color backgroundPrimary: isCopper ? "#080605" : isAmber ? "#070705" : "#040607"
    readonly property color backgroundSecondary: isCopper ? "#120D0A" : isAmber ? "#121009" : "#081014"
    readonly property color surfaceBase: isCopper ? "#18100D" : isAmber ? "#17140B" : "#0E171C"
    readonly property color surfaceRaised: isCopper ? "#231711" : isAmber ? "#221C0E" : "#14222A"
    readonly property color surfaceSunken: isCopper ? "#0D0907" : isAmber ? "#0E0C07" : "#071014"
    readonly property color surfacePressed: isCopper ? "#2E1F17" : isAmber ? "#2B2411" : "#1D303B"
    readonly property color borderSubtle: isCopper ? "#4A342A" : isAmber ? "#443719" : "#29414C"
    readonly property color borderWarm: isCopper ? "#B2785E" : isAmber ? "#C49536" : "#587A90"
    readonly property color borderActive: isCopper ? "#E29572" : isAmber ? "#F0B84D" : "#72D7FF"

    readonly property color textPrimary: isCopper ? "#FFF4EE" : isAmber ? "#FFF8E8" : "#F1FAFF"
    readonly property color textSecondary: isCopper ? "#D8B9AA" : isAmber ? "#D8C699" : "#B8D1DC"
    readonly property color textMuted: isCopper ? "#8B6C60" : isAmber ? "#89784D" : "#6E8895"
    readonly property color textWarm: isCopper ? "#E6A184" : isAmber ? "#E4B655" : "#A4DDF4"

    readonly property color accentEco: isCopper ? "#6FE09B" : isAmber ? "#9DD66F" : "#67E8C9"
    readonly property color accentCity: isCopper ? "#D1A78F" : isAmber ? "#E0C56D" : "#72D7FF"
    readonly property color accentSport: isCopper ? "#F08B61" : isAmber ? "#FFB02E" : "#FF8D6B"
    readonly property color accentCopper: "#C47F61"
    readonly property color accentCopperDim: "#523328"
    readonly property color accentBlue: "#72D7FF"
    readonly property color warning: isCopper ? "#F0B066" : isAmber ? "#F4C24E" : "#F4C95D"
    readonly property color critical: "#FF6B6B"

    readonly property color transparentPanel: isCopper ? "#AA18100D" : isAmber ? "#AA17140B" : "#AA0E171C"
    readonly property color glassPanel: isCopper ? "#E018100D" : isAmber ? "#E017140B" : "#E00E171C"
    readonly property color mapBase: isCopper ? "#1B120D" : isAmber ? "#181509" : "#101A20"
    readonly property color mapRoad: isCopper ? "#5B3B2E" : isAmber ? "#554519" : "#2F4E5D"
    readonly property color shadow: "#66000000"
}
