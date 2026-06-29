import QtQuick
import QtQuick.Layouts
import EvHmi

Item {
    id: commsPage
    anchors.fill: parent

    readonly property int paddingSize: Math.round(10 * Theme.scale)
    readonly property int innerRadius: 4

    // Live Telemetry Math Calculations (Protects against Division by Zero)
    readonly property int totalFrames: vehicleData.framesReceived
    readonly property int goodFrames: Math.max(0, commsPage.totalFrames - vehicleData.invalidFrames - vehicleData.checksumErrors)
    
    readonly property int goodPercent: commsPage.totalFrames > 0 ? Math.round((commsPage.goodFrames / commsPage.totalFrames) * 100) : 0
    readonly property int invalidPercent: commsPage.totalFrames > 0 ? Math.round((vehicleData.invalidFrames / commsPage.totalFrames) * 100) : 0
    readonly property int checksumPercent: commsPage.totalFrames > 0 ? Math.round((vehicleData.checksumErrors / commsPage.totalFrames) * 100) : 0

    // =====================================================
    // LOCALIZATION DICTIONARY
    // =====================================================
    readonly property var translations: {
        "title_status_overview": { "en": "Status Overview",     "de": "Statusübersicht",       "es": "Resumen de Estado" },
        "title_data_rate":       { "en": "Data Rate Monitor",   "de": "Datenraten-Monitor",    "es": "Monitor de Tasa" },
        "title_port_info":       { "en": "Port Information",    "de": "Port-Informationen",    "es": "Información de Puerto" },
        "title_protocol_info":   { "en": "Protocol Information","de": "Protokoll-Info",        "es": "Información de Protocolo" },
        "title_comms_stats":     { "en": "Comms Stats",         "de": "Komms-Statistik",       "es": "Estadísticas Comms" }, // Shortened to fix top-right card squeeze
        "title_conn_details":    { "en": "Conn Details",        "de": "Verbindungsdetails",    "es": "Detalles Conexión" },  // Shortened to prevent header clipping
        "title_frame_quality":   { "en": "Frame Quality",       "de": "Frame-Qualität",        "es": "Calidad de Trama" },
        "title_actions":         { "en": "Actions",             "de": "Aktionen",              "es": "Acciones" },
        
        "connected":             { "en": "CONNECTED",           "de": "VERBUNDEN",             "es": "CONECTADO" },
        "offline":               { "en": "OFFLINE",             "de": "OFFLINE",               "es": "FUERA DE LÍNEA" },
        "active":                { "en": "ACTIVE ●",            "de": "AKTIV ●",               "es": "ACTIVO ●" },
        "error_dot":             { "en": "ERROR ●",             "de": "FEHLER ●",              "es": "ERROR ●" },
        "fault":                 { "en": "● FAULT",             "de": "● FEHLER",              "es": "● FALLO" },
        "ok":                    { "en": "● OK",                "de": "● OK",                  "es": "● OK" },
        "halted":                { "en": "HALTED",              "de": "ANGEHALTEN",            "es": "DETENIDO" },
        "recording":             { "en": "RECORDING",           "de": "AUFZEICHNUNG",          "es": "GRABANDO" },
        "running":               { "en": "RUNNING",             "de": "LÄUFT",                 "es": "EN MARCHA" },
        "disabled":              { "en": "DISABLED",            "de": "DEAKTIVIERT",           "es": "DESACTIVADO" },
        
        "live_source":           { "en": "Live Data Source",    "de": "Live-Datenquelle",      "es": "Fuente de Datos en Vivo" },
        "current_rate":          { "en": "Current: ",           "de": "Aktuell: ",             "es": "Actual: " },
        "bad_badge":             { "en": "BAD",                 "de": "SCHLECHT",              "es": "MALO" },
        "empty_badge":           { "en": "EMPTY",               "de": "LEER",                  "es": "VACÍO" },
        "good_badge":            { "en": "GOOD",                "de": "GUT",                   "es": "BUENO" },

        "label_driver":          { "en": "Driver",              "de": "Treiber",               "es": "Controlador" },
        "label_firmware":        { "en": "Firmware",            "de": "Firmware",              "es": "Firmware" },
        "label_buffer_size":     { "en": "Buffer Size",         "de": "Puffergröße",           "es": "Tam. de Búfer" },
        "label_rx_tx_buffer":    { "en": "Rx / Tx Buffer",      "de": "Rx / Tx Puffer",        "es": "Búfer Rx / Tx" },
        "label_protocol":        { "en": "Protocol",            "de": "Protokoll",             "es": "Protocolo" },
        "label_version":         { "en": "Version",             "de": "Version",               "es": "Versión" },
        "label_msg_count":       { "en": "Message Count",       "de": "Nachrichtenanzahl",     "es": "Conteo Mensajes" },
        "label_proto_status":    { "en": "Protocol Status",     "de": "Protokollstatus",       "es": "Estado Protocolo" },
        "label_telemetry_rate":  { "en": "Telemetry Rate",      "de": "Telemetrierate",        "es": "Tasa Telemetría" },
        "label_frame_interval":  { "en": "Frame Interval",      "de": "Frame-Intervall",       "es": "Interv. Trama" },
        "label_packet_loss":     { "en": "Packet Loss",         "de": "Paketverlust",          "es": "Pérdida Paquetes" },
        "label_frames_recv":     { "en": "Frames Recv",         "de": "Frames empf.",          "es": "Tramas Recib." },
        "label_invalid_frames":  { "en": "Invalid Frames",      "de": "Ungültige Frames",      "es": "Tramas Inválidas" },
        "label_checksum_errors": { "en": "Checksum Errors",     "de": "Prüfsummenfehler",      "es": "Err. Checksum" },
        "label_lost_frames":     { "en": "Lost Frames",         "de": "Verlorene Frames",      "es": "Tramas Perdidas" },
        "label_interface":       { "en": "Interface",           "de": "Schnittstelle",         "es": "Interfaz" },
        "label_baud_rate":       { "en": "Baud Rate",           "de": "Baudrate",              "es": "Tasa Baudios" },
        "label_data_stop":       { "en": "Data / Stop Bits",    "de": "Daten-/Stopp-Bits",     "es": "Bits Datos/Parada" },
        "label_parity_flow":     { "en": "Parity / Flow",       "de": "Parität / Fluss",       "es": "Paridad / Flujo" },
        "label_status":          { "en": "Status",              "de": "Status",                "es": "Estado" },
        "label_uptime":          { "en": "Uptime",              "de": "Betriebszeit",          "es": "Tiempo Activo" },
        
        "action_reset":          { "en": "🔄\nReset Statistics", "de": "🔄\nStatistik zurücks.","es": "🔄\nReiniciar Stats" },
        "action_export":         { "en": "📥\nExport Log",       "de": "📥\nLog exportieren",   "es": "📥\nExportar Log" },
        "action_test":           { "en": "⚡\nTest Connection",  "de": "⚡\nVerbindung testen",  "es": "⚡\nProbar Conexión" }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: commsPage.paddingSize
        spacing: commsPage.paddingSize

        // =====================================================
        // LEFT COLUMN: MAIN DASHBOARD & MONITORING PIPELINE (65%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 650
            spacing: commsPage.paddingSize

            // 1. STATUS OVERVIEW
            BaseCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.verticalStretchFactor: 4
                baseColor: Colors.surfaceRaised
                title: commsPage.translations["title_status_overview"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent
                    spacing: commsPage.paddingSize

                    // Subcard 1: UART
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: Colors.surfaceBase; radius: commsPage.innerRadius; border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 4; spacing: 2
                            Text { text: "🔌 UART"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.communicationFault ? commsPage.translations["offline"][Typography.currentLanguage] : commsPage.translations["connected"][Typography.currentLanguage]
                                font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { text: "/dev/ttyUSB0"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text { text: vehicleData.communicationFault ? "0 bps" : "115200 bps"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    // Subcard 2: PARSER
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: Colors.surfaceBase; radius: commsPage.innerRadius; border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 4; spacing: 2
                            Text { text: "</> PARSER"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.communicationFault ? commsPage.translations["error_dot"][Typography.currentLanguage] : commsPage.translations["active"][Typography.currentLanguage]
                                font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { text: "Protocol: EV_CAN_V1"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.communicationFault ? commsPage.translations["fault"][Typography.currentLanguage] : commsPage.translations["ok"][Typography.currentLanguage]
                                font.family: Typography.family; font.pixelSize: Typography.bodySmall
                                color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    // Subcard 3: LOGGER
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: Colors.surfaceBase; radius: commsPage.innerRadius; border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 4; spacing: 2
                            Text { text: "📄 LOGGER"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.communicationFault ? commsPage.translations["halted"][Typography.currentLanguage] : commsPage.translations["recording"][Typography.currentLanguage]
                                font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyLarge
                                color: vehicleData.communicationFault ? Colors.textMuted : Colors.accentEco
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { text: "File: log_2026_06_21.csv"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text { text: "● 12.4 MB"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    // Subcard 4: SIMULATOR
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: Colors.surfaceBase; radius: commsPage.innerRadius; border.color: Colors.borderSubtle
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 4; spacing: 2
                            Text { text: "📦 SIMULATOR"; font.family: Typography.family; font.pixelSize: Typography.label; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.simulationActive ? commsPage.translations["running"][Typography.currentLanguage] : commsPage.translations["disabled"][Typography.currentLanguage]
                                font.family: Typography.family; font.weight: Font.Bold; font.pixelSize: Typography.bodyLarge
                                color: vehicleData.simulationActive ? Colors.accentEco : Colors.textMuted
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                            Text { text: commsPage.translations["live_source"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter }
                            Text {
                                text: vehicleData.simulationActive ? commsPage.translations["ok"][Typography.currentLanguage] : "● OFF"
                                font.family: Typography.family; font.pixelSize: Typography.bodySmall
                                color: vehicleData.simulationActive ? Colors.accentEco : Colors.textMuted
                                Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
            }

            // 2. DATA RATE MONITOR
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 11
                baseColor: Colors.surfaceRaised
                title: commsPage.translations["title_data_rate"][Typography.currentLanguage]

                Text {
                    text: commsPage.translations["current_rate"][Typography.currentLanguage] + (vehicleData.communicationFault ? "0 Hz" : "50 Hz")
                    color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity
                    font.family: Typography.family; font.pixelSize: Typography.bodySmall
                    anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: -22
                }

                Item {
                    anchors.fill: parent
                    Canvas {
                        id: waveCanvas; anchors.fill: parent; anchors.bottomMargin: 20
                        Connections {
                            target: vehicleData
                            function onCommunicationFaultChanged() { waveCanvas.requestPaint() }
                        }
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = vehicleData.communicationFault ? Colors.borderSubtle : Colors.accentCity
                            ctx.lineWidth = 1.5; ctx.beginPath()
                            if (vehicleData.communicationFault) {
                                ctx.moveTo(0, height - 5); ctx.lineTo(width, height - 5)
                            } else {
                                ctx.moveTo(0, height * 0.4)
                                for(var x = 0; x <= width; x += 15) {
                                    var y = (height * 0.4) + (Math.sin(x / 12) * 5) + (Math.random() * 3 - 1.5)
                                    ctx.lineTo(x, y)
                                }
                            }
                            ctx.stroke()
                        }
                    }

                    RowLayout {
                        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                        Text { text: "60s ago"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "45s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "30s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "15s"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: "Now"; font.family: Typography.family; font.pixelSize: Typography.bodySmall; color: Colors.textMuted }
                    }
                }
            }

            // 3. LOWER METADATA FIELDS
            RowLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 5
                spacing: commsPage.paddingSize

                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    title: commsPage.translations["title_port_info"][Typography.currentLanguage]
                    ColumnLayout {
                        anchors.fill: parent; spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_driver"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "FTDI USB Serial"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_firmware"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "v2.12.36"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_buffer_size"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "4096 bytes"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_rx_tx_buffer"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "0% / 0%"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.alignment: Qt.AlignRight }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    title: commsPage.translations["title_protocol_info"][Typography.currentLanguage]
                    ColumnLayout {
                        anchors.fill: parent; spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_protocol"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "EV_CAN_V1"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_version"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "1.0.3"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_msg_count"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "36"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_proto_status"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.communicationFault ? "FAULT" : "OK"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco; font.bold: true; Layout.alignment: Qt.AlignRight }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }

        // =====================================================
        // RIGHT COLUMN: METRICS SIDEBAR & QUICK ACTION PANEL (35%)
        // =====================================================
        ColumnLayout {
            Layout.fillWidth: true; Layout.fillHeight: true
            Layout.preferredWidth: 350
            spacing: commsPage.paddingSize

            // 1. STATS TWIN PAIR
            RowLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 9
                spacing: commsPage.paddingSize

                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    title: commsPage.translations["title_comms_stats"][Typography.currentLanguage]
                    ColumnLayout {
                        anchors.fill: parent; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_telemetry_rate"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.communicationFault ? "0 Hz" : "50 Hz"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_frame_interval"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.communicationFault ? "--" : "20 ms"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_packet_loss"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.communicationFault ? "100 %" : "0 %"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco; font.bold: true; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_frames_recv"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.framesReceived; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_invalid_frames"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.invalidFrames; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_checksum_errors"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.checksumErrors; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.alignment: Qt.AlignRight }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                BaseCard {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    title: commsPage.translations["title_conn_details"][Typography.currentLanguage]
                    ColumnLayout {
                        anchors.fill: parent; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_interface"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "UART"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; font.bold: true; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_baud_rate"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "115200"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_data_stop"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "8 / 1"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_parity_flow"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "None"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_status"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.communicationFault ? commsPage.translations["offline"][Typography.currentLanguage] : commsPage.translations["connected"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: vehicleData.communicationFault ? Colors.critical : Colors.accentEco; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: commsPage.translations["label_uptime"][Typography.currentLanguage]; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "02:14:37"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentCity; Layout.alignment: Qt.AlignRight }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // 2. FRAME QUALITY COMPONENT
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 7
                title: commsPage.translations["title_frame_quality"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: 16

                    Rectangle {
                        id: progressRing; width: 64; height: 64; radius: 32; color: "transparent"
                        border.color: vehicleData.communicationFault ? Colors.critical : (commsPage.totalFrames === 0 ? Colors.borderSubtle : Colors.accentEco)
                        border.width: 4; Layout.alignment: Qt.AlignVCenter
                        Text {
                            text: vehicleData.communicationFault ? "0%\n" + commsPage.translations["bad_badge"][Typography.currentLanguage] : (commsPage.totalFrames === 0 ? "0%\n" + commsPage.translations["empty_badge"][Typography.currentLanguage] : commsPage.goodPercent + "%\n" + commsPage.translations["good_badge"][Typography.currentLanguage])
                            font.family: Typography.family; font.bold: true; font.pixelSize: Typography.bodySmall; color: Colors.textPrimary
                            anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    ColumnLayout {
                        spacing: 2; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "● Good Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.accentEco; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: commsPage.goodFrames + " (" + commsPage.goodPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "● Invalid Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: "orange"; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.invalidFrames + " (" + commsPage.invalidPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "● Checksum Errors"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.critical; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: vehicleData.checksumErrors + " (" + commsPage.checksumPercent + "%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.alignment: Qt.AlignRight }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "● Lost Frames"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: "purple"; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "0 (0%)"; font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textMuted; Layout.alignment: Qt.AlignRight }
                        }
                    }
                }
            }

            // 3. ACTIONS PANEL WITH INTERACTIVE BUTTONS
            BaseCard {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.verticalStretchFactor: 4
                title: commsPage.translations["title_actions"][Typography.currentLanguage]

                RowLayout {
                    anchors.fill: parent; spacing: commsPage.paddingSize

                    BaseCard {
                        Layout.fillWidth: true; Layout.fillHeight: true; interactive: !vehicleData.communicationFault; baseColor: Colors.surfaceBase; title: ""
                        Text {
                            text: commsPage.translations["action_reset"][Typography.currentLanguage]
                            font.family: Typography.family; font.pixelSize: Typography.bodyMedium
                            color: vehicleData.communicationFault ? Colors.textMuted : Colors.textPrimary
                            anchors.fill: parent; anchors.margins: 2; elide: Text.ElideRight; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onTapped: vehicleData.resetStatistics()
                    }

                    BaseCard {
                        Layout.fillWidth: true; Layout.fillHeight: true; interactive: true; baseColor: Colors.surfaceBase; title: ""
                        Text {
                            text: commsPage.translations["action_export"][Typography.currentLanguage]
                            font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary
                            anchors.fill: parent; anchors.margins: 2; elide: Text.ElideRight; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onTapped: vehicleData.exportLog()
                    }

                    BaseCard {
                        Layout.fillWidth: true; Layout.fillHeight: true; interactive: true; baseColor: Colors.surfaceBase; title: ""
                        Text {
                            text: commsPage.translations["action_test"][Typography.currentLanguage]
                            font.family: Typography.family; font.pixelSize: Typography.bodyMedium; color: Colors.textPrimary
                            anchors.fill: parent; anchors.margins: 2; elide: Text.ElideRight; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        onTapped: vehicleData.testConnection()
                    }
                }
            }
        }
    }
}