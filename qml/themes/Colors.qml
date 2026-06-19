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
    // PALETTE METHODOLOGY
    // -----------------------------------------------------
    // Every colour below was generated in OKLCH space (see
    // https://oklch.com/) rather than picked by eye in sRGB hex.
    // OKLCH separates Lightness / Chroma / Hue perceptually, so:
    //   - elevation steps (bg -> surface -> raised -> pressed) use a
    //     fixed, identical L-ramp across all six themes, guaranteeing
    //     consistent perceived contrast between elevations regardless
    //     of hue.
    //   - text steps (primary/secondary/muted/warm) use a fixed L-ramp
    //     tuned against each theme's backgroundPrimary to clear
    //     WCAG AA (>= 4.5:1 for primary/secondary, deliberately lower
    //     for "muted" disabled-style text, matching the original
    //     design intent).
    //   - each theme keeps two hue anchors: a quiet "surfaceHue" that
    //     tints backgrounds/surfaces/borders, and a vivid "accentHue"
    //     used only for borderActive / accentCity / textWarm / mapRoad
    //     - mirroring how uicolors.app derives a full tonal ramp (50-950)
    //     from one brand colour, then a second ramp for the accent.
    //   - out-of-gamut OKLCH requests are chroma-reduced (gamut mapped)
    //     rather than naively clipped, so every hex below is a real,
    //     reproducible sRGB colour - paste any of them into oklch.com
    //     to inspect/tweak its L/C/H directly.
    //
    // Theme hue anchors used (degrees, OKLCH hue circle):
    //   NOIR    surface 250 (near-achromatic steel)   accent 250 (silver)
    //   SAKURA  surface 340 (rose-plum)                accent 352 (blossom)
    //   LILAC   surface 286 (violet)                   accent 291 (amethyst)
    //   NEON    surface 131 (KPIT green)                accent 131 (KPIT green)
    //   VERDANT surface 163 (teal-forest)              accent  86 (antique brass - complementary)
    //   AURORA  surface 250 (abyssal navy)              accent 187 (aurora teal - complementary)
    //
    // accentEco and accentSport are intentionally hue-locked (green ~142,
    // red ~26) across every theme so "eco" and "sport" stay semantically
    // identifiable no matter which theme is active.
    // =====================================================

    // =====================================================
    // DARK MODE PALETTES
    // =====================================================

    readonly property color backgroundPrimary:
        isLightMode ? _lightBgPrimary :
        isNoir      ? "#020305" :   // OKLCH(0.10, 0.006, 250) - near-black steel
        isSakura    ? "#090106" :   // OKLCH(0.10, 0.033, 340) - deep plum-void
        isLilac     ? "#03020D" :   // OKLCH(0.10, 0.033, 286) - violet-void
        isNeon      ? "#020400" :   // OKLCH(0.10, 0.030, 131) - true near-black, faint green breath
        isVerdant   ? "#000502" :   // OKLCH(0.10, 0.030, 163) - deep forest-black
        isAurora    ? "#00030B" :   // OKLCH(0.10, 0.030, 250) - abyssal navy
                      "#00030B"

    readonly property color backgroundSecondary:
        isLightMode ? _lightBgSecondary :
        isNoir      ? "#07090C" :
        isSakura    ? "#13040E" :
        isLilac     ? "#080618" :
        isNeon      ? "#050C01" :   // header / chrome ground - dark, not a green fill
        isVerdant   ? "#000D06" :
        isAurora    ? "#010A17" :
                      "#010A17"

    // -------------------------------------------------------------------------
    //  Surfaces
    // -------------------------------------------------------------------------

    //  surfaceBase: the resting elevation - cards, panels, drawers
    readonly property color surfaceBase:
        isLightMode ? _lightSurfaceBase :
        isNoir      ? "#0F1215" :   // L 0.18 graphite, no hue
        isSakura    ? "#1F0818" :   // L 0.18 dark rose-plum
        isLilac     ? "#100E25" :   // L 0.18 deep violet
        isNeon      ? "#0B1502" :   // L 0.18 dark slate, whisper of green - reads as black
        isVerdant   ? "#00170C" :   // L 0.18 dark teal-forest
        isAurora    ? "#031223" :   // L 0.18 deep navy
                      "#031223"

    //  surfaceRaised: hover state, selected card, popover
    readonly property color surfaceRaised:
        isLightMode ? _lightSurfaceRaised :
        isNoir      ? "#1A1D21" :
        isSakura    ? "#2C1324" :
        isLilac     ? "#1B1933" :
        isNeon      ? "#152109" :   // one step up - still dark, restrained saturation
        isVerdant   ? "#042317" :
        isAurora    ? "#0B1E31" :
                      "#0B1E31"

    //  surfaceSunken: recessed inputs, troughs, map underlay
    readonly property color surfaceSunken:
        isLightMode ? _lightSurfaceSunken :
        isNoir      ? "#000101" :
        isSakura    ? "#020001" :
        isLilac     ? "#010003" :
        isNeon      ? "#000100" :
        isVerdant   ? "#000100" :
        isAurora    ? "#000102" :
                      "#000102"

    //  surfacePressed: active/held state, button depression
    readonly property color surfacePressed:
        isLightMode ? _lightSurfacePressed :
        isNoir      ? "#2A2E33" :
        isSakura    ? "#402236" :
        isLilac     ? "#2C2948" :
        isNeon      ? "#253317" :   // visible press-state, still controlled - not a neon flash
        isVerdant   ? "#123626" :
        isAurora    ? "#192F46" :
                      "#192F46"

    // -------------------------------------------------------------------------
    //  Borders
    // -------------------------------------------------------------------------

    //  borderSubtle: structural dividers, card edges, input outlines at rest
    readonly property color borderSubtle:
        isLightMode ? _lightBorderSubtle :
        isNoir      ? "#1F2328" :   // cool-graphite hairline
        isSakura    ? "#35172B" :   // dim rose-plum
        isLilac     ? "#211E3D" :   // compressed violet
        isNeon      ? "#1A280B" :   // dim structural hairline - present but quiet
        isVerdant   ? "#022A1B" :   // dark patina
        isAurora    ? "#0D243B" :   // deep navy line
                      "#0D243B"

    //  borderWarm: secondary interactive state, focused-but-not-active
    readonly property color borderWarm:
        isLightMode ? _lightBorderWarm :
        isNoir      ? "#53595F" :   // steel-blue grey
        isSakura    ? "#7F405D" :   // muted rose
        isLilac     ? "#594B91" :   // muted violet
        isNeon      ? "#3E6500" :   // structural mid-green
        isVerdant   ? "#6F5303" :   // muted brass
        isAurora    ? "#00665F" :   // muted aurora-teal
                      "#00665F"

    //  borderActive: selection ring, slider fill, active toggle - always vivid.
    //  NOTE: also used as the top GradientStop in AppShell.qml's full-window
    //  background wash, so the light-mode variant must stay restrained -
    //  this was previously missing an isLightMode branch entirely, which is
    //  why every light theme flooded the whole shell with a saturated color.
    readonly property color borderActive:
        isLightMode ? _lightBorderActive :
        isNoir      ? "#AEB9C4" :   // pure silver - the only chroma in the theme
        isSakura    ? "#FF8CC1" :   // blossom rose
        isLilac     ? "#B8A9FF" :   // soft amethyst
        isNeon      ? "#85D100" :   // KPIT brand green - reserved for strokes, rings, key state
        isVerdant   ? "#E2AF27" :   // antique brass
        isAurora    ? "#00D3C6" :   // teal aurora
                      "#00D3C6"

    //  _lightBorderActive: muted counterpart of borderActive for day mode -
    //  same accent hue, ~L0.58 OKLCH, clears 4:1 contrast against white so it
    //  still works as a selection ring/slider fill, without overwhelming the
    //  AppShell gradient the way the full-saturation dark value did.
    readonly property color _lightBorderActive:
        isNoir      ? "#727B85" :
        isSakura    ? "#B65383" :
        isLilac     ? "#7D63D3" :
        isNeon      ? "#578C00" :
        isVerdant   ? "#997400" :
        isAurora    ? "#008D84" :
                      "#008D84"

    // -------------------------------------------------------------------------
    //  Typography
    // -------------------------------------------------------------------------

    //  textPrimary: headings, values, primary labels - high contrast (>=17.5:1 on bgPrimary, all themes)
    readonly property color textPrimary:
        isLightMode ? _lightTextPrimary :
        isNoir      ? "#F0F2F4" :   // cool white - no warmth, no hue
        isSakura    ? "#FBEDF6" :   // blush white
        isLilac     ? "#F0F0FF" :   // lavender white
        isNeon      ? "#EEF4E8" :   // near-white, whisper of green
        isVerdant   ? "#E8F6EE" :   // cool ivory-green
        isAurora    ? "#E9F3FE" :   // polar white
                      "#E9F3FE"

    //  textSecondary: descriptions, secondary values, sub-labels (>=9:1 on bgPrimary)
    readonly property color textSecondary:
        isLightMode ? _lightTextSecondary :
        isNoir      ? "#ABB2B9" :   // steel grey
        isSakura    ? "#D1A0BF" :   // muted blush
        isLilac     ? "#ADABDD" :   // muted amethyst
        isNeon      ? "#A3BA8F" :   // desaturated sage-grey - legible, not glowing
        isVerdant   ? "#8BBFA5" :   // muted patina
        isAurora    ? "#92B5D9" :   // muted aurora-teal
                      "#92B5D9"

    //  textMuted: placeholder text, disabled states, tertiary labels (~3.7:1, intentionally low)
    readonly property color textMuted:
        isLightMode ? _lightTextMuted :
        isNoir      ? "#636A71" :
        isSakura    ? "#895678" :
        isLilac     ? "#656296" :
        isNeon      ? "#5A7243" :   // low-contrast - genuinely receded
        isVerdant   ? "#3C775C" :
        isAurora    ? "#466C93" :
                      "#466C93"

    //  textWarm: active labels, selected option text, accent callouts
    readonly property color textWarm:
        isLightMode ? _lightTextWarm :
        isNoir      ? "#BDC5CE" :   // silver - harmonised with borderActive
        isSakura    ? "#FFA4CC" :   // bright blossom
        isLilac     ? "#C4B9FF" :   // bright amethyst
        isNeon      ? "#9ADB53" :   // bright accent text - softened from pure brand green for body use
        isVerdant   ? "#E6BF65" :   // bright brass
        isAurora    ? "#63DBD0" :   // bright aurora-teal
                      "#63DBD0"

    // =========================================================================
    //  ACCENTS - Semantic  (drive mode indicators, eco readouts, etc.)
    // =========================================================================

    //  accentCity: default city drive mode indicator
    readonly property color accentCity:
        isLightMode ? _lightAccentCity :
        isNoir      ? "#AEB9C4" :
        isSakura    ? "#FF8CC1" :
        isLilac     ? "#B8A9FF" :
        isNeon      ? "#85D100" :   // matches KPIT brand green exactly
        isVerdant   ? "#E2AF27" :
        isAurora    ? "#00D3C6" :
                      "#00D3C6"

    //  accentEco: hue-locked green (OKLCH hue 142) across every theme, so "eco" reads
    //  identically regardless of active theme - L/C tuned per mode for contrast.
    readonly property color accentEco:
        isLightMode ? "#1A6E13" : "#7BD871"

    //  accentSport: hue-locked high-energy red (OKLCH hue 26) across every theme
    readonly property color accentSport:
        isLightMode ? "#C2342E" : "#FA4846"

    //  accentPrimary: alias for the main theme accent (= borderActive)
    readonly property color accentPrimary: borderActive

    //  accentSakura: named constant for blossom-rose; used by non-Sakura themes
    //  for contextual rose highlights (e.g. battery-low warning tinting)
    readonly property color accentSakura:    "#FF8CC1"
    readonly property color accentSakuraDim: isLightMode ? "#FFF1F7" : "#35172B"

    // =========================================================================
    //  STATUS COLOURS - Universal, never themed
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
        isNoir      ? "#AA0F1215" :
        isSakura    ? "#AA1F0818" :
        isLilac     ? "#AA100E25" :
        isNeon      ? "#AA0B1502" :
        isVerdant   ? "#AA00170C" :
        isAurora    ? "#AA031223" :
                      "#AA031223"

    //  glassPanel: deeper overlay, ~88% opaque; drawers, sheets
    readonly property color glassPanel:
        isLightMode ? "#FAFAFAFF" :
        isNoir      ? "#E00F1215" :
        isSakura    ? "#E01F0818" :
        isLilac     ? "#E0100E25" :
        isNeon      ? "#E00B1502" :
        isVerdant   ? "#E000170C" :
        isAurora    ? "#E0031223" :
                      "#E0031223"

    //  mapBase: background fill for the navigation map surface
    readonly property color mapBase:
        isLightMode ? _lightBgPrimary :
        isNoir      ? "#0F1215" :
        isSakura    ? "#1F0818" :
        isLilac     ? "#100E25" :
        isNeon      ? "#0B1502" :
        isVerdant   ? "#00170C" :
        isAurora    ? "#031223" :
                      "#031223"

    //  mapRoad: road colour on the nav map
    readonly property color mapRoad:
        isLightMode ? "#FFFFFF" :
        isNoir      ? "#393E43" :   // cool grey road on void
        isSakura    ? "#5D2942" :   // deep rose road
        isLilac     ? "#3E316C" :   // violet-indigo road
        isNeon      ? "#2A4700" :   // legible structural green road, distinct from background
        isVerdant   ? "#4E3A00" :   // patina road
        isAurora    ? "#004843" :   // deep teal road
                      "#004843"

    //  shadow: drop shadow colour
    readonly property color shadow:
        isLightMode ? "#20000000" : "#78000000"

    // =========================================================================
    //  LIGHT MODE PALETTES
    // =========================================================================

    // -------------------------------------------------------------------------
    //  Backgrounds - light
    // -------------------------------------------------------------------------

    readonly property color _lightBgPrimary:
        isNoir      ? "#F5F7F9" :   // cool off-white - graphite undertone
        isSakura    ? "#FFF3FA" :   // blush-white
        isLilac     ? "#F6F6FF" :   // iris-white
        isNeon      ? "#F3F9EF" :   // clean ivory with the faintest green breath
        isVerdant   ? "#EEFAF4" :   // cool ivory-teal
        isAurora    ? "#F1F8FF" :   // polar white
                      "#F1F8FF"

    readonly property color _lightBgSecondary:
        isNoir      ? "#E7EAED" :
        isSakura    ? "#F8E2F0" :
        isLilac     ? "#E7E7FE" :
        isNeon      ? "#E3EEDB" :   // soft tinted neon base
        isVerdant   ? "#DAF0E4" :
        isAurora    ? "#DCEBFC" :
                      "#DCEBFC"

    readonly property color _lightSurfaceBase: "#FFFFFF"

    readonly property color _lightSurfaceRaised:
        isNoir      ? "#F9FAFB" :
        isSakura    ? "#FFF8FC" :
        isLilac     ? "#F9F9FF" :
        isNeon      ? "#F8FCF5" :
        isVerdant   ? "#F4FCF8" :
        isAurora    ? "#F6FBFF" :
                      "#F6FBFF"

    readonly property color _lightSurfaceSunken:
        isNoir      ? "#D7DBE0" :
        isSakura    ? "#F1CFE5" :
        isLilac     ? "#D7D7F9" :
        isNeon      ? "#D1E1C4" :
        isVerdant   ? "#C2E4D3" :
        isAurora    ? "#C6DEF6" :
                      "#C6DEF6"

    readonly property color _lightSurfacePressed:
        isNoir      ? "#BFC5CB" :
        isSakura    ? "#E0B5D1" :
        isLilac     ? "#C0BFEA" :
        isNeon      ? "#B8CCA7" :
        isVerdant   ? "#A5D0BA" :
        isAurora    ? "#AAC8E7" :
                      "#AAC8E7"

    // -------------------------------------------------------------------------
    //  Borders - light
    // -------------------------------------------------------------------------

    readonly property color _lightBorderSubtle:
        isNoir      ? "#C9CED4" :
        isSakura    ? "#E6C1D9" :
        isLilac     ? "#CAC9EF" :
        isNeon      ? "#C3D5B5" :
        isVerdant   ? "#B3D8C5" :
        isAurora    ? "#B7D1EC" :
                      "#B7D1EC"

    readonly property color _lightBorderWarm:
        isNoir      ? "#636A71" :
        isSakura    ? "#974C6F" :
        isLilac     ? "#6A59AD" :
        isNeon      ? "#4A7800" :
        isVerdant   ? "#846300" :
        isAurora    ? "#007972" :
                      "#007972"

    // -------------------------------------------------------------------------
    //  Typography - light
    // -------------------------------------------------------------------------

    readonly property color _lightTextPrimary:
        isNoir      ? "#0D1116" :   // near-black, cool undertone
        isSakura    ? "#220319" :   // deep plum
        isLilac     ? "#0F092B" :   // deep violet-indigo
        isNeon      ? "#091400" :   // deep forest-black - crisp, not garish
        isVerdant   ? "#00150C" :   // deep forest
        isAurora    ? "#001125" :   // deep navy
                      "#001125"

    readonly property color _lightTextSecondary:
        isNoir      ? "#3A4148" :
        isSakura    ? "#5D2B4E" :
        isLilac     ? "#3D376C" :
        isNeon      ? "#304816" :
        isVerdant   ? "#004C33" :
        isAurora    ? "#1A4268" :
                      "#1A4268"

    readonly property color _lightTextMuted:
        isNoir      ? "#5F6469" :
        isSakura    ? "#874F68" :
        isLilac     ? "#645897" :
        isNeon      ? "#497114" :
        isVerdant   ? "#786025" :
        isAurora    ? "#1F716B" :
                      "#1F716B"

    readonly property color _lightTextWarm:
        isNoir      ? "#464E56" :
        isSakura    ? "#7E2854" :
        isLilac     ? "#513698" :
        isNeon      ? "#365900" :
        isVerdant   ? "#624900" :
        isAurora    ? "#005A54" :
                      "#005A54"

    //  Light-mode accent for accentCity; matches _lightBorderWarm in hue
    readonly property color _lightAccentCity:
        isNoir      ? "#636A71" :
        isSakura    ? "#974C6F" :
        isLilac     ? "#6A59AD" :
        isNeon      ? "#4A7800" :
        isVerdant   ? "#846300" :
        isAurora    ? "#007972" :
                      "#007972"
}
