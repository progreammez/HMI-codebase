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
    Q_PROPERTY(QStringList recentWarnings READ recentWarnings NOTIFY recentWarningsChanged)

public:
    explicit TelemetryLogger(
        VehicleData *vehicleData,
        QObject *parent = nullptr
    );
    void logWarning(const QString& warning);
    QStringList recentWarnings() const;
    QStringList readRecentWarnings(int maxEntries) const;
    Q_INVOKABLE void clearWarnings();

public slots:
    void logTelemetry();

signals:
    void recentWarningsChanged();

private:
    VehicleData *m_vehicleData;
    QStringList m_displayWarnings;

    QFile m_logFile;
};

#endif