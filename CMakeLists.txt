cmake_minimum_required(VERSION 3.16)

project(EV_HMI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick SerialPort Multimedia Network)

qt_standard_project_setup()

qt_add_executable(EV_HMI
    main.cpp

    backend/VehicleData.cpp
    backend/TelemetrySimulator.cpp
    backend/WarningManager.cpp
    backend/LocalMusicPlayer.cpp
    backend/TelemetryParser.cpp
    backend/SerialManager.cpp
    backend/TelemetryLogger.cpp
    backend/SpotifyAPIManager.cpp
)

target_include_directories(EV_HMI PRIVATE
    backend
)

set_source_files_properties(
    qml/themes/Colors.qml
    qml/themes/Typography.qml
    qml/themes/Theme.qml
    qml/themes/Fonts.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(EV_HMI
    URI EvHmi
    VERSION 1.0

    QML_FILES
        qml/Main.qml
        qml/AppShell.qml

        qml/components/BaseCard.qml
        qml/components/CockpitFrame.qml
        qml/components/EnergyBar.qml
        qml/components/MetricTile.qml
        qml/components/ModeButton.qml
        qml/components/BatteryGraphic.qml
        qml/components/PowertrainIcon.qml
        qml/components/ThermalIcon.qml


        qml/components/home-panels/DistancePanel.qml
        qml/components/home-panels/SpeedometerPanel.qml
        qml/components/home-panels/DriveModePanel.qml
        qml/components/home-panels/VehicleStatusPanel.qml
        qml/components/home-panels/SystemStatusPanel.qml
        qml/components/home-panels/BatteryPanel.qml

        qml/pages/HomePage.qml
        qml/pages/MusicPage.qml
        qml/pages/SettingsPage.qml
        qml/pages/DiagnosticsPage.qml

        qml/themes/Colors.qml
        qml/themes/Typography.qml
        qml/themes/Theme.qml
        qml/themes/Fonts.qml
)

qt_add_resources(EV_HMI "assets"
    PREFIX "/"

    FILES
        assets/music/placeholder/default_cover.png
    #Dark Theme
        #Universal
        assets/icons/Dark/Universal/home-main.png
        assets/icons/Dark/Universal/music-main.png
        assets/icons/Dark/Universal/diagnostics-main.png
        assets/icons/Dark/Universal/settings-main.png

        #Home Page
        assets/icons/Dark/HomePage/battery.png
        assets/icons/Dark/HomePage/batterytemp.png
        assets/icons/Dark/HomePage/caution-lights-off.png
        assets/icons/Dark/HomePage/caution-lights-on.png
        assets/icons/Dark/HomePage/handbrake-light-off.png
        assets/icons/Dark/HomePage/handbrake-light-on.png
        assets/icons/Dark/HomePage/high-beam.png
        assets/icons/Dark/HomePage/low-beam.png
        assets/icons/Dark/HomePage/left-indicator-off.png
        assets/icons/Dark/HomePage/left-indicator-on.png
        assets/icons/Dark/HomePage/range.png
        assets/icons/Dark/HomePage/right-indicator-off.png
        assets/icons/Dark/HomePage/right-indicator-on.png
        assets/icons/Dark/HomePage/speedometer.png

        #Music Page
        assets/icons/Dark/MusicPage/play.png
        assets/icons/Dark/MusicPage/pause.png
        assets/icons/Dark/MusicPage/previous.png
        assets/icons/Dark/MusicPage/next.png
        assets/icons/Dark/MusicPage/shuffle.png
        assets/icons/Dark/MusicPage/repeat.png 
        assets/icons/Dark/MusicPage/volume-loud.png
        assets/icons/Dark/MusicPage/volume-mute.png
        assets/icons/Dark/MusicPage/search.png
        assets/icons/Dark/MusicPage/queue.png
        assets/icons/Dark/MusicPage/lyrics.png
        assets/icons/Dark/MusicPage/playback.png

        #Settings Page
        assets/icons/Dark/SettingsPage/Tabs/display-tab.png
        assets/icons/Dark/SettingsPage/Tabs/modes-tab.png
        assets/icons/Dark/SettingsPage/Tabs/sound-tab.png
        assets/icons/Dark/SettingsPage/Tabs/settings-tab.png
        assets/icons/Dark/SettingsPage/Tabs/system-tab.png

        assets/icons/Dark/SettingsPage/brightness.png
        assets/icons/Dark/SettingsPage/contrast.png
        assets/icons/Dark/SettingsPage/language.png
        assets/icons/Dark/SettingsPage/units.png
        assets/icons/Dark/SettingsPage/theme.png
        assets/icons/Dark/SettingsPage/drive-mode.png
        assets/icons/Dark/SettingsPage/day-night-mode.png
        assets/icons/Dark/SettingsPage/alert-vol.png
        assets/icons/Dark/SettingsPage/indicator-vol.png
        assets/icons/Dark/SettingsPage/clock-format.png
        assets/icons/Dark/SettingsPage/date-format.png
        assets/icons/Dark/SettingsPage/restart.png
        assets/icons/Dark/SettingsPage/about.png

    #Light Theme
        #Universal
        assets/icons/Light/Universal/home-main.png
        assets/icons/Light/Universal/music-main.png
        assets/icons/Light/Universal/diagnostics-main.png
        assets/icons/Light/Universal/settings-main.png

        #Home Page
        assets/icons/Light/HomePage/battery.png
        assets/icons/Light/HomePage/batterytemp.png
        assets/icons/Light/HomePage/caution-lights-off.png
        assets/icons/Light/HomePage/caution-lights-on.png
        assets/icons/Light/HomePage/handbrake-light-off.png
        assets/icons/Light/HomePage/handbrake-light-on.png
        assets/icons/Light/HomePage/high-beam.png
        assets/icons/Light/HomePage/low-beam.png
        assets/icons/Light/HomePage/left-indicator-off.png
        assets/icons/Light/HomePage/left-indicator-on.png
        assets/icons/Light/HomePage/range.png
        assets/icons/Light/HomePage/right-indicator-off.png
        assets/icons/Light/HomePage/right-indicator-on.png
        assets/icons/Light/HomePage/speedometer.png
        
        #Music Page
        assets/icons/Light/MusicPage/play.png
        assets/icons/Light/MusicPage/pause.png
        assets/icons/Light/MusicPage/previous.png
        assets/icons/Light/MusicPage/next.png
        assets/icons/Light/MusicPage/shuffle.png
        assets/icons/Light/MusicPage/repeat.png 
        assets/icons/Light/MusicPage/volume-loud.png
        assets/icons/Light/MusicPage/volume-mute.png
        assets/icons/Light/MusicPage/search.png
        assets/icons/Light/MusicPage/queue.png
        assets/icons/Light/MusicPage/lyrics.png
        assets/icons/Light/MusicPage/playback.png

        #Settings Page
        assets/icons/Light/SettingsPage/Tabs/display-tab.png
        assets/icons/Light/SettingsPage/Tabs/modes-tab.png
        assets/icons/Light/SettingsPage/Tabs/sound-tab.png
        assets/icons/Light/SettingsPage/Tabs/settings-tab.png
        assets/icons/Light/SettingsPage/Tabs/system-tab.png

        assets/icons/Light/SettingsPage/brightness.png
        assets/icons/Light/SettingsPage/contrast.png
        assets/icons/Light/SettingsPage/language.png
        assets/icons/Light/SettingsPage/units.png
        assets/icons/Light/SettingsPage/theme.png
        assets/icons/Light/SettingsPage/drive-mode.png
        assets/icons/Light/SettingsPage/day-night-mode.png
        assets/icons/Light/SettingsPage/alert-vol.png
        assets/icons/Light/SettingsPage/indicator-vol.png
        assets/icons/Light/SettingsPage/clock-format.png
        assets/icons/Light/SettingsPage/date-format.png
        assets/icons/Light/SettingsPage/restart.png
        assets/icons/Light/SettingsPage/about.png

    # Fonts
        assets/fonts/Rajdhani-Regular.ttf
        assets/fonts/Rajdhani-Medium.ttf
        assets/fonts/Rajdhani-Bold.ttf
        assets/fonts/Rajdhani-Light.ttf
        assets/fonts/Rajdhani-SemiBold.ttf

)

target_link_libraries(EV_HMI
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::SerialPort
        Qt6::Multimedia
        Qt6::Network
)
