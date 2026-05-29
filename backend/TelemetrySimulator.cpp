#include "TelemetrySimulator.h"
#include "VehicleData.h"

TelemetrySimulator::TelemetrySimulator(VehicleData *vehicleData,
                                       QObject *parent)
    : QObject(parent),
      m_vehicleData(vehicleData)
{
    connect(&m_timer,
            &QTimer::timeout,
            this,
            &TelemetrySimulator::generateFakeData);
}

void TelemetrySimulator::start()
{
    m_timer.start(100);
}

void TelemetrySimulator::generateFakeData()
{
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
    // Simulate RPM based on speed
    m_state.rpm = m_state.speed * 50;
    
    // Simulate battery drain and range reduction every 15 seconds
    if (m_state.speed > 0)
    {
        static int batteryCounter = 0;
        batteryCounter++;
        if (batteryCounter >= 1500)
            {
            batteryCounter = 0;

            if (m_state.batteryPercent > 0)
                m_state.batteryPercent--;

            if (m_state.rangeKm > 0)
                m_state.rangeKm--;
            }
    }
    // Simulate temperature changes based on speed
    m_state.motorTemp = 35 + (m_state.speed / 4);
    m_state.batteryTemp = 30 + (m_state.speed / 8);

    // Simulate gear state based on speed
    if (m_state.speed == 0)
    m_state.gearState = "P";
    else
        m_state.gearState = "D";

    // Simulate drive mode changes based on speed
    if (m_state.speed < 40)
        m_state.driveMode = "ECO";
    else if (m_state.speed < 80)
        m_state.driveMode = "CITY";
    else
        m_state.driveMode = "SPORT";

    // Simulate warning message if motor temperature exceeds threshold
    if (m_state.motorTemp > 55)
    {
        m_state.warningMessage =
            "Motor Temperature High";
    }
    else
    {
        m_state.warningMessage = "";
    }
    // Simulate indicator behavior
    static int indicatorCounter = 0;

    indicatorCounter++;

    if (indicatorCounter >= 50)
    {
        indicatorCounter = 0;

        m_state.leftIndicator =
            !m_state.leftIndicator;
    }
    // Simulate headlights turning on at higher speeds
    m_state.headlights =(m_state.speed > 60);

    m_vehicleData->setSpeed(m_state.speed);
    m_vehicleData->setRpm(m_state.rpm);
    m_vehicleData->setBatteryPercent(m_state.batteryPercent);

    m_vehicleData->setMotorTemp(m_state.motorTemp);
    m_vehicleData->setBatteryTemp(m_state.batteryTemp);

    m_vehicleData->setRangeKm(m_state.rangeKm);

    m_vehicleData->setDriveMode(m_state.driveMode);
    m_vehicleData->setGearState(m_state.gearState);

    m_vehicleData->setLeftIndicator(m_state.leftIndicator);
    m_vehicleData->setRightIndicator(m_state.rightIndicator);

    m_vehicleData->setHeadlights(m_state.headlights);

    m_vehicleData->setWarningMessage(m_state.warningMessage);

}