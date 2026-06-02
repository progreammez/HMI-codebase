#ifndef TELEMETRYLOGGER_H
#define TELEMETRYLOGGER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTimer>

class VehicleData;

class TelemetryLogger : public QObject
{
    Q_OBJECT
    QTimer m_timer;

public:
    explicit TelemetryLogger(
        VehicleData *vehicleData,
        QObject *parent = nullptr
    );

public slots:
    void logTelemetry();

private:
    VehicleData *m_vehicleData;

    QFile m_logFile;
};

#endif