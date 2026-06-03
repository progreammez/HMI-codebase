pragma Singleton

import QtQuick
import EvHmi

QtObject {
    // Linked straight to settingsState.language ("en", "de", "es")
    property string currentLanguage: "en"

    readonly property bool isEn: currentLanguage === "en"
    readonly property bool isDe: currentLanguage === "de"
    readonly property bool isEs: currentLanguage === "es"

    // =====================================================
    // HARDCODED HMI STRINGS
    // =====================================================
    
    // --- Top Bar & System Notifications ---
    readonly property string liveTelemetry: isDe ? "LIVE-TELEMETRIE" : isEs ? "TELEMETRÍA EN VIVO" : "LIVE TELEMETRY"
    readonly property string systemNominal: isDe ? "SYSTEM NOMINAL" : isEs ? "SISTEMA NOMINAL" : "SYSTEM NOMINAL"
    readonly property string commFault: isDe ? "KOMMUNIKATIONSFEHLER" : isEs ? "FALLO DE COMUNICACIÓN" : "COMMUNICATION FAULT"

    // --- Card Titles ---
    readonly property string modesTitle: isDe ? "Modi" : isEs ? "Modos" : "Modes"
    readonly property string displayTitle: isDe ? "Anzeige" : isEs ? "Pantalla" : "Display"
    readonly property string soundTitle: isDe ? "Ton" : isEs ? "Sound" : "Sound"
    readonly property string systemTitle: isDe ? "System" : isEs ? "Sistema" : "System"

    // --- Setting Labels ---
    readonly property string unitsLabel: isDe ? " Einheiten" : isEs ? " Unidades" : " Units"
    readonly property string languageLabel: isDe ? " Sprache" : isEs ? " Idioma" : " Language"
    readonly property string dayNightLabel: isDe ? " Tag- / Nachtmodus" : isEs ? " Modo Día / Noche" : " Day / Night Mode"
    readonly property string themeLabel: isDe ? " Thema" : isEs ? " Tema" : " Theme"
    readonly property string brightnessLabel: isDe ? " Helligkeit" : isEs ? " Brillo" : " Brightness"
    readonly property string contrastLabel: isDe ? " Kontrast" : isEs ? " Contraste" : " Contrast"
    readonly property string alertVolLabel: isDe ? " Alarmlautstärke" : isEs ? " Volumen de Alerta" : " Alert Volume"
    readonly property string indicatorVolLabel: isDe ? " Blinkerlautstärke" : isEs ? " Volumen de Indicador" : " Indicator Volume"
}