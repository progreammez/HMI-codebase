#include "STMDataSimulator.h"
#include "VehicleData.h"

STMDataSimulator::STMDataSimulator(VehicleData *vehicleData, QObject *parent)
    : QObject(parent), m_vehicleData(vehicleData)
{
    m_clock.start();

    // Periodically re-check liveness so `communicationFault` reflects a
    // dropped STM32 even if no new frame ever arrives to trigger it.
    connect(&m_timer, &QTimer::timeout, this, &STMDataSimulator::checkLiveness);
}

void STMDataSimulator::start()
{
    // No simulation. This only starts the liveness watchdog; it never
    // generates telemetry. Waiting for real STM packets via the
    // onXReceived() slots below.
    m_timer.start(100);
}

// ==========================================================
// LIVENESS TABLE
// ==========================================================

void STMDataSimulator::markLive(StmField field)
{
    m_lastSeenMs[static_cast<int>(field)] = m_clock.elapsed();
}

bool STMDataSimulator::isLive(StmField field) const
{
    const int key = static_cast<int>(field);
    if (!m_lastSeenMs.contains(key))
        return false;

    return (m_clock.elapsed() - m_lastSeenMs.value(key)) <= kLivenessTimeoutMs;
}

void STMDataSimulator::checkLiveness()
{
    // If every field has gone stale, flag it for the dashboard. Any one
    // field still being live means the link is at least partially up.
    bool anyLive = false;
    for (int i = 0; i < static_cast<int>(StmField::Count); ++i)
    {
        if (isLive(static_cast<StmField>(i)))
        {
            anyLive = true;
            break;
        }
    }

    // Only meaningful once at least one frame has ever arrived --
    // otherwise every fresh boot would report a fault before the STM32
    // has had a chance to say hello.
    if (!m_lastSeenMs.isEmpty())
        m_vehicleData->setCommunicationFault(!anyLive);
}

// ==========================================================
// REAL TELEMETRY INTAKE -- pure forwarding, no fabrication
// ==========================================================

void STMDataSimulator::onSpeedReceived(int speed)
{
    m_vehicleData->setSpeed(speed);
    markLive(StmField::Speed);
}

void STMDataSimulator::onRpmReceived(int rpm)
{
    m_vehicleData->setRpm(rpm);
    markLive(StmField::Rpm);
}

void STMDataSimulator::onMotorTempReceived(int celsius)
{
    m_vehicleData->setMotorTemp(celsius);
    markLive(StmField::MotorTemp);
}

void STMDataSimulator::onBatteryTempReceived(int celsius)
{
    m_vehicleData->setBatteryTemp(celsius);
    markLive(StmField::BatteryTemp);
}

void STMDataSimulator::onControllerTempReceived(int celsius)
{
    m_vehicleData->setControllerTemp(celsius);
    markLive(StmField::ControllerTemp);
}

void STMDataSimulator::onDriveModeReceived(const QString &mode)
{
    m_vehicleData->setDriveMode(mode);
    markLive(StmField::DriveMode);
}

void STMDataSimulator::onGearStateReceived(const QString &gear)
{
    m_vehicleData->setGearState(gear);
    markLive(StmField::GearState);
}

void STMDataSimulator::onLeftIndicatorReceived(bool on)
{
    m_vehicleData->setLeftIndicator(on);
    markLive(StmField::LeftIndicator);
}

void STMDataSimulator::onRightIndicatorReceived(bool on)
{
    m_vehicleData->setRightIndicator(on);
    markLive(StmField::RightIndicator);
}
