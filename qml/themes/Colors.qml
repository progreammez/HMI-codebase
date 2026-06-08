pragma Singleton

import QtQuick
import EvHmi

QtObject {
    // --- Global Controls ---
    property string themeName: "ICE"     // Options: "ICE", "AMBER", "COPPER"
    property string dayNightMode: "night" // Options: "auto", "day", "night"

    // --- State Evaluators ---
    readonly property bool isLightMode: dayNightMode === "day"
    readonly property bool isCopper: themeName === "COPPER"
    readonly property bool isAmber: themeName === "AMBER"
    readonly property bool isIce: themeName === "ICE"

    // =====================================================
    // 🎨 THEME SPECIFIC LIGHT MODE PALETTES (PREMIUM DAY VARIANTS)
    // =====================================================
    
    // Light Ice: Crisp tech silver/blue | Light Amber: Warm cream/gold | Light Copper: Premium sand/terracotta
    readonly property color lightBgPrimary: isCopper ? "#F7F3F0" : isAmber ? "#F6F5EE" : "#F2F4F7"
    readonly property color lightBgSecondary: isCopper ? "#EFE8E3" : isAmber ? "#ECEAE0" : "#E4E7EC"
    readonly property color lightSurfaceBase: "#FFFFFF"
    readonly property color lightSurfaceRaised: isCopper ? "#FAF8F6" : isAmber ? "#FAF9F5" : "#F9FAFB"
    readonly property color lightSurfaceSunken: isCopper ? "#E4DAD2" : isAmber ? "#E3DEC8" : "#EAECF0"
    readonly property color lightSurfacePressed: isCopper ? "#DECFC3" : isAmber ? "#DDD5B8" : "#D0D5DD"
    
    readonly property color lightBorderSubtle: isCopper ? "#DCC6B5" : isAmber ? "#DCD4B3" : "#D0D5DD"
    readonly property color lightBorderWarm: isCopper ? "#C48E74" : isAmber ? "#C9A75D" : "#98A2B3"

    // High contrast light mode text typography
    readonly property color lightTextPrimary: isCopper ? "#2B160B" : isAmber ? "#261F05" : "#101828"
    readonly property color lightTextSecondary: isCopper ? "#543725" : isAmber ? "#4F441E" : "#344054"
    readonly property color lightTextMuted: isCopper ? "#8A6D5E" : isAmber ? "#8A7D55" : "#667085"

    // =====================================================
    // 💻 SYSTEM PALETTE INVERSION LOGIC
    // =====================================================
    
    // --- Backgrounds & Surfaces ---
    readonly property color backgroundPrimary: isLightMode ? lightBgPrimary : isCopper ? "#080605" : isAmber ? "#070705" : "#020B16"
    readonly property color backgroundSecondary: isLightMode ? lightBgSecondary : isCopper ? "#120D0A" : isAmber ? "#121009" : "#061321"             
    readonly property color surfaceBase: isLightMode ? lightSurfaceBase : isCopper ? "#18100D" : isAmber ? "#17140B" : "#081725"

    readonly property color surfaceRaised: isLightMode ? lightSurfaceRaised : isCopper ? "#231711" : isAmber ? "#221C0E" : "#0B1B2A"

    readonly property color surfaceSunken: isLightMode ? lightSurfaceSunken : isCopper ? "#0D0907" : isAmber ? "#0E0C07" : "#040F1A"

    readonly property color surfacePressed: isLightMode ? lightSurfacePressed : isCopper ? "#2E1F17" : isAmber ? "#2B2411" : "#102434"

    // --- Borders & Outlines ---
    readonly property color borderSubtle: isLightMode ? lightBorderSubtle : isCopper ? "#4A342A" : isAmber ? "#443719" : "#0E2A3A"

    readonly property color borderWarm: isLightMode ? lightBorderWarm : isCopper ? "#B2785E" : isAmber ? "#C49536" : "#1A3A4D"

    readonly property color borderActive: isCopper ? "#E29572" : isAmber ? "#F0B84D" : "#00E7FF"

    // --- Typography (Dark graphite signatures for light mode) ---
    readonly property color textPrimary: isLightMode ? lightTextPrimary : isCopper ? "#FFF4EE" : isAmber ? "#FFF8E8" : "#F5F7FA"
    readonly property color textSecondary: isLightMode ? lightTextSecondary : isCopper ? "#D8B9AA" : isAmber ? "#D8C699" : "#C7D1DA"
    readonly property color textMuted: isLightMode ? lightTextMuted : isCopper ? "#8B6C60" : isAmber ? "#89784D" : "#8A98A5"
    readonly property color textWarm: isLightMode ? lightTextSecondary : isCopper ? "#E6A184" : isAmber ? "#E4B655" : "#00E7FF"

    // --- Safety Accents & Metrics Compliance ---
    readonly property color accentCity: isLightMode ? "#004EEB" : isCopper ? "#D1A78F" : isAmber ? "#E0C56D" : "#00E7FF"
    readonly property color accentEco: isLightMode ? (isCopper ? "#117A3C" : isAmber ? "#4E7A11" : "#027A48") : isCopper ? "#6FE09B" : isAmber ? "#9DD66F" : "#3CFF4E"
    readonly property color accentSport: isLightMode ? "#D92D20" : isCopper ? "#F08B61" : isAmber ? "#FFB02E" : "#FF8D6B"

    readonly property color accentCopper: "#C47F61"
    readonly property color accentCopperDim: isLightMode ? "#F3E9E5" : "#523328"
    readonly property color accentBlue: "#72D7FF"
    readonly property color warning: isLightMode ? "#B54708" : isCopper ? "#F0B066" : isAmber ? "#F4C24E" : "#FFC72B"

    readonly property color critical: "#FF4040"

    // --- Glass Panels & Structural Underlays ---
    readonly property color transparentPanel: isLightMode ? "#EAEAEAFF" : isCopper ? "#AA18100D" : isAmber ? "#AA17140B" : "#AA081725"

    readonly property color glassPanel: isLightMode ? "#FAFAFAFF" : isCopper ? "#E018100D" : isAmber ? "#E017140B" : "#E0081725"
    readonly property color mapBase: isLightMode ? lightBgPrimary : isCopper ? "#1B120D" : isAmber ? "#181509" : "#081725"

    readonly property color mapRoad: isLightMode ? "#FFFFFF" : isCopper ? "#5B3B2E" : isAmber ? "#554519" : "#2A4C60"
    readonly property color shadow: isLightMode ? "#00E7FF" : "#66000000"
}