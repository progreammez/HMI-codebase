#include "VirtualVehicle.h"
#include "VehicleData.h"
#include "DriverInput.h"
#include "STMDataSimulator.h"

#include <QtMath>
#include <QStringList>
#include <algorithm>

// ==========================================================
// PHYSICAL / TUNING CONSTANTS
//
// These are deliberately simple, hand-picked constants rather than
// lookup tables or a full physics engine -- the goal is a model whose
// *shape* of behaviour is realistic (weaker accel at speed, RPM lag/
// overshoot, CC/CV charging, asymmetric thermal response), not a
// certified vehicle-dynamics solver.
// ==========================================================

namespace
{
constexpr float kMass = 1500.0f;                 // kg
constexpr float kGravity = 9.81f;                 // m/s^2
constexpr float kRollingResistanceCoeff = 0.015f; // Crr
constexpr float kAirDensity = 1.225f;             // kg/m^3
constexpr float kDragCoeff = 0.28f;               // Cd
constexpr float kFrontalArea = 2.2f;              // m^2

constexpr float kIdleRpm = 800.0f;
constexpr float kNeutralMaxRpm = 4000.0f;
constexpr float kMaxRpm = 6500.0f;
// A real EV has a single fixed-ratio gearbox: RPM is (almost) directly
// proportional to wheel speed, NOT to pedal position. This is rpm-per-
// (m/s), derived so that top speed (kMaxForwardSpeedMs) lines up with
// redline (kMaxRpm) above idle.
constexpr float kRpmPerMs = (kMaxRpm - kIdleRpm) / 50.0f; // 50 == kMaxForwardSpeedMs
constexpr float kRpmSpring = 45.0f;  // spring constant (per second^2 per rpm-of-error)
constexpr float kRpmDamping = 9.5f;  // damping -- tuned to slightly underdamp on purpose

constexpr float kMaxForwardSpeedMs = 50.0f; // ~180 km/h
constexpr float kMaxReverseSpeedMs = 4.2f;  // ~15 km/h, EVs deliberately limit reverse

constexpr float kMaxBrakeForceN = 6000.0f;
constexpr float kRegenEfficiency = 0.65f;
constexpr float kAuxLoadKw = 0.3f; // electronics/lights baseline draw

constexpr float kBatteryCapacityKwh = 20.0f;
constexpr float kNominalVoltage = 72.4f;
constexpr float kInternalResistanceOhm = 0.08f;
constexpr float kVoltageFilterTimeConstant = 0.3f;

constexpr float kMaxChargePowerKw = 3.3f;
constexpr float kChargeEfficiency = 0.92f;

constexpr float kBaseRangeKm = 180.0f;
constexpr float kAmbientTempC = 25.0f;

// Regen strength per level (0 = off), before drive-mode scaling.
constexpr float kRegenLevelGain[3] = {0.0f, 0.9f, 2.0f};

const DriveModeParams kEcoParams{10.0f, 3200.0f, 0.75f, 1.3f, 1.15f, 250.0f, 0.75f};
const DriveModeParams kCityParams{16.0f, 4200.0f, 1.0f, 1.0f, 1.0f, 400.0f, 1.0f};
const DriveModeParams kSportParams{24.0f, 5200.0f, 1.3f, 0.7f, 0.85f, 700.0f, 1.4f};

// Reverse gear always uses a fraction of the active mode's forward
// power/force so backing up never feels as strong as driving forward.
constexpr float kReversePowerFraction = 0.25f;

float signOf(float v)
{
    if (v > 0.001f) return 1.0f;
    if (v < -0.001f) return -1.0f;
    return 0.0f;
}
} // namespace

VirtualVehicle::VirtualVehicle(VehicleData *vehicleData,
                                DriverInput *driverInput,
                                STMDataSimulator *stmDataSimulator,
                                QObject *parent)
    : QObject(parent)
    , m_vehicleData(vehicleData)
    , m_driverInput(driverInput)
    , m_stmDataSimulator(stmDataSimulator)
{
    connect(&m_timer, &QTimer::timeout, this, &VirtualVehicle::onTick);
}

