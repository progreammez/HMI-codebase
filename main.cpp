#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QQuickWindow>

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
#include "backend/DriverInput.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    VehicleData vehicleData;
    LocalMusicPlayer musicPlayer;
    SerialManager serialManager;
    SpotifyApiManager spotifyApi;
    DriverInput driverInput;

    app.installEventFilter(&driverInput);

    STMDataSimulator stmSimulator(&vehicleData);
    VirtualVehicle virtualVehicle(&vehicleData, &driverInput, &stmSimulator);
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

    QObject::connect(&driverInput,
        &DriverInput::acceleratePressed,
        &virtualVehicle,
        &VirtualVehicle::setAccelerating
    );

    QObject::connect(
        &driverInput,
        &DriverInput::brakePressed,
        &virtualVehicle,
        &VirtualVehicle::setBraking
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::gearChanged,
        &virtualVehicle,
        &VirtualVehicle::setGear
    );

    QObject::connect(
        &driverInput,
        &DriverInput::gearShiftDown,
        &virtualVehicle,
        &VirtualVehicle::shiftGearDown
    );

    QObject::connect(
        &driverInput,
        &DriverInput::gearShiftUp,
        &virtualVehicle,
        &VirtualVehicle::shiftGearUp
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::headlightsPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleHeadlights
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::highBeamPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleHighBeam
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::leftIndicatorPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleLeftIndicator
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::rightIndicatorPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleRightIndicator
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::hazardPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleHazards
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::regenPressed,
        &virtualVehicle,
        &VirtualVehicle::cycleRegen
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::chargingPressed,
        &virtualVehicle,
        &VirtualVehicle::toggleCharging
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::cruisePressed,
        &virtualVehicle,
        &VirtualVehicle::toggleCruise
    );
    
    QObject::connect(
        &driverInput,
        &DriverInput::handBrakePressed,
        &virtualVehicle,
        &VirtualVehicle::toggleHandBrake
    );

    QObject::connect(
        &driverInput,
        &DriverInput::driveModePressed,
        &virtualVehicle,
        &VirtualVehicle::cycleDriveMode
    );

    // NOTE: TelemetryParser currently writes STM32 telemetry straight into
    // VehicleData. For VirtualVehicle's field-authority check to work,
    // route real telemetry through stmSimulator's onXReceived() slots
    // instead (e.g. connect TelemetryParser::speedParsed to
    // stmSimulator.onSpeedReceived) so STMDataSimulator can stamp each
    // field as "live" at the moment real data arrives.

    stmSimulator.start();
    //musicPlayer.play();
    virtualVehicle.start();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(
        "vehicleData",
        &vehicleData
    );

    engine.rootContext()->setContextProperty(
        "virtualVehicle",
        &virtualVehicle
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

    // Force fullscreen
    QQuickWindow *window =
        qobject_cast<QQuickWindow *>(engine.rootObjects().first());

    if (window) {
        window->showFullScreen();
    }

    return app.exec();
}