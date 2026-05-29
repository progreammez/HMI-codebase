#include "TelemetryParser.h"
#include "VehicleData.h"

TelemetryParser::TelemetryParser(VehicleData *vehicleData,
                                 QObject *parent)
    : QObject(parent),
      m_vehicleData(vehicleData)
{
}

void TelemetryParser::parsePacket(const QString &packet)
{
    Q_UNUSED(packet)
}