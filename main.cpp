#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>

#include "backend/VehicleData.h"
#include "backend/VirtualVehicle.h"
#include "backend/STMDataSimulator.h"
#include "backend/WarningManager.h"
#include "backend/LocalMusicPlayer.h"
#include "backend/TelemetryParser.h"
#include "backend/SerialManager.h"
#include "backend/TelemetryLogger.h"
#include "backend/SpotifyAPIManager.h"
#include "backend/BluetoothManager.h"
#include "backend/DummyBluetoothManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    VehicleData vehicleData;
    LocalMusicPlayer musicPlayer;
    SerialManager serialManager;
    SpotifyApiManager spotifyApi;

    STMDataSimulator stmSimulator(&vehicleData);
    VirtualVehicle virtualVehicle(&vehicleData);
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

    stmSimulator.start();
    //musicPlayer.play();
    virtualVehicle.start();

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

    #ifdef __aarch64__

    BluetoothManager bluetoothManager;

    engine.rootContext()->setContextProperty(
        "bluetoothManager",
        &bluetoothManager
    );

    #else

    DummyBluetoothManager bluetoothManager;

    engine.rootContext()->setContextProperty(
        "bluetoothManager",
        &bluetoothManager
    );

    #endif
    
    #if QT_VERSION >= QT_VERSION_CHECK(6,5,0)
        engine.loadFromModule("EvHmi", "Main");
    #else
        engine.load(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/EvHmi/qml/Main.qml"));
    #endif

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}