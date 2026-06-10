pragma Singleton

import QtQuick
import EvHmi

QtObject {
    // --- Global Controls ---
    property string themeName: "ICE"     // Options: "ICE", "LAVENDER", "SAKURA"
    property string dayNightMode: "night" // Options: "auto", "day", "night"

    // --- State Evaluators ---
    readonly property bool isLightMode: dayNightMode === "day"
    readonly property bool isSakura: themeName === "SAKURA"
    readonly property bool isLavender: themeName === "LAVENDER"
    readonly property bool isIce: themeName === "ICE"

    // =====================================================
    // LIGHT MODE
    // =====================================================

    readonly property color lightBgPrimary:
        isSakura ? "#FFF1F7" :
        isLavender ? "#F7F4FF" :
        "#F4F5F8"

    readonly property color lightBgSecondary:
        isSakura ? "#FFE7F2" :
        isLavender ? "#EFEAFF" :
        "#EBF0F5"

    readonly property color lightSurfaceBase: "#FFFFFF"

    readonly property color lightSurfaceRaised:
        isSakura ? "#FFF8FB" :
        isLavender ? "#FCFAFF" :
        "#FAFAFB"

    readonly property color lightSurfaceSunken:
        isSakura ? "#FAD7E8" :
        isLavender ? "#E7DDFD" :
        "#E4E7EC"

    readonly property color lightSurfacePressed:
        isSakura ? "#F6C5DE" :
        isLavender ? "#D8CCFB" :
        "#D0D5DD"

    readonly property color lightBorderSubtle:
        isSakura ? "#F2C7DA" :
        isLavender ? "#DCCFFF" :
        "#E2E8F0"

    readonly property color lightBorderWarm:
        isSakura ? "#E58CB7" :
        isLavender ? "#A78BFA" :
        "#94A3B8"

    readonly property color lightTextPrimary:
        isSakura ? "#4A1030" :
        isLavender ? "#2E1065" :
        "#0F172A"

    readonly property color lightTextSecondary:
        isSakura ? "#7B355A" :
        isLavender ? "#5B4A92" :
        "#475569"

    readonly property color lightTextMuted:
        isSakura ? "#A16286" :
        isLavender ? "#8B7CB8" :
        "#64748B"

    // =====================================================
    // DARK MODE
    // =====================================================

    readonly property color backgroundPrimary:
        isLightMode ? lightBgPrimary :
        isSakura ? "#09060A" :
        isLavender ? "#05060A" :
        "#05070B"

    readonly property color backgroundSecondary:
        isLightMode ? lightBgSecondary :
        isSakura ? "#140A11" :
        isLavender ? "#0D0B16" :
        "#0B0F17"

    readonly property color surfaceBase:
        isLightMode ? lightSurfaceBase :
        isSakura ? "#1A0F18" :
        isLavender ? "#131425" :
        "#111622"

    readonly property color surfaceRaised:
        isLightMode ? lightSurfaceRaised :
        isSakura ? "#231320" :
        isLavender ? "#1A1D34" :
        "#161E2E"

    readonly property color surfaceSunken:
        isLightMode ? lightSurfaceSunken :
        isSakura ? "#0B0609" :
        isLavender ? "#080812" :
        "#070A10"

    readonly property color surfacePressed:
        isLightMode ? lightSurfacePressed :
        isSakura ? "#341B2C" :
        isLavender ? "#2A2450" :
        "#1E293B"

    // =====================================================
    // BORDERS
    // =====================================================

    readonly property color borderSubtle:
        isLightMode ? lightBorderSubtle :
        isSakura ? "#5A2948" :
        isLavender ? "#43387A" :
        "#1E293B"

    readonly property color borderWarm:
        isLightMode ? lightBorderWarm :
        isSakura ? "#FF9CCB" :
        isLavender ? "#B79CFF" :
        "#334155"

    readonly property color borderActive:
        isSakura ? "#FF85C2" :
        isLavender ? "#A78BFA" :
        "#00E7FF"

    // =====================================================
    // TYPOGRAPHY
    // =====================================================

    readonly property color textPrimary:
        isLightMode ? lightTextPrimary :
        isSakura ? "#FFF4FA" :
        isLavender ? "#F8F4FF" :
        "#FFFFFF"

    readonly property color textSecondary:
        isLightMode ? lightTextSecondary :
        isSakura ? "#F4BDD7" :
        isLavender ? "#D8CCFF" :
        "#94A3B8"

    readonly property color textMuted:
        isLightMode ? lightTextMuted :
        isSakura ? "#B57E9C" :
        isLavender ? "#A89ACD" :
        "#64748B"

    readonly property color textWarm:
        isLightMode ? lightTextSecondary :
        isSakura ? "#FF9CCB" :
        isLavender ? "#C4B5FD" :
        "#00E7FF"

    // =====================================================
    // ACCENTS
    // =====================================================

    readonly property color accentCity:
        isLightMode ? "#0097A7" :
        isSakura ? "#FFB7D5" :
        isLavender ? "#C4B5FD" :
        "#00E7FF"

    readonly property color accentEco:
        isLightMode
            ? (isSakura ? "#117A3C"
                        : isLavender ? "#4E7A11"
                                     : "#027A48")
            : isSakura ? "#7EF2AF"
                       : isLavender ? "#A5E87A"
                                    : "#10B981"

    readonly property color accentSport:
        isLightMode ? "#D92D20" :
        isSakura ? "#FF6FA5" :
        isLavender ? "#B388FF" :
        "#EF4444"

    readonly property color accentSakura: "#FFB7D5"

    readonly property color accentSakuraDim:
        isLightMode ? "#FFF1F7" : "#3A1A2E"

    readonly property color accentBlue:
        isLavender ? "#C4B5FD" :
        isSakura ? "#FFB7D5" :
        "#72D7FF"

    readonly property color warning: "#ffd900"

    readonly property color critical: "#ff2f2f"

    // =====================================================
    // PANELS
    // =====================================================

    readonly property color transparentPanel:
        isLightMode ? "#EAEAEAFF" :
        isSakura ? "#AA1A0F18" :
        isLavender ? "#AA131425" :
        "#AA0B0F17"

    readonly property color glassPanel:
        isLightMode ? "#FAFAFAFF" :
        isSakura ? "#E01A0F18" :
        isLavender ? "#E0131425" :
        "#E00B0F17"

    // =====================================================
    // MAP
    // =====================================================

    readonly property color mapBase:
        isLightMode ? lightBgPrimary :
        isSakura ? "#1A0F18" :
        isLavender ? "#131425" :
        "#0B0F17"

    readonly property color mapRoad:
        isLightMode ? "#FFFFFF" :
        isSakura ? "#7A4A66" :
        isLavender ? "#6C5BB0" :
        "#1E293B"

    readonly property color shadow:
        isLightMode ? "#15000000" :
        "#66000000"
}