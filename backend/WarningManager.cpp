#include "WarningManager.h"
#include "VehicleData.h"
#include "TelemetryLogger.h"
#include <QDateTime>

WarningManager::WarningManager(VehicleData *vehicleData, TelemetryLogger *logger, QObject *parent) : QObject(parent), m_vehicleData(vehicleData), m_logger(logger)
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

    connect(
        m_vehicleData,
        &VehicleData::communicationFaultChanged,
        this,
        &WarningManager::evaluateWarnings
    );

    evaluateWarnings();
}

void WarningManager::evaluateWarnings()
    {
        bool hasWarning = false;

        m_vehicleData->setLowBatteryWarning(false);
        m_vehicleData->setLowRangeWarning(false);
        m_vehicleData->setMotorOverTempWarning(false);
        m_vehicleData->setBatteryOverTempWarning(false);

        // --- 1. Battery Temperature Check ---
        if (m_vehicleData->batteryTemp() > 60)
        {
            m_vehicleData->setBatteryOverTempWarning(true);
            
            if (!m_batteryTempLogged)
            {
                QString timestamp = QDateTime::currentDateTime().toString("dd-MMM-yyyy hh:mm:ss");
                m_vehicleData->setWarningTimestamp(timestamp);
                m_batteryTempLogged = true;
                m_logger->logWarning("Battery Temperature High");
                m_vehicleData->setHistoricalWarnings(m_vehicleData->historicalWarnings() + 1);
            }
            hasWarning = true;
        }
        else 
        {   
            m_batteryTempLogged = false;
        }

        // --- 2. Motor Temperature Check ---
        if (m_vehicleData->motorTemp() > 55)
        {
            m_vehicleData->setMotorOverTempWarning(true);
            
            if (!m_motorTempLogged)
            {   
                QString timestamp = QDateTime::currentDateTime().toString("dd-MMM-yyyy hh:mm:ss");
                m_vehicleData->setWarningTimestamp(timestamp);
                m_motorTempLogged = true;
                m_logger->logWarning("Motor Temperature High");
                m_vehicleData->setHistoricalWarnings(m_vehicleData->historicalWarnings() + 1);
            }
            hasWarning = true;
        }
        else 
        {
            // Temperature went back down! Reset the tracking flag
            m_motorTempLogged = false; 
        }

        // --- 3. Battery Percentage Check ---
        if (m_vehicleData->batteryPercent() < 20)
        {
            m_vehicleData->setLowBatteryWarning(true);
            
            if (!m_lowBatteryLogged)
            {   
                QString timestamp = QDateTime::currentDateTime().toString("dd-MMM-yyyy hh:mm:ss");
                m_vehicleData->setWarningTimestamp(timestamp);
                m_lowBatteryLogged = true;
                m_logger->logWarning("Low Battery");
                m_vehicleData->setHistoricalWarnings(m_vehicleData->historicalWarnings() + 1);
            }
            hasWarning = true;
        }
        else 
        {
            // Battery level went back up! Reset the tracking flag
            m_lowBatteryLogged = false; 
        }

        // --- 4. Range Check ---
        if (m_vehicleData->rangeKm() < 20)
        {
            m_vehicleData->setLowRangeWarning(true);
            
            if (!m_lowRangeLogged)
            {
                QString timestamp = QDateTime::currentDateTime().toString("dd-MMM-yyyy hh:mm:ss");
                m_vehicleData->setWarningTimestamp(timestamp);
                m_lowRangeLogged = true;
                m_logger->logWarning("Low Range");
                m_vehicleData->setHistoricalWarnings(m_vehicleData->historicalWarnings() + 1);
            }
            hasWarning = true;
        }
        else 
        {
            // Range went back up! Reset the tracking flag
            m_lowRangeLogged = false; 
        }

        // --- 5. Global UI Message Handling ---
        if (hasWarning)
        {
            if (m_vehicleData->batteryOverTempWarning())
                m_vehicleData->setWarningMessage("Battery Temperature High");

            else if (m_vehicleData->motorOverTempWarning())
                m_vehicleData->setWarningMessage("Motor Temperature High");

            else if (m_vehicleData->lowBatteryWarning())
                m_vehicleData->setWarningMessage("Low Battery");

            else if (m_vehicleData->lowRangeWarning())
                m_vehicleData->setWarningMessage("Low Range");
        }
        else
        {
            m_vehicleData->setWarningMessage("SYSTEM NOMINAL");
        }
        
        m_vehicleData->setHasWarning(hasWarning);
    }