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
    // 1. COMMUNICATION FAULT GATEWAY
    // =========================================================================

    m_state.communicationFault = m_vehicleData->communicationFault();

    if (m_state.communicationFault)
    {
        m_vehicleData->setSimulationActive(false);

        m_vehicleData->setWarningMessage(
            "CAN BUS COMMS FAULT: SIMULATION INHIBITED");

        m_vehicleData->setHasWarning(true);

        return;
    }

    // =========================================================================
    // 2. SIMULATION ENABLE CHECK
    // =========================================================================

    m_state.simulationActive = m_vehicleData->simulationActive();

    if (!m_state.simulationActive)
        return;

    // =========================================================================
    // 3. VEHICLE DYNAMICS
    // =========================================================================

    if (m_state.accelerating)
    {
        m_state.speed += QRandomGenerator::global()->bounded(1, 4);

        if (m_state.speed >=
            QRandomGenerator::global()->bounded(70, 121))
        {
            m_state.accelerating = false;
        }
    }
    else
    {
        m_state.speed -= QRandomGenerator::global()->bounded(1, 3);

        if (m_state.speed <=
            QRandomGenerator::global()->bounded(5, 20))
        {
            m_state.accelerating = true;
        }
    }

    m_state.speed = qBound(0, m_state.speed, 120);

    // =========================================================================
    // 4. RPM MODEL
    // =========================================================================

    m_state.rpm =
        (m_state.speed * 45)
        + QRandomGenerator::global()->bounded(-150, 151);

    m_state.rpm = qBound(800, m_state.rpm, 6500);

    // =========================================================================
    // 5. DRIVE MODE
    // =========================================================================

    static int driveModeCounter = 0;
    driveModeCounter++;

    if (driveModeCounter >= 250)
    {
        driveModeCounter = 0;

        switch(QRandomGenerator::global()->bounded(3))
        {
            case 0:
                m_state.driveMode = "ECO";
                break;

            case 1:
                m_state.driveMode = "CITY";
                break;

            default:
                m_state.driveMode = "SPORT";
                break;
        }
    }

    // =========================================================================
    // 6. GEAR LOGIC
    // =========================================================================

    if (m_state.speed == 0)
    {
        switch(QRandomGenerator::global()->bounded(3))
        {
            case 0:
                m_state.gearState = "P";
                break;

            case 1:
                m_state.gearState = "N";
                break;

            default:
                m_state.gearState = "D";
                break;
        }
    }
    else
    {
        m_state.gearState = "D";
    }

    // =========================================================================
    // 7. POWER MODEL
    // =========================================================================

    m_state.motorPower =
        (m_state.speed * 0.65f)
        + QRandomGenerator::global()->bounded(-5, 6);

    // =========================================================================
    // 8. THERMAL MODEL
    // =========================================================================

    int thermalLoad = static_cast<int>(m_state.motorPower);

    if (thermalLoad > 60)
        m_state.motorTemp++;
    else if (m_state.motorTemp > 35)
        m_state.motorTemp--;

    if (thermalLoad > 50)
        m_state.controllerTemp++;
    else if (m_state.controllerTemp > 30)
        m_state.controllerTemp--;

    if (thermalLoad > 40)
        m_state.batteryTemp++;
    else if (m_state.batteryTemp > 45)
        m_state.batteryTemp--;

    m_state.motorTemp =
        qBound(35, m_state.motorTemp, 120);

    m_state.controllerTemp =
        qBound(30, m_state.controllerTemp, 100);

    m_state.batteryTemp =
        qBound(45, m_state.batteryTemp, 85);

    // =========================================================================
    // 9. BATTERY + RANGE
    // =========================================================================

    static int batteryCounter = 0;
    batteryCounter++;

    if (batteryCounter >= 50)
    {
        batteryCounter = 0;

        if (m_state.batteryPercent > 0)
            m_state.batteryPercent--;
    }

    m_state.rangeKm =
        static_cast<int>(m_state.batteryPercent * 1.8f);

    // =========================================================================
    // 10. INDICATORS
    // =========================================================================

    static int indicatorCounter = 0;
    indicatorCounter++;

    if (indicatorCounter >= 30)
    {
        indicatorCounter = 0;

        int state =
            QRandomGenerator::global()->bounded(4);

        m_state.leftIndicator = false;
        m_state.rightIndicator = false;

        if (state == 1)
            m_state.leftIndicator = true;

        if (state == 2)
            m_state.rightIndicator = true;
    }

    // =========================================================================
    // 11. HEADLIGHTS
    // =========================================================================

    static int headlightCounter = 0;
    headlightCounter++;

    if (headlightCounter >= 150)
    {
        headlightCounter = 0;

        m_state.headlights =
            QRandomGenerator::global()->bounded(100) > 40;
    }

    // =========================================================================
    // 12. HIGH BEAM
    // =========================================================================

    if (!m_state.headlights)
    {
        m_state.highBeam = false;
    }
    else
    {
        static int highBeamCounter = 0;
        highBeamCounter++;

        if (highBeamCounter >= 60)
        {
            highBeamCounter = 0;

            m_state.highBeam =
                QRandomGenerator::global()->bounded(100) > 70;
        }
    }

    // =========================================================================
    // 13. REGEN
    // =========================================================================

    m_state.regenLevel =
        QRandomGenerator::global()->bounded(1, 4);

    // =========================================================================
    // 14. ODOMETER
    // =========================================================================

    m_state.odometer +=
        m_state.speed / 36000.0f;

    m_state.tripDistance +=
        m_state.speed / 36000.0f;

    m_state.tripA +=
        m_state.speed / 36000.0f;

    m_state.tripB +=
        m_state.speed / 36000.0f;

    // =========================================================================
    // 15. WARNINGS
    // =========================================================================

    if (m_state.batteryPercent < 15)
    {
        m_vehicleData->setHasWarning(true);
        m_vehicleData->setWarningMessage(
            "LOW BATTERY");
    }
    else if (m_state.motorTemp > 95)
    {
        m_vehicleData->setHasWarning(true);
        m_vehicleData->setWarningMessage(
            "MOTOR TEMPERATURE HIGH");
    }
    else if (m_state.batteryTemp > 70)
    {
        m_vehicleData->setHasWarning(true);
        m_vehicleData->setWarningMessage(
            "BATTERY TEMPERATURE HIGH");
    }
    else
    {
        m_vehicleData->setHasWarning(false);
        m_vehicleData->setWarningMessage("");
    }

    // =========================================================================
    // 16. PUSH TO QML
    // =========================================================================

    m_vehicleData->setSpeed(m_state.speed);
    m_vehicleData->setRpm(m_state.rpm);

    m_vehicleData->setBatteryPercent(
        m_state.batteryPercent);

    m_vehicleData->setMotorTemp(
        m_state.motorTemp);

    m_vehicleData->setBatteryTemp(
        m_state.batteryTemp);

    m_vehicleData->setControllerTemp(
        m_state.controllerTemp);

    m_vehicleData->setRangeKm(
        m_state.rangeKm);

    m_vehicleData->setDriveMode(
        m_state.driveMode);

    m_vehicleData->setGearState(
        m_state.gearState);

    m_vehicleData->setLeftIndicator(
        m_state.leftIndicator);

    m_vehicleData->setRightIndicator(
        m_state.rightIndicator);

    m_vehicleData->setHeadlights(
        m_state.headlights);

    m_vehicleData->setHighBeam(
        m_state.highBeam);

    m_vehicleData->setMotorPower(
        m_state.motorPower);

    m_vehicleData->setRegenLevel(
        m_state.regenLevel);

    m_vehicleData->setOdometer(
        m_state.odometer);

    m_vehicleData->setTripDistance(
        m_state.tripDistance);
}