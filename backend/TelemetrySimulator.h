// #FAKEVEHICLEDATA

#ifndef TELEMETRYSIMULATOR_H
#define TELEMETRYSIMULATOR_H

#include <QObject>
#include <QTimer>
#include <QString>
#include "IDataSource.h"

class VehicleData;

struct SimulationState
{
    int rpm = 0;
    int speed = 0;

    int batteryPercent = 100;

    int motorTemp = 35;
    int batteryTemp = 60;
    int controllerTemp = 30;

    int rangeKm = 180;

    QString driveMode = "ECO";

    bool accelerating = true;

    QString gearState = "P";

    bool leftIndicator = false;
    bool rightIndicator = false;

    bool headlights = false;
    bool highBeam = false;
    
    float motorPower = 0.0f;
    int regenLevel = 0;
    
    float odometer = 0.0f;
    float tripDistance = 0.0f;
    float tripA = 0.0f;
    float tripB = 0.0f;
    
    bool lowBatteryWarning = false;
    bool motorOverTempWarning = false;
    bool batteryOverTempWarning = false;
    bool communicationFault = false;
    QString warningMessage = "";
};

class TelemetrySimulator : public QObject, public IDataSource
{
    Q_OBJECT

public:
    explicit TelemetrySimulator(VehicleData *vehicleData, QObject *parent = nullptr);

    void start() override;

private slots:
    void generateFakeData();

private:
    VehicleData *m_vehicleData;

    QTimer m_timer;

    SimulationState m_state;
};

#endif // TELEMETRYSIMULATOR_H