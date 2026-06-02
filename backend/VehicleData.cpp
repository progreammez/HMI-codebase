#include "VehicleData.h"

// VehicleData class implementation
VehicleData::VehicleData(QObject *parent)
    : QObject(parent),
      m_rpm(0),
      m_speed(0),
      m_batteryPercent(100),
      m_motorTemp(35),
      m_batteryTemp(30),
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
      m_lowBatteryWarning(false),
      m_motorOverTempWarning(false),
      m_batteryOverTempWarning(false),
      m_communicationFault(false),
      m_warningMessage("")
{
}

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

void VehicleData::setRpm(int rpm)
{
    // Only update if the value has changed to avoid unnecessary signals
    if (m_rpm == rpm)
        return;
    // Update the RPM value and emit the signal
    m_rpm = rpm;
    emit rpmChanged();
    emit telemetryChanged();     // Notify that telemetry data has changed
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

void VehicleData::setLowRangeWarning(
    bool lowRangeWarning
)
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