void VirtualVehicle::start()
{
    m_timer.start(static_cast<int>(kDt * 1000)); // 100ms -> 10Hz
}

void VirtualVehicle::onTick()
{
    update();
}

const DriveModeParams &VirtualVehicle::currentModeParams() const
{
    if (m_state.driveMode == "SPORT") return kSportParams;
    if (m_state.driveMode == "CITY") return kCityParams;
    return kEcoParams; // default / ECO
}

// ==========================================================
// MAIN PIPELINE
// ==========================================================

void VirtualVehicle::update()
{
    updateInputs(kDt);
    updateVehicleDynamics(kDt);
    updateMotor();
    updateBattery(kDt);
    updateCharging(kDt);
    updateTemperatures(kDt);
    updateTrips(kDt);
    updateWarnings();
    publish();
}

// ----------------------------------------------------------
// 1. INPUT SHAPING
//
// Turns the driver's raw button presses into continuous 0..1 pedal
// positions via rate limiting. This single step is what removes the
// "instant jump" arcade feel without touching the dynamics model.
// ----------------------------------------------------------
void VirtualVehicle::updateInputs(float dt)
{
    // Cruise control auto-disengages the moment it stops making sense --
    // leaving Drive, pulling the handbrake, plugging in to charge, or the
    // driver touching the brake all hand control straight back to the
    // driver, same as a real car.
    if (m_state.cruiseControl &&
        (m_state.gearState != "D" || m_state.handBrake || m_state.charging || m_state.braking))
    {
        m_state.cruiseControl = false;
        m_state.cruiseIntegral = 0.0f;
    }

    const bool inputsLocked = m_state.handBrake || m_state.charging;

    float accelTarget;
    if (m_state.cruiseControl)
    {
        // Closed-loop speed hold: a PI controller continuously nulls out
        // the speed error caused by rolling resistance/drag by adjusting
        // the (virtual) pedal input -- exactly what a real cruise-control
        // ECU does to counter the forces trying to slow the car down.
        constexpr float kCruiseKp = 0.15f; // pedal fraction per m/s of error
        constexpr float kCruiseKi = 0.08f; // pedal fraction per (m/s * s) of accumulated error
        constexpr float kCruiseIntegralClamp = 2.0f; // anti-windup

        const float errorMs = m_state.cruiseTargetSpeedMs - m_state.speedMs;
        m_state.cruiseIntegral = qBound(-kCruiseIntegralClamp,
                                         m_state.cruiseIntegral + errorMs * dt,
                                         kCruiseIntegralClamp);

        accelTarget = qBound(0.0f, kCruiseKp * errorMs + kCruiseKi * m_state.cruiseIntegral, 1.0f);
    }
    else
    {
        accelTarget = (!inputsLocked && m_state.accelerating) ? 1.0f : 0.0f;
    }

    const float brakeTarget = (!inputsLocked && m_state.braking) ? 1.0f : 0.0f;

    constexpr float kAccelRiseTime = 0.25f; // seconds to reach full pedal
    constexpr float kBrakeRiseTime = 0.15f; // brake should feel more immediate

    m_state.accelPedal += (accelTarget - m_state.accelPedal) * std::min(1.0f, dt / kAccelRiseTime);
    m_state.brakePedal += (brakeTarget - m_state.brakePedal) * std::min(1.0f, dt / kBrakeRiseTime);
}

