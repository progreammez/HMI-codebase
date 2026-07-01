#include "VehicleData.h"
#include <QFile>
#include <QDir>
#include <QDateTime>

// VehicleData class implementation
VehicleData::VehicleData(QObject *parent)
    : QObject(parent)
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

// ==========================================================
// CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
// ==========================================================

// Motion
int VehicleData::speed() const
{
    return m_speed;
}

int VehicleData::rpm() const
{
    return m_rpm;
}

// Temperatures
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

// Drive State
QString VehicleData::driveMode() const
{
    return m_driveMode;
}

QString VehicleData::gearState() const
{
    return m_gearState;
}

// Indicators
bool VehicleData::leftIndicator() const
{
    return m_leftIndicator;
}

bool VehicleData::rightIndicator() const
{
    return m_rightIndicator;
}


// ==========================================================
// VIRTUAL VEHICLE (Always Simulated)
// ==========================================================

// Battery
int VehicleData::batteryPercent() const
{
    return m_batteryPercent;
}

int VehicleData::rangeKm() const
{
    return m_rangeKm;
}

float VehicleData::batteryVoltage() const
{
    return m_batteryVoltage;
}

// Trips
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

// Lighting
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

// Powertrain
float VehicleData::motorPower() const
{
    return m_motorPower;
}

int VehicleData::regenLevel() const
{
    return m_regenLevel;
}

// Charging
bool VehicleData::charging() const
{
    return m_charging;
}

float VehicleData::chargingPower() const
{
    return m_chargingPower;
}

int VehicleData::chargeTimeRemaining() const
{
    return m_chargeTimeRemaining;
}

// Cooling
int VehicleData::fanSpeed() const
{
    return m_fanSpeed;
}

float VehicleData::coolantTemp() const
{
    return m_coolantTemp;
}

float VehicleData::coolantFlow() const
{
    return m_coolantFlow;
}

bool VehicleData::pumpStatus() const
{
    return m_pumpStatus;
}

QString VehicleData::radiatorStatus() const
{
    return m_radiatorStatus;
}


// ==========================================================
// WARNINGS & FAULTS
// ==========================================================

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


// ==========================================================
// ENGINEER / POWERTRAIN STATUS
// ==========================================================

QString VehicleData::bmsStatus() const
{
    return m_bmsStatus;
}

QString VehicleData::vcuStatus() const
{
    return m_vcuStatus;
}

QString VehicleData::inverterStatus() const
{
    return m_inverterStatus;
}

QString VehicleData::dcDcStatus() const
{
    return m_dcDcStatus;
}

QString VehicleData::motorControllerStatus() const
{
    return m_motorControllerStatus;
}

QString VehicleData::driveSystemFault() const
{
    return m_driveSystemFault;
}

QString VehicleData::powerLimitState() const
{
    return m_powerLimitState;
}


// ==========================================================
// COMMUNICATION / TELEMETRY
// ==========================================================

bool VehicleData::simulationActive() const
{
    return m_simulationActive;
}

QString VehicleData::uartStatus() const
{
    return m_uartStatus;
}

QString VehicleData::parserStatus() const
{
    return m_parserStatus;
}

QString VehicleData::loggerStatus() const
{
    return m_loggerStatus;
}

QString VehicleData::simulatorStatus() const
{
    return m_simulatorStatus;
}

int VehicleData::telemetryRate() const
{
    return m_telemetryRate;
}

