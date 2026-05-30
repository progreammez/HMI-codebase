cmake_minimum_required(VERSION 3.16)

project(EV_HMI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup()

qt_add_executable(EV_HMI
    main.cpp

    backend/VehicleData.cpp
    backend/TelemetrySimulator.cpp
    backend/WarningManager.cpp
    backend/LocalMusicPlayer.cpp
    
)

target_include_directories(EV_HMI PRIVATE
    backend
)

set_source_files_properties(
    qml/themes/Colors.qml
    qml/themes/Typography.qml
    qml/themes/Theme.qml
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
        qml/pages/HomePage.qml
        qml/pages/MusicPage.qml
        qml/pages/SettingsPage.qml
        qml/pages/DiagnosticsPage.qml
        qml/themes/Colors.qml
        qml/themes/Typography.qml
        qml/themes/Theme.qml
)

target_link_libraries(EV_HMI 
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Multimedia
)