// ----------------------------------------------------------
// 2. VEHICLE DYNAMICS
//
// Speed comes from a longitudinal force balance (tractive force vs.
// rolling resistance, aerodynamic drag, regen and friction braking).
// RPM is a decoupled second-order (spring-damper) response to a target
// derived from pedal load and speed -- this is what allows RPM to lag,
// briefly overshoot, and move independently of speed in Neutral/Park.
// ----------------------------------------------------------
void VirtualVehicle::updateVehicleDynamics(float dt)
{
    const DriveModeParams &mode = currentModeParams();
    const bool isReverse = (m_state.gearState == "R");
    const bool isDriving = (m_state.gearState == "D" || isReverse);
    const bool isParked = (m_state.gearState == "P");

    const float driveSign = isReverse ? -1.0f : (m_state.gearState == "D" ? 1.0f : 0.0f);
    const float powerFraction = isReverse ? kReversePowerFraction : 1.0f;
    const float vMax = isReverse ? kMaxReverseSpeedMs : kMaxForwardSpeedMs;

    float v = m_state.speedMs;
    const float vAbs = std::fabs(v);
    const float vDenom = std::max(vAbs, 1.0f); // avoid divide-by-zero at standstill

    // --- Tractive force: constant-force at low speed (traction-limited),
    //     constant-power at higher speed (power/velocity-limited). This
    //     single min() is what naturally produces "acceleration weakens
    //     as speed increases" and a realistic top speed, with no tables.
    float tractionForceN = 0.0f;
    if (isDriving && !m_state.handBrake && !m_state.charging)
    {
        const float availablePowerW = mode.maxMotorPowerKw * 1000.0f * powerFraction
                                       * m_state.accelPedal * mode.torqueMultiplier;
        const float maxForceN = mode.maxTractionForceN * mode.torqueMultiplier * powerFraction;
        tractionForceN = driveSign * std::min(maxForceN, availablePowerW / vDenom);
    }

    // --- Resistive forces (always oppose current motion direction).
    const float dir = signOf(v);
    const float rollForceN = kRollingResistanceCoeff * kMass * kGravity * dir;
    const float dragForceN = 0.5f * kAirDensity * kDragCoeff * kFrontalArea * v * v * dir;

    // --- Regenerative braking: engages while coasting (pedal released)
    //     or actively braking, proportional to speed and regen level.
    float regenForceN = 0.0f;
    if (isDriving && m_state.regenLevel > 0 && m_state.accelPedal < 0.05f)
    {
        const float regenGain = kRegenLevelGain[m_state.regenLevel] * mode.regenMultiplier;
        regenForceN = regenGain * vAbs * dir;                 // lift-off regen
        regenForceN += m_state.brakePedal * regenGain * 1.5f * vAbs * dir; // brake-blended regen
    }

    // --- Friction brake (whatever regen doesn't cover).
    const float brakeForceN = m_state.brakePedal * kMaxBrakeForceN * dir;

    float netForceN = tractionForceN - rollForceN - dragForceN - regenForceN - brakeForceN;

    // Park / handbrake / charging: vehicle is physically locked.
    if (isParked || m_state.handBrake || m_state.charging)
    {
        v = 0.0f;
        netForceN = 0.0f;
    }
    else
    {
        const float a = netForceN / kMass;
        v += a * dt;

        if (isReverse)
            v = qBound(-vMax, v, 0.0f);
        else
            v = qBound(0.0f, v, vMax);
    }

    m_state.speedMs = v;
    m_state.speedKmh = static_cast<int>(std::round(std::fabs(v) * 3.6f));
    m_state.tractionForceN = tractionForceN;
    m_state.regenForceN = regenForceN;

    // --- RPM: target derived from load + speed, then chased with a
    //     lightly-underdamped spring-damper so it lags and can overshoot
    //     instead of snapping to a linear function of speed.
    float targetRpm;
    if (isParked)
    {
        targetRpm = kIdleRpm + m_state.accelPedal * 300.0f;
    }
    else if (m_state.gearState == "N")
    {
        // Neutral: RPM responds purely to throttle, completely decoupled
        // from (unchanging) speed.
        targetRpm = kIdleRpm + m_state.accelPedal * (kNeutralMaxRpm - kIdleRpm);
    }
    else
    {
        // RPM is coupled to wheel speed via the fixed final-drive ratio
        // (kRpmPerMs) -- this is the primary term, matching how a real
        // single-speed EV motor behaves: RPM tracks speed, it doesn't
        // sit near redline just because the pedal is floored at low
        // speed. Throttle load only adds a modest "kick" on top, and
        // how big that kick is depends on drive mode (ECO barely
        // noticeable, SPORT noticeably livelier).
        const float speedBasedRpm = vAbs * kRpmPerMs;
        const float loadKick = m_state.accelPedal * mode.rpmLoadGain;
        targetRpm = kIdleRpm + speedBasedRpm + loadKick;
    }
    targetRpm = qBound(0.0f, targetRpm, kMaxRpm);

    const float rpmError = targetRpm - m_state.rpm;
    const float rpmAccel = (rpmError * kRpmSpring - m_state.rpmVelocity * kRpmDamping) * mode.rpmResponseMultiplier;
    m_state.rpmVelocity += rpmAccel * dt;
    m_state.rpm += m_state.rpmVelocity * dt;
    m_state.rpm = qBound(0.0f, m_state.rpm, kMaxRpm * 1.05f); // allow a small overshoot margin

    m_state.rpmPublished = static_cast<int>(qBound(0.0f, std::round(m_state.rpm), kMaxRpm));
}

