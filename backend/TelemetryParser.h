#ifndef TELEMETRYPARSER_H
#define TELEMETRYPARSER_H

#include <QObject>

class VehicleData;

class TelemetryParser : public QObject
{
    Q_OBJECT

public:
    explicit TelemetryParser(VehicleData *vehicleData,
                             QObject *parent = nullptr);

    void parsePacket(const QString &packet);

private:
    VehicleData *m_vehicleData;
};

#endif // TELEMETRYPARSER_H