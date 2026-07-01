#include "VirtualVehicle.h"
#include "VehicleData.h"
#include "DriverInput.h"
#include <QDebug>

VirtualVehicle::VirtualVehicle(VehicleData *vehicleData, DriverInput *driverInput, QObject *parent)
    : QObject(parent), m_vehicleData(vehicleData), m_driverInput(driverInput)
    {
        connect(&m_timer,
                &QTimer::timeout,
                this,
                &VirtualVehicle::update);
    }

void VirtualVehicle::start()
{
    m_timer.start(100);
}

void VirtualVehicle::update()
{   
    // ==========================================================
    // VEHICLE DYNAMICS
    // ==========================================================

    if (m_state.handBrake || m_state.charging)
    {
        m_state.speed = 0;
    }
    else if (!m_state.cruiseControl && (m_state.gearState == "D" || m_state.gearState == "R"))
    {
        if (m_state.accelerating)
            m_state.speed += 2;

        if (m_state.braking)
            m_state.speed -= 4;
    }

    m_state.speed = qBound(0, m_state.speed, 120);

    m_state.rpm = (m_state.speed == 0) ? 0 : 800 + m_state.speed * 45;
    m_state.rpm = qBound(0, m_state.rpm, 6500);

    m_vehicleData->setSpeed(m_state.speed);
    m_vehicleData->setRpm(m_state.rpm);

    m_vehicleData->setGearState(m_state.gearState);
    m_vehicleData->setDriveMode(m_state.driveMode);
    m_vehicleData->setHandBrake(m_state.handBrake);

    // ==========================================================
    // BATTERY
    // ==========================================================

    if (m_state.charging)
    {
        if (m_state.batteryPercent < 100)
            m_state.batteryPercent++;

        m_state.chargingPower = 7.2f;

        if (m_state.batteryPercent >= 100)
        {
            m_state.batteryPercent = 100;
            m_state.charging = false;
            m_state.chargingPower = 0.0f;
        }
    }
    else
    {
        m_state.chargingPower = 0.0f;

        if (m_state.speed > 0 && m_state.batteryPercent > 0)
            m_state.batteryPercent--;
    }

    if (m_state.charging)
        m_state.chargeTimeRemaining = (100 - m_state.batteryPercent) * 2;
    else
        m_state.chargeTimeRemaining = 0;

    m_state.rangeKm = m_state.batteryPercent * 180 / 100;

    m_vehicleData->setBatteryPercent(m_state.batteryPercent);
    m_vehicleData->setRangeKm(m_state.rangeKm);
    m_vehicleData->setBatteryVoltage(m_state.batteryVoltage);

    // ==========================================================
    // TRIPS
    // ==========================================================

    float distance = m_state.speed * 0.0003f;

    m_state.odometer += distance;
    m_state.tripDistance += distance;
    m_state.tripA += distance;
    m_state.tripB += distance;

    m_vehicleData->setOdometer(m_state.odometer);
    m_vehicleData->setTripDistance(m_state.tripDistance);
    m_vehicleData->setTripA(m_state.tripA);
    m_vehicleData->setTripB(m_state.tripB);

    // ==========================================================
    // LIGHTING
    // ==========================================================

    m_vehicleData->setHazardLights(m_state.hazardLights);
    m_vehicleData->setHeadlights(m_state.headlights);
    m_vehicleData->setHighBeam(m_state.highBeam);

    qDebug() << "State =" << m_state.leftIndicator;
    m_vehicleData->setLeftIndicator(m_state.leftIndicator);
    m_vehicleData->setRightIndicator(m_state.rightIndicator);

    // ==========================================================
    // POWERTRAIN
    // ==========================================================

    m_state.motorPower = m_state.speed * 0.8f;
    m_vehicleData->setMotorPower(m_state.motorPower);
    m_vehicleData->setRegenLevel(m_state.regenLevel);

    // ==========================================================
    // CHARGING
    // ==========================================================

    m_vehicleData->setCharging(m_state.charging);
    m_vehicleData->setChargingPower(m_state.chargingPower);
    m_vehicleData->setChargeTimeRemaining(m_state.chargeTimeRemaining);

    // ==========================================================
    // COMMUNICATION FAULT
    // ==========================================================

    m_vehicleData->setCommunicationFault(m_state.communicationFault);
}

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
    // Prevent shifting into Park or Reverse while moving
    if ((gear == "P" || gear == "R") && m_state.speed > 2)
        return;

    m_state.gearState = gear;
}

void VirtualVehicle::toggleHandBrake()
{
    qDebug() << "toggleHandBrake() called";

    m_state.handBrake = !m_state.handBrake;

    qDebug() << "HandBrake =" << m_state.handBrake;

    m_vehicleData->setHandBrake(m_state.handBrake);
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
    qDebug() << "Before =" << m_state.leftIndicator;

    m_state.leftIndicator = !m_state.leftIndicator;

    qDebug() << "After =" << m_state.leftIndicator;

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

    if (m_state.hazardLights)
    {
        m_state.leftIndicator = true;
        m_state.rightIndicator = true;
    }
    else
    {
        m_state.leftIndicator = false;
        m_state.rightIndicator = false;
    }
}

void VirtualVehicle::cycleRegen()
{
    m_state.regenLevel++;

    if (m_state.regenLevel >= 3)
        m_state.regenLevel = 0;
}

void VirtualVehicle::toggleCharging()
{
    // Only allow charging when stationary and in Park
    if (m_state.speed == 0 && m_state.gearState == "P")
    {
        m_state.charging = !m_state.charging;
    }
}

void VirtualVehicle::toggleCruise()
{
    // Cruise only makes sense when moving
    if (m_state.speed > 0)
        m_state.cruiseControl = !m_state.cruiseControl;
}