// ----------------------------------------------------------
// 3. MOTOR / POWERTRAIN
//
// Converts the forces computed above into electrical power. Positive
// motorPowerKw = drawing from the battery; negative = regen recovering.
// ----------------------------------------------------------
void VirtualVehicle::updateMotor()
{
    const DriveModeParams &mode = currentModeParams();
    const float vAbs = std::fabs(m_state.speedMs);

    // Drive-mode efficiency: dividing by rangeEfficiency means ECO
    // (1.15) pulls LESS battery power for the same tractive force,
    // while SPORT (0.85) pulls MORE for identical driving -- this is
    // what makes SOC actually drain faster in SPORT even at the same
    // cruising speed, not just during hard acceleration. Uses the same
    // rangeEfficiency value the range estimate already relies on, so
    // the displayed range and the real depletion rate stay consistent
    // with each other.
    const float tractionPowerKw = (m_state.tractionForceN * vAbs) / 1000.0f / mode.rangeEfficiency;
    const float regenPowerKw = (std::fabs(m_state.regenForceN) * vAbs / 1000.0f) * kRegenEfficiency;

    m_state.motorPowerKw = tractionPowerKw - regenPowerKw;
}

// ----------------------------------------------------------
// 4. BATTERY
//
// State of charge is driven by instantaneous electrical power (not a
// flat per-tick decrement). Voltage sags under load and recovers under
// regen, filtered so the gauge doesn't jitter.
// ----------------------------------------------------------
void VirtualVehicle::updateBattery(float dt)
{
    const DriveModeParams &mode = currentModeParams();

    // While actively charging, updateCharging() owns SOC changes; here we
    // only account for the small always-on auxiliary draw so the two
    // update paths never fight over the same energy.
    const float netPowerKw = m_state.charging ? kAuxLoadKw : (m_state.motorPowerKw + kAuxLoadKw);

    if (!m_state.charging)
    {
        const float dSocPercent = -(netPowerKw * (dt / 3600.0f)) / kBatteryCapacityKwh * 100.0f;
        m_state.stateOfCharge = qBound(0.0f, m_state.stateOfCharge + dSocPercent, 100.0f);
    }

    m_state.batteryCurrentA = (netPowerKw * 1000.0f) / kNominalVoltage;

    const float targetVoltage = kNominalVoltage * (0.85f + 0.15f * (m_state.stateOfCharge / 100.0f))
                                 - m_state.batteryCurrentA * kInternalResistanceOhm;

    m_state.batteryVoltage += (targetVoltage - m_state.batteryVoltage)
                               * std::min(1.0f, dt / kVoltageFilterTimeConstant);

    m_state.batteryPercent = static_cast<int>(std::round(m_state.stateOfCharge));
    m_state.rangeKm = static_cast<int>(std::round((m_state.stateOfCharge / 100.0f) * kBaseRangeKm * mode.rangeEfficiency));
}

