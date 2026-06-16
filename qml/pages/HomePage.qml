import QtQuick
import EvHmi


Item {
    id: root

    anchors.fill: parent

    readonly property real gap: Theme.cardGap

    Column {
        anchors.fill: parent

        spacing: Theme.sectionGap

        // =====================================================
        // TOP ROW
        // =====================================================

        Row {
            width: parent.width
            height: parent.height * 0.56

            spacing: gap

            Loader {
                width: parent.width * 0.55 - (gap / 2)
                height: parent.height
                
                // Adapts automatically to whatever state naming configuration you choose!
                source: (Typography.unitSystem === "metric")
                        ? "../components/home-panels/SpeedometerPanel200.qml" 
                        : "../components/home-panels/SpeedometerPanel120.qml"

                onSourceChanged: console.log("Loading:", source)
                onStatusChanged: {
                    if (status === Loader.Error)
                        console.log("Loader error:", sourceComponent, source)
                }
            }

            BatteryPanel {
                width: parent.width * 0.45 - (gap / 2)
                height: parent.height
            }
        }

        // =====================================================
        // MIDDLE ROW
        // =====================================================

        Row {
            width: parent.width
            height: parent.height * 0.22

            spacing: gap

            VehicleStatusPanel {
                width: parent.width * 0.46
                height: parent.height
            }

            DriveModePanel {
                width: parent.width * 0.25
                height: parent.height
            }

            SystemStatusPanel {
                width: parent.width * 0.29 - (gap * 2)
                height: parent.height
            }
        }

        // =====================================================
        // BOTTOM ROW
        // =====================================================

        DistancePanel {
            width: parent.width

            height:
                parent.height
                - (root.height * 0.56)
                - (root.height * 0.22)
                - (Theme.sectionGap * 2)
        }
    }
}