import QtQuick
import EvHmi

Item {
    id: root

    property int currentPageIndex: 0
    
    // =====================================================
    // GLOBAL APPLICATION-WIDE STATE
    // =====================================================
    property int globalBrightness: 70
    property string globalFont: "Rajdhani"
    property string globalUnits: "metric"
    // =====================================================
    // GLOBAL APP TRANSLATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "live_telemetry":   { "en": "LIVE TELEMETRY",    "de": "LIVE-TELEMETRIE",   "es": "TELEMETRÍA EN VIVO" },
        "offline":          { "en": "OFFLINE",           "de": "OFFLINE",           "es": "FUERA DE LÍNEA" },
        "system_nominal":   { "en": "SYSTEM NOMINAL",    "de": "SYSTEM NOMINAL",    "es": "SISTEMA NOMINAL" },
        "comm_fault":       { "en": "COMMUNICATION FAULT, CONTACT SERVICE IMMEDIATELY","de": "KOMMUNIKATIONSFEHLER","es": "FALLO DE COMUNICACIÓN" },
        "tab_home":         { "en": "Home",              "de": "Start",             "es": "Inicio" },
        "tab_music":        { "en": "Music",             "de": "Musik",             "es": "Música" },
        "tab_settings":     { "en": "Settings",          "de": "Einstellungen",     "es": "Ajustes" },
        "tab_diagnostics":  { "en": "Diagnostics",       "de": "Diagnose",          "es": "Diagnóstico" }
    }

    // Dynamic keys mapping back directly to the translation dictionary above
    readonly property var pages: [
        { "key": "tab_home" },
        { "key": "tab_music" },
        { "key": "tab_settings" },
        { "key": "tab_diagnostics" }
    ]

    // Internal state helper to see if we should show warnings or dashboard info
    readonly property bool hasWarning: vehicleData.communicationFault || vehicleData.warningMessage.length > 0

    // Background Canvas
    Rectangle {
        anchors.fill: parent
        color: Colors.backgroundPrimary

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Colors.borderActive }                
                GradientStop { position: 1.0; color: Colors.backgroundPrimary }
            }
        }
    }

    // =====================================================
    // TOP STATUS BAR
    // =====================================================
    Item {
        id: topBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Theme.topBarHeight

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Theme.pageMargin
            anchors.verticalCenter: parent.verticalCenter
            spacing: Math.round(12 * Theme.scale)

            Text {
                text: "EV HMI"
                color: Colors.textPrimary
                font.family: Typography.family
                font.pixelSize: Typography.bodyMedium
                font.weight: Font.DemiBold
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: vehicleData.communicationFault 
                      ? root.translations["offline"][Typography.currentLanguage] 
                      : root.translations["live_telemetry"][Typography.currentLanguage]
                color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                font.family: Typography.family
                font.pixelSize: Typography.label
                font.weight: Font.DemiBold
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: Theme.pageMargin
            anchors.verticalCenter: parent.verticalCenter
            spacing: Math.round(14 * Theme.scale)

            Text {
                text: vehicleData.driveMode
                color: vehicleData.driveMode === "SPORT" ? Colors.accentSport
                    : vehicleData.driveMode === "CITY" ? Colors.accentCity
                    : Colors.accentEco
                font.family: Typography.family
                font.pixelSize: Typography.label
                font.weight: Font.DemiBold
            }

            Text {
                text: vehicleData.communicationFault ? "?" : Math.round(vehicleData.batteryPercent) + "%"
                color: Colors.textSecondary
                font.family: Typography.family
                font.pixelSize: Typography.label
                font.weight: Font.DemiBold
            }
        }
    }

    // =====================================================
    // DYNAMIC WIDGET / WARNING BANNER
    // =====================================================
    Rectangle {
        id: warningBanner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topBar.bottom
        anchors.leftMargin: Theme.pageMargin
        anchors.rightMargin: Theme.pageMargin
        height: Math.round(40 * Theme.scale)
        radius: Theme.controlRadius
        color: vehicleData.communicationFault ? Qt.rgba(Colors.critical.r, Colors.critical.g, Colors.critical.b, 0.16)
            : vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning
            ? Qt.rgba(Colors.critical.r, Colors.critical.g, Colors.critical.b, 0.16)
            : vehicleData.lowBatteryWarning || vehicleData.lowRangeWarning ? Qt.rgba(Colors.warning.r, Colors.warning.g, Colors.warning.b, 0.16) : Qt.rgba(Colors.accentCity.r, Colors.accentCity.g, Colors.accentCity.b, 0.11)
        border.color: vehicleData.communicationFault ? Colors.critical
            : vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning
            ? Colors.critical
            : vehicleData.lowBatteryWarning || vehicleData.lowRangeWarning ? Colors.warning : Colors.borderSubtle
        border.width: 1

        // --- SECTION A: ACTIVE WARNING LAYOUT ---
        Row {
            anchors.fill: parent
            anchors.leftMargin: Math.round(14 * Theme.scale)
            anchors.rightMargin: Math.round(14 * Theme.scale)
            spacing: Math.round(10 * Theme.scale)
            visible: root.hasWarning

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: vehicleData.communicationFault ? "⚠" : vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning ? "!" : vehicleData.lowBatteryWarning || vehicleData.lowRangeWarning ? "WARN" : "OK"
                color: vehicleData.communicationFault ? Colors.critical : vehicleData.batteryOverTempWarning || vehicleData.motorOverTempWarning ? Colors.critical : vehicleData.lowBatteryWarning || vehicleData.lowRangeWarning ? Colors.warning : Colors.accentEco
                font.family: Typography.family
                font.pixelSize: Typography.bodySmall
                font.weight: Font.DemiBold
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Math.round(42 * Theme.scale)
                
                text: vehicleData.communicationFault 
                      ? root.translations["comm_fault"][Typography.currentLanguage] : vehicleData.hasWarning 
                      ? vehicleData.warningMessage.toUpperCase() : clockDisplay.text = clockDisplay.getOffsetTime()
                color: Colors.textPrimary
                elide: Text.ElideRight
                font.family: Typography.family
                font.pixelSize: Typography.bodySmall
                font.weight: Font.DemiBold
            }
        }

        // --- SECTION B: TIME & WEATHER DASHBOARD LAYOUT ---
        Item {
            anchors.fill: parent
            visible: !root.hasWarning

            // Left Side: Live Clock
            Text {
                id: clockDisplay
                anchors.left: parent.left
                anchors.leftMargin: Math.round(14 * Theme.scale)
                anchors.verticalCenter: parent.verticalCenter
                
                // Initial load calculation
                text: getOffsetTime()
                
                color: Colors.textPrimary
                font.family: Typography.family
                font.pixelSize: Typography.bodySmall
                font.weight: Font.DemiBold

                // JavaScript helper function to calculate GMT + 5:30 safely
                function getOffsetTime() {
                    let date = new Date();
                    
                    // 1. Get current UTC values
                    let utcHours = date.getUTCHours();
                    let utcMinutes = date.getUTCMinutes();
                    
                    // 2. Apply the +5 hours and +30 minutes offset
                    date.setUTCHours(utcHours + 5);
                    date.setUTCMinutes(utcMinutes + 30);
                    
                    // 3. Format the adjusted time based on your Settings page selection
                    return Qt.formatTime(date, Typography.timeFormat);
                }

                // Updates the clock rendering every second
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockDisplay.text = clockDisplay.getOffsetTime()
                }
            }

            // Right Side: Weather Status Info
            Row {
                anchors.right: parent.right
                anchors.rightMargin: Math.round(14 * Theme.scale)
                anchors.verticalCenter: parent.verticalCenter
                spacing: Math.round(8 * Theme.scale)

                Text {
                    // Check if weatherData backend is available, or use placeholder strings
                    text: typeof weatherData !== 'undefined' ? weatherData.conditionText : "Sunny"
                    color: Colors.textSecondary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                    font.weight: Font.Medium
                }

                Text {
                    text: typeof weatherData !== 'undefined' ? Math.round(weatherData.temperature) + "°C" : "24°C"
                    color: Colors.textPrimary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodySmall
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    // =====================================================
    // MAIN CONTENT PAGE LOADER
    // =====================================================
    Loader {
        id: pageLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: warningBanner.bottom
        anchors.bottom: navBar.top
        anchors.leftMargin: Theme.pageMargin
        anchors.rightMargin: Theme.pageMargin
        anchors.topMargin: Math.round(10 * Theme.scale)
        anchors.bottomMargin: Math.round(8 * Theme.scale)
        sourceComponent: root.currentPageIndex === 0 ? homePage
            : root.currentPageIndex === 1 ? musicPage
            : root.currentPageIndex === 2 ? settingsPage
            : diagnosticsPage
    }

    // =====================================================
    // BOTTOM NAVIGATION BAR
    // =====================================================
    Rectangle {
        id: navBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Theme.navBarHeight
        color: Colors.surfaceRaised
        border.color: Colors.borderSubtle

        Row {
            anchors.centerIn: parent
            spacing: Math.round(8 * Theme.scale)

            Repeater {
                model: root.pages.length

                Rectangle {
                    width: Math.round(132 * Theme.scale)
                    height: Math.round(46 * Theme.scale)
                    radius: Math.round(8 * Theme.scale)
                    color: root.currentPageIndex === index 
                             ? Colors.surfaceBase 
                             : "transparent"
                    border.color: root.currentPageIndex === index
                             ? Colors.borderWarm 
                             : Colors.borderSubtle
                    border.width: 1

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.motionFast
                            easing.type: Easing.OutCubic
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.translations[root.pages[index].key][Typography.currentLanguage]
                        color: root.currentPageIndex === index
                                 ? Colors.textPrimary
                                 : Colors.textMuted
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                        font.weight: root.currentPageIndex === index 
                                 ? Font.DemiBold 
                                 : Font.Medium
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.currentPageIndex = index
                    }
                }
            }
        }
    }
    
    Component { id: homePage; HomePage {} }
    Component { id: musicPage; MusicPage {} }
    Component { id: settingsPage; SettingsPage {} }
    Component { id: diagnosticsPage; DiagnosticsPage {} }

    // =====================================================
    // GLOBAL HARDWARE BRIGHTNESS DIMMER OVERLAY
    // =====================================================
    Rectangle {
        id: globalHardwareDimmer
        anchors.fill: parent
        color: "black"
        // Reads from the global state property to dim the absolute entire viewport display smoothly
        opacity: (100 - root.globalBrightness) / 100 * 0.75
        visible: opacity > 0.01
        z: 999999 // Keeps it resting cleanly above everything including status bars
        enabled: false // Touch events pass straight through to actions underneath seamlessly
    }
}