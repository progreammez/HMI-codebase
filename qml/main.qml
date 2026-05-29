import QtQuick
import QtQuick.Window

Window {
    visible: true

    width: 800
    height: 480

    title: "EV HMI"

    Rectangle {
        width: 50
        height: 50

        color:
            vehicleData.leftIndicator
            ? "green"
            : "gray"
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: "Speed: " + vehicleData.speed
        }

        Text {
            text: "RPM: " + vehicleData.rpm
        }

        Text {
            text: "Battery: " + vehicleData.batteryPercent + "%"
        }

        Text {
            text: "Motor Temp: " + vehicleData.motorTemp + "°C"
        }

        Text {
            text: "Mode: " + vehicleData.driveMode
        }
        Text {
            text: vehicleData.gearState
        }

        Text {
            text: vehicleData.warningMessage
        }

        Text {
            text: "Right Indicator: " + vehicleData.rightIndicator
        }

        Text {
            text: "Headlights: " + vehicleData.headlights
        }
    }
}