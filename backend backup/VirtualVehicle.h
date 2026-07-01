#pragma once

#include <QObject>
#include <QTimer>

class VehicleData;
class DriverInput;

struct VirtualVehicleState
{
    // ===========================
    // Driving
    // ===========================

    int speed = 0;
    int rpm = 0;

    QString gearState = "P";
    QString driveMode = "ECO";

    bool accelerating = false;
    bool braking = false;

    bool cruiseControl = false;
    bool handBrake = true;

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
    bool leftIndicator = false;
    bool rightIndicator = false;

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
                            DriverInput *driverInput,
                            QObject *parent = nullptr);

    void start();

public slots:

    void setAccelerating(bool pressed);
    void setBraking(bool pressed);

    void setGear(const QString &gear);

    void toggleHeadlights();
    void toggleHighBeam();

    void toggleLeftIndicator();
    void toggleRightIndicator();
    void toggleHazards();

    void cycleRegen();

    void toggleCharging();

    void toggleCruise();

    void toggleHandBrake();


private:
    VehicleData *m_vehicleData;
    DriverInput *m_driverInput;
    int m_batteryTick = 0;

    QTimer m_timer;

    VirtualVehicleState m_state;

private slots:
    void update();
};