int VehicleData::frameInterval() const
{
    return m_frameInterval;
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

int VehicleData::packetLoss() const
{
    return m_packetLoss;
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

void VehicleData::setTripA(float tripA)
{
    if (qFuzzyCompare(m_tripA, tripA))
        return;
    m_tripA = tripA;
    emit tripAChanged();
}

void VehicleData::setTripB(float tripB)
{
    if (qFuzzyCompare(m_tripB, tripB))
        return;
    m_tripB = tripB;
    emit tripBChanged();
}  

// ==========================================================
// Battery
// ==========================================================

void VehicleData::setBatteryVoltage(float batteryVoltage)
{
    if (qFuzzyCompare(m_batteryVoltage, batteryVoltage))
        return;

    m_batteryVoltage = batteryVoltage;
    emit batteryVoltageChanged();
}

// ==========================================================
// Charging
// ==========================================================

void VehicleData::setCharging(bool charging)
{
    if (m_charging == charging)
        return;

    m_charging = charging;
    emit chargingChanged();
}

void VehicleData::setChargingPower(float chargingPower)
{
    if (qFuzzyCompare(m_chargingPower, chargingPower))
        return;

    m_chargingPower = chargingPower;
    emit chargingPowerChanged();
}

void VehicleData::setChargeTimeRemaining(int chargeTimeRemaining)
{
    if (m_chargeTimeRemaining == chargeTimeRemaining)
        return;

    m_chargeTimeRemaining = chargeTimeRemaining;
    emit chargeTimeRemainingChanged();
}

// ==========================================================
// Cooling
// ==========================================================

void VehicleData::setFanSpeed(int fanSpeed)
{
    if (m_fanSpeed == fanSpeed)
        return;

    m_fanSpeed = fanSpeed;
    emit fanSpeedChanged();
}

void VehicleData::setCoolantTemp(float coolantTemp)
{
    if (qFuzzyCompare(m_coolantTemp, coolantTemp))
        return;

    m_coolantTemp = coolantTemp;
    emit coolantTempChanged();
}

void VehicleData::setCoolantFlow(float coolantFlow)
{
    if (qFuzzyCompare(m_coolantFlow, coolantFlow))
        return;

    m_coolantFlow = coolantFlow;
    emit coolantFlowChanged();
}

void VehicleData::setPumpStatus(bool pumpStatus)
{
    if (m_pumpStatus == pumpStatus)
        return;

    m_pumpStatus = pumpStatus;
    emit pumpStatusChanged();
}

void VehicleData::setRadiatorStatus(const QString &radiatorStatus)
{
    if (m_radiatorStatus == radiatorStatus)
        return;

    m_radiatorStatus = radiatorStatus;
    emit radiatorStatusChanged();
}

// ==========================================================
// Engineer Status
// ==========================================================

void VehicleData::setBmsStatus(const QString &bmsStatus)
{
    if (m_bmsStatus == bmsStatus)
        return;

    m_bmsStatus = bmsStatus;
    emit bmsStatusChanged();
}

void VehicleData::setVcuStatus(const QString &vcuStatus)
{
    if (m_vcuStatus == vcuStatus)
        return;

    m_vcuStatus = vcuStatus;
    emit vcuStatusChanged();
}

// ==========================================================
// Powertrain Status
// ==========================================================

void VehicleData::setInverterStatus(const QString &inverterStatus)
{
    if (m_inverterStatus == inverterStatus)
        return;

    m_inverterStatus = inverterStatus;
    emit inverterStatusChanged();
}

void VehicleData::setDcDcStatus(const QString &dcDcStatus)
{
    if (m_dcDcStatus == dcDcStatus)
        return;

    m_dcDcStatus = dcDcStatus;
    emit dcDcStatusChanged();
}

void VehicleData::setMotorControllerStatus(const QString &motorControllerStatus)
{
    if (m_motorControllerStatus == motorControllerStatus)
        return;

    m_motorControllerStatus = motorControllerStatus;
    emit motorControllerStatusChanged();
}

void VehicleData::setDriveSystemFault(const QString &driveSystemFault)
{
    if (m_driveSystemFault == driveSystemFault)
        return;

    m_driveSystemFault = driveSystemFault;
    emit driveSystemFaultChanged();
}

void VehicleData::setPowerLimitState(const QString &powerLimitState)
{
    if (m_powerLimitState == powerLimitState)
        return;

    m_powerLimitState = powerLimitState;
    emit powerLimitStateChanged();
}

// ==========================================================
// Communication
// ==========================================================

void VehicleData::setUartStatus(const QString &uartStatus)
{
    if (m_uartStatus == uartStatus)
        return;

    m_uartStatus = uartStatus;
    emit uartStatusChanged();
}

void VehicleData::setParserStatus(const QString &parserStatus)
{
    if (m_parserStatus == parserStatus)
        return;

    m_parserStatus = parserStatus;
    emit parserStatusChanged();
}

void VehicleData::setLoggerStatus(const QString &loggerStatus)
{
    if (m_loggerStatus == loggerStatus)
        return;

    m_loggerStatus = loggerStatus;
    emit loggerStatusChanged();
}

void VehicleData::setSimulatorStatus(const QString &simulatorStatus)
{
    if (m_simulatorStatus == simulatorStatus)
        return;

    m_simulatorStatus = simulatorStatus;
    emit simulatorStatusChanged();
}

void VehicleData::setTelemetryRate(int telemetryRate)
{
    if (m_telemetryRate == telemetryRate)
        return;

    m_telemetryRate = telemetryRate;
    emit telemetryRateChanged();
}

void VehicleData::setFrameInterval(int frameInterval)
{
    if (m_frameInterval == frameInterval)
        return;

    m_frameInterval = frameInterval;
    emit frameIntervalChanged();
}

void VehicleData::setPacketLoss(int packetLoss)
{
    if (m_packetLoss == packetLoss)
        return;

    m_packetLoss = packetLoss;
    emit packetLossChanged();
}