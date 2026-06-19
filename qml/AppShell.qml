import QtQuick
import EvHmi

Item {
    id: root

    property int currentPageIndex: 0
    
    // =====================================================
    // GLOBAL APPLICATION-WIDE STATE & MODES
    // =====================================================
    property bool isEngineerMode: false
    property int globalBrightness: 70
    property string globalFont: "Rajdhani"
    property string globalUnits: "metric"

    // Automatically safeguard bounds when toggling between standard (4) and engineer (7) arrays
    onIsEngineerModeChanged: root.currentPageIndex = 0

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
        "tab_diagnostics":  { "en": "Diagnostics",       "de": "Diagnose",          "es": "Diagnóstico" },
        
        // Engineer Mode Localized Text Strings
        "tab_eng_overview":  { "en": "Overview" },
        "tab_eng_telemetry": { "en": "Telemetry" },
        "tab_eng_thermal":   { "en": "Thermal" },
        "tab_eng_powertrain":{ "en": "Powertrain" },
        "tab_eng_comms":     { "en": "Comms" },
        "tab_eng_faults":    { "en": "Faults" },
        "tab_eng_exit":      { "en": "✕ EXIT ENG" }
    }

    // =====================================================
    // DYNAMIC NAVIGATION SCHEMAS
    // =====================================================
    readonly property var normalPages: [
        { "key": "tab_home",        "isDiag": false, "isExit": false },
        { "key": "tab_music",       "isDiag": false, "isExit": false },
        { "key": "tab_settings",    "isDiag": false, "isExit": false },
        { "key": "tab_diagnostics", "isDiag": true,  "isExit": false }
    ]

    readonly property var engineerPages: [
        { "key": "tab_eng_overview",   "isDiag": false, "isExit": false },
        { "key": "tab_eng_telemetry",  "isDiag": false, "isExit": false },
        { "key": "tab_eng_thermal",    "isDiag": false, "isExit": false },
        { "key": "tab_eng_powertrain", "isDiag": false, "isExit": false },
        { "key": "tab_eng_comms",      "isDiag": false, "isExit": false },
        { "key": "tab_eng_faults",     "isDiag": true,  "isExit": false },
        { "key": "tab_eng_exit",       "isDiag": false, "isExit": true } // 7th Tab Entry
    ]

    readonly property var activePages: root.isEngineerMode ? engineerPages : normalPages
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
                // Displays elevated hierarchy header if configured in Engineer Mode (image_0a2d6c.png reference)
                text: root.isEngineerMode ? "ENGINEER MODE • LEVEL 2 • READ / MONITOR" : "EV HMI"
                color: root.isEngineerMode ? Colors.accentSport : Colors.textPrimary
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
                visible: !root.isEngineerMode
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
        border.width: 2

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

        Item {
            anchors.fill: parent
            visible: !root.hasWarning

            Text {
                id: clockDisplay
                anchors.left: parent.left
                anchors.leftMargin: Math.round(14 * Theme.scale)
                anchors.verticalCenter: parent.verticalCenter
                text: getOffsetTime()
                color: Colors.textPrimary
                font.family: Typography.family
                font.pixelSize: Typography.bodySmall
                font.weight: Font.DemiBold

                function getOffsetTime() {
                    let date = new Date();
                    let utcHours = date.getUTCHours();
                    let utcMinutes = date.getUTCMinutes();
                    date.setUTCHours(utcHours + 5);
                    date.setUTCMinutes(utcMinutes + 30);
                    return Qt.formatTime(date, Typography.timeFormat);
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockDisplay.text = clockDisplay.getOffsetTime()
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: Math.round(14 * Theme.scale)
                anchors.verticalCenter: parent.verticalCenter
                spacing: Math.round(8 * Theme.scale)

                Text {
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
        
        sourceComponent: {
            if (!root.isEngineerMode) {
                return root.currentPageIndex === 0 ? homePage
                     : root.currentPageIndex === 1 ? musicPage
                     : root.currentPageIndex === 2 ? settingsPage
                     : diagnosticsPage;
            } else {
                return root.currentPageIndex === 0 ? engOverviewPage
                     : root.currentPageIndex === 1 ? engTelemetryPage
                     : root.currentPageIndex === 2 ? engThermalPage
                     : root.currentPageIndex === 3 ? engPowertrainPage
                     : root.currentPageIndex === 4 ? engCommsPage
                     : engFaultsPage; // Note: The 7th (Exit) button handles context state switching, not layout content loading.
            }
        }
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
            spacing: Math.round(6 * Theme.scale) // Snugger spacing to fit 7 elements easily

            Repeater {
                model: root.activePages.length

                Rectangle {
                    // Dynamically adjusts width to fit 7 tabs comfortably side-by-side in Engineer Mode
                    width: root.isEngineerMode ? Math.round(102 * Theme.scale) : Math.round(132 * Theme.scale)
                    height: Math.round(46 * Theme.scale)
                    radius: Math.round(8 * Theme.scale)
                    
                    color: root.activePages[index].isExit 
                           ? "transparent"
                           : (root.currentPageIndex === index ? Colors.surfaceBase : "transparent")
                           
                    border.color: root.activePages[index].isExit 
                                  ? Colors.critical 
                                  : (root.currentPageIndex === index ? Colors.borderWarm : Colors.borderSubtle)
                    border.width: 1

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.motionFast
                            easing.type: Easing.OutCubic
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: {
                            var keyLookup = root.activePages[index].key;
                            var dict = root.translations[keyLookup];
                            return (dict && dict[Typography.currentLanguage] !== undefined) ? dict[Typography.currentLanguage] : (dict ? dict["en"] : "");
                        }
                        color: root.activePages[index].isExit 
                               ? Colors.critical 
                               : (root.currentPageIndex === index ? Colors.textPrimary : Colors.textMuted)
                        font.family: Typography.family
                        font.pixelSize: root.isEngineerMode ? Typography.label : Typography.bodySmall
                        font.weight: (root.currentPageIndex === index || root.activePages[index].isExit) ? Font.DemiBold : Font.Medium
                    }

                    MouseArea {
                        anchors.fill: parent
                        
                        onClicked: {
                            if (root.activePages[index].isExit) {
                                root.isEngineerMode = false; // Graceful state reversal back to user mode
                            } else {
                                root.currentPageIndex = index;
                            }
                        }
                        
                        pressAndHoldInterval: 800
                        onPressAndHold: {
                            // Diagnostics tab (and Faults tab in engineer view) accepts long press state flips
                            if (root.activePages[index].isDiag) {
                                root.isEngineerMode = !root.isEngineerMode;
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Core User Mode Components
    Component { id: homePage; HomePage {} }
    Component { id: musicPage; MusicPage {} }
    Component { id: settingsPage; SettingsPage {} }
    Component { id: diagnosticsPage; DiagnosticsPage {} }

    // Specialized Engineer Components
    Component { id: engOverviewPage;  OverviewPage {} }
    Component { id: engTelemetryPage;  TelemetryPage {} }
    Component { id: engThermalPage;   ThermalPage {} }
    Component { id: engPowertrainPage; PowertrainPage {} }
    Component { id: engCommsPage;     CommsPage {} }
    Component { id: engFaultsPage;     FaultsPage {} }

    // =====================================================
    // GLOBAL HARDWARE BRIGHTNESS DIMMER OVERLAY
    // =====================================================
    Rectangle {
        id: globalHardwareDimmer
        anchors.fill: parent
        color: "black"
        opacity: (100 - root.globalBrightness) / 100 * 0.75
        visible: opacity > 0.01
        z: 999999 
        enabled: false 
    }
}