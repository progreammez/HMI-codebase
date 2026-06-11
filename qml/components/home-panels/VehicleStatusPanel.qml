import QtQuick
import EvHmi

BaseCard {
    id: root

    title: "VEHICLE STATUS"

    readonly property var gearsModel: ["P", "R", "N", "D"]
    readonly property string iconSetPath: "qrc:/assets/icons/" + (Colors.dayNightMode === "day" ? "Light" : "Dark") + "/HomePage/"

    // Master container switched to Item for absolute anchor positioning control
    Item {
        anchors.fill: parent
        anchors.margins: 20 * Theme.scale

        // =====================================================
        // 1. PRND UNIFIED SLIDER TRACK
        // =====================================================
        Rectangle {
            id: prndSliderContainer
            
            width: Math.round(180 * Theme.scale)
            height: Math.round(44 * Theme.scale)
            radius: Theme.controlRadius
            
            // Anchored strictly to the left wall
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            
            color: Colors.surfaceSunken
            border.width: 1
            border.color: Qt.rgba(Colors.borderSubtle.r, Colors.borderSubtle.g, Colors.borderSubtle.b, 0.3)

            Row {
                anchors.fill: parent
                padding: 4 * Theme.scale
                spacing: 4 * Theme.scale

                Repeater {
                    model: root.gearsModel

                    Rectangle {
                        width: (parent.width - (parent.padding * 2) - (parent.spacing * 3)) / 4
                        height: parent.height - (parent.padding * 2) 
                        anchors.verticalCenter: parent.verticalCenter
                        radius: Theme.controlRadius - 2

                        readonly property bool isSelected: vehicleData.gearState === modelData

                        color: isSelected
                               ? Qt.rgba(Colors.borderActive.r, Colors.borderActive.g, Colors.borderActive.b, 0.15)
                               : "transparent"

                        border.width: isSelected ? 1.5 : 0
                        border.color: isSelected ? Colors.borderActive : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: isSelected ? Colors.borderActive : Colors.textMuted
                            font.family: Typography.family
                            font.pixelSize: Typography.bodyMedium
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                vehicleData.gearState = modelData
                            }
                        }
                    }
                }
            }
        }

        // =====================================================
        // 2. VISUAL VERTICAL DIVIDER LINE
        // =====================================================
        Rectangle {
            id: verticalVisualDivider

            width: 2 
            height: Math.round(54 * Theme.scale)
            
            anchors.left: prndSliderContainer.right
            anchors.leftMargin: 26 * Theme.scale 
            anchors.verticalCenter: parent.verticalCenter
            
            color: Colors.borderSubtle
            opacity: 0.85
        }

        // =====================================================
        // 3. THEME-REFLECTIVE INDICATORS CONTAINER
        // =====================================================
        Item {
            id: iconsContainer
            
            anchors.left: verticalVisualDivider.right
            // FIXED: Explicitly pushes the icons away from the divider so it doesn't crowd the "Left" sign
            anchors.leftMargin: 20 * Theme.scale 
            anchors.right: parent.right
            
            anchors.verticalCenter: parent.verticalCenter
            // FIXED: Drops the entire icon block down by 6px to correct the Y-Axis misalignment against the PRND text
            anchors.verticalCenterOffset: 6 * Theme.scale 
            
            height: parent.height

            Row {
                anchors.fill: parent

                // 1. LEFT TURN SIGNAL
                Item {
                    // FIXED: Claims exactly 20% of the remaining area to guarantee perfect spacing
                    width: parent.width / 5
                    height: parent.height
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6 * Theme.scale

                        Image {
                            source: root.iconSetPath + (vehicleData.leftIndicator ? "left-indicator-on.png" : "left-indicator-off.png")
                            width: 30 * Theme.scale
                            height: 30 * Theme.scale
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Left"
                            color: Colors.textSecondary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // 2. HEADLIGHT BEAM
                Item {
                    width: parent.width / 5
                    height: parent.height
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6 * Theme.scale

                        Image {
                            source: root.iconSetPath + (vehicleData.highBeam ? "high-beam.png" : "low-beam.png")
                            width: 30 * Theme.scale
                            height: 30 * Theme.scale
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true
                            opacity: vehicleData.headlights ? 1.0 : 0.3
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Beam"
                            color: Colors.textSecondary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // 3. HAZARD WARNING TRIANGLE
                Item {
                    width: parent.width / 5
                    height: parent.height
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6 * Theme.scale

                        Image {
                            source: root.iconSetPath + (vehicleData.hazardLights ? "caution-lights-on.png" : "caution-lights-off.png")
                            width: 30 * Theme.scale
                            height: 30 * Theme.scale
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Hazard"
                            color: Colors.textSecondary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // 4. HANDBRAKE / BRAKE STATUS
                Item {
                    width: parent.width / 5
                    height: parent.height
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6 * Theme.scale

                        Image {
                            source: root.iconSetPath + (vehicleData.handbrakeEngaged ? "handbrake-light-on.png" : "handbrake-light-off.png")
                            width: 30 * Theme.scale
                            height: 30 * Theme.scale
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Brake"
                            color: Colors.textSecondary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // 5. RIGHT TURN SIGNAL
                Item {
                    width: parent.width / 5
                    height: parent.height
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6 * Theme.scale

                        Image {
                            source: root.iconSetPath + (vehicleData.rightIndicator ? "right-indicator-on.png" : "right-indicator-off.png")
                            width: 30 * Theme.scale
                            height: 30 * Theme.scale
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Right"
                            color: Colors.textSecondary
                            font.family: Typography.family
                            font.pixelSize: Typography.bodySmall - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}