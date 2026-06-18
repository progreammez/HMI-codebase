pragma Singleton

import QtQuick
import EvHmi

QtObject {
    // --- Global Controls ---
    property string themeName: "NEON"      // Options: "NOIR", "SAKURA", "LILAC", "VERDANT", "NEON", "AURORA"
    property string dayNightMode: "night" // Options: "auto", "day", "night"

    // --- State Evaluators ---
    readonly property bool isLightMode: dayNightMode === "day"
    readonly property bool isSakura: themeName === "SAKURA"
    readonly property bool isLilac: themeName === "LILAC"
    readonly property bool isAurora: themeName === "AURORA"
    readonly property bool isNeon: themeName === "NEON"
    readonly property bool isVerdant: themeName === "VERDANT"
    readonly property bool isNoir: themeName === "NOIR"

    // =====================================================
    // LIGHT MODE PALETTES
    // =====================================================

    readonly property color backgroundPrimary:
        isLightMode ? _lightBgPrimary :
        isNoir      ? "#06070A" :   // void: near-black, achromatic
        isSakura    ? "#090509" :   // deep plum-void
        isLilac     ? "#06050D" :   // violet-void
        isNeon      ? "#060806" :   // true near-black void — KPIT logo ground, faint green undertone only
        isVerdant   ? "#040A08" :   // deep forest-black
        isAurora    ? "#030710" :   // abyssal navy
                      "#030710"

    readonly property color backgroundSecondary:
        isLightMode ? _lightBgSecondary :
        isNoir      ? "#0C0E14" :
        isSakura    ? "#110810" :
        isLilac     ? "#0C0A1A" :
        isNeon      ? "#0A0F0A" :   // header / chrome ground — dark, NOT a green fill
        isVerdant   ? "#08130E" :
        isAurora    ? "#060D1E" :
                      "#060D1E"

    // -------------------------------------------------------------------------
    //  Surfaces
    // -------------------------------------------------------------------------

    //  surfaceBase: the resting elevation — cards, panels, drawers
    readonly property color surfaceBase:
        isLightMode ? _lightSurfaceBase :
        isNoir      ? "#101218" :   // slightly lighter graphite, no hue
        isSakura    ? "#180D16" :   // dark rose-plum
        isLilac     ? "#110F22" :   // deep violet
        isNeon      ? "#0E140E" :   // dark slate with a whisper of green — reads as black, not olive
        isVerdant   ? "#0D1C14" :   // dark teal-forest
        isAurora    ? "#0A1228" :   // deep navy
                      "#0A1228"

    //  surfaceRaised: hover state, selected card, popover
    readonly property color surfaceRaised:
        isLightMode ? _lightSurfaceRaised :
        isNoir      ? "#181B24" :
        isSakura    ? "#22121E" :
        isLilac     ? "#181530" :
        isNeon      ? "#161E16" :   // one step up — still dark, restrained saturation
        isVerdant   ? "#11251A" :
        isAurora    ? "#101A36" :
                      "#101A36"

    //  surfaceSunken: recessed inputs, troughs, map underlay
    readonly property color surfaceSunken:
        isLightMode ? _lightSurfaceSunken :
        isNoir      ? "#05060A" :
        isSakura    ? "#07030A" :
        isLilac     ? "#060510" :
        isNeon      ? "#030503" :
        isVerdant   ? "#030806" :
        isAurora    ? "#02050D" :
                      "#02050D"

    //  surfacePressed: active/held state, button depression
    readonly property color surfacePressed:
        isLightMode ? _lightSurfacePressed :
        isNoir      ? "#252A38" :
        isSakura    ? "#321A2E" :
        isLilac     ? "#242048" :
        isNeon      ? "#1C2E1C" :   // visible press-state, still controlled — not a neon flash
        isVerdant   ? "#1A3828" :
        isAurora    ? "#182850" :
                      "#182850"

    // -------------------------------------------------------------------------
    //  Borders
    // -------------------------------------------------------------------------

    //  borderSubtle: structural dividers, card edges, input outlines at rest
    readonly property color borderSubtle:
        isLightMode ? _lightBorderSubtle :
        isNoir      ? "#1E2230" :   // cool-graphite hairline
        isSakura    ? "#3A1830" :   // dim rose-plum
        isLilac     ? "#221E45" :   // compressed violet
        isNeon      ? "#1E2E1E" :   // dim structural hairline — present but quiet
        isVerdant   ? "#14302A" :   // dark patina
        isAurora    ? "#142248" :   // deep navy line
                      "#142248"

    //  borderWarm: secondary interactive state, focused-but-not-active
    readonly property color borderWarm:
        isLightMode ? _lightBorderWarm :
        isNoir      ? "#3D4560" :   // steel-blue grey
        isSakura    ? "#7A3860" :   // muted rose
        isLilac     ? "#5040A0" :   // muted violet
        isNeon      ? "#3E6E2A" :   // structural mid-green — half the saturation of the brand accent
        isVerdant   ? "#2A6050" :   // muted teal
        isAurora    ? "#244580" :   // muted aurora-blue
                      "#244580"

    //  borderActive: selection ring, slider fill, active toggle — always vivid
    readonly property color borderActive:
        isNoir      ? "#C8D0E0" :   // pure silver — the only chroma in the theme
        isSakura    ? "#FF8DB5" :   // blossom rose
        isLilac     ? "#B08AFF" :   // soft amethyst
        isNeon      ? "#7CE500" :   // exact KPIT brand green — reserved for strokes, rings, key state
        isVerdant   ? "#C8A838" :   // antique brass
        isAurora    ? "#38D8D0" :   // teal aurora
                      "#38D8D0"

    // -------------------------------------------------------------------------
    //  Typography
    // -------------------------------------------------------------------------

    //  textPrimary: headings, values, primary labels — high contrast
    readonly property color textPrimary:
        isLightMode ? _lightTextPrimary :
        isNoir      ? "#EDF0F8" :   // cool white — no warmth, no hue
        isSakura    ? "#FFF0F6" :   // blush white
        isLilac     ? "#F4F0FF" :   // lavender white
        isNeon      ? "#F2F8EF" :   // near-white with a whisper of green — not mint, not tinted heavily
        isVerdant   ? "#EEF8F2" :   // cool ivory-green
        isAurora    ? "#EAF2FF" :   // polar white
                      "#EAF2FF"

    //  textSecondary: descriptions, secondary values, sub-labels
    readonly property color textSecondary:
        isLightMode ? _lightTextSecondary :
        isNoir      ? "#7888A8" :   // steel grey
        isSakura    ? "#D890B0" :   // muted blush
        isLilac     ? "#A890D8" :   // muted amethyst
        isNeon      ? "#8FA888" :   // desaturated sage-grey — legible, not glowing
        isVerdant   ? "#5AA882" :   // muted patina
        isAurora    ? "#60A8D8" :   // muted aurora-teal
                      "#60A8D8"

    //  textMuted: placeholder text, disabled states, tertiary labels
    readonly property color textMuted:
        isLightMode ? _lightTextMuted :
        isNoir      ? "#3A4258" :
        isSakura    ? "#7A4060" :
        isLilac     ? "#504880" :
        isNeon      ? "#48603F" :   // low-contrast — genuinely receded, not "dim neon"
        isVerdant   ? "#2A5848" :
        isAurora    ? "#203870" :
                      "#203870"

    //  textWarm: active labels, selected option text, accent callouts
    readonly property color textWarm:
        isLightMode ? _lightTextWarm :
        isNoir      ? "#C8D0E0" :   // silver — matches borderActive
        isSakura    ? "#FFB8D0" :   // bright blossom
        isLilac     ? "#C8AAFF" :   // bright amethyst
        isNeon      ? "#9CE83C" :   // bright accent text — softened a touch from pure brand green for body use
        isVerdant   ? "#E8C060" :   // bright brass
        isAurora    ? "#50E0D8" :   // bright aurora-teal
                      "#50E0D8"

    // =========================================================================
    //  ACCENTS — Semantic  (drive mode indicators, eco readouts, etc.)
    // =========================================================================

    //  accentCity: default city drive mode indicator
    readonly property color accentCity:
        isLightMode ? _lightAccentCity :
        isNoir      ? "#C8D0E0" :
        isSakura    ? "#FF8DB5" :
        isLilac     ? "#B08AFF" :
        isNeon      ? "#7CE500" :   // matches KPIT brand green exactly
        isVerdant   ? "#C8A838" :
        isAurora    ? "#38D8D0" :
                      "#38D8D0"

    //  accentEco: always green-spectrum, harmonised to theme warmth
    readonly property color accentEco:
        isLightMode
            ? (isSakura    ? "#1A7A3C" :
               isLilac     ? "#3A7A10" :
               isNeon      ? "#2A7A15" :
               isVerdant   ? "#187050" :
               isAurora    ? "#108060" :
                             "#068050")
            : (isSakura    ? "#80EFB0" :
               isLilac     ? "#90E870" :
               isNeon      ? "#6FDB3A" :   // distinguishable from accentCity — slightly warmer, less saturated
               isVerdant   ? "#40D890" :
               isAurora    ? "#30D8A0" :
                             "#10C880")

    //  accentSport: high-energy red, harmonised per theme
    readonly property color accentSport:
        isLightMode ? "#D02020" :
        isNoir      ? "#E83030" :   // clean red — no tint
        isSakura    ? "#FF5080" :   // hot pink-red
        isLilac     ? "#D060FF" :   // energised violet — sport in Lilac means power
        isNeon      ? "#FF3300" :   // raw high-octane racing red — true complement to the brand green
        isVerdant   ? "#E84020" :   // raw red on patina
        isAurora    ? "#FF4060" :   // plasma red
                      "#FF4060"

    //  accentPrimary: alias for the main theme accent (= borderActive)
    readonly property color accentPrimary: borderActive

    //  accentSakura: named constant for blossom-rose; used by non-Sakura themes
    //  for contextual rose highlights (e.g. battery-low warning tinting)
    readonly property color accentSakura:    "#FF8DB5"
    readonly property color accentSakuraDim: isLightMode ? "#FFF1F7" : "#38122A"

    // =========================================================================
    //  STATUS COLOURS — Universal, never themed
    // =========================================================================

    readonly property color warning:  "#FFD60A"
    readonly property color critical: "#FF3B3B"
    readonly property color success:  "#30D158"

    // =========================================================================
    //  GLASS / PANEL / MAP
    // =========================================================================

    //  transparentPanel: frosted-glass panels, ~67% opaque
    readonly property color transparentPanel:
        isLightMode ? "#EAEAEAFF" :
        isNoir      ? "#AA101218" :
        isSakura    ? "#AA180D16" :
        isLilac     ? "#AA110F22" :
        isNeon      ? "#AA0E140E" :
        isVerdant   ? "#AA0D1C14" :
        isAurora    ? "#AA0A1228" :
                      "#AA0A1228"

    //  glassPanel: deeper overlay, ~88% opaque; drawers, sheets
    readonly property color glassPanel:
        isLightMode ? "#FAFAFAFF" :
        isNoir      ? "#E0101218" :
        isSakura    ? "#E0180D16" :
        isLilac     ? "#E0110F22" :
        isNeon      ? "#E00E140E" :
        isVerdant   ? "#E00D1C14" :
        isAurora    ? "#E00A1228" :
                      "#E00A1228"

    //  mapBase: background fill for the navigation map surface
    readonly property color mapBase:
        isLightMode ? _lightBgPrimary :
        isNoir      ? "#101218" :
        isSakura    ? "#180D16" :
        isLilac     ? "#110F22" :
        isNeon      ? "#0E140E" :
        isVerdant   ? "#0D1C14" :
        isAurora    ? "#0A1228" :
                      "#0A1228"

    //  mapRoad: road colour on the nav map
    readonly property color mapRoad:
        isLightMode ? "#FFFFFF" :
        isNoir      ? "#2A3048" :   // cool grey road on void
        isSakura    ? "#602840" :   // deep rose road
        isLilac     ? "#3A3070" :   // violet-indigo road
        isNeon      ? "#345A1E" :   // legible structural green road, distinct from background
        isVerdant   ? "#1A4030" :   // patina road
        isAurora    ? "#184060" :   // deep teal road
                      "#184060"

    //  shadow: drop shadow colour
    readonly property color shadow:
        isLightMode ? "#20000000" : "#78000000"

    // =========================================================================
    //  LIGHT MODE PALETTES
    // =========================================================================

    // -------------------------------------------------------------------------
    //  Backgrounds — light
    // -------------------------------------------------------------------------

    readonly property color _lightBgPrimary:
        isNoir      ? "#F3F4F8" :   // cool off-white — graphite undertone
        isSakura    ? "#FFF4F8" :   // blush-white
        isLilac     ? "#F8F4FF" :   // iris-white
        isNeon      ? "#F5FAF2" :   // clean ivory with the faintest green breath
        isVerdant   ? "#F2F9F5" :   // cool ivory-teal
        isAurora    ? "#F2F6FF" :   // polar white
                      "#F2F6FF"

    readonly property color _lightBgSecondary:
        isNoir      ? "#E5E8F0" :
        isSakura    ? "#FFE8F2" :
        isLilac     ? "#EDE6FF" :
        isNeon      ? "#E6F2DE" :   // soft tinted neon base
        isVerdant   ? "#DFF0E8" :
        isAurora    ? "#E0ECFF" :
                      "#E0ECFF"

    readonly property color _lightSurfaceBase: "#FFFFFF"

    readonly property color _lightSurfaceRaised:
        isNoir      ? "#F9FAFE" :
        isSakura    ? "#FFFAFE" :
        isLilac     ? "#FDFAFF" :
        isNeon      ? "#FAFEF8" :
        isVerdant   ? "#F8FFFC" :
        isAurora    ? "#F8FBFF" :
                      "#F8FBFF"

    readonly property color _lightSurfaceSunken:
        isNoir      ? "#D8DCE8" :
        isSakura    ? "#F8D8E8" :
        isLilac     ? "#DDD5FF" :
        isNeon      ? "#D2EAC4" :
        isVerdant   ? "#B8E0D0" :
        isAurora    ? "#C8DDF8" :
                      "#C8DDF8"

    readonly property color _lightSurfacePressed:
        isNoir      ? "#C8CCD8" :
        isSakura    ? "#F4C4D8" :
        isLilac     ? "#CBBFFF" :
        isNeon      ? "#BEE0A8" :
        isVerdant   ? "#98D0B8" :
        isAurora    ? "#B0CEEE" :
                      "#B0CEEE"

    // -------------------------------------------------------------------------
    //  Borders — light
    // -------------------------------------------------------------------------

    readonly property color _lightBorderSubtle:
        isNoir      ? "#CDD0DC" :
        isSakura    ? "#F0C8D8" :
        isLilac     ? "#DACED8" :
        isNeon      ? "#CBE8B8" :
        isVerdant   ? "#A8D4C0" :
        isAurora    ? "#B8D0EE" :
                      "#B8D0EE"

    readonly property color _lightBorderWarm:
        isNoir      ? "#5A6080" :
        isSakura    ? "#D87898" :
        isLilac     ? "#9070D8" :
        isNeon      ? "#4F9322" :
        isVerdant   ? "#1A8060" :
        isAurora    ? "#2060B0" :
                      "#2060B0"

    // -------------------------------------------------------------------------
    //  Typography — light
    // -------------------------------------------------------------------------

    readonly property color _lightTextPrimary:
        isNoir      ? "#161B28" :   // near-black, cool undertone
        isSakura    ? "#38082A" :   // deep plum
        isLilac     ? "#220850" :   // deep violet-indigo
        isNeon      ? "#16280E" :   // deep forest-black — crisp, not garish
        isVerdant   ? "#082818" :   // deep forest
        isAurora    ? "#081838" :   // deep navy
                      "#081838"

    readonly property color _lightTextSecondary:
        isNoir      ? "#3A4260" :
        isSakura    ? "#6A2848" :
        isLilac     ? "#4A2890" :
        isNeon      ? "#33591C" :
        isVerdant   ? "#186048" :
        isAurora    ? "#1840A0" :
                      "#1840A0"

    readonly property color _lightTextMuted:
        isNoir      ? "#606880" :
        isSakura    ? "#985078" :
        isLilac     ? "#7860A8" :
        isNeon      ? "#5E7E4C" :
        isVerdant   ? "#388068" :
        isAurora    ? "#4070B8" :
                      "#4070B8"

    readonly property color _lightTextWarm:
        isNoir      ? "#3A4260" :
        isSakura    ? "#6A2848" :
        isLilac     ? "#4A2890" :
        isNeon      ? "#3E7D1E" :
        isVerdant   ? "#186048" :
        isAurora    ? "#1840A0" :
                      "#1840A0"

    //  Light-mode accent for accentCity; matches _lightBorderWarm in hue
    readonly property color _lightAccentCity:
        isNoir      ? "#3A4260" :
        isSakura    ? "#C86080" :
        isLilac     ? "#7050C0" :
        isNeon      ? "#4F9322" :
        isVerdant   ? "#148058" :
        isAurora    ? "#1060B0" :
                      "#1060B0"
}
