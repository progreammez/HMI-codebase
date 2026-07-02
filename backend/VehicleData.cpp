#include "VehicleData.h"
#include <QFile>
#include <QDir>
#include <QDateTime>

// VehicleData class implementation
VehicleData::VehicleData(QObject *parent)
    : QObject(parent),
      m_rpm(0),
      m_speed(0),
      m_batteryPercent(100),
      m_motorTemp(35),
      m_batteryTemp(30),
      m_controllerTemp(30),
      m_rangeKm(180),
      m_driveMode("ECO"),
      m_gearState("P"),
      m_leftIndicator(false),
      m_rightIndicator(false),
      m_hazardLights(false),
      m_headlights(false),
      m_highBeam(false),
      m_motorPower(0.0f),
      m_regenLevel(0),
      m_odometer(0.0f),
      m_tripDistance(0.0f),
      m_tripA(0.0f),
      m_tripB(0.0f),
      m_lowBatteryWarning(false),
      m_motorOverTempWarning(false),
      m_batteryOverTempWarning(false),
      m_communicationFault(false),
      m_lowRangeWarning(false),
      m_warningMessage(""),
      m_simulationActive(true),
      m_framesReceived(124536),
      m_invalidFrames(15),
      m_checksumErrors(2)

    

{
}

// =====================================================
// FRONTEND INTERACTIVE ACTIONS SLOTS IMPLEMENTATION
// =====================================================

void VehicleData::resetStatistics()
{
    // Clear out screen tracking counters
    setHistoricalWarnings(0);
    setFramesReceived(0);
    setInvalidFrames(0);
    setChecksumErrors(0);
}

void VehicleData::exportLog()
{
    // Point straight to your mapped runtime workspace path
    QString logsPath = "./logs/"; 
    QString exportPath = "./exported_logs/";
    
    QDir dir;
    if (!dir.exists(exportPath)) {
        dir.mkpath(exportPath);
    }
    
    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    
    // Perform standard safe file stream copying routines
    QFile::copy(logsPath + "telemetry.csv", exportPath + "exported_telemetry_" + timestamp + ".csv");
    QFile::copy(logsPath + "warnings.csv", exportPath + "exported_warnings_" + timestamp + ".csv");
}

void VehicleData::testConnection()
{
    // Target real systemic file nodes to verify live target connection hardware state
    if (QFile::exists("/dev/ttyUSB0")) {
        setCommunicationFault(false);
    } else {
        setCommunicationFault(true);
    }
}

// =====================================================
// GETTER METHODS
// =====================================================

int VehicleData::rpm() const
{
    return m_rpm;
}

int VehicleData::speed() const
{
    return m_speed;
}

int VehicleData::batteryPercent() const
{
    return m_batteryPercent;
}

int VehicleData::motorTemp() const
{
    return m_motorTemp;
}

int VehicleData::batteryTemp() const
{
    return m_batteryTemp;
}

int VehicleData::controllerTemp() const
{
    return m_controllerTemp;
}

int VehicleData::rangeKm() const
{
    return m_rangeKm;
}

QString VehicleData::driveMode() const
{
    return m_driveMode;
}

QString VehicleData::gearState() const
{
    return m_gearState;
}

bool VehicleData::leftIndicator() const
{
    return m_leftIndicator;
}

bool VehicleData::rightIndicator() const
{
    return m_rightIndicator;
}

bool VehicleData::hazardLights() const
{
    return m_hazardLights;
}

bool VehicleData::headlights() const
{
    return m_headlights;
}

bool VehicleData::highBeam() const
{
    return m_highBeam;
}

float VehicleData::motorPower() const
{
    return m_motorPower;
}

int VehicleData::regenLevel() const
{
    return m_regenLevel;
}

float VehicleData::odometer() const
{
    return m_odometer;
}

float VehicleData::tripDistance() const
{
    return m_tripDistance;
}

float VehicleData::tripA() const
{
    return m_tripA;
}

float VehicleData::tripB() const
{
    return m_tripB;
}

bool VehicleData::lowBatteryWarning() const
{
    return m_lowBatteryWarning;
}

bool VehicleData::motorOverTempWarning() const
{
    return m_motorOverTempWarning;
}

bool VehicleData::batteryOverTempWarning() const
{
    return m_batteryOverTempWarning;
}

bool VehicleData::communicationFault() const
{
    return m_communicationFault;
}

bool VehicleData::lowRangeWarning() const
{
    return m_lowRangeWarning;
}

QString VehicleData::warningMessage() const
{
    return m_warningMessage;
}

bool VehicleData::simulationActive() const
{
    return m_simulationActive;
}

int VehicleData::framesReceived() const
{
    return m_framesReceived;
}

int VehicleData::invalidFrames() const
{
    return m_invalidFrames;
}

int VehicleData::checksumErrors() const
{
    return m_checksumErrors;
}

// =====================================================
// SETTER METHODS
// =====================================================

void VehicleData::setRpm(int rpm)
{
    if (m_rpm == rpm)
        return;
    m_rpm = rpm;
    emit rpmChanged();
    emit telemetryChanged();
}

void VehicleData::setSpeed(int speed)
{
    if (m_speed == speed)
        return;
    m_speed = speed;
    emit speedChanged();
    emit telemetryChanged();
}

void VehicleData::setBatteryPercent(int batteryPercent)
{
    if (m_batteryPercent == batteryPercent)
        return;
    m_batteryPercent = batteryPercent;
    emit batteryPercentChanged();
    emit telemetryChanged();
}

void VehicleData::setMotorTemp(int motorTemp)
{
    if (m_motorTemp == motorTemp)
        return;
    m_motorTemp = motorTemp;
    emit motorTempChanged();
    emit telemetryChanged();
}

