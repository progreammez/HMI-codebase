#include "TelemetryParser.h"
#include "VehicleData.h"
#include "STMDataSimulator.h"

TelemetryParser::TelemetryParser(
    VehicleData *vehicleData,
    STMDataSimulator *stmDataSimulator,
    QObject *parent
)
    : QObject(parent),
      m_vehicleData(vehicleData),
      m_stm(stmDataSimulator)
{
}

void TelemetryParser::parsePacket(
    const QString &packet
)
{
    QStringList fields =
        packet.split(",");

    int validFields = 0;

    for (const QString &field : fields)
    {
        QStringList kv =
            field.split("=");

        if (kv.size() != 2)
            continue;

        QString key =
            kv[0].trimmed();

        QString value =
            kv[1].trimmed();

        // Reject a value that isn't the type we expect for this key, so a
        // corrupted/half frame (very common right at STM power-up) can't
        // push a garbage 0 into the dashboard. Numeric keys must parse.
        bool numericOk = false;

        // Fields the STM32 genuinely measures are routed through
        // STMDataSimulator (which stamps them "live"); if no simulator was
        // supplied we fall back to writing VehicleData directly.
        if (key == "SPD")
        {
            const int v = value.toInt(&numericOk);
            if (!numericOk) continue;
            if (m_stm) m_stm->onSpeedReceived(v);
            else       m_vehicleData->setSpeed(v);
        }
        else if (key == "RPM")
        {
            const int v = value.toInt(&numericOk);
            if (!numericOk) continue;
            if (m_stm) m_stm->onRpmReceived(v);
            else       m_vehicleData->setRpm(v);
        }
        else if (key == "BAT")
        {
            const int v = value.toInt(&numericOk);
            if (!numericOk) continue;
            if (m_stm) m_stm->onBatteryPercentReceived(v);
            else       m_vehicleData->setBatteryPercent(v);
        }
        else if (key == "MT")
        {
            const int v = value.toInt(&numericOk);
            if (!numericOk) continue;
            if (m_stm) m_stm->onMotorTempReceived(v);
            else       m_vehicleData->setMotorTemp(v);
        }
        else if (key == "PWR")
        {
            // STM sends motor power in WATTS (integer); the UI shows kW.
            const int watts = value.toInt(&numericOk);
            if (!numericOk) continue;
            const float kw = watts / 1000.0f;
            if (m_stm) m_stm->onMotorPowerReceived(kw);
            else       m_vehicleData->setMotorPower(kw);
        }
        else if (key == "MODE")
        {
            if (m_stm) m_stm->onDriveModeReceived(value);
            else       m_vehicleData->setDriveMode(value);
        }
        else if (key == "GEAR")
        {
            if (m_stm) m_stm->onGearStateReceived(value);
            else       m_vehicleData->setGearState(value);
        }
        else if (key == "RNG" || key == "BT")
        {
            // Deliberately ignored: the STM sends fixed placeholders
            // (RNG=180, BT=35) -- it has no range estimator and no battery
            // temperature sensor. VirtualVehicle computes far better values
            // for rangeKm and batteryTemp, so we let the simulator own them
            // and do NOT stamp them live here.
        }
        else
        {
            // Unknown key -- skip without counting it as valid.
            continue;
        }

        ++validFields;
    }

    // Diagnostics counters (previously always stuck at 0 on the debug page).
    if (validFields > 0)
        m_vehicleData->setFramesReceived(m_vehicleData->framesReceived() + 1);
    else
        m_vehicleData->setInvalidFrames(m_vehicleData->invalidFrames() + 1);
}
