#include "WarningManager.h"
#include "VehicleData.h"

WarningManager::WarningManager(
    VehicleData *vehicleData,
    QObject *parent)
    : QObject(parent),
      m_vehicleData(vehicleData)
{
    connect(
        m_vehicleData,
        &VehicleData::batteryPercentChanged,
        this,
        &WarningManager::evaluateWarnings
    );

    connect(
        m_vehicleData,
        &VehicleData::motorTempChanged,
        this,
        &WarningManager::evaluateWarnings
    );

    connect(
        m_vehicleData,
        &VehicleData::batteryTempChanged,
        this,
        &WarningManager::evaluateWarnings
    );

    connect(
        m_vehicleData,
        &VehicleData::rangeKmChanged,
        this,
        &WarningManager::evaluateWarnings
    );

    evaluateWarnings();
}

void WarningManager::evaluateWarnings()
    {
        m_vehicleData->setLowBatteryWarning(false);
        m_vehicleData->setLowRangeWarning(false);
        m_vehicleData->setMotorOverTempWarning(false);
        m_vehicleData->setBatteryOverTempWarning(false);

        if (m_vehicleData->batteryTemp() > 60)
        {
            m_vehicleData->setBatteryOverTempWarning(true);
            m_vehicleData->setWarningMessage(
                "Battery Temperature High"
            );
            return;
        }

        if (m_vehicleData->motorTemp() > 55)
        {
            m_vehicleData->setMotorOverTempWarning(true);
            m_vehicleData->setWarningMessage(
                "Motor Temperature High"
            );
            return;
        }

        if (m_vehicleData->batteryPercent() < 20)
        {
            m_vehicleData->setLowBatteryWarning(true);
            m_vehicleData->setWarningMessage(
                "Low Battery"
            );
            return;
        }

        if (m_vehicleData->rangeKm() < 20)
        {
            m_vehicleData->setLowRangeWarning(true);
            m_vehicleData->setWarningMessage(
                "Low Range"
            );
            return;
        }

        m_vehicleData->setWarningMessage(
            "SYSTEM NOMINAL"
        );
    }