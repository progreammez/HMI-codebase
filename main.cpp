#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/VehicleData.h"
#include "backend/TelemetrySimulator.h"
#include "backend/WarningManager.h"
#include "backend/LocalMusicPlayer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    VehicleData vehicleData;
    LocalMusicPlayer musicPlayer;

    TelemetrySimulator simulator(&vehicleData);

    WarningManager warningManager(&vehicleData);

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

    simulator.start();
    musicPlayer.play();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(
        "vehicleData",
        &vehicleData
    );

    engine.rootContext()->setContextProperty(
        "musicPlayer",
        &musicPlayer
    );
    #if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
        engine.loadFromModule("EvHmi", "Main");
    #else
        engine.load(QUrl(QStringLiteral("qrc:qt/qml/EvHmi/Main.qml")));
    #endif

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}