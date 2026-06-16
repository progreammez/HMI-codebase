import QtQuick
import EvHmi

BaseCard {
    id: root

    // FIXED: Dynamically switches card title based on global language selection
    title: root.translations["title"][Typography.currentLanguage]

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title":      { "en": "System Status", "de": "Systemstatus",      "es": "Estado del Sistema" },
        "battery":    { "en": "Battery",       "de": "Batterie",          "es": "Batería" },
        "motor":      { "en": "Motor",         "de": "Motor",             "es": "Motor" },
        "controller": { "en": "Controller",    "de": "Steuergerät",       "es": "Controlador" },
        "tires":      { "en": "Tires",         "de": "Reifen",            "es": "Neumáticos" },
        "ok":         { "en": "OK",            "de": "OK",                "es": "OK" },
        "fault":      { "en": "FAULT",         "de": "FEHLER",            "es": "FALLO" }
    }

    // Unified 2x2 layout wrapper centered vertically inside the panel card
    Grid {
        id: statusGrid
        
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 16 * Theme.scale
        anchors.rightMargin: 16 * Theme.scale
        anchors.verticalCenter: parent.verticalCenter
        
        columns: 2
        columnSpacing: 12 * Theme.scale 
        rowSpacing: 10 * Theme.scale

        Repeater {
            // FIXED: Modified the string layout definitions into dictionary element keys to map correctly
            model: [
                {
                    labelKey: "battery",
                    ok: (typeof vehicleData.batteryOverTempWarning !== 'undefined') ? !vehicleData.batteryOverTempWarning : true
                },
                {
                    labelKey: "motor",
                    ok: (typeof vehicleData.motorOverTempWarning !== 'undefined') ? !vehicleData.motorOverTempWarning : true
                },
                {
                    labelKey: "controller",
                    ok: (typeof vehicleData.communicationFault !== 'undefined') ? !vehicleData.communicationFault : true
                },
                {
                    labelKey: "tires",
                    ok: (typeof vehicleData.lowBatteryWarning !== 'undefined') ? !vehicleData.lowBatteryWarning : true
                }
            ]

            // Premium widget capsule container row adapted for a two-column distribution landscape
            Rectangle {
                width: (statusGrid.width - statusGrid.columnSpacing) / 2
                height: 36 * Theme.scale
                radius: 6 * Theme.scale
                color: Qt.rgba(1, 1, 1, 0.03) 

                // Label Text (Left-Aligned)
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter

                    text: root.translations[modelData.labelKey][Typography.currentLanguage]
                    color: Colors.textSecondary
                    font.family: Typography.family
                    font.pixelSize: Typography.bodyMedium
                }

                // Status Group: Dot indicator + Status string (Right-Aligned)
                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * Theme.scale
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8 * Theme.scale

                    // Status Glow Dot Indicator
                    Rectangle {
                        width: 8 * Theme.scale
                        height: width
                        radius: width / 2
                        anchors.verticalCenter: parent.verticalCenter

                        color: modelData.ok ? Colors.accentEco : Colors.critical
                    }

                    // Dynamic Status Text Readout
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.ok ? root.translations["ok"][Typography.currentLanguage] : root.translations["fault"][Typography.currentLanguage]
                        color: modelData.ok ? Colors.accentEco : Colors.critical

                        font.family: Typography.family
                        font.pixelSize: Typography.bodyMedium
                        font.bold: true
                    }
                }
            }
        }
    }
}