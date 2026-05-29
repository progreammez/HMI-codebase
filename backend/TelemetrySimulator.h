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
    int batteryTemp = 30;

    int rangeKm = 180;

    QString driveMode = "ECO";

    bool accelerating = true;

    QString gearState = "P";

    bool leftIndicator = false;
    bool rightIndicator = false;

    bool headlights = false;

    QString warningMessage = "";
};

class TelemetrySimulator : public QObject, public IdataSource
{
    Q_OBJECT

public:
    explicit TelemetrySimulator(VehicleData *vehicleData,
                                QObject *parent = nullptr);

    void start() override;

private slots:
    void generateFakeData();

private:
    VehicleData *m_vehicleData;

    QTimer m_timer;

    SimulationState m_state;
};

#endif // TELEMETRYSIMULATOR_H