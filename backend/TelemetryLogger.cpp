#include "TelemetryLogger.h"
#include "VehicleData.h"
#include "WarningManager.h"

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

void TelemetryLogger::logWarning(const QString& warning)
{
    QDir().mkpath("logs");
    
    // Use a local QFile instead of the member variable m_logFile
    QFile warningFile("logs/warnings.csv");

    bool exists = warningFile.exists();

    // Open, write, and automatically close via block scope
    if (!warningFile.open(QIODevice::Append | QIODevice::Text))
        return;

    QTextStream out(&warningFile);

    if (!exists)
    {
        out << "Timestamp,Warning\n";
    }

    out
        << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss")
        << ","
        << warning
        << "\n";

    // Optional: flush is handled safely when the file closes out of scope
    out.flush();
    m_displayWarnings.prepend(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss") + "," + warning);

    while (m_displayWarnings.size() > 10)
    {
        m_displayWarnings.removeLast();
    }

    emit recentWarningsChanged();
}

QStringList TelemetryLogger::readRecentWarnings(int maxEntries) const
{
    QStringList warnings;

    QFile file("logs/warnings.csv");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return warnings;

    QTextStream in(&file);

    in.readLine(); // Skip header

    while (!in.atEnd())
    {
        warnings.append(in.readLine());
    }

    while (warnings.size() > maxEntries)
    {
        warnings.removeFirst();
    }

    std::reverse(warnings.begin(), warnings.end());

    return warnings;
}

QStringList TelemetryLogger::recentWarnings() const
{
    return m_displayWarnings;
}

void TelemetryLogger::clearWarnings()
{
    m_displayWarnings.clear();

    emit recentWarningsChanged();
}
