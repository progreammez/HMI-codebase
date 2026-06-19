pragma Singleton

import QtQuick

Item {
    visible: false

    readonly property string rajdhani: rajdhaniRegular.name

    FontLoader {
        id: rajdhaniRegular
        source: "qrc:/assets/fonts/Rajdhani-SemiBold.ttf"
    }
}