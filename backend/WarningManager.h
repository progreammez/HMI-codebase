#ifndef WARNINGMANAGER_H
#define WARNINGMANAGER_H

#include <QObject>
#include <QTimer>

class VehicleData;
class TelemetryLogger;

class WarningManager : public QObject
{
    Q_OBJECT

public:
    explicit WarningManager(
        VehicleData *vehicleData,
        TelemetryLogger* logger,
        QObject *parent = nullptr);

public slots:
    void evaluateWarnings();

private:
    VehicleData *m_vehicleData;
    TelemetryLogger* m_logger;
    bool m_motorTempLogged = false;
    bool m_batteryTempLogged = false;
    bool m_lowBatteryLogged = false;
    bool m_lowRangeLogged = false;
};

#endif // WARNINGMANAGER_H