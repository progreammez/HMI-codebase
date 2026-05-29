#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/VehicleData.h"
#include "backend/TelemetrySimulator.h"
#include "backend/WarningManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    VehicleData vehicleData;

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

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(
        "vehicleData",
        &vehicleData
    );

    engine.loadFromModule("EvHmi", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}