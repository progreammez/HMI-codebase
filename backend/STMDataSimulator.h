// #FAKEVEHICLEDATA
//
// STMDataSimulator is a PURE BRIDGE between the STM32 and VehicleData.
// It never invents values. Its only two jobs are:
//
//   1. Forward real telemetry from the STM32 into VehicleData.
//   2. Record *when* each field was last updated, so VirtualVehicle can
//      ask "is this field currently live from hardware?" before it dares
//      to write to it.
//
// This second job is what actually enforces "if the STM32 sends a value,
// that value always wins" -- without it, the rule was only a comment.

#ifndef STMDataSimulator_H
#define STMDataSimulator_H

#include <QObject>
#include <QTimer>
#include <QString>
#include <QHash>
#include <QElapsedTimer>
#include "IDataSource.h"

class VehicleData;

// Logical groups of telemetry that the STM32 can supply. Kept coarse
// (matching what a real STM packet would realistically bundle together)
// rather than one enum value per Q_PROPERTY.
enum class StmField
{
    Speed,
    Rpm,
    MotorTemp,
    BatteryTemp,
    ControllerTemp,
    DriveMode,
    GearState,
    LeftIndicator,
    RightIndicator,
    BatteryPercent,   // real coulomb-counted SoC from the STM32
    MotorPower,       // real motor power (kW) derived from the current sensor
    Count             // keep last -- used to size the liveness sweep
};

class STMDataSimulator : public QObject, public IDataSource
{
    Q_OBJECT

public:
    explicit STMDataSimulator(VehicleData *vehicleData, QObject *parent = nullptr);

    void start() override;

    // ==========================================================
    // AUTHORITY QUERY (used by VirtualVehicle)
    // ==========================================================
    //
    // Returns true if `field` was updated by real STM telemetry within
    // the last kLivenessTimeoutMs. If the STM32 disconnects (cable pull,
    // firmware reset, etc.) this naturally goes false after the timeout
    // and VirtualVehicle reclaims that field -- no manual handoff needed.
    bool isLive(StmField field) const;

    // How long a field is considered "STM owned" after its last update.
    // Chosen as ~5x the simulator's own tick (100ms) so a single missed
    // STM frame doesn't cause a visible flicker back to simulated data.
    static constexpr qint64 kLivenessTimeoutMs = 500;

public slots:
    // ==========================================================
    // REAL TELEMETRY INTAKE
    // ==========================================================
    //
    // These are the intended call sites for whatever parses real STM32
    // packets (e.g. TelemetryParser). Each one forwards the value to
    // VehicleData verbatim and stamps the field as "live". Nothing here
    // computes or fabricates a value -- if the STM32 didn't send it,
    // these are simply never called.
    void onSpeedReceived(int speed);
    void onRpmReceived(int rpm);
    void onMotorTempReceived(int celsius);
    void onBatteryTempReceived(int celsius);
    void onControllerTempReceived(int celsius);
    void onDriveModeReceived(const QString &mode);
    void onGearStateReceived(const QString &gear);
    void onLeftIndicatorReceived(bool on);
    void onRightIndicatorReceived(bool on);
    void onBatteryPercentReceived(int percent);
    void onMotorPowerReceived(float kilowatts);

private slots:
    void checkLiveness();

private:
    void markLive(StmField field);

    // True when real hardware values should be written straight to the
    // dashboard -- i.e. the simulation toggle is OFF. Liveness is still
    // recorded when this is false; only the value write is suppressed.
    bool hardwareOwnsOutput() const;

    VehicleData *m_vehicleData;

    // Idle housekeeping timer only -- re-evaluates communicationFault
    // state, does NOT generate telemetry.
    QTimer m_timer;

    QHash<int, qint64> m_lastSeenMs; // key = static_cast<int>(StmField)
    QElapsedTimer m_clock;
};

#endif // STMDataSimulator_H
