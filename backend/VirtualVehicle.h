#pragma once

#include <QObject>
#include <QTimer>
#include <QString>

class VehicleData;
class DriverInput;

struct VirtualVehicleState
{
    // ===========================
    // Driver commands (raw, from DriverInput)
    // ===========================
    bool accelerating = false;
    bool braking = false;

    QString gearState = "P";
    QString driveMode = "ECO";

    bool cruiseControl = false;
    bool handBrake = true;

    // ===========================
    // Smoothed / continuous inputs (derived, never set directly)
    // ===========================
    float accelPedal = 0.0f; // 0..1, rate-limited toward accelerating
    float brakePedal = 0.0f; // 0..1, rate-limited toward braking

    // ===========================
    // Longitudinal dynamics
    // ===========================
    float speedMs = 0.0f;    // internal precision, metres/second
    int speedKmh = 0;        // published value

    float rpm = 800.0f;      // internal precision
    float rpmVelocity = 0.0f; // "velocity" term of the spring-damper model
    int rpmPublished = 800;

    // ===========================
    // Powertrain / motor
    // ===========================
    float tractionForceN = 0.0f;
    float regenForceN = 0.0f;
    float motorPowerKw = 0.0f;   // published (can be negative during regen)
    int regenLevel = 0;          // 0..2, cycled by driver

    // ===========================
    // Battery
    // ===========================
    float stateOfCharge = 100.0f; // internal precision (%)
    int batteryPercent = 100;     // published
    int rangeKm = 180;
    float batteryVoltage = 72.4f;
    float batteryCurrentA = 0.0f;

    // ===========================
    // Charging
    // ===========================
    bool charging = false;
    float chargingPowerKw = 0.0f;
    int chargeTimeRemaining = 0; // minutes

    // ===========================
    // Temperatures (internal float precision, published as int)
    // ===========================
    float motorTempC = 35.0f;
    float controllerTempC = 30.0f;
    float batteryTempC = 30.0f;

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
    // Diagnostics
    // ===========================
    bool communicationFault = false;
};

class VirtualVehicle : public QObject
{
    Q_OBJECT

public:
    explicit VirtualVehicle(VehicleData *vehicleData,
                             DriverInput *driverInput,
                             STMDataSimulator *stmDataSimulator,
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


    VehicleData *m_vehicleData;
    DriverInput *m_driverInput;
    STMDataSimulator *m_stmDataSimulator;

    QTimer m_timer;
    VirtualVehicleState m_state;

private slots:
    void update();
};