// ----------------------------------------------------------
// 5. CHARGING (constant-current / constant-voltage)
//
// Fast and flat up to ~80% SOC, then progressively tapers -- matches
// how real EV DC/AC charging curves behave, without modelling the
// charger hardware itself.
// ----------------------------------------------------------
void VirtualVehicle::updateCharging(float dt)
{
    if (!m_state.charging)
    {
        m_state.chargingPowerKw = 0.0f;
        m_state.chargeTimeRemaining = 0;
        return;
    }

    constexpr float kConstantCurrentCutoffSoc = 80.0f;

    if (m_state.stateOfCharge < kConstantCurrentCutoffSoc)
    {
        m_state.chargingPowerKw = kMaxChargePowerKw; // CC phase
    }
    else
    {
        const float taper = 1.0f - (m_state.stateOfCharge - kConstantCurrentCutoffSoc) / 20.0f;
        m_state.chargingPowerKw = kMaxChargePowerKw * std::max(0.05f, taper); // CV phase
    }

    const float dSocPercent = (m_state.chargingPowerKw * kChargeEfficiency * (dt / 3600.0f))
                               / kBatteryCapacityKwh * 100.0f;
    m_state.stateOfCharge = qBound(0.0f, m_state.stateOfCharge + dSocPercent, 100.0f);

    if (m_state.stateOfCharge >= 99.95f)
    {
        m_state.stateOfCharge = 100.0f;
        m_state.charging = false;
        m_state.chargingPowerKw = 0.0f;
    }

    const float energyNeededKwh = (100.0f - m_state.stateOfCharge) / 100.0f * kBatteryCapacityKwh;
    m_state.chargeTimeRemaining = (m_state.chargingPowerKw > 0.05f)
                                       ? static_cast<int>(std::round(energyNeededKwh / m_state.chargingPowerKw * 60.0f))
                                       : 0;
}

// ----------------------------------------------------------
// 6. TEMPERATURES
//
// Asymmetric first-order lag: heating is fast (thermal response to load
// is quick), cooling is slow (thermal mass dissipates gradually) -- this
// is what makes temperatures rise under load and fall gently afterwards
// instead of snapping back.
// ----------------------------------------------------------
void VirtualVehicle::updateTemperatures(float dt)
{
    const DriveModeParams &mode = currentModeParams();
    const float motorLoad = qBound(0.0f, std::fabs(m_state.motorPowerKw) / mode.maxMotorPowerKw, 1.0f);

    const float targetMotorTemp = kAmbientTempC + motorLoad * 70.0f;
    const float targetControllerTemp = kAmbientTempC + motorLoad * 55.0f;
    const float targetBatteryTemp = kAmbientTempC
                                     + qBound(0.0f, std::fabs(m_state.batteryCurrentA) / 150.0f, 1.0f) * 25.0f
                                     + (m_state.chargingPowerKw / kMaxChargePowerKw) * 30.0f;

    auto approach = [dt](float current, float target, float heatRate, float coolRate) {
        const float rate = (target > current) ? heatRate : coolRate;
        return current + (target - current) * rate * dt;
    };

    m_state.motorTempC = approach(m_state.motorTempC, targetMotorTemp, 0.6f, 0.15f);
    m_state.controllerTempC = approach(m_state.controllerTempC, targetControllerTemp, 0.8f, 0.20f);
    m_state.batteryTempC = approach(m_state.batteryTempC, targetBatteryTemp, 0.3f, 0.05f); // cools slowly
}

// ----------------------------------------------------------
// 7. TRIPS / ODOMETER
// ----------------------------------------------------------
void VirtualVehicle::updateTrips(float dt)
{
    const float distanceKm = std::fabs(m_state.speedMs) * dt / 1000.0f;

    m_state.odometer += distanceKm;
    m_state.tripDistance += distanceKm;
    m_state.tripA += distanceKm;
    m_state.tripB += distanceKm;
}

// ----------------------------------------------------------
// 8. WARNINGS
//
// Hook reserved for future simulated-side warnings (e.g. low range).
// communicationFault is intentionally NOT touched here -- it is owned
// exclusively by STMDataSimulator, which is the only component that
// actually knows whether the hardware link is alive.
// ----------------------------------------------------------
void VirtualVehicle::updateWarnings()
{
}

