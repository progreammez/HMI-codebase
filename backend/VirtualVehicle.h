#pragma once

#include <QObject>
#include <QTimer>
#include <QString>

class VehicleData;
class DriverInput;
class STMDataSimulator;

// Drive-mode tuning. Values are intentionally simple constants rather
// than curves/tables -- this is a dashboard simulator, not a physics
// engine, so "intuitive and clearly different per mode" beats "precise".
struct DriveModeParams
{
    float maxMotorPowerKw;   // ceiling on tractive power
    float maxTractionForceN; // low-speed force ceiling (traction/torque limit)
    float torqueMultiplier;  // scales how eagerly pedal maps to force
    float regenMultiplier;   // scales regen strength
    float rangeEfficiency;   // >1 = better range (ECO), <1 = worse (SPORT)
    float rpmLoadGain;       // extra RPM "kick" from throttle load, on top of speed-coupled RPM
    float rpmResponseMultiplier; // scales how snappy the RPM needle reacts (spring/damping)
};

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
    float cruiseTargetSpeedMs = 0.0f; // speed latched when cruise is engaged
    float cruiseIntegral = 0.0f;      // PI controller integral term
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
    void shiftGearDown(); // relative: D -> N -> R -> P, no-op at P
    void shiftGearUp();   // relative: P -> R -> N -> D, no-op at D

    void toggleHeadlights();
    void toggleHighBeam();

    void toggleLeftIndicator();
    void toggleRightIndicator();
    void toggleHazards();

    void cycleRegen();
    void cycleDriveMode();
    void setDriveMode(const QString &mode);

    void toggleCharging();
    void toggleCruise();
    void toggleHandBrake();

private:
    // ==========================================================
    // Simulation pipeline -- each stage owns one concern.
    // Order matters: dynamics/motor must run before battery/temps,
    // which must run before publish() (which enforces STM authority).
    // ==========================================================
    void update();

    void updateInputs(float dt);          // smooth pedals, resolve gear legality
    void updateVehicleDynamics(float dt); // force balance -> speed, spring-damper -> rpm
    void updateMotor();                   // tractive/regen power from forces
    void updateBattery(float dt);         // SOC, voltage, current, range
    void updateCharging(float dt);        // CC/CV charge curve
    void updateTemperatures(float dt);    // asymmetric first-order thermal lag
    void updateTrips(float dt);           // odometer/trip integration
    void updateWarnings();                // communication fault mirror
    void publish();                       // write to VehicleData, respecting STM authority

    const DriveModeParams &currentModeParams() const;

    VehicleData *m_vehicleData;
    DriverInput *m_driverInput;
    STMDataSimulator *m_stmDataSimulator;

    QTimer m_timer;
    VirtualVehicleState m_state;

    static constexpr float kDt = 0.1f; // 10 Hz, matches m_timer interval

private slots:
    void onTick();
};
