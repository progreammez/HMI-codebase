#include "VirtualVehicle.h"
#include "VehicleData.h"

VirtualVehicle::VirtualVehicle(VehicleData *vehicleData, QObject *parent)
    : QObject(parent), m_vehicleData(vehicleData)
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
    // BATTERY
    // ==========================================================

    if (m_state.batteryPercent > 0)
        m_state.batteryPercent--;
    else
        m_state.batteryPercent = 100;

    m_state.rangeKm = 180 * m_state.batteryPercent / 100;

    m_vehicleData->setBatteryPercent(m_state.batteryPercent);
    m_vehicleData->setRangeKm(m_state.rangeKm);
    m_vehicleData->setBatteryVoltage(m_state.batteryVoltage);

    // ==========================================================
    // TRIPS
    // ==========================================================

    m_state.odometer += 0.02f;
    m_state.tripDistance += 0.02f;
    m_state.tripA += 0.02f;
    m_state.tripB += 0.02f;

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

    // ==========================================================
    // POWERTRAIN
    // ==========================================================

    m_state.motorPower = 25.0f + (rand() % 200) / 10.0f;
    m_state.regenLevel = rand() % 4;

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