pragma Singleton

import QtQuick

Item {
    visible: false

    readonly property string rajdhaniBold: rajdhaniBold.name
    readonly property string rajdhaniLight: rajdhaniLight.name
    readonly property string rajdhaniMedium: rajdhaniMedium.name
    readonly property string rajdhaniRegular: rajdhaniRegular.name
    readonly property string rajdhaniSemiBold: rajdhaniSemiBold.name
    readonly property string orbitronBlack: orbitronBlack.name
    readonly property string orbitronBold: orbitronBold.name
    readonly property string orbitronExtraBold: orbitronExtraBold.name
    readonly property string orbitronMedium: orbitronMedium.name
    readonly property string orbitronRegular: orbitronRegular.name
    readonly property string orbitronSemiBold: orbitronSemiBold.name

    FontLoader {
        id: rajdhaniBold
        source: "qrc:/assets/fonts/Rajdhani/Rajdhani-Bold.ttf"
    }

    FontLoader {
        id: rajdhaniLight
        source: "qrc:/assets/fonts/Rajdhani/Rajdhani-Light.ttf"
    }

    FontLoader {
        id: rajdhaniMedium
        source: "qrc:/assets/fonts/Rajdhani/Rajdhani-Medium.ttf"
    }

    FontLoader {
        id: rajdhaniRegular
        source: "qrc:/assets/fonts/Rajdhani/Rajdhani-Regular.ttf"
    }   

    FontLoader {
        id: rajdhaniSemiBold
        source: "qrc:/assets/fonts/Rajdhani/Rajdhani-SemiBold.ttf"
    }

    FontLoader {
        id: orbitronBlack
        source: "qrc:/assets/fonts/Orbitron/Orbitron-Black.ttf"
    }

    FontLoader {
        id: orbitronBold
        source: "qrc:/assets/fonts/Orbitron/Orbitron-Bold.ttf"
    }

    FontLoader {
        id: orbitronExtraBold
        source: "qrc:/assets/fonts/Orbitron/Orbitron-ExtraBold.ttf"
    }

    FontLoader {
        id: orbitronMedium
        source: "qrc:/assets/fonts/Orbitron/Orbitron-Medium.ttf"
    }

    FontLoader {
        id: orbitronRegular
        source: "qrc:/assets/fonts/Orbitron/Orbitron-Regular.ttf"
    }

    FontLoader {
        id: orbitronSemiBold
        source: "qrc:/assets/fonts/Orbitron/Orbitron-SemiBold.ttf"
    } 
}