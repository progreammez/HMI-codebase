#include "TelemetryLogger.h"
#include "VehicleData.h"

#include <QDateTime>
#include <QDir>
#include <QDebug>

TelemetryLogger::TelemetryLogger(
    VehicleData *vehicleData,
    QObject *parent
)
    : QObject(parent), m_vehicleData(vehicleData)
{   
    QDir().mkpath("logs");
    m_logFile.setFileName("logs/telemetry.csv");

    bool fileExists = m_logFile.exists();

    if (!m_logFile.open(
        QIODevice::Append |
        QIODevice::Text))
    {
        qDebug() << "Failed to open telemetry log";
        return;
    }

    if (!fileExists)
    {
        QTextStream out(&m_logFile);

        out
            << "Timestamp,"
            << "Speed,"
            << "RPM,"
            << "Battery,"
            << "Range,"
            << "MotorTemp,"
            << "BatteryTemp,"
            << "DriveMode,"
            << "Gear"
            << "\n";
    }

    connect(
        &m_timer,
        &QTimer::timeout,
        this,
        &TelemetryLogger::logTelemetry
    );

    m_timer.start(2500);
}

void TelemetryLogger::logTelemetry()
{
    if (!m_logFile.isOpen())
        return;

    QTextStream out(&m_logFile);

    out
        << QDateTime::currentDateTime()
               .toString(
                   "yyyy-MM-dd hh:mm:ss"
               )
        << ","
        << m_vehicleData->speed()
        << ","
        << m_vehicleData->rpm()
        << ","
        << m_vehicleData->batteryPercent()
        << ","
        << m_vehicleData->rangeKm()
        << ","
        << m_vehicleData->motorTemp()
        << ","
        << m_vehicleData->batteryTemp()
        << ","
        << m_vehicleData->driveMode()
        << ","
        << m_vehicleData->gearState()
        << "\n";

    out.flush();
}