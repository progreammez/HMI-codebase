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
    // 1. ENGINE TOGGLE: SIMULATION ACTIVE CHECK
    // =========================================================================
    // Sync internal state with the QML toggle
    m_state.simulationActive = m_vehicleData->simulationActive();

    if (!m_state.simulationActive)
    {
        // If stopped, we bypass data generation calculations entirely.
        // This causes the dashboard UI values to freeze at their last state.
        return; 
    }

    // =========================================================================
    // 2. FAULT TOGGLE: COMMUNICATION FAULT CHECK
    // =========================================================================
    m_state.communicationFault = m_vehicleData->communicationFault();

    if (m_state.communicationFault)
    {
        // SIMULATE BUS CORRUPTION: Inject missing/garbage telemetry frames
        // In a real EV, a CAN-bus failure results in frozen, out-of-bounds, or missing data.
        
        // Randomly spike power and RPM to simulate bus noise
        float corruptedPower = QRandomGenerator::global()->bounded(-50, 150);
        int corruptedRpm = QRandomGenerator::global()->bounded(0, 8000);

        m_vehicleData->setMotorPower(corruptedPower);
        m_vehicleData->setRpm(corruptedRpm);
        m_vehicleData->setWarningMessage("CAN BUS COMMS FAULT: CRC ERROR");
        m_vehicleData->setHasWarning(true);
        
        // We skip updating the rest of the variables to let them freeze/stale out
        return; 
    }

    // =========================================================================
    // 3. NOMINAL OPERATION CALCULATIONS (Runs only if Active & No Fault)
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

    // Dynamic temps, power, gear states
    m_state.motorTemp = 35 + (m_state.speed / 4);
    m_state.batteryTemp = 50 + (m_state.speed / 8);
    m_state.controllerTemp = 30 + (m_state.speed / 6);
    m_state.motorPower = m_state.speed * 0.8f;
    m_state.gearState = (m_state.speed == 0) ? "P" : "D";

    if (m_state.speed < 40) m_state.driveMode = "ECO";
    else if (m_state.speed < 80) m_state.driveMode = "CITY";
    else m_state.driveMode = "SPORT";

    // Odometer increments
    m_state.odometer += m_state.speed / 36000.0f;
    m_state.tripDistance += m_state.speed / 36000.0f;

    // Indicators
    static int indicatorCounter = 0;
    indicatorCounter++;
    if (indicatorCounter >= 50)
    {
        indicatorCounter = 0;
        m_state.leftIndicator = !m_state.leftIndicator;
    }

    m_state.headlights = (m_state.speed > 60);
    m_state.regenLevel = m_state.speed > 60 ? 3 : m_state.speed > 30 ? 2 : 1;

    // Clear warnings if we are nominal
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