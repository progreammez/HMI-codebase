// #FAKEVEHICLEDATA

#ifndef STMDataSimulator_H
#define STMDataSimulator_H

#include <QObject>
#include <QTimer>
#include <QString>
#include "IDataSource.h"

class VehicleData;

struct SimulationState
{
    // ==========================================
    // Simulation Control
    // ==========================================

    bool simulationActive = true;
    bool accelerating = true;

    // ==========================================
    // STM Telemetry
    // ==========================================

    int speed = 0;
    int rpm = 0;

    int motorTemp = 35;
    int batteryTemp = 60;
    int controllerTemp = 30;

    QString driveMode = "ECO";
    QString gearState = "P";

    bool leftIndicator = false;
    bool rightIndicator = false;

    // ==========================================
    // Warnings (leave for now)
    // ==========================================

    bool lowBatteryWarning = false;
    bool motorOverTempWarning = false;
    bool batteryOverTempWarning = false;

    bool communicationFault = false;

    QString warningMessage = "";
};

class STMDataSimulator : public QObject, public IDataSource
{
    Q_OBJECT

public:
    explicit STMDataSimulator(VehicleData *vehicleData, QObject *parent = nullptr);

    void start() override;

private slots:
    void generateFakeData();

private:
    VehicleData *m_vehicleData;

    QTimer m_timer;

    SimulationState m_state;
};

#endif // STMDataSimulator_H