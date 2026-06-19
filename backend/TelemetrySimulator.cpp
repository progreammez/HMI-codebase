#include "TelemetrySimulator.h"
#include "VehicleData.h"
#include <QRandomGenerator>

TelemetrySimulator::TelemetrySimulator(VehicleData *vehicleData, QObject *parent) 
    : QObject(parent), m_vehicleData(vehicleData)
{
    connect(&m_timer, &QTimer::timeout, this, &TelemetrySimulator::generateFakeData);
}

void TelemetrySimulator::start()
{
    m_timer.start(100); // 10 Hz update loop
}

void TelemetrySimulator::generateFakeData()
{
    // =========================================================================
    // 1. FAULT GATEWAY: COMMUNICATION FAULT CHECK (HIGHEST PRIORITY)
    // =========================================================================
    m_state.communicationFault = m_vehicleData->communicationFault();

    if (m_state.communicationFault)
    {
        // INTERLOCK ACTUATED: Force simulation state off immediately 
        m_vehicleData->setSimulationActive(false);

        // SIMULATE BUS CORRUPTION NOISE OVER THE DATA LINK
        // float corruptedPower = QRandomGenerator::global()->bounded(-50, 150);
        // int corruptedRpm = QRandomGenerator::global()->bounded(0, 8000);

        // m_vehicleData->setMotorPower(corruptedPower);
        // m_vehicleData->setRpm(corruptedRpm);
        
        m_vehicleData->setWarningMessage("CAN BUS COMMS FAULT: SIMULATION INHIBITED");
        m_vehicleData->setHasWarning(true);
        
        // Bail immediately. The physics engine cannot calculate under bus fault conditions.
        return; 
    }

    // =========================================================================
    // 2. ENGINE GATEWAY: SIMULATION ACTIVE CHECK
    // =========================================================================
    // Sync internal state with QML. This will only matter if communicationFault == false
    m_state.simulationActive = m_vehicleData->simulationActive();

    if (!m_state.simulationActive)
    {
        // If the engineer toggled it off manually (while system is NOMINAL), 
        // freeze values or optionally set them to safety idles.
        return; 
    }

    // =========================================================================
    // 3. NOMINAL OPERATION CALCULATIONS (Runs only if Active & Healthy Comms)
    // =========================================================================
    if (m_state.accelerating)
    {
        m_state.speed += 1;
        if (m_state.speed >= 120)
            m_state.accelerating = false;
    }
    else
    {
        m_state.speed -= 1;
        if (m_state.speed <= 0)
            m_state.accelerating = true;
    }

    m_state.rpm = m_state.speed * 50;
    
    if (m_state.speed > 0)
    {
        static int batteryCounter = 0;
        batteryCounter++;
        if (batteryCounter >= 10)
        {
            batteryCounter = 0;
            if (m_state.batteryPercent > 0)
                m_state.batteryPercent--;

            if (m_state.rangeKm > 0)
                m_state.rangeKm--;
        }
    }

    // Dynamic environmental and powertrain states
    m_state.motorTemp = 35 + (m_state.speed / 4);
    m_state.batteryTemp = 50 + (m_state.speed / 8);
    m_state.controllerTemp = 30 + (m_state.speed / 6);
    m_state.motorPower = m_state.speed * 0.8f;
    m_state.gearState = (m_state.speed == 0) ? "P" : "D";

    if (m_state.speed < 40) m_state.driveMode = "ECO";
    else if (m_state.speed < 80) m_state.driveMode = "CITY";
    else m_state.driveMode = "SPORT";

    m_state.odometer += m_state.speed / 36000.0f;
    m_state.tripDistance += m_state.speed / 36000.0f;

    // Signal status updates
    static int indicatorCounter = 0;
    indicatorCounter++;
    if (indicatorCounter >= 50)
    {
        indicatorCounter = 0;
        m_state.leftIndicator = !m_state.leftIndicator;
    }

    m_state.headlights = (m_state.speed > 60);
    m_state.regenLevel = m_state.speed > 60 ? 3 : m_state.speed > 30 ? 2 : 1;

    // Clear active faults once conditions return to nominal states
    m_vehicleData->setWarningMessage("");
    m_vehicleData->setHasWarning(false);

    // =========================================================================
    // 4. PUSH STATE TO QML INTERFACE
    // =========================================================================
    m_vehicleData->setSpeed(m_state.speed);
    m_vehicleData->setRpm(m_state.rpm);
    m_vehicleData->setBatteryPercent(m_state.batteryPercent);
    m_vehicleData->setMotorTemp(m_state.motorTemp);
    m_vehicleData->setBatteryTemp(m_state.batteryTemp);
    m_vehicleData->setControllerTemp(m_state.controllerTemp);
    m_vehicleData->setRangeKm(m_state.rangeKm);
    m_vehicleData->setDriveMode(m_state.driveMode);
    m_vehicleData->setGearState(m_state.gearState);
    m_vehicleData->setLeftIndicator(m_state.leftIndicator);
    m_vehicleData->setRightIndicator(m_state.rightIndicator);
    m_vehicleData->setHeadlights(m_state.headlights);
    m_vehicleData->setMotorPower(m_state.motorPower);
    m_vehicleData->setRegenLevel(m_state.regenLevel);
    m_vehicleData->setOdometer(m_state.odometer);
    m_vehicleData->setTripDistance(m_state.tripDistance);
}