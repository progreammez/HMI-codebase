#pragma once

#include <QObject>
#include <QTimer>

class VehicleData;

struct VirtualVehicleState
{
    // ===========================
    // Battery
    // ===========================

    int batteryPercent = 100;
    int rangeKm = 180;
    float batteryVoltage = 72.4f;

    // ===========================
    // Trips
    // ===========================

    float odometer = 0.0f;
    float tripDistance = 0.0f;
    float tripA = 0.0f;
    float tripB = 0.0f;
    
    // ===========================
    // Lighting
    // ===========================

    bool hazardLights = false;
    bool headlights = false;
    bool highBeam = false;

    // ===========================
    // Powertrain
    // ===========================

    float motorPower = 0.0f;
    int regenLevel = 0;

    // ===========================
    // Charging
    // ===========================

    bool charging = false;
    float chargingPower = 0.0f;
    int chargeTimeRemaining = 0;

    // ===========================
    // Cooling System
    // ===========================

    int fanSpeed = 68;
    float coolantTemp = 38.0f;
    float coolantFlow = 12.4f;
    bool pumpStatus = true;
    QString radiatorStatus = "NORMAL";

    // ===========================
    // Communication / Diagnostics
    // ===========================

    bool communicationFault = false;

    QString uartStatus = "CONNECTED";
    QString parserStatus = "ACTIVE";
    QString loggerStatus = "RECORDING";
    QString simulatorStatus = "RUNNING";

    int telemetryRate = 50;
    int frameInterval = 20;

    int framesReceived = 124519;
    int invalidFrames = 15;
    int checksumErrors = 2;
    int packetLoss = 0;

    // ===========================
    // Engineer Status
    // ===========================

    QString bmsStatus = "NORMAL";
    QString vcuStatus = "NORMAL";

    // ===========================
    // Powertrain Status
    // ===========================

    QString inverterStatus = "NORMAL";
    QString dcdcStatus = "NORMAL";
    QString motorControllerStatus = "NORMAL";
    QString driveSystemFault = "NONE";
    QString powerLimitState = "NONE";
};

class VirtualVehicle : public QObject
{
    Q_OBJECT

public:
    explicit VirtualVehicle(VehicleData *vehicleData,
                            QObject *parent = nullptr);

    void start();

private:
    VehicleData *m_vehicleData;

    QTimer m_timer;

    VirtualVehicleState m_state;

private slots:
    void update();
};