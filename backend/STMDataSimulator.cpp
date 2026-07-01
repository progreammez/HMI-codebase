#include "STMDataSimulator.h"
#include "VehicleData.h"
#include <QRandomGenerator>

STMDataSimulator::STMDataSimulator(VehicleData *vehicleData, QObject *parent) 
    : QObject(parent), m_vehicleData(vehicleData)
{
    connect(&m_timer, &QTimer::timeout, this, &STMDataSimulator::generateFakeData);
}

void STMDataSimulator::start()
{
    // No simulation.
    // Waiting for STM packets.
}

void STMDataSimulator::generateFakeData()
{
    // ==========================================================
    // STM BRIDGE
    // ==========================================================
    //
    // This class no longer simulates vehicle behaviour.
    //
    // Its only responsibility is to forward data received
    // from the STM32 to VehicleData.
    //
    // When no STM is connected, it remains idle.
    //
}