void VehicleData::setControllerTemp(int controllerTemp)
{
    if (m_controllerTemp == controllerTemp)
        return;
    m_controllerTemp = controllerTemp;
    emit controllerTempChanged();
    emit telemetryChanged();
}

void VehicleData::setBatteryTemp(int batteryTemp)
{
    if (m_batteryTemp == batteryTemp)
        return;
    m_batteryTemp = batteryTemp;
    emit batteryTempChanged();
    emit telemetryChanged();
}

void VehicleData::setRangeKm(int rangeKm)
{
    if (m_rangeKm == rangeKm)
        return;
    m_rangeKm = rangeKm;
    emit rangeKmChanged();
    emit telemetryChanged();
}

void VehicleData::setDriveMode(const QString &driveMode)
{
    if (m_driveMode == driveMode)
        return;
    m_driveMode = driveMode;
    emit driveModeChanged();
    emit telemetryChanged();
}

void VehicleData::setGearState(const QString &gearState)
{
    if (m_gearState == gearState)
        return;
    m_gearState = gearState;
    emit gearStateChanged();
    emit telemetryChanged();
}

void VehicleData::setLeftIndicator(bool leftIndicator)
{
    if (m_leftIndicator == leftIndicator)
        return;
    m_leftIndicator = leftIndicator;
    emit leftIndicatorChanged();
}

void VehicleData::setRightIndicator(bool rightIndicator)
{
    if (m_rightIndicator == rightIndicator)
        return;
    m_rightIndicator = rightIndicator;
    emit rightIndicatorChanged();
}

void VehicleData::setHazardLights(bool hazardLights)
{
    if (m_hazardLights == hazardLights)
        return;
    m_hazardLights = hazardLights;
    emit hazardLightsChanged();
}

void VehicleData::setHeadlights(bool headlights)
{
    if (m_headlights == headlights)
        return;
    m_headlights = headlights;
    emit headlightsChanged();
}

void VehicleData::setHighBeam(bool highBeam)
{
    if (m_highBeam == highBeam)
        return;
    m_highBeam = highBeam;
    emit highBeamChanged();
}

void VehicleData::setMotorPower(float motorPower)
{
    if (qFuzzyCompare(m_motorPower, motorPower))
        return;
    m_motorPower = motorPower;
    emit motorPowerChanged();
}

void VehicleData::setRegenLevel(int regenLevel)
{
    if (m_regenLevel == regenLevel)
        return;
    m_regenLevel = regenLevel;
    emit regenLevelChanged();
}

void VehicleData::setOdometer(float odometer)
{
    if (qFuzzyCompare(m_odometer, odometer))
        return;
    m_odometer = odometer;
    emit odometerChanged();
}

void VehicleData::setTripDistance(float tripDistance)
{
    if (qFuzzyCompare(m_tripDistance, tripDistance))
        return;
    m_tripDistance = tripDistance;
    emit tripDistanceChanged();
}

void VehicleData::settripA(float tripA)
{
    if (qFuzzyCompare(m_tripA, tripA))
        return;
    m_tripA = tripA;
    emit tripAChanged();
}

void VehicleData::settripB(float tripB)
{
    if (qFuzzyCompare(m_tripB, tripB))
        return;
    m_tripB = tripB;
    emit tripBChanged();
}  

void VehicleData::setLowBatteryWarning(bool lowBatteryWarning)
{
    if (m_lowBatteryWarning == lowBatteryWarning)
        return;
    m_lowBatteryWarning = lowBatteryWarning;
    emit lowBatteryWarningChanged();
    emit telemetryChanged();
}

void VehicleData::setMotorOverTempWarning(bool motorOverTempWarning)
{
    if (m_motorOverTempWarning == motorOverTempWarning)
        return;
    m_motorOverTempWarning = motorOverTempWarning;
    emit motorOverTempWarningChanged();
    emit telemetryChanged();
}

void VehicleData::setBatteryOverTempWarning(bool batteryOverTempWarning)
{
    if (m_batteryOverTempWarning == batteryOverTempWarning)
        return;
    m_batteryOverTempWarning = batteryOverTempWarning;
    emit batteryOverTempWarningChanged();
    emit telemetryChanged();
}

void VehicleData::setCommunicationFault(bool communicationFault)
{
    if (m_communicationFault == communicationFault)
        return;
    m_communicationFault = communicationFault;
    emit communicationFaultChanged();
    emit telemetryChanged();
}

void VehicleData::setLowRangeWarning(bool lowRangeWarning)
{
    if (m_lowRangeWarning == lowRangeWarning)
        return;
    m_lowRangeWarning = lowRangeWarning;
    emit lowRangeWarningChanged();
    emit telemetryChanged();
}

void VehicleData::setWarningMessage(const QString &warningMessage)
{
    if (m_warningMessage == warningMessage)
        return;
    m_warningMessage = warningMessage;
    emit warningMessageChanged();
    emit telemetryChanged();
}

void VehicleData::setSimulationActive(bool active)
{
    if (m_simulationActive == active)
        return;
    m_simulationActive = active;
    emit simulationActiveChanged();
}

void VehicleData::setFramesReceived(int framesReceived)
{
    if (m_framesReceived == framesReceived)
        return;
    m_framesReceived = framesReceived;
    emit framesReceivedChanged();
}

void VehicleData::setInvalidFrames(int invalidFrames)
{
    if (m_invalidFrames == invalidFrames)
        return;
    m_invalidFrames = invalidFrames;
    emit invalidFramesChanged();
}

void VehicleData::setChecksumErrors(int checksumErrors)
{
    if (m_checksumErrors == checksumErrors)
        return;
    m_checksumErrors = checksumErrors;
    emit checksumErrorsChanged();
}