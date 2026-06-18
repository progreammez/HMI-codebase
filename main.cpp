#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>

#include "backend/VehicleData.h"
#include "backend/TelemetrySimulator.h"
#include "backend/WarningManager.h"
#include "backend/LocalMusicPlayer.h"
#include "backend/TelemetryParser.h"
#include "backend/SerialManager.h"
#include "backend/TelemetryLogger.h"
#include "backend/SpotifyAPIManager.h"
#include "backend/BluetoothManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    VehicleData vehicleData;
    LocalMusicPlayer musicPlayer;
    SerialManager serialManager;
    SpotifyApiManager spotifyApi;
    BluetoothManager bluetoothManager;

    TelemetrySimulator simulator(&vehicleData);
    TelemetryLogger telemetryLogger(&vehicleData);
    WarningManager warningManager(&vehicleData, &telemetryLogger);
    TelemetryParser parser(&vehicleData);
    if (!serialManager.connectPort("/dev/ttyACM0"))
        {
            qDebug() << "Failed to open STM serial port";
        }
    else
        {
            qDebug() << "STM serial port connected";
        }

    // Low battery warning test
    // QTimer::singleShot(
    //     5000,
    //     [&]()
    //     {
    //         parser.parsePacket(
    //             "SPD=75,"
    //             "RPM=3200,"
    //             "BAT=15,"
    //             "RNG=160,"
    //             "MT=45,"
    //             "BT=35,"
    //             "MODE=SPORT,"
    //             "GEAR=D"
    //         );
    //     }
    // );

    // // High motor temp warning test
    // QTimer::singleShot(
    //     10000,
    //     [&]()
    //     {
    //         parser.parsePacket(
    //             "SPD=75,"
    //             "RPM=3200,"
    //             "BAT=88,"
    //             "RNG=160,"
    //             "MT=70,"
    //             "BT=35,"
    //             "MODE=SPORT,"
    //             "GEAR=D"
    //         );
    //     }
    // );

    // // High battery temp warning test
    // QTimer::singleShot(
    //     15000,
    //     [&]()
    //     {
    //         parser.parsePacket(
    //             "SPD=75,"
    //             "RPM=3200,"
    //             "BAT=88,"
    //             "RNG=160,"
    //             "MT=45,"
    //             "BT=70,"
    //             "MODE=SPORT,"
    //             "GEAR=D"
    //         );
    //     }
    // );

    // CONNECTS GO HERE
    QObject::connect(
    &vehicleData,
    &VehicleData::batteryPercentChanged,
    &warningManager,
    &WarningManager::evaluateWarnings
    );

    QObject::connect(
        &vehicleData,
        &VehicleData::motorTempChanged,
        &warningManager,
        &WarningManager::evaluateWarnings
    );

    QObject::connect(
        &vehicleData,
        &VehicleData::batteryTempChanged,
        &warningManager,
        &WarningManager::evaluateWarnings
    );

    QObject::connect(
        &serialManager,
        &SerialManager::packetReceived,
        &parser,
        &TelemetryParser::parsePacket
    );
    
    QObject::connect(
        &serialManager,
        &SerialManager::packetReceived,
        [](const QString &packet)
        {
            qDebug() << "STM:" << packet;
        }
    );

    simulator.start();
    //musicPlayer.play();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(
        "vehicleData",
        &vehicleData
    );

    engine.rootContext()->setContextProperty(
        "musicPlayer",
        &musicPlayer
    );

    engine.rootContext()->setContextProperty(
        "spotifyApi",
        &spotifyApi);

    engine.rootContext()->setContextProperty(
        "telemetryLogger",
        &telemetryLogger
    );
    engine.rootContext()->setContextProperty(
        "bluetoothManager",
        &bluetoothManager
    );
    
    #if QT_VERSION >= QT_VERSION_CHECK(6,5,0)
        engine.loadFromModule("EvHmi", "Main");
    #else
        engine.load(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/EvHmi/qml/Main.qml"));
    #endif

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}