// ----------------------------------------------------------
// 9. PUBLISH
//
// The only place VirtualVehicle writes to VehicleData. Every field the
// STM32 is capable of supplying is gated behind isLive() -- if real
// telemetry is currently flowing for that field, the simulated value is
// computed (to keep internal state warm) but never published.
// ----------------------------------------------------------
void VirtualVehicle::publish()
{
    // A "Real" field is published by the simulator when the simulation
    // toggle is ON, OR -- as a live fallback -- when the STM is not currently
    // supplying that field (so a dead/absent hardware link never leaves a
    // gauge frozen). When the toggle is OFF and the STM is live, the sim
    // stays silent and the parser's real value (written via
    // STMDataSimulator::onXReceived) is what the dashboard shows.
    // For fields the STM never sends, isLive() is always false, so these are
    // published unconditionally regardless of the toggle -- i.e. always
    // simulated, which is exactly what "fully simulated" fields want.
    auto simPublishes = [this](StmField field) {
        return m_vehicleData->simulationActive()
            || !(m_stmDataSimulator && m_stmDataSimulator->isLive(field));
    };

    if (simPublishes(StmField::Speed))
        m_vehicleData->setSpeed(m_state.speedKmh);

    if (simPublishes(StmField::Rpm))
        m_vehicleData->setRpm(m_state.rpmPublished);

    if (simPublishes(StmField::MotorTemp))
        m_vehicleData->setMotorTemp(static_cast<int>(std::round(m_state.motorTempC)));

    if (simPublishes(StmField::BatteryTemp))
        m_vehicleData->setBatteryTemp(static_cast<int>(std::round(m_state.batteryTempC)));

    if (simPublishes(StmField::ControllerTemp))
        m_vehicleData->setControllerTemp(static_cast<int>(std::round(m_state.controllerTempC)));

    if (simPublishes(StmField::DriveMode))
        m_vehicleData->setDriveMode(m_state.driveMode);

    if (simPublishes(StmField::GearState))
        m_vehicleData->setGearState(m_state.gearState);

    if (simPublishes(StmField::LeftIndicator))
        m_vehicleData->setLeftIndicator(m_state.leftIndicator);

    if (simPublishes(StmField::RightIndicator))
        m_vehicleData->setRightIndicator(m_state.rightIndicator);

    // Battery SoC and motor power ARE supplied by the STM (coulomb-counted
    // SoC and current-sensor-derived power), gated the same way.
    if (simPublishes(StmField::BatteryPercent))
        m_vehicleData->setBatteryPercent(m_state.batteryPercent);

    if (simPublishes(StmField::MotorPower))
        m_vehicleData->setMotorPower(m_state.motorPowerKw);

    // Fields STM never supplies -- always owned by the simulation.
    m_vehicleData->setHandBrake(m_state.handBrake);

    // rangeKm stays simulation-owned: the STM only sends a fixed placeholder
    // (RNG=180), while the simulator derives range from live SoC.
    m_vehicleData->setRangeKm(m_state.rangeKm);
    m_vehicleData->setBatteryVoltage(m_state.batteryVoltage);

    m_vehicleData->setOdometer(m_state.odometer);
    m_vehicleData->setTripDistance(m_state.tripDistance);
    m_vehicleData->setTripA(m_state.tripA);
    m_vehicleData->setTripB(m_state.tripB);

    m_vehicleData->setHazardLights(m_state.hazardLights);
    m_vehicleData->setHeadlights(m_state.headlights);
    m_vehicleData->setHighBeam(m_state.highBeam);

    // NOTE: motorPower is published above, gated behind StmField::MotorPower.
    m_vehicleData->setRegenLevel(m_state.regenLevel);

    m_vehicleData->setCharging(m_state.charging);
    m_vehicleData->setChargingPower(m_state.chargingPowerKw);
    m_vehicleData->setChargeTimeRemaining(m_state.chargeTimeRemaining);
}

// ==========================================================
// DRIVER COMMAND SLOTS
//
// These only ever record intent (booleans, enums). They never touch
// the physics/electrical state directly -- that all happens inside the
// update pipeline above, which is what keeps the model smooth.
// ==========================================================

void VirtualVehicle::setAccelerating(bool pressed)
{
    m_state.accelerating = pressed;
}

void VirtualVehicle::setBraking(bool pressed)
{
    m_state.braking = pressed;
}

void VirtualVehicle::setGear(const QString &gear)
{
    // Prevent shifting into Park or Reverse while moving at any
    // meaningful speed -- a fixed 2 km/h grace window avoids blocking a
    // shift due to residual coast-down noise right at standstill.
    if ((gear == "P" || gear == "R") && m_state.speedKmh > 2)
        return;

    m_state.gearState = gear;
}

void VirtualVehicle::shiftGearDown()
{
    // Order is P - R - N - D. "Down" steps toward P; already at P is a
    // no-op (no wraparound/cycling).
    static const QStringList kGearOrder = {"P", "R", "N", "D"};

    const int idx = kGearOrder.indexOf(m_state.gearState);
    if (idx <= 0)
        return;

    setGear(kGearOrder.at(idx - 1));
}

void VirtualVehicle::shiftGearUp()
{
    // Order is P - R - N - D. "Up" steps toward D; already at D is a
    // no-op (no wraparound/cycling).
    static const QStringList kGearOrder = {"P", "R", "N", "D"};

    const int idx = kGearOrder.indexOf(m_state.gearState);
    if (idx < 0 || idx >= kGearOrder.size() - 1)
        return;

    setGear(kGearOrder.at(idx + 1));
}

void VirtualVehicle::toggleHeadlights()
{
    m_state.headlights = !m_state.headlights;
}

void VirtualVehicle::toggleHighBeam()
{
    m_state.highBeam = !m_state.highBeam;
}

void VirtualVehicle::toggleLeftIndicator()
{
    m_state.leftIndicator = !m_state.leftIndicator;

    if (m_state.leftIndicator)
    {
        m_state.rightIndicator = false;
        m_state.hazardLights = false;
    }
}

void VirtualVehicle::toggleRightIndicator()
{
    m_state.rightIndicator = !m_state.rightIndicator;

    if (m_state.rightIndicator)
    {
        m_state.leftIndicator = false;
        m_state.hazardLights = false;
    }
}

void VirtualVehicle::toggleHazards()
{
    m_state.hazardLights = !m_state.hazardLights;

    m_state.leftIndicator = m_state.hazardLights;
    m_state.rightIndicator = m_state.hazardLights;
}

void VirtualVehicle::cycleRegen()
{
    m_state.regenLevel = (m_state.regenLevel + 1) % 3; // 0..2
}

void VirtualVehicle::cycleDriveMode()
{
    if (m_state.driveMode == "ECO")
        m_state.driveMode = "CITY";
    else if (m_state.driveMode == "CITY")
        m_state.driveMode = "SPORT";
    else
        m_state.driveMode = "ECO";
}

void VirtualVehicle::setDriveMode(const QString &mode)
{
    // Only accept known modes -- silently ignore anything else rather
    // than letting a typo'd QML binding put the vehicle in a mode the
    // dynamics model doesn't know how to handle. Must match the HMI's
    // button labels exactly: ECO / CITY / SPORT.
    if (mode == "ECO" || mode == "CITY" || mode == "SPORT")
        m_state.driveMode = mode;
}

void VirtualVehicle::toggleCharging()
{
    // Only allow charging when stationary and in Park -- matches the
    // real-world constraint that you can't plug in and drive at once.
    if (m_state.speedKmh == 0 && m_state.gearState == "P")
        m_state.charging = !m_state.charging;
}

void VirtualVehicle::toggleCruise()
{
    // Only makes sense moving forward in Drive.
    if (m_state.gearState != "D" || m_state.speedKmh <= 0)
        return;

    m_state.cruiseControl = !m_state.cruiseControl;

    if (m_state.cruiseControl)
    {
        // Latch whatever speed we're doing right now as the hold point.
        m_state.cruiseTargetSpeedMs = m_state.speedMs;
        m_state.cruiseIntegral = 0.0f;
    }
}

void VirtualVehicle::toggleHandBrake()
{
    m_state.handBrake = !m_state.handBrake;
}
