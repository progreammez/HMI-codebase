import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvHmi

Item {
    id: settingsRoot
    anchors.fill: parent

    property int cardSpacing: Theme.cardGap ? Theme.cardGap : 10
    property int innerMargin: Theme.cardPadding ? Theme.cardPadding : 14

    QtObject {
        id: settingsState
        property int brightness: 70
        property int contrast: 55
        property int alertVolume: 66
        property int indicatorVolume: 40

        property string units: "metric"     
        property string language: "en"         
        property string dayNightMode: "night"  
        property int clockFormat: 24           
        property string dateFormat: "dd"        
    }

    RowLayout {
        anchors.fill: parent
        spacing: settingsRoot.cardSpacing

        // =====================================================
        // CARD 1: MODES & ENVIRONMENT
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            title: "Modes"

            Column {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 12

                Item {
                    width: parent.width
                    height: 20
                    
                    Image { id: unitsIcon
                    source: settingsState.dayNightMode === "day"
                             ? "qrc:/assets/icons/Light/SettingsPage/units.png"
                             : "qrc:/assets/icons/Dark/SettingsPage/units.png" 
                    width: 18
                    height: 18
                    anchors.verticalCenter: parent.verticalCenter }
                    Text { 
                        text: " Units"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: unitsIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    spacing: 8
                    width: parent.width
                    
                    Rectangle {
                        width: (parent.width - 8) / 2; height: 34; radius: Theme.controlRadius
                        color: settingsState.units === "metric" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1
                        border.color: settingsState.units === "metric" ? Colors.borderActive : Colors.borderSubtle
                        
                        Text { anchors.centerIn: parent; text: "Metric\nkm/h, °C"; color: settingsState.units === "metric" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignCenter }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.units = "metric" }
                    }
                    
                    Rectangle {
                        width: (parent.width - 8) / 2; height: 34; radius: Theme.controlRadius
                        color: settingsState.units === "imperial" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1
                        border.color: settingsState.units === "imperial" ? Colors.borderActive : Colors.borderSubtle
                        
                        Text { anchors.centerIn: parent; text: "Imperial\nmph, °F"; color: settingsState.units === "imperial" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignCenter }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.units = "imperial" }
                    }
                }

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: langIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/language.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/language.png"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter 
                    
                    }
                    Text { 
                        text: " Language"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: langIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    spacing: 4
                    width: parent.width
                    
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.language === "en" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.language === "en" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "ENG"; color: settingsState.language === "en" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.language = "en" }
                    }
                    
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.language === "de" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.language === "de" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "GER"; color: settingsState.language === "de" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.language = "de" }
                    }
                    
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.language === "es" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.language === "es" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "ESP"; color: settingsState.language === "es" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Font.DemiBold }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.language = "es" }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: Colors.borderSubtle }

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: dayNightIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/day-night-mode.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/day-night-mode.png"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { 
                        text: " Day / Night Mode"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: dayNightIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width
                    
                    // --- Auto Button ---
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.dayNightMode === "auto" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1
                        border.color: settingsState.dayNightMode === "auto" ? Colors.borderActive : Colors.borderSubtle
                        
                        Text { 
                            anchors.centerIn: parent
                            text: "Auto"
                            color: settingsState.dayNightMode === "auto" ? Colors.textPrimary : Colors.textMuted
                            font.pixelSize: 11
                            font.weight: Font.DemiBold 
                        }
                        
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                settingsState.dayNightMode = "auto"
                                Colors.dayNightMode = "auto"
                            }
                        }
                    }
                    
                    // --- Day Button (Light Mode Override) ---
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.dayNightMode === "day" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1
                        border.color: settingsState.dayNightMode === "day" ? Colors.borderActive : Colors.borderSubtle
                        
                        Text { 
                            anchors.centerIn: parent
                            text: "Day"
                            color: settingsState.dayNightMode === "day" ? Colors.textPrimary : Colors.textMuted
                            font.pixelSize: 11
                            font.weight: Font.DemiBold 
                        }
                        
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                settingsState.dayNightMode = "day"
                                Colors.dayNightMode = "day" // Forces the global singleton to invert palettes to Light Mode
                            }
                        }
                    }
                    
                    // --- Night Button (Dark Mode Override) ---
                    Rectangle {
                        width: (parent.width - 8) / 3; height: 30; radius: Theme.controlRadius
                        color: settingsState.dayNightMode === "night" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1
                        border.color: settingsState.dayNightMode === "night" ? Colors.borderActive : Colors.borderSubtle
                        
                        Text { 
                            anchors.centerIn: parent
                            text: "Night"
                            color: settingsState.dayNightMode === "night" ? Colors.textPrimary : Colors.textMuted
                            font.pixelSize: 11
                            font.weight: Font.DemiBold 
                        }
                        
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                settingsState.dayNightMode = "night"
                                Colors.dayNightMode = "night" // Forces the global singleton back into pristine Dark Mode layouts
                            }
                        }
                    }
                }
            }
        }

        // =====================================================
        // CARD 2: DISPLAY VISUALS (IMPROVED GRADIENT THEMES)
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            title: "Display"

            Column {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 14 // Increased padding spacing for cleanly defined section breaks

                Item {
                    width: parent.width
                    height: 20
                    Image { id: themeIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/theme.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/theme.png"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter
                     }

                    Text { 
                        text: " Theme"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: themeIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Cleanly isolated row container with balanced touch areas for gradients
                Row {
                    spacing: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    // --- Ice Node ---
                    Column {
                        spacing: 6
                        Rectangle { 
                            width: 28; height: 28; radius: 14
                            color: "transparent"
                            border.width: Colors.themeName === "ICE" ? 2 : 1
                            border.color: Colors.themeName === "ICE" ? Colors.borderActive : "transparent"
                            
                            Rectangle {
                                anchors.fill: parent; anchors.margins: 3; radius: 11
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#72D7FF" }
                                    GradientStop { position: 1.0; color: "#0088cc" }
                                }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "ICE" }
                        }
                        Text { text: "Ice"; color: Colors.themeName === "ICE" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Colors.themeName === "ICE" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // --- Ember Node ---
                    Column {
                        spacing: 6
                        Rectangle { 
                            width: 28; height: 28; radius: 14
                            color: "transparent"
                            border.width: Colors.themeName === "AMBER" ? 2 : 1
                            border.color: Colors.themeName === "AMBER" ? Colors.borderActive : "transparent"
                            
                            Rectangle {
                                anchors.fill: parent; anchors.margins: 3; radius: 11
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#F0B84D" }
                                    GradientStop { position: 1.0; color: "#b84a14" }
                                }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "AMBER" }
                        }
                        Text { text: "Ember"; color: Colors.themeName === "AMBER" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Colors.themeName === "AMBER" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    // --- Copper Node ---
                    Column {
                        spacing: 6
                        Rectangle { 
                            width: 28; height: 28; radius: 14
                            color: "transparent"
                            border.width: Colors.themeName === "COPPER" ? 2 : 1
                            border.color: Colors.themeName === "COPPER" ? Colors.borderActive : "transparent"
                            
                            Rectangle {
                                anchors.fill: parent; anchors.margins: 3; radius: 11
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#E29572" }
                                    GradientStop { position: 1.0; color: "#6e4431" }
                                }
                            }
                            MouseArea { anchors.fill: parent; onClicked: Colors.themeName = "COPPER" }
                        }
                        Text { text: "Copper"; color: Colors.themeName === "COPPER" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 11; font.weight: Colors.themeName === "COPPER" ? Font.DemiBold : Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: brightnessIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/brightness.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/brightness.png"
                        width: 18
                        height: 18
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    
                     }
                    Text { text: " Brightness"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; anchors.left: brightnessIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.brightness) + "%"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    width: parent.width; height: 22
                    from: 0; to: 100; value: settingsState.brightness
                    onValueChanged: { settingsState.brightness = value }
                }

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: contrastIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/contrast.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/contrast.png"
                        width: 18
                        height: 18
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { text: " Contrast"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; anchors.left: contrastIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.contrast) + "%"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    width: parent.width; height: 22
                    from: 0; to: 100; value: settingsState.contrast
                    onValueChanged: { settingsState.contrast = value }
                }
            }
        }

        // =====================================================
        // CARD 3: SOUND TELEMETRY (FIXED TEXT OVERLAPS)
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            title: "Volume"

            Column {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 10

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: alertIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/alert-vol.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/alert-vol.png"
                         
                        width: 18
                        height: 18
                        anchors.left: parent.left
                        
                        anchors.verticalCenter: parent.verticalCenter
                     }
                    Text { text: " Alert"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; anchors.left: alertIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.alertVolume) + "%"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    width: parent.width; height: 22
                    from: 0; to: 100; value: settingsState.alertVolume
                    onValueChanged: { settingsState.alertVolume = value }
                }
                Item {
                    width: parent.width; height: 14
                    Text { text: "0%"; color: Colors.textMuted; font.pixelSize: 10; anchors.left: parent.left }
                    Text { text: "50%"; color: Colors.textMuted; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "100%"; color: Colors.textMuted; font.pixelSize: 10; anchors.right: parent.right }
                }

                Item { width: 1; height: 8 }

                // FIXED: Precise anchoring configurations tracking title strings and data markers safely
                Item {
                    width: parent.width
                    height: 20
                    Image {
                         id: indicatorIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/indicator-vol.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/indicator-vol.png"

                        width: 18
                        height: 18
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter 
                    }
                    Text { text: " Indicator"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.DemiBold; anchors.left: indicatorIcon.right; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: Math.round(settingsState.indicatorVolume) + "%"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.weight: Font.Bold; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                }
                Slider {
                    width: parent.width; height: 22
                    from: 0; to: 100; value: settingsState.indicatorVolume
                    onValueChanged: { settingsState.indicatorVolume = value }
                }
                Item {
                    width: parent.width; height: 14
                    Text { text: "0%"; color: Colors.textMuted; font.pixelSize: 10; anchors.left: parent.left }
                    Text { text: "50%"; color: Colors.textMuted; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: "100%"; color: Colors.textMuted; font.pixelSize: 10; anchors.right: parent.right }
                }
            }
        }

        // =====================================================
        // CARD 4: SYSTEM PROPERTIES
        // =====================================================
        BaseCard {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            title: "System"

            Column {
                anchors.fill: parent
                anchors.margins: settingsRoot.innerMargin
                spacing: 12

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: clockIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/clock-format.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/clock-format.png"

                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter 
                    
                    }
                    Text { 
                        text: " Clock Format"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: clockIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    spacing: 6; width: parent.width
                    
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 30; radius: Theme.controlRadius
                        color: settingsState.clockFormat === 12 ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.clockFormat === 12 ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "12 Hour"; color: settingsState.clockFormat === 12 ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 12; font.weight: settingsState.clockFormat === 12 ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.clockFormat = 12 }
                    }
                    
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 30; radius: Theme.controlRadius
                        color: settingsState.clockFormat === 24 ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.clockFormat === 24 ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "24 Hour"; color: settingsState.clockFormat === 24 ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 12; font.weight: settingsState.clockFormat === 24 ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.clockFormat = 24 }
                    }
                }

                Item {
                    width: parent.width
                    height: 20
                    Image { 
                        id: dateIcon
                        source: settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/date-format.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/date-format.png"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter 
                   
                    }
                    Text { 
                        text: " Date Format"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: dateIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    spacing: 6; width: parent.width
                    
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 30; radius: Theme.controlRadius
                        color: settingsState.dateFormat === "dd" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.dateFormat === "dd" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "DD/MM/YY"; color: settingsState.dateFormat === "dd" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 12; font.weight: settingsState.dateFormat === "dd" ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.dateFormat = "dd" }
                    }
                    
                    Rectangle {
                        width: (parent.width - 6) / 2; height: 30; radius: Theme.controlRadius
                        color: settingsState.dateFormat === "mm" ? Colors.surfacePressed : Colors.surfaceRaised
                        border.width: 1; border.color: settingsState.dateFormat === "mm" ? Colors.borderActive : Colors.borderSubtle
                        Text { anchors.centerIn: parent; text: "MM/DD/YY"; color: settingsState.dateFormat === "mm" ? Colors.textPrimary : Colors.textMuted; font.pixelSize: 12; font.weight: settingsState.dateFormat === "mm" ? Font.DemiBold : Font.Normal }
                        MouseArea { anchors.fill: parent; onClicked: settingsState.dateFormat = "mm" }
                    }
                }

                Item {
                    width: parent.width
                    height: 20
                    Image {
                         id: aboutIcon;
                        source:settingsState.dayNightMode === "day"
                                 ? "qrc:/assets/icons/Light/SettingsPage/about.png"
                                 : "qrc:/assets/icons/Dark/SettingsPage/about.png"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter 
                    
                    }

                    Text { 
                        text: " About"
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.weight: Font.DemiBold
                        anchors.left: aboutIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                Grid {
                    columns: 2; spacing: 6; width: parent.width
                    Text { text: "Firmware Version"; color: Colors.textMuted; font.pixelSize: 11; width: parent.width * 0.55 }
                    Text { text: "v1.2.3"; color: Colors.textPrimary; font.pixelSize: 11; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignRight; width: parent.width * 0.45 }
                    Text { text: "Build Number"; color: Colors.textMuted; font.pixelSize: 11; width: parent.width * 0.45 }
                    Text { text: "2024.05.28.01"; color: Colors.textPrimary; font.pixelSize: 11; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignRight; width: parent.width * 0.55 }
                }

                Rectangle {
                    width: parent.width; height: 32; radius: Theme.controlRadius
                    color: "transparent"; border.width: 1; border.color: "#55ff4444"
                    
                    Row {
                        anchors.centerIn: parent; spacing: 8
                        Text { text: "Factory Reset"; color: "#ff4444"; font.weight: Font.Bold; font.pixelSize: 12 }
                        Image { 
                            
                            source: settingsState.dayNightMode === "day"
                                    ? "qrc:/assets/icons/Light/SettingsPage/restart.png"
                                    : "qrc:/assets/icons/Dark/SettingsPage/restart.png"
                                                    
                            width: 14
                            height: 14
                            anchors.verticalCenter: parent.verticalCenter 
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.color = "#22ff4444"
                        onReleased: parent.color = "transparent"
                        onClicked: {
                            settingsState.brightness = 70
                            settingsState.contrast = 55
                            settingsState.alertVolume = 66
                            settingsState.indicatorVolume = 40
                            settingsState.units = "metric"
                            settingsState.language = "en"
                            settingsState.dayNightMode = "auto"
                            Colors.themeName = "ICE"
                            settingsState.clockFormat = 24
                            settingsState.dateFormat = "dd"
                        }

                    }
                }
            }
        }
    }
}