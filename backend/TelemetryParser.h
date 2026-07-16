#ifndef TELEMETRYPARSER_H
#define TELEMETRYPARSER_H

#include <QObject>

class VehicleData;
class STMDataSimulator;

class TelemetryParser : public QObject
{
    Q_OBJECT

public:
    // Real STM telemetry is routed through STMDataSimulator (not written
    // straight into VehicleData) so that each field is stamped "live" the
    // moment hardware data arrives. That liveness stamp is what makes
    // VirtualVehicle back off and let real values win instead of
    // overwriting them on its next tick.
    explicit TelemetryParser(VehicleData *vehicleData,
                             STMDataSimulator *stmDataSimulator = nullptr,
                             QObject *parent = nullptr);

public slots:
    void parsePacket(const QString &packet);

private:
    VehicleData *m_vehicleData;
    STMDataSimulator *m_stm;
};

#endif
