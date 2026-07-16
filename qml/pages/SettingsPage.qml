import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvHmi

Item {
    id: settingsRoot
    anchors.fill: parent

    Component.onCompleted: {
        Colors.contrastValue = settingsState.contrast
    }

    property int cardSpacing: Theme.cardGap ? Theme.cardGap : 10
    property int innerMargin: Theme.cardPadding ? Theme.cardPadding : 14

    QtObject {
        id: settingsState
        property int brightness: typeof root !== 'undefined' ? root.globalBrightness : 100
        property int contrast: Colors.contrastValue
        property int alertVolume: 66
        property int indicatorVolume: 40
        property int masterVolume: musicPlayer.volume

        property string fontStyle: typeof root !== 'undefined' ? root.globalFont : "Rajdhani"
        property string language: Typography.currentLanguage  
        property string theme: Colors.themeName
        property string dayNightMode: Colors.dayNightMode

        property string units: Typography.unitSystem

         // Time & Date Formatters    
        property int clockFormat: Typography.timeFormat === "HH:mm" ? 24 : 12           
        property string dateFormat: "dd"        
    }

    // =====================================================
    // HARDCODED TRANSLATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "modes_title":  { "en": "Modes",       "de": "Modi",               "es": "Modos" },
        "display_title":{ "en": "Display",     "de": "Anzeige",            "es": "Mostrar" },
        "volume_title": { "en": "Volume",      "de": "Lautstärke",         "es": "Volumen" },
        "system_title": { "en": "System",      "de": "System",             "es": "Sistema" },
        "units":        { "en": " Units",      "de": " Einheiten",         "es": " Unidades" },
        "language":     { "en": " Language",   "de": " Sprache",           "es": " Idioma" },
        "day_night":    { "en": " Day / Night Mode", "de": " Tag / Nacht Modus", "es": " Modo Día / Noche" },
        "theme":        { "en": " Theme",      "de": " Thema",            "es": " Tema" },
        "brightness":   { "en": " Brightness", "de": " Helligkeit",        "es": " Brillo" },
        "contrast":     { "en": " Contrast",   "de": " Kontrast",          "es": " Contraste" },
        "alert":        { "en": " Alert",      "de": " Wachsam",           "es": " Alerta" },
        "indicator":    { "en": " Indicator",  "de": " Indikator",           "es": " Indicador" },
        "clock_format": { "en": " Clock Format", "de": " Zeitformat",    "es": " Formato de Reloj" },
        "date_format":  { "en": " Date Format",  "de": " Datumsformat",     "es": " Formato de Fecha" },
        "about":        { "en": " About",      "de": " Über",              "es": " Acerca de" },
        "factory_reset":{ "en": "Factory Reset", "de": "Werkseinstellung", "es": "Reiniciar Fábrica" },
        "reset_warning":{ "en": "Confirm Settings Reset", "de": "Zurücksetzen der Einstellungen bestätigen", "es": "Confirmar el restablecimiento de la configuración" },
        "reset_confirm":{ "en": "Are you sure you want to reset all settings to default?", "de": "Sind Sie sicher, dass Sie alle Einstellungen auf die Standardeinstellungen zurücksetzen möchten?", "es": "¿Está seguro de que desea restablecer todas las configuraciones a los valores predeterminados?" },
        "ok":           { "en": "OK",           "de": "Akzeptieren",                 "es": "Aceptar" },
        "cancel":       { "en": "Cancel",       "de": "Stornieren",           "es": "Cancelar" }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: settingsRoot.cardSpacing

        // =====================================================
        // CARD 1: MODES & ENVIRONMENT
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            title: settingsRoot.translations["modes_title"][settingsState.language]
 
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 4

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: unitsIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/units.png" : "qrc:/assets/icons/Dark/SettingsPage/units.png" 
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["units"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: unitsIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; spacing: 8
                    Rectangle {
                        width: (parent.width - 8) / 2; height: 54; radius: Theme.controlRadius*1.67
                        color: settingsState.units === "metric" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.units === "metric" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Metric\nkm/h, °C"; color: settingsState.units === "metric" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignCenter }
                        MouseArea { anchors.fill: parent; onClicked: {settingsState.units = "metric" 
                        Typography.unitSystem = "metric"} }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 2; height: 54; radius: Theme.controlRadius*1.67
                        color: settingsState.units === "imperial" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.units === "imperial" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Imperial\nmph, °F"; color: settingsState.units === "imperial" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignCenter }
                        MouseArea { anchors.fill: parent; onClicked:{ settingsState.units = "imperial"
                        Typography.unitSystem = "imperial" } }
                    }
                }

                Item { Layout.fillHeight: true } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.fillHeight: true }

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: langIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/language.png" : "qrc:/assets/icons/Dark/SettingsPage/language.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["language"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: langIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; spacing: 4
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.language === "en" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.language === "en" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "ENG"; color: settingsState.language === "en" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.language = "en"; Typography.currentLanguage = "en" } }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.language === "de" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.language === "de" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "GER"; color: settingsState.language === "de" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.language = "de"; Typography.currentLanguage = "de" } }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.language === "es" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.language === "es" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "ESP"; color: settingsState.language === "es" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.language = "es"; Typography.currentLanguage = "es" } }
                    }
                }

                Item { Layout.fillHeight: true } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: fontIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/language.png" : "qrc:/assets/icons/Dark/SettingsPage/language.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: " Font Style"
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: fontIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; spacing: 4
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.fontStyle === "Rajdhani" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.fontStyle === "Rajdhani" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Rajdhani"; color: settingsState.fontStyle === "Rajdhani" ? Colors.textPrimary : Colors.textMuted; font.family: "Rajdhani"; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsState.fontStyle = "Rajdhani"
                                Typography.family = Fonts.rajdhaniRegular
                                if (typeof root !== "undefined")
                                    root.globalFont = Typography.family
                            }
                        }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.fontStyle === "Roboto" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.fontStyle === "Roboto" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Roboto"; color: settingsState.fontStyle === "Roboto" ? Colors.textPrimary : Colors.textMuted; font.family: "Roboto"; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsState.fontStyle = "Roboto"
                                Typography.family = "Roboto"
                                if (typeof root !== "undefined")
                                    root.globalFont = Typography.family
                            }
                        }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.fontStyle === "Orbitron" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.fontStyle === "Orbitron" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Orbitron"; color: settingsState.fontStyle === "Orbitron" ? Colors.textPrimary : Colors.textMuted; font.family: "Orbitron"; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsState.fontStyle = "Orbitron"
                                Typography.family = Fonts.orbitronRegular
                                if (typeof root !== "undefined")
                                    root.globalFont = Typography.family
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: dayNightIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/day-night-mode.png" : "qrc:/assets/icons/Dark/SettingsPage/day-night-mode.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["day_night"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: dayNightIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; spacing: 4
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.dayNightMode === "auto" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.dayNightMode === "auto" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Auto"; color: settingsState.dayNightMode === "auto" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.dayNightMode = "auto"; Colors.dayNightMode = "auto" } }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.dayNightMode === "day" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.dayNightMode === "day" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Day"; color: settingsState.dayNightMode === "day" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.dayNightMode = "day"; Colors.dayNightMode = "day" } }
                    }
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.dayNightMode === "night" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.dayNightMode === "night" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "Night"; color: settingsState.dayNightMode === "night" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.dayNightMode = "night"; Colors.dayNightMode = "night" } }
                    }
                }
                Item { Layout.fillHeight: true } 
            }
        }

        // =====================================================
        // CARD 2: DISPLAY VISUALS
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            title: settingsRoot.translations["display_title"][settingsState.language]

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 6

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { id: themeIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/theme.png" : "qrc:/assets/icons/Dark/SettingsPage/theme.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter
                     }
                    Text { 
                        text: settingsRoot.translations["theme"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: themeIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Grid layout to wrap the 6 theme nodes nicely
                                
                GridLayout {
                    Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 8
                    columns: 3; columnSpacing: 34; rowSpacing: 12
                    
                    // 1. AURORA THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "AURORA" ? 2 : 1; border.color: Colors.themeName === "AURORA" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                // Concentric gap animation: color dot pulls inward subtly when active
                                anchors.margins: Colors.themeName === "AURORA" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { GradientStop { position: 0.0; color: "#72D7FF" } GradientStop { position: 1.0; color: "#0088cc" } }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "AURORA" }
                        }
                        Text { text: "Aurora"; color: Colors.themeName === "AURORA" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "AURORA" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                        
                    // 2. LILAC THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "LILAC" ? 2 : 1; border.color: Colors.themeName === "LILAC" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                anchors.margins: Colors.themeName === "LILAC" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { GradientStop { position: 0.0; color: "#C4B5FD" } GradientStop { position: 1.0; color: "#8669c4" } }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "LILAC" }
                        }
                        Text { text: "Lilac"; color: Colors.themeName === "LILAC" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "LILAC" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // 3. SAKURA THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "SAKURA" ? 2 : 1; border.color: Colors.themeName === "SAKURA" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                anchors.margins: Colors.themeName === "SAKURA" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { GradientStop { position: 0.0; color: "#FFB7D5" } GradientStop { position: 1.0; color: "#FF85C2" } }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "SAKURA" }
                        }
                        Text { text: "Sakura"; color: Colors.themeName === "SAKURA" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "SAKURA" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // 4. NOIR THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "NOIR" ? 2 : 1; border.color: Colors.themeName === "NOIR" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                anchors.margins: Colors.themeName === "NOIR" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { 
                                    GradientStop { position: 0.0; color: "#9197a3" } 
                                    GradientStop { position: 1.0; color: "#3A3F47" } 
                                }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "NOIR" }
                        }
                        Text { text: "Noir"; color: Colors.themeName === "NOIR" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "NOIR" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // 5. NEON THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "NEON" ? 2 : 1; border.color: Colors.themeName === "NEON" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                anchors.margins: Colors.themeName === "NEON" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { 
                                    GradientStop { position: 0.0; color: "#1cb86a" } 
                                    GradientStop { position: 1.0; color: "#32c675" } 
                                }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "NEON" }
                        }
                        Text { text: "Neon"; color: Colors.themeName === "NEON" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "NEON" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // 6. VERDANT THEME
                    Column {
                        spacing: 4
                        Rectangle { 
                            width: 48; height: 48; radius: 24; color: "transparent"
                            border.width: Colors.themeName === "VERDANT" ? 2 : 1; border.color: Colors.themeName === "VERDANT" ? Colors.borderActive : "transparent"
                            antialiasing: true
                            Behavior on border.color { ColorAnimation { duration: 150 } }
                            
                            Rectangle { 
                                anchors.fill: parent
                                anchors.margins: Colors.themeName === "VERDANT" ? 4 : 0
                                radius: width / 2; antialiasing: true
                                gradient: Gradient { 
                                    GradientStop { position: 0.0; color: "#fdb32a" } 
                                    GradientStop { position: 1.0; color: "#146e64" } 
                                }
                                Behavior on anchors.margins { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "VERDANT" }
                        }
                        Text { text: "Verdant"; color: Colors.themeName === "VERDANT" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyMedium; font.weight: Colors.themeName === "VERDANT" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
                Item { Layout.fillHeight: true } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: brightnessIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/brightness.png" : "qrc:/assets/icons/Dark/SettingsPage/brightness.png"
                        width: 29; height: 29; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                     }
                    Text { text: settingsRoot.translations["brightness"][settingsState.language]; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; anchors.left: brightnessIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.brightness) + "%"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    id: brightnessSlider
                    Layout.fillWidth: true; Layout.topMargin: 8; Layout.preferredHeight: 32
                    from: 0; to: 100; value: settingsState.brightness
                    onValueChanged: { 
                        settingsState.brightness = value 
                        if (typeof root !== 'undefined') { root.globalBrightness = value }
                    }
                    background: Rectangle {
                        x: brightnessSlider.leftPadding; y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                        width: brightnessSlider.availableWidth; height: 6; radius: 3; color: Colors.borderSubtle
                        Rectangle { width: brightnessSlider.visualPosition * parent.width; height: parent.height; color: Colors.borderActive; radius: 3 }
                    }
                    handle: Rectangle {
                        x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20; implicitHeight: 20; radius: 10; color: "#ffffff"; border.color: Colors.borderActive; border.width: 2 + (Colors.contrastFactor / 2)
                    }
                }
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 18
                    Text { text: "0%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.left: parent.left }
                    Text { text: "25%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: -parent.width * 0.25 }
                    Text { text: "50%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "75%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: parent.width * 0.25 }
                    Text { text: "100%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.right: parent.right }
                }

                Item { Layout.fillHeight: true } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: contrastIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/contrast.png" : "qrc:/assets/icons/Dark/SettingsPage/contrast.png"
                        width: 29; height: 29; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { text: settingsRoot.translations["contrast"][settingsState.language]; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; anchors.left: contrastIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.contrast) + "%"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    id: contrastSlider
                    Layout.fillWidth: true; Layout.topMargin: 8; Layout.preferredHeight: 32
                    from: 0; to: 100; value: settingsState.contrast
                    onValueChanged: { 
                        settingsState.contrast = value
                        Colors.contrastValue = value
                            }
                    background: Rectangle {
                        x: contrastSlider.leftPadding; y: contrastSlider.topPadding + contrastSlider.availableHeight / 2 - height / 2
                        width: contrastSlider.availableWidth; height: 6; radius: 3; color: Colors.borderSubtle
                        Rectangle { width: contrastSlider.visualPosition * parent.width; height: parent.height; color: Colors.borderActive; radius: 3 }
                    }
                    handle: Rectangle {
                        x: contrastSlider.leftPadding + contrastSlider.visualPosition * (contrastSlider.availableWidth - width)
                        y: contrastSlider.topPadding + contrastSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20; implicitHeight: 20; radius: 10; color: "#ffffff"; border.color: Colors.borderActive; border.width: 2 + (Colors.contrastFactor / 2)
                    }
                }
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 18
                    Text { text: "0%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.left: parent.left }
                    Text { text: "25%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: -parent.width * 0.25 }
                    Text { text: "50%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "75%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: parent.width * 0.25 }
                    Text { text: "100%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.right: parent.right }
                }
                Item { Layout.fillHeight: true } 
            }
        }

        // =====================================================
        // CARD 3: SOUND TELEMETRY
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            title: settingsRoot.translations["volume_title"][settingsState.language]

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 2 // Tightened spacing configuration loop

                // Master Volume Controls
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: masterVolIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/alert-vol.png" : "qrc:/assets/icons/Dark/SettingsPage/alert-vol.png"
                        width: 29; height: 29; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                     }
                    Text { text: " Master Volume"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; anchors.left: masterVolIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.masterVolume) + "%"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    id: masterSlider
                    Layout.fillWidth: true; Layout.topMargin: 4; Layout.preferredHeight: 30
                    from: 0; to: 100; value: settingsState.masterVolume
                    onMoved: {
                        let targetVal = Math.round(value)
                        settingsState.masterVolume = targetVal
                        settingsState.alertVolume = targetVal
                        settingsState.indicatorVolume = targetVal
                        musicPlayer.volume = targetVal
                    }
                    background: Rectangle {
                        x: masterSlider.leftPadding; y: masterSlider.topPadding + masterSlider.availableHeight / 2 - height / 2
                        width: masterSlider.availableWidth; height: 6; radius: 3; color: Colors.borderSubtle
                        Rectangle { width: masterSlider.visualPosition * parent.width; height: parent.height; color: Colors.borderActive; radius: 3 }
                    }
                    handle: Rectangle {
                        x: masterSlider.leftPadding + masterSlider.visualPosition * (masterSlider.availableWidth - width)
                        y: masterSlider.topPadding + masterSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20; implicitHeight: 20; radius: 10; color: "#ffffff"; border.color: Colors.borderActive; border.width: 2 + (Colors.contrastFactor / 2)
                    }
                }
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 18
                    Text { text: "0%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.left: parent.left }
                    Text { text: "25%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: -parent.width * 0.25 }
                    Text { text: "50%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "75%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: parent.width * 0.25 }
                    Text { text: "100%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.right: parent.right }
                }

                Item { Layout.preferredHeight: 8 } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.preferredHeight: 8 } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: alertIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/alert-vol.png" : "qrc:/assets/icons/Dark/SettingsPage/alert-vol.png"
                        width: 29; height: 29; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                     }
                    Text { text: settingsRoot.translations["alert"][settingsState.language]; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; anchors.left: alertIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.alertVolume) + "%"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    id: alertSlider
                    Layout.fillWidth: true; Layout.topMargin: 4; Layout.preferredHeight: 30
                    from: 0; to: 100; value: settingsState.alertVolume
                    onMoved: { settingsState.alertVolume = Math.round(value) }
                    background: Rectangle {
                        x: alertSlider.leftPadding; y: alertSlider.topPadding + alertSlider.availableHeight / 2 - height / 2
                        width: alertSlider.availableWidth; height: 6; radius: 3; color: Colors.borderSubtle
                        Rectangle { width: alertSlider.visualPosition * parent.width; height: parent.height; color: Colors.borderActive; radius: 3 }
                    }
                    handle: Rectangle {
                        x: alertSlider.leftPadding + alertSlider.visualPosition * (alertSlider.availableWidth - width)
                        y: alertSlider.topPadding + alertSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20; implicitHeight: 20; radius: 10; color: "#ffffff"; border.color: Colors.borderActive; border.width: 2 + (Colors.contrastFactor / 2)
                    }
                }
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 18
                    Text { text: "0%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.left: parent.left }
                    Text { text: "25%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: -parent.width * 0.25 }
                    Text { text: "50%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "75%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: parent.width * 0.25 }
                    Text { text: "100%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.right: parent.right }
                }

                Item { Layout.preferredHeight: 8 } 
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Colors.borderSubtle }
                Item { Layout.preferredHeight: 8 } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image {
                        id: indicatorIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/indicator-vol.png" : "qrc:/assets/icons/Dark/SettingsPage/indicator-vol.png"
                        width: 29; height: 29; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { text: settingsRoot.translations["indicator"][settingsState.language]; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; anchors.left: indicatorIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.indicatorVolume) + "%"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    id: indicatorSlider
                    Layout.fillWidth: true; Layout.topMargin: 4; Layout.preferredHeight: 30
                    from: 0; to: 100; value: settingsState.indicatorVolume
                    onMoved: { settingsState.indicatorVolume = Math.round(value) }
                    background: Rectangle {
                        x: indicatorSlider.leftPadding; y: indicatorSlider.topPadding + indicatorSlider.availableHeight / 2 - height / 2
                        width: indicatorSlider.availableWidth; height: 6; radius: 3; color: Colors.borderSubtle
                        Rectangle { width: indicatorSlider.visualPosition * parent.width; height: parent.height; color: Colors.borderActive; radius: 3 }
                    }
                    handle: Rectangle {
                        x: indicatorSlider.leftPadding + indicatorSlider.visualPosition * (indicatorSlider.availableWidth - width)
                        y: indicatorSlider.topPadding + indicatorSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20; implicitHeight: 20; radius: 10; color: "#ffffff"; border.color: Colors.borderActive; border.width: 2 + (Colors.contrastFactor / 2) 
                    }
                }
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 18
                    Text { text: "0%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.left: parent.left }
                    Text { text: "25%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: -parent.width * 0.25 }
                    Text { text: "50%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "75%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: parent.width * 0.25 }
                    Text { text: "100%"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: 13; anchors.right: parent.right }
                }
            }
        }

        // =====================================================
        // CARD 4: SYSTEM PROPERTIES
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            title: settingsRoot.translations["system_title"][settingsState.language]

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 12

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: clockIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/clock-format.png" : "qrc:/assets/icons/Dark/SettingsPage/clock-format.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["clock_format"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: clockIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; Layout.preferredHeight: 48
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.clockFormat === 12 ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.clockFormat === 12 ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "12 Hour"; color: settingsState.clockFormat === 12 ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: settingsState.clockFormat === 12 ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.clockFormat = 12; Typography.timeFormat = "hh:mm AP" } }
                    }
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.clockFormat === 24 ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.clockFormat === 24 ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "24 Hour"; color: settingsState.clockFormat === 24 ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: settingsState.clockFormat === 24 ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: { settingsState.clockFormat = 24; Typography.timeFormat = "HH:mm" } }
                    }
                }

                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: dateIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/date-format.png" : "qrc:/assets/icons/Dark/SettingsPage/date-format.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["date_format"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: dateIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    Layout.fillWidth: true; Layout.topMargin: 8; Layout.preferredHeight: 48
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.dateFormat === "dd" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.dateFormat === "dd" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "DD/MM/YY"; color: settingsState.dateFormat === "dd" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: settingsState.dateFormat === "dd" ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.dateFormat = "dd" }
                    }
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 48; radius: Theme.controlRadius*1.67
                        color: settingsState.dateFormat === "mm" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1 + (Colors.contrastFactor / 2); border.color: settingsState.dateFormat === "mm" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "MM/DD/YY"; color: settingsState.dateFormat === "mm" ? Colors.textPrimary : Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: settingsState.dateFormat === "mm" ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.dateFormat = "mm" }
                    }
                }

                Item { Layout.fillHeight: true } 

                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Image { 
                        id: aboutIcon
                        source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/about.png" : "qrc:/assets/icons/Dark/SettingsPage/about.png"
                        width: 29; height: 29; anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: settingsRoot.translations["about"][settingsState.language]
                        color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold
                        anchors.left: aboutIcon.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                Grid {
                    columns: 2; spacing: 6; Layout.fillWidth: true; Layout.topMargin: 8; Layout.preferredHeight: 50
                    Text { text: "Firmware Version"; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; width: parent.width * 0.42 }
                    Text { text: "v1.2.3"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignRight; width: parent.width * 0.58 }
                    Text { text: "Build No."; color: Colors.textMuted; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; width: parent.width * 0.42 }
                    Text { text: "2024.05.28.01"; color: Colors.textPrimary; font.family: settingsState.fontStyle; font.pixelSize: Typography.bodyLarge; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignRight; width: parent.width * 0.58 }
                }

                Rectangle {
                    Layout.fillWidth: true; Layout.topMargin: 12; Layout.preferredHeight: 51; radius: Theme.controlRadius*1.67
                    color: "transparent"; border.width: 1 + (Colors.contrastFactor / 2); border.color: "#88ff4444"
                    Row {
                        anchors.centerIn: parent; spacing: 8
                        Text { text: settingsRoot.translations["factory_reset"][settingsState.language]; color: "#ff4444"; font.family: settingsState.fontStyle; font.weight: Font.Bold; font.pixelSize: Typography.bodyLarge }
                        Image { 
                            source: settingsState.dayNightMode === "day" ? "qrc:/assets/icons/Light/SettingsPage/restart.png" : "qrc:/assets/icons/Dark/SettingsPage/restart.png"
                            width: 22; height: 22; anchors.verticalCenter: parent.verticalCenter 
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.color = "#22ff4444"
                        onReleased: parent.color = "transparent"
                        onClicked: resetConfirmationDialog.open()
                    }
                }
            }
        }
    }

    /// =====================================================
    // REFINED FACTORY RESET SAFETY POPUP
    // =====================================================
    Dialog {
        id: resetConfirmationDialog

        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape

        // Dark overlay behind the dialog
        Overlay.modal: Rectangle {
            color: "#70000000"    // semi-transparent black
        }

        // Remove default title bar
        header: Item {
            width: 0
            height: 0
        }

        background: Rectangle {
            implicitWidth: 400
            implicitHeight: 220

            color: Colors.surfaceRaised
            border.color: "#ff4444"
            border.width: 1 + (Colors.contrastFactor / 2)
            radius: Theme.controlRadius * 1.5
        }

        contentItem: Column {
            spacing: 20
            padding: 24

            Text {
                text: settingsRoot.translations["reset_warning"][settingsState.language]
                color: "#ff4444"

                font.family: settingsState.fontStyle
                font.pixelSize: Typography.titleMedium
                font.weight: Font.Bold
            }

            Text {
                width: 350
                wrapMode: Text.WordWrap

                text: settingsRoot.translations["reset_confirm"][settingsState.language]
                color: Colors.textPrimary

                font.family: settingsState.fontStyle
                font.pixelSize: Typography.bodyLarge
            }
        }

        footer: DialogButtonBox {
            alignment: Qt.AlignRight
            spacing: 12
            padding: 16

            background: Rectangle {
                color: "transparent"
            }

            Button {
                text: settingsRoot.translations["cancel"][settingsState.language]
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole

                implicitWidth: 96
                implicitHeight: 44

                onClicked: resetConfirmationDialog.reject()

                contentItem: Text {
                    text: parent.text
                    color: Colors.textPrimary

                    font.family: settingsState.fontStyle
                    font.pixelSize: Typography.bodyLarge

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "transparent"
                    border.color: Colors.borderSubtle
                    border.width: 1 + (Colors.contrastFactor / 2)
                    radius: Theme.controlRadius
                }
            }

            Button {
                text: settingsRoot.translations["ok"][settingsState.language]
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole

                implicitWidth: 96
                implicitHeight: 44

                onClicked: resetConfirmationDialog.accept()

                contentItem: Text {
                    text: parent.text
                    color: "#ff4444"

                    font.family: settingsState.fontStyle
                    font.pixelSize: Typography.bodyLarge

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "transparent"
                    border.color: "#ff4444"
                    border.width: 1 + (Colors.contrastFactor / 2)
                    radius: Theme.controlRadius
                }
            }
        }

        onAccepted: {
            settingsState.brightness = 100
            settingsState.contrast = 55
            settingsState.alertVolume = 66
            settingsState.indicatorVolume = 40
            settingsState.masterVolume = 66
            musicPlayer.volume = 66

            settingsState.language = "en"
            settingsState.fontStyle = "Rajdhani"
            settingsState.dayNightMode = "auto"

            settingsState.clockFormat = 24
            settingsState.dateFormat = "dd"

            Colors.themeName = "NEON"
            Colors.dayNightMode = "auto"
            Typography.currentLanguage = "en"
            Typography.unitSystem = "metric"
            Typography.family = Fonts.rajdhaniRegular

            if (typeof root !== "undefined") {
                root.globalFont = Typography.family
                root.globalBrightness = 100
            }

            close()
        }

        onRejected: {
            close()
        }
    }
}
