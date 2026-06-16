import QtQuick
import QtQuick.Controls
import EvHmi

Item {
    id: musicPageRoot
    property int activeTab: 0
    property int mediaSourceTab: 0 // 0 = Local, 1 = Spotify
    property string localSearchQuery: ""

    // Helper property to fetch dynamic theme paths cleanly across all components
    readonly property string iconPathPrefix: "qrc:/assets/icons/" + (Colors.dayNightMode === "day" ? "Light" : "Dark") + "/MusicPage/"

    // =====================================================
    // HARDCODED TRANSLATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "local":            { "en": "Local",            "de": "Lokal",                  "es": "Local" },
        "spotify":          { "en": "Spotify",          "de": "Spotify",                "es": "Spotify" },
        "lyrics":           { "en": "Lyrics",           "de": "Songtext",               "es": "Letras" },
        "media_hub":        { "en": "Media Hub",        "de": "Medien-Hub",             "es": "Centro de Medios" },
        "source_device":    { "en": "Source Device",    "de": "Quellgerät",             "es": "Dispositivo Origen" },
        "switch":           { "en": "Switch",           "de": "Wechseln",               "es": "Cambiar" },
        "track":            { "en": "Track",            "de": "Titel",                  "es": "Pista" },
        "status":           { "en": "Status",           "de": "Status",                 "es": "Estado" },
        "playing":          { "en": "Playing",          "de": "Wird abgespielt",        "es": "Reproduciendo" },
        "paused":           { "en": "Paused",           "de": "Pausiert",               "es": "Pausado" },
        "volume":           { "en": "Volume",           "de": "Lautstärke",             "es": "Volumen" },
        "mute":             { "en": "Mute",             "de": "Stumm",                  "es": "Silenciar" },
        "unmute":           { "en": "Unmute",           "de": "Ton an",                 "es": "No silenciar" },
        "shuffle":          { "en": "Shuffle",          "de": "Zufall",                 "es": "Aleatorio" },
        "repeat":           { "en": "Repeat",           "de": "Wiederholen",            "es": "Repetir" },
        "search_local":     { "en": "Search Local Storage...", "de": "Lokalen Speicher durchsuchen...", "es": "Buscar en almacenamiento local..." },
        "search_spotify":   { "en": "Search Spotify...",       "de": "Spotify durchsuchen...",          "es": "Buscar en Spotify..." },
        "spotify_fallback": { "en": "No matches. Search Spotify instead?", "de": "Keine Treffer. Stattdessen Spotify durchsuchen?", "es": "Sin coincidencias. ¿Buscar en Spotify?" },
        "queue_title":      { "en": "Playback Queue",   "de": "Wiedergabewarteschlange", "es": "Cola de Reproducción" }
    }

    Row {
        anchors.fill: parent
        spacing: Theme.cardGap

        // =====================================================
        // COLUMN 1 – NOW PLAYING (FLUID MULTI-LAYER ARCHITECTURE)
        // =====================================================
        BaseCard {
            width: parent.width * 0.45
            height: parent.height
            title: "" 

            Item {
                anchors.fill: parent

                // Top Media Source Switcher Row Bar
                Row {
                    id: sourceTabsRow
                    width: parent.width
                    height: 44
                    z: 2

                    Repeater {
                        model: ["local", "spotify"]
                        delegate: Rectangle {
                            width: parent.width / 2
                            height: 44
                            color: mediaSourceTab === index ? Colors.surfacePressed : Colors.surfaceRaised
                            
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 3
                                color: Colors.borderActive
                                visible: mediaSourceTab === index
                            }

                            Text {
                                anchors.centerIn: parent
                                text: musicPageRoot.translations[modelData][Typography.currentLanguage]
                                color: mediaSourceTab === index ? Colors.textPrimary : Colors.textMuted
                                font.family: Typography.family
                                font.pixelSize: Typography.labelTab
                                font.bold: mediaSourceTab === index
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: mediaSourceTab = index
                            }
                        }
                    }
                }

                // Main Art Stage Canvas Layout
                Item {
                    anchors.top: sourceTabsRow.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true

                    // Ambient Background Blur Glow Layer
                    Image {
                        id: ambientBackgroundArt
                        anchors.fill: parent
                        source: mediaSourceTab === 1 ? spotifyApi.selectedImageUrl : musicPlayer.albumArtUrl
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0.15 
                        visible: status === Image.Ready
                    }

                    // 1. Day Mode Light Protective Gradient Mask
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height * 0.55
                        z: 1
                        visible: Colors.dayNightMode === "day"
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.4; color: "#CCFFFFFF" }
                            GradientStop { position: 1.0; color: "#FCFFFFFF" } 
                        }
                    }

                    // 2. Night Mode Dark Protective Gradient Mask
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height * 0.55
                        z: 1
                        visible: Colors.dayNightMode !== "day"
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.4; color: "#99000000" }
                            GradientStop { position: 1.0; color: "#F2000000" } 
                        }
                    }

                    // Pure Bottom-Anchored Interactive Content Group
                    Column {
                        id: bottomControlsColumn
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 24 
                        spacing: 16 
                        z: 2

                        // Metadata Overlay
                        Column {
                            id: metadataColumn
                            width: parent.width
                            spacing: 2

                            Text {
                                id: mainTitleText
                                text: mediaSourceTab === 1 ? spotifyApi.selectedTitle : musicPlayer.trackTitle
                                color: Colors.textPrimary 
                                font.family: Typography.family
                                font.pixelSize: Typography.titleLarge
                                font.weight: Font.DemiBold
                                wrapMode: Text.WordWrap
                                width: parent.width

                                Text {
                                    text: parent.text; 
                                    color: "#CC000000"; 
                                    font: parent.font
                                    wrapMode: parent.wrapMode; width: parent.width; x: 1; y: 2; z: -1
                                    visible: Colors.dayNightMode !== "day"
                                }
                            }

                            Text {
                                id: mainArtistText
                                text: mediaSourceTab === 1 ? spotifyApi.selectedArtist : musicPlayer.artistName
                                color: Colors.textSecondary 
                                font.family: Typography.family
                                font.pixelSize: Typography.titleSmall
                                wrapMode: Text.WordWrap
                                width: parent.width

                                Text {
                                    text: parent.text; 
                                    color: "#E6000000"; 
                                    font: parent.font
                                    wrapMode: parent.wrapMode; width: parent.width; x: 1; y: 1; z: -1
                                    visible: Colors.dayNightMode !== "day"
                                }
                            }
                        }

                        // Progress Stream Interface
                        Item {
                            id: progressSectionContainer
                            width: parent.width
                            height: progressSlider.height + 14 

                            Slider {
                                id: progressSlider
                                width: parent.width
                                anchors.top: parent.top
                                from: 0
                                to: musicPlayer.duration
                                value: musicPlayer.position
                                onMoved: musicPlayer.seek(value)

                                background: Rectangle {
                                    x: progressSlider.leftPadding
                                    y: progressSlider.topPadding + (progressSlider.availableHeight - height) / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: progressSlider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: Colors.borderSubtle

                                    Rectangle {
                                        width: progressSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: Colors.borderActive 
                                        radius: 2
                                    }
                                }

                                handle: Rectangle {
                                    x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                                    y: progressSlider.topPadding + (progressSlider.availableHeight - height) / 2
                                    implicitWidth: 200 / 10
                                    implicitHeight: 20
                                    radius: 10
                                    color: "#ffffff"
                                    border.color: Colors.borderActive 
                                    border.width: 2
                                }
                            }

                            Text {
                                id: startTimeText
                                anchors.left: progressSlider.left; anchors.top: progressSlider.bottom; anchors.topMargin: 2
                                text: musicPlayer.currentTime; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall
                            }

                            Text {
                                id: endTimeText
                                anchors.right: progressSlider.right; anchors.top: progressSlider.bottom; anchors.topMargin: 2
                                text: musicPlayer.totalTime; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall
                            }
                        }

                        // Premium Borderless Audio Action Controls
                        Row {
                            id: controlsRow
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 48 

                            Rectangle {
                                width: 52; height: 52; radius: 26; anchors.verticalCenter: parent.verticalCenter
                                color: prevMouse.pressed 
                                    ? (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.08) : Qt.rgba(255,255,255,0.12)) 
                                    : (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.03) : Qt.rgba(255,255,255,0.04))

                                Image {
                                    anchors.centerIn: parent; width: 20; height: 20
                                    source: iconPathPrefix + "previous.png"
                                }
                                MouseArea { id: prevMouse; anchors.fill: parent; onClicked: musicPlayer.previousTrack() }
                            }

                            Rectangle {
                                width: 68; height: 68; radius: 34
                                color: Colors.surfacePressed

                                Image {
                                    anchors.centerIn: parent; width: 26; height: 26
                                    source: musicPlayer.isPlaying
                                        ? (iconPathPrefix + "pause.png")
                                        : (iconPathPrefix + "play.png")
                                }
                                MouseArea { anchors.fill: parent; onClicked: musicPlayer.togglePlayback() }
                            }

                            Rectangle {
                                width: 52; height: 52; radius: 26; anchors.verticalCenter: parent.verticalCenter
                                color: nextMouse.pressed 
                                    ? (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.08) : Qt.rgba(255,255,255,0.12)) 
                                    : (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.03) : Qt.rgba(255,255,255,0.04))

                                Image {
                                    anchors.centerIn: parent; width: 20; height: 20
                                    source: iconPathPrefix + "next.png"
                                }
                                MouseArea { id: nextMouse; anchors.fill: parent; onClicked: musicPlayer.nextTrack() }
                            }
                        }

                        // Subtle Theme-Adaptive Pill Mode Shifters
                        Row {
                            id: shuffleRepeatRow
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 24

                            Rectangle {
                                width: 130; height: 45 ; radius: 18
                                color: musicPlayer.shuffleEnabled 
                                    ? (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.06) : Qt.rgba(255,255,255,0.15)) 
                                    : "transparent"

                                Row {
                                    anchors.centerIn: parent; spacing: 6
                                    Image { width: 14; height: 14; source: iconPathPrefix + "shuffle.png" }
                                    Text { text: musicPageRoot.translations["shuffle"][Typography.currentLanguage]; color: musicPlayer.shuffleEnabled ? Colors.textPrimary : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                                }
                                MouseArea { anchors.fill: parent; onClicked: musicPlayer.toggleShuffle() }
                            }

                            Rectangle {
                                width: 130; height: 45 ; radius: 18
                                color: musicPlayer.repeatEnabled 
                                    ? (Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.06) : Qt.rgba(255,255,255,0.15)) 
                                    : "transparent"

                                Row {
                                    anchors.centerIn: parent; spacing: 6
                                    Image { width: 14; height: 14; source: iconPathPrefix + "repeat.png" }
                                    Text { text: musicPageRoot.translations["repeat"][Typography.currentLanguage]; color: musicPlayer.repeatEnabled ? Colors.textPrimary : Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                                }
                                MouseArea { anchors.fill: parent; onClicked: musicPlayer.toggleRepeat() }
                            }
                        }
                    }

                    // Floating Card Area
                    Item {
                        anchors.top: parent.top
                        anchors.bottom: bottomControlsColumn.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 12

                        Rectangle {
                            id: floatingCardWrapper
                            anchors.centerIn: parent
                            width: Math.min(parent.width * 0.62, parent.height * 0.85) 
                            height: width
                            radius: 16
                            color: Colors.surfaceRaised

                            scale: musicPlayer.isPlaying ? 1.0 : 0.90
                            Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

                            Image {
                                id: albumArt
                                anchors.fill: parent
                                anchors.margins: 1 
                                source: mediaSourceTab === 1 ? spotifyApi.selectedImageUrl : musicPlayer.albumArtUrl
                                fillMode: Image.PreserveAspectCrop
                            } 

                            Rectangle {
                                anchors.fill: parent  
                                color: "transparent"
                                border.width: 2
                                border.color: Colors.borderActive
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: albumArt.status !== Image.Ready
                                text: "♪"
                                color: Colors.accentCity
                                font.family: Typography.family
                                font.pixelSize: 42
                            }
                        }
                    }
                }
            }
        }

        // =====================================================
        // COLUMN 2 – DEDICATED LIVE LYRICS PANEL (.LRC DISPLAY)
        // =====================================================
        BaseCard {
            id: lyricsCard
            width: parent.width * 0.25
            height: parent.height
            title: musicPageRoot.translations["lyrics"][Typography.currentLanguage]
            
            
            

            Column {
                width: parent.width - 32 
                anchors.centerIn: parent
                spacing: 18

                Repeater {
                    model: musicPlayer.visibleLyrics

                    delegate: Text {
                        width: parent.width
                        text: modelData

                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.family: Typography.family

                        // Preserved index 3 mechanical middle node tracking for 7-line model configurations
                        font.pixelSize: index === 3 ? 25 : 20
                        font.bold: index === 3

                        color: index === 3 ? Colors.textPrimary : Colors.textMuted
                        opacity: index === 3 ? 1.0 : 0.4
                        
                        Behavior on font.pixelSize { NumberAnimation { duration: 200 } }
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

        // =====================================================
        // COLUMN 3 – MEDIA HUB (PLAYBACK, SEARCH, QUEUE, WIDGET)
        // =====================================================
        BaseCard {
            width: parent.width * 0.30 - (Theme.cardGap * 2)
            height: parent.height
            title: musicPageRoot.translations["media_hub"][Typography.currentLanguage]
            
            

            Item {
                anchors.fill: parent
                anchors.margins: 10

                // Icon-Only Minimalism Switching Row Bar
                Row {
                    id: hubTabsRow
                    width: parent.width
                    height: 34
                    spacing: 6
                    anchors.top: parent.top

                    Repeater {
                        model: ["Playback", "Search", "Queue"]

                        delegate: Rectangle {
                            width: (parent.width - 12) / 3
                            height: 34
                            radius: 8
                            color: activeTab === index ? Colors.surfacePressed : Colors.surfaceRaised
                            border.width: 1
                            border.color: activeTab === index ? Colors.borderActive : Colors.borderWarm

                            Image {
                                anchors.centerIn: parent
                                width: 22 
                                height: 22
                                source: iconPathPrefix + (modelData === "Playback" ? "playback.png" : modelData === "Search" ? "search.png" : "queue.png")
                            }

                            MouseArea { anchors.fill: parent; onClicked: activeTab = index }
                        }
                    }
                }

                // Dynamic Loader Port
                Loader {
                    id: hubLoader
                    width: parent.width
                    anchors.top: hubTabsRow.bottom
                    anchors.topMargin: 12
                    anchors.bottom: deviceManagerWidget.top
                    anchors.bottomMargin: 12
                    sourceComponent: activeTab === 0 ? playbackTab : activeTab === 1 ? searchTab : queueTab
                }

                // Premium Connection Manager Widget
                Rectangle {
                    id: deviceManagerWidget
                    width: parent.width
                    height: parent.height * 0.22 
                    anchors.bottom: parent.bottom
                    radius: 12
                    
                    color: Colors.dayNightMode === "day" ? Qt.rgba(0, 0, 0, 0.03) : Qt.rgba(255, 255, 255, 0.04)
                    border.width: 1
                    border.color: Colors.dayNightMode === "day" ? Qt.rgba(0, 0, 0, 0.05) : Qt.rgba(255, 255, 255, 0.08)

                    Row {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 12

                        Rectangle {
                            width: 40; height: 40; radius: 20; anchors.verticalCenter: parent.verticalCenter
                            color: Colors.dayNightMode === "day" ? Qt.rgba(0,0,0,0.05) : Qt.rgba(255,255,255,0.08)
                            Text { anchors.centerIn: parent; text: "📱"; font.pixelSize: 18 }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 52 - 90 
                            spacing: 2

                            Text { text: musicPageRoot.translations["source_device"][Typography.currentLanguage]; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                            Text { text: "Pixel 8 Pro"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; font.bold: true; elide: Text.ElideRight; width: parent.width }
                        }

                        Rectangle {
                            id: swapDeviceButton
                            width: 84; height: 32; radius: 16; anchors.verticalCenter: parent.verticalCenter
                            color: swapMouse.pressed ? Colors.surfacePressed : Colors.surfaceRaised
                            border.width: 1; border.color: Colors.borderWarm
                            Text { anchors.centerIn: parent; text: musicPageRoot.translations["switch"][Typography.currentLanguage]; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.bold: true }
                            MouseArea { id: swapMouse; anchors.fill: parent; onClicked: console.log("Device profile change overlay requested") }
                        }
                    }
                }
            }
        }
    }

    // =====================================================
    // ATTACHED EXTENSION MODULE COMPONENT TABS
    // =====================================================
    Component {
        id: playbackTab

        Item {
            anchors.fill: parent

            // 1. Top Section: Track & Playback Status Info
            Column {
                id: topPlaybackDetails
                width: parent.width
                anchors.top: parent.top
                spacing: 8

                Text { text: musicPageRoot.translations["track"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                Text { text: musicPlayer.currentTrackIndex + " / " + musicPlayer.trackCount; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.titleMedium }
                
                Rectangle { width: parent.width; height: 1; color: Colors.borderSubtle }
                
                Text { text: musicPageRoot.translations["status"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                Text { text: musicPlayer.isPlaying ? musicPageRoot.translations["playing"][Typography.currentLanguage] : musicPageRoot.translations["paused"][Typography.currentLanguage]; color: musicPlayer.isPlaying ? Colors.accentEco : Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyLarge }
                
                Rectangle { width: parent.width; height: 1; color: Colors.borderSubtle }
            }

            // 2. Center Section: Volume Layout Grid
            Item {
                id: centerPlaybackDetails
                width: parent.width
                anchors.top: topPlaybackDetails.bottom
                anchors.bottom: bottomPlaybackDetails.top
                anchors.topMargin: 4
                anchors.bottomMargin: 4

                // Left: Icon + Percentage Metrics Block
                Row {
                    id: volumeIndicatorGroup
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Image {
                        width: 22
                        height: 22
                        anchors.verticalCenter: parent.verticalCenter
                        source: musicPlayer.muted ? (iconPathPrefix + "volume-mute.png") : (iconPathPrefix + "volume-loud.png")
                    }

                    Column {
                        spacing: 1
                        anchors.verticalCenter: parent.verticalCenter
                        Text { text: musicPageRoot.translations["volume"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        Text { text: Math.round(musicPlayer.volume) + "%"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyLarge; font.bold: true }
                    }
                }

                // Center: Text-Driven Mute Action Button Box
                Rectangle {
                    id: textMuteButton
                    width: 76
                    height: 34
                    radius: 8
                    anchors.centerIn: parent
                    color: musicPlayer.muted ? Colors.surfacePressed : Colors.surfaceRaised
                    border.width: 1
                    border.color: musicPlayer.muted ? Colors.borderActive : Colors.borderWarm

                    Text {
                        anchors.centerIn: parent
                        text: musicPlayer.muted ? musicPageRoot.translations["unmute"][Typography.currentLanguage] : musicPageRoot.translations["mute"][Typography.currentLanguage]
                        color: Colors.textPrimary
                        font.family: Typography.family
                        font.pixelSize: Typography.bodySmall
                        font.bold: true
                    }

                    MouseArea { anchors.fill: parent; onClicked: musicPlayer.toggleMute() }
                }

                // Right: Premium Vertical Slider + Scale Indicators
                Row {
                    id: trackSliderGroup
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    height: parent.height * 0.85

                    Slider { 
                        id: volumeSlider
                        orientation: Qt.Vertical
                        width: 32
                        height: parent.height
                        from: 0
                        to: 100
                        value: musicPlayer.volume
                        onValueChanged: { musicPlayer.volume = value }

                        background: Rectangle {
                            x: volumeSlider.leftPadding + (volumeSlider.availableWidth - width) / 2
                            y: volumeSlider.topPadding
                            implicitWidth: 4
                            width: implicitWidth
                            height: volumeSlider.availableHeight
                            radius: 2
                            color: Colors.borderSubtle
                            
                            Rectangle {
                                x: 0
                                y: volumeSlider.visualPosition * parent.height
                                width: parent.width
                                height: parent.height - y
                                color: Colors.borderActive
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: volumeSlider.leftPadding + (volumeSlider.availableWidth - width) / 2
                            y: volumeSlider.topPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                            implicitWidth: 20
                            implicitHeight: 20
                            radius: 10
                            color: "#ffffff"
                            border.color: Colors.borderActive
                            border.width: 2
                        }
                    }

                    // Scale Ticks Indicators
                    Item {
                        width: 32
                        height: volumeSlider.height
                        anchors.verticalCenter: parent.verticalCenter

                        // 100% Mark Node
                        Row {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            spacing: 4
                            Rectangle { width: 5; height: 1; color: Colors.textMuted; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "100%"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        }

                        // 50% Mark Node
                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            spacing: 4
                            Rectangle { width: 5; height: 1; color: Colors.textMuted; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "50%"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        }

                        // 0% Mark Node
                        Row {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            spacing: 4
                            Rectangle { width: 5; height: 1; color: Colors.textMuted; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "0%"; color: Colors.textMuted; font.family: Typography.family; font.pixelSize: 9 }
                        }
                    }
                }
            }

            // 3. Bottom Section: Shuffle & Repeat Properties Flag
            Column {
                id: bottomPlaybackDetails
                width: parent.width
                anchors.bottom: parent.bottom
                spacing: 8

                Rectangle { width: parent.width; height: 1; color: Colors.borderSubtle }

                Row {
                    width: parent.width
                    spacing: 0

                    Column {
                        width: parent.width / 2; spacing: 2
                        Text { text: musicPageRoot.translations["shuffle"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        Text { text: musicPlayer.shuffleEnabled ? "ON" : "OFF"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium }
                    }
                    Column {
                        width: parent.width / 2; spacing: 2
                        Text { horizontalAlignment: Text.AlignRight; text: musicPageRoot.translations["repeat"][Typography.currentLanguage]; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall }
                        Text { horizontalAlignment: Text.AlignRight; text: musicPlayer.repeatEnabled ? "ON" : "OFF"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium }
                    }
                }
            }
        }
    }

    Component {
        id: searchTab

        Column {
            id: searchRoot
            property int selectedIndex: -1
            width: parent.width
            spacing: 10

            function getFilteredLocalTracks() {
                var res = [];
                if (localSearchQuery === "") return res;
                
                var allTracks = musicPlayer.getAvailableTracksMatrix();
                var query = localSearchQuery.toLowerCase();
                
                for (var i = 0; i < allTracks.length; i++) {
                    var track = allTracks[i];
                    if (track.title.toLowerCase().indexOf(query) !== -1 || 
                        track.artist.toLowerCase().indexOf(query) !== -1) {
                        
                        res.push({ 
                            "title": track.title, 
                            "artist": track.artist, 
                            "imageUrl": "", 
                            "localIndex": track.localIndex 
                        });
                    }
                }
                return res;
            }

            readonly property var localResults: getFilteredLocalTracks()
            readonly property bool showSpotifyFallback: mediaSourceTab === 0 && localSearchQuery !== "" && localResults.length === 0

            Row {
                width: parent.width
                spacing: 6

                TextField {
                    id: searchField
                    width: parent.width - 46
                    placeholderText: mediaSourceTab === 0 ? musicPageRoot.translations["search_local"][Typography.currentLanguage] : musicPageRoot.translations["search_spotify"][Typography.currentLanguage]
                    onAccepted: {
                        if (text.length > 0) {
                            if (mediaSourceTab === 1) {
                                spotifyApi.searchTracks(text)
                            } else {
                                localSearchQuery = text
                            }
                        }
                    }
                }

                Rectangle {
                    id: searchButton
                    width: 40; height: searchField.height; radius: 6
                    color: searchMouse.pressed ? Colors.surfacePressed : Colors.surfaceRaised
                    border.width: 1; border.color: Colors.borderWarm
                    Image {
                        anchors.centerIn: parent; width: 18; height: 18
                        source: iconPathPrefix + "search.png"
                    }
                    MouseArea {
                        id: searchMouse; anchors.fill: parent
                        onClicked: {
                            if (searchField.text.length > 0) {
                                if (mediaSourceTab === 1) {
                                    spotifyApi.searchTracks(searchField.text)
                                } else {
                                    localSearchQuery = searchField.text
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Colors.borderSubtle }

            Rectangle {
                width: parent.width; height: 44; radius: 6
                visible: searchRoot.showSpotifyFallback
                color: fallbackMouse.pressed ? Colors.surfacePressed : Colors.surfaceRaised
                border.width: 1; border.color: Colors.borderWarm

                Text {
                    anchors.centerIn: parent; text: musicPageRoot.translations["spotify_fallback"][Typography.currentLanguage]
                    color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; font.bold: true
                }
                MouseArea {
                    id: fallbackMouse; anchors.fill: parent
                    onClicked: {
                        mediaSourceTab = 1; 
                        spotifyApi.searchTracks(searchField.text);
                    }
                }
            }

            ListView {
                width: parent.width
                height: searchRoot.showSpotifyFallback ? 196 : 250
                clip: true
                visible: !searchRoot.showSpotifyFallback
                model: mediaSourceTab === 0 ? searchRoot.localResults : spotifyApi.tracks

                delegate: Rectangle {
                    width: ListView.view.width; height: 64; radius: 6
                    color: searchRoot.selectedIndex === index ? Colors.surfacePressed : Colors.surfaceRaised
                    border.width: 1; border.color: Colors.borderWarm

                    Row {
                        anchors.fill: parent; anchors.margins: 8; spacing: 10

                        Rectangle {
                            width: 48; height: 48; radius: 4; color: Colors.surfacePressed
                            visible: mediaSourceTab === 0 || modelData.imageUrl === ""
                            Text { anchors.centerIn: parent; text: "♪"; color: Colors.textSecondary; font.pixelSize: 20 }
                        }

                        Image {
                            width: 48; height: 48; fillMode: Image.PreserveAspectFit
                            source: mediaSourceTab === 1 ? modelData.imageUrl : ""
                            visible: mediaSourceTab === 1 && modelData.imageUrl !== ""
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter; width: parent.width - 60; spacing: 2
                            Text { text: modelData.title; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; elide: Text.ElideRight; width: parent.width }
                            Text { text: modelData.artist; color: Colors.textSecondary; font.family: Typography.family; font.pixelSize: Typography.bodySmall; elide: Text.ElideRight; width: parent.width }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            searchRoot.selectedIndex = index
                            if (mediaSourceTab === 1) {
                                spotifyApi.selectTrack(index)
                            } else {
                                musicPlayer.playTrack(modelData.localIndex)
                            }
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar { }
            }
        }
    }

    Component {
        id: queueTab

        Item {
            anchors.fill: parent

            Text { id: queueTitle; text: musicPageRoot.translations["queue_title"][Typography.currentLanguage]; anchors.top: parent.top; anchors.left: parent.left; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyLarge }
            Rectangle { id: queueDivider; anchors.top: queueTitle.bottom; anchors.topMargin: 8; width: parent.width; height: 1; color: Colors.borderSubtle }

            ListView {
                id: queueList; anchors.top: queueDivider.bottom; anchors.topMargin: 8; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; clip: true; spacing: 4
                model: musicPlayer.playlistTitles

                delegate: Rectangle {
                    width: ListView.view.width; height: 56
                    color: index === musicPlayer.currentTrackIndex - 1 ? Colors.surfacePressed : Colors.surfaceRaised
                    border.width: 0.5; border.color: Colors.borderWarm

                    Row {
                        anchors.fill: parent; anchors.margins: 8; spacing: 10
                        Rectangle {
                            width: 32; height: 32; radius: 4; color: Colors.surfacePressed
                            Text { anchors.centerIn: parent; text: index === musicPlayer.currentTrackIndex - 1 ? "▶" : "♪"; color: Colors.textPrimary; font.family: Typography.family; font.pixelSize: Typography.bodyMedium }
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter; width: parent.width - 60; text: modelData; color: Colors.textPrimary; font.family: Typography.family
                            font.pixelSize: index === musicPlayer.currentTrackIndex - 1 ? Typography.bodyMedium : Typography.bodySmall
                            font.bold: index === musicPlayer.currentTrackIndex - 1; elide: Text.ElideRight
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: musicPlayer.playTrack(index) }
                }
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
            }
        }
    }
}