// Storing state variables for the vehicle and providing a way to update them from the simulator
#ifndef VEHICLEDATA_H
#define VEHICLEDATA_H

#include <QObject>
#include <QString>

class VehicleData : public QObject
{
        Q_OBJECT

    // ==========================================================
    // CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
    // ==========================================================

    // Motion
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int rpm READ rpm WRITE setRpm NOTIFY rpmChanged)

    // Temperatures
    Q_PROPERTY(int motorTemp READ motorTemp WRITE setMotorTemp NOTIFY motorTempChanged)
    Q_PROPERTY(int batteryTemp READ batteryTemp WRITE setBatteryTemp NOTIFY batteryTempChanged)
    Q_PROPERTY(int controllerTemp READ controllerTemp WRITE setControllerTemp NOTIFY controllerTempChanged)

    // Drive State
    Q_PROPERTY(QString driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    Q_PROPERTY(QString gearState READ gearState WRITE setGearState NOTIFY gearStateChanged)
    Q_PROPERTY(bool handBrake READ handBrake WRITE setHandBrake NOTIFY handBrakeChanged)

    // Indicators
    Q_PROPERTY(bool leftIndicator READ leftIndicator WRITE setLeftIndicator NOTIFY leftIndicatorChanged)
    Q_PROPERTY(bool rightIndicator READ rightIndicator WRITE setRightIndicator NOTIFY rightIndicatorChanged)

    // ==========================================================
    // VIRTUAL VEHICLE (Always Simulated)
    // ==========================================================

    // Battery
    Q_PROPERTY(int batteryPercent READ batteryPercent WRITE setBatteryPercent NOTIFY batteryPercentChanged)
    Q_PROPERTY(int rangeKm READ rangeKm WRITE setRangeKm NOTIFY rangeKmChanged)
    Q_PROPERTY(float batteryVoltage READ batteryVoltage WRITE setBatteryVoltage NOTIFY batteryVoltageChanged)

    // Trips
    Q_PROPERTY(float odometer READ odometer WRITE setOdometer NOTIFY odometerChanged)
    Q_PROPERTY(float tripDistance READ tripDistance WRITE setTripDistance NOTIFY tripDistanceChanged)
    Q_PROPERTY(float tripA READ tripA WRITE setTripA NOTIFY tripAChanged)
    Q_PROPERTY(float tripB READ tripB WRITE setTripB NOTIFY tripBChanged)

    // Lighting
    Q_PROPERTY(bool hazardLights READ hazardLights WRITE setHazardLights NOTIFY hazardLightsChanged)
    Q_PROPERTY(bool headlights READ headlights WRITE setHeadlights NOTIFY headlightsChanged)
    Q_PROPERTY(bool highBeam READ highBeam WRITE setHighBeam NOTIFY highBeamChanged)

    // Powertrain
    Q_PROPERTY(float motorPower READ motorPower WRITE setMotorPower NOTIFY motorPowerChanged)
    Q_PROPERTY(int regenLevel READ regenLevel WRITE setRegenLevel NOTIFY regenLevelChanged)

    // Charging
    Q_PROPERTY(bool charging READ charging WRITE setCharging NOTIFY chargingChanged)
    Q_PROPERTY(float chargingPower READ chargingPower WRITE setChargingPower NOTIFY chargingPowerChanged)
    Q_PROPERTY(int chargeTimeRemaining READ chargeTimeRemaining WRITE setChargeTimeRemaining NOTIFY chargeTimeRemainingChanged)

    // Cooling
    Q_PROPERTY(int fanSpeed READ fanSpeed WRITE setFanSpeed NOTIFY fanSpeedChanged)
    Q_PROPERTY(float coolantTemp READ coolantTemp WRITE setCoolantTemp NOTIFY coolantTempChanged)
    Q_PROPERTY(float coolantFlow READ coolantFlow WRITE setCoolantFlow NOTIFY coolantFlowChanged)
    Q_PROPERTY(bool pumpStatus READ pumpStatus WRITE setPumpStatus NOTIFY pumpStatusChanged)
    Q_PROPERTY(QString radiatorStatus READ radiatorStatus WRITE setRadiatorStatus NOTIFY radiatorStatusChanged)

    // ==========================================================
    // WARNINGS & FAULTS
    // ==========================================================

    Q_PROPERTY(bool lowBatteryWarning READ lowBatteryWarning WRITE setLowBatteryWarning NOTIFY lowBatteryWarningChanged)
    Q_PROPERTY(bool motorOverTempWarning READ motorOverTempWarning WRITE setMotorOverTempWarning NOTIFY motorOverTempWarningChanged)
    Q_PROPERTY(bool batteryOverTempWarning READ batteryOverTempWarning WRITE setBatteryOverTempWarning NOTIFY batteryOverTempWarningChanged)
    Q_PROPERTY(bool communicationFault READ communicationFault WRITE setCommunicationFault NOTIFY communicationFaultChanged)
    Q_PROPERTY(bool lowRangeWarning READ lowRangeWarning WRITE setLowRangeWarning NOTIFY lowRangeWarningChanged)

    Q_PROPERTY(QString warningMessage READ warningMessage WRITE setWarningMessage NOTIFY warningMessageChanged)

    Q_PROPERTY(bool hasWarning READ hasWarning WRITE setHasWarning NOTIFY hasWarningChanged)
    Q_PROPERTY(QString warningTimestamp READ warningTimestamp WRITE setWarningTimestamp NOTIFY warningTimestampChanged)
    Q_PROPERTY(int historicalWarnings READ historicalWarnings WRITE setHistoricalWarnings NOTIFY historicalWarningsChanged)

    // ==========================================================
    // ENGINEER / POWERTRAIN STATUS
    // ==========================================================

    Q_PROPERTY(QString bmsStatus READ bmsStatus WRITE setBmsStatus NOTIFY bmsStatusChanged)
    Q_PROPERTY(QString vcuStatus READ vcuStatus WRITE setVcuStatus NOTIFY vcuStatusChanged)

    Q_PROPERTY(QString inverterStatus READ inverterStatus WRITE setInverterStatus NOTIFY inverterStatusChanged)
    Q_PROPERTY(QString dcDcStatus READ dcDcStatus WRITE setDcDcStatus NOTIFY dcDcStatusChanged)
    Q_PROPERTY(QString motorControllerStatus READ motorControllerStatus WRITE setMotorControllerStatus NOTIFY motorControllerStatusChanged)
    Q_PROPERTY(QString driveSystemFault READ driveSystemFault WRITE setDriveSystemFault NOTIFY driveSystemFaultChanged)
    Q_PROPERTY(QString powerLimitState READ powerLimitState WRITE setPowerLimitState NOTIFY powerLimitStateChanged)

    // ==========================================================
    // COMMUNICATION / TELEMETRY
    // ==========================================================

    Q_PROPERTY(bool simulationActive READ simulationActive WRITE setSimulationActive NOTIFY simulationActiveChanged)

    Q_PROPERTY(QString uartStatus READ uartStatus WRITE setUartStatus NOTIFY uartStatusChanged)
    Q_PROPERTY(QString parserStatus READ parserStatus WRITE setParserStatus NOTIFY parserStatusChanged)
    Q_PROPERTY(QString loggerStatus READ loggerStatus WRITE setLoggerStatus NOTIFY loggerStatusChanged)
    Q_PROPERTY(QString simulatorStatus READ simulatorStatus WRITE setSimulatorStatus NOTIFY simulatorStatusChanged)

    Q_PROPERTY(int telemetryRate READ telemetryRate WRITE setTelemetryRate NOTIFY telemetryRateChanged)
    Q_PROPERTY(int frameInterval READ frameInterval WRITE setFrameInterval NOTIFY frameIntervalChanged)

    Q_PROPERTY(int framesReceived READ framesReceived WRITE setFramesReceived NOTIFY framesReceivedChanged)
    Q_PROPERTY(int invalidFrames READ invalidFrames WRITE setInvalidFrames NOTIFY invalidFramesChanged)
    Q_PROPERTY(int checksumErrors READ checksumErrors WRITE setChecksumErrors NOTIFY checksumErrorsChanged)
    Q_PROPERTY(int packetLoss READ packetLoss WRITE setPacketLoss NOTIFY packetLossChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);

public slots:
    // Fully exposed execution handlers called directly by QML action buttons
    void resetStatistics();
    void exportLog();
    void testConnection();

public:
        // ==========================================================
    // CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
    // ==========================================================

    // Motion
    int speed() const;
    int rpm() const;

    // Temperatures
    int motorTemp() const;
    int batteryTemp() const;
    int controllerTemp() const;

    // Drive State
    QString driveMode() const;
    QString gearState() const;
    bool handBrake() const;

    // Indicators
    bool leftIndicator() const;
    bool rightIndicator() const;

    // ==========================================================
    // VIRTUAL VEHICLE (Always Simulated)
    // ==========================================================

    // Battery
    int batteryPercent() const;
    int rangeKm() const;
    float batteryVoltage() const;

    // Trips
    float odometer() const;
    float tripDistance() const;
    float tripA() const;
    float tripB() const;

    // Lighting
    bool hazardLights() const;
    bool headlights() const;
    bool highBeam() const;

    // Powertrain
    float motorPower() const;
    int regenLevel() const;

    // Charging
    bool charging() const;
    float chargingPower() const;
    int chargeTimeRemaining() const;

    // Cooling
    int fanSpeed() const;
    float coolantTemp() const;
    float coolantFlow() const;
    bool pumpStatus() const;
    QString radiatorStatus() const;

    // ==========================================================
    // WARNINGS & FAULTS
    // ==========================================================

    bool lowBatteryWarning() const;
    bool motorOverTempWarning() const;
    bool batteryOverTempWarning() const;
    bool communicationFault() const;
    bool lowRangeWarning() const;

    QString warningMessage() const;

    bool hasWarning() const
    {
        return m_hasWarning;
    }

    QString warningTimestamp() const
    {
        return m_warningTimestamp;
    }

    int historicalWarnings() const
    {
        return m_historicalWarnings;
    }

    // ==========================================================
    // ENGINEER / POWERTRAIN STATUS
    // ==========================================================

    QString bmsStatus() const;
    QString vcuStatus() const;

    QString inverterStatus() const;
    QString dcDcStatus() const;
    QString motorControllerStatus() const;
    QString driveSystemFault() const;
    QString powerLimitState() const;

    // ==========================================================
    // COMMUNICATION / TELEMETRY
    // ==========================================================

    bool simulationActive() const;

    QString uartStatus() const;
    QString parserStatus() const;
    QString loggerStatus() const;
    QString simulatorStatus() const;

    int telemetryRate() const;
    int frameInterval() const;

    int framesReceived() const;
    int invalidFrames() const;
    int checksumErrors() const;
    int packetLoss() const;

        // ==========================================================
    // CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
    // ==========================================================

    // Motion
    void setSpeed(int speed);
    void setRpm(int rpm);

    // Temperatures
    void setMotorTemp(int motorTemp);
    void setBatteryTemp(int batteryTemp);
    void setControllerTemp(int controllerTemp);

    // Drive State
    void setDriveMode(const QString &driveMode);
    void setGearState(const QString &gearState);
    void setHandBrake(bool handBrake);

    // Indicators
    void setLeftIndicator(bool leftIndicator);
    void setRightIndicator(bool rightIndicator);

    // ==========================================================
    // VIRTUAL VEHICLE (Always Simulated)
    // ==========================================================

    // Battery
    void setBatteryPercent(int batteryPercent);
    void setRangeKm(int rangeKm);
    void setBatteryVoltage(float batteryVoltage);

    // Trips
    void setOdometer(float odometer);
    void setTripDistance(float tripDistance);
    void setTripA(float tripA);
    void setTripB(float tripB);

    // Lighting
    void setHazardLights(bool hazardLights);
    void setHeadlights(bool headlights);
    void setHighBeam(bool highBeam);

    // Powertrain
    void setMotorPower(float motorPower);
    void setRegenLevel(int regenLevel);

    // Charging
    void setCharging(bool charging);
    void setChargingPower(float chargingPower);
    void setChargeTimeRemaining(int chargeTimeRemaining);

    // Cooling
    void setFanSpeed(int fanSpeed);
    void setCoolantTemp(float coolantTemp);
    void setCoolantFlow(float coolantFlow);
    void setPumpStatus(bool pumpStatus);
    void setRadiatorStatus(const QString &radiatorStatus);

    // ==========================================================
    // WARNINGS & FAULTS
    // ==========================================================

    void setLowBatteryWarning(bool lowBatteryWarning);
    void setMotorOverTempWarning(bool motorOverTempWarning);
    void setBatteryOverTempWarning(bool batteryOverTempWarning);
    void setCommunicationFault(bool communicationFault);
    void setLowRangeWarning(bool lowRangeWarning);

    void setWarningMessage(const QString &warningMessage);

    void setHasWarning(bool value)
    {
        if (m_hasWarning == value)
            return;

        m_hasWarning = value;
        emit hasWarningChanged();
    }

    void setWarningTimestamp(const QString &value)
    {
        if (m_warningTimestamp == value)
            return;

        m_warningTimestamp = value;
        emit warningTimestampChanged();
    }

    void setHistoricalWarnings(int value)
    {
        if (m_historicalWarnings == value)
            return;

        m_historicalWarnings = value;
        emit historicalWarningsChanged();
    }

    // ==========================================================
    // ENGINEER / POWERTRAIN STATUS
    // ==========================================================

    void setBmsStatus(const QString &bmsStatus);
    void setVcuStatus(const QString &vcuStatus);

    void setInverterStatus(const QString &inverterStatus);
    void setDcDcStatus(const QString &dcDcStatus);
    void setMotorControllerStatus(const QString &motorControllerStatus);
    void setDriveSystemFault(const QString &driveSystemFault);
    void setPowerLimitState(const QString &powerLimitState);

    // ==========================================================
    // COMMUNICATION / TELEMETRY
    // ==========================================================

    void setSimulationActive(bool active);

    void setUartStatus(const QString &uartStatus);
    void setParserStatus(const QString &parserStatus);
    void setLoggerStatus(const QString &loggerStatus);
    void setSimulatorStatus(const QString &simulatorStatus);

    void setTelemetryRate(int telemetryRate);
    void setFrameInterval(int frameInterval);

    void setFramesReceived(int framesReceived);
    void setInvalidFrames(int invalidFrames);
    void setChecksumErrors(int checksumErrors);
    void setPacketLoss(int packetLoss);

signals:
    // ==========================================================
    // CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
    // ==========================================================

    // Motion
    void speedChanged();
    void rpmChanged();

    // Temperatures
    void motorTempChanged();
    void batteryTempChanged();
    void controllerTempChanged();

    // Drive State
    void driveModeChanged();
    void gearStateChanged();
    void handBrakeChanged();

    // Indicators
    void leftIndicatorChanged();
    void rightIndicatorChanged();

    // ==========================================================
    // VIRTUAL VEHICLE (Always Simulated)
    // ==========================================================

    // Battery
    void batteryPercentChanged();
    void rangeKmChanged();
    void batteryVoltageChanged();

    // Trips
    void odometerChanged();
    void tripDistanceChanged();
    void tripAChanged();
    void tripBChanged();

    // Lighting
    void hazardLightsChanged();
    void headlightsChanged();
    void highBeamChanged();

    // Powertrain
    void motorPowerChanged();
    void regenLevelChanged();

    // Charging
    void chargingChanged();
    void chargingPowerChanged();
    void chargeTimeRemainingChanged();

    // Cooling
    void fanSpeedChanged();
    void coolantTempChanged();
    void coolantFlowChanged();
    void pumpStatusChanged();
    void radiatorStatusChanged();

    // ==========================================================
    // WARNINGS & FAULTS
    // ==========================================================

    void lowBatteryWarningChanged();
    void motorOverTempWarningChanged();
    void batteryOverTempWarningChanged();
    void communicationFaultChanged();
    void lowRangeWarningChanged();

    void warningMessageChanged();

    void hasWarningChanged();
    void warningTimestampChanged();
    void historicalWarningsChanged();

    // ==========================================================
    // ENGINEER / POWERTRAIN STATUS
    // ==========================================================

    void bmsStatusChanged();
    void vcuStatusChanged();

    void inverterStatusChanged();
    void dcDcStatusChanged();
    void motorControllerStatusChanged();
    void driveSystemFaultChanged();
    void powerLimitStateChanged();

    // ==========================================================
    // COMMUNICATION / TELEMETRY
    // ==========================================================

    void simulationActiveChanged();

    void uartStatusChanged();
    void parserStatusChanged();
    void loggerStatusChanged();
    void simulatorStatusChanged();

    void telemetryRateChanged();
    void frameIntervalChanged();

    void framesReceivedChanged();
    void invalidFramesChanged();
    void checksumErrorsChanged();
    void packetLossChanged();

    void telemetryChanged();

private:

    // ==========================================================
    // CORE VEHICLE TELEMETRY (STM / Raspberry Pi)
    // ==========================================================

    // Motion
    int m_speed = 0;
    int m_rpm = 0;

    // Temperatures
    int m_motorTemp = 35;
    int m_batteryTemp = 35;
    int m_controllerTemp = 30;

    // Drive State
    QString m_driveMode = "ECO";
    QString m_gearState = "P";
    bool m_handBrake = true;

    // Indicators
    bool m_leftIndicator = false;
    bool m_rightIndicator = false;

    // ==========================================================
    // VIRTUAL VEHICLE (Always Simulated)
    // ==========================================================

    // Battery
    int m_batteryPercent = 100;
    int m_rangeKm = 180;
    float m_batteryVoltage = 72.4f;

    // Trips
    float m_odometer = 0.0f;
    float m_tripDistance = 0.0f;
    float m_tripA = 0.0f;
    float m_tripB = 0.0f;

    // Lighting
    bool m_hazardLights = false;
    bool m_headlights = false;
    bool m_highBeam = false;

    // Powertrain
    float m_motorPower = 0.0f;
    int m_regenLevel = 0;

    // Charging
    bool m_charging = false;
    float m_chargingPower = 0.0f;
    int m_chargeTimeRemaining = 0;

    // Cooling
    int m_fanSpeed = 0;
    float m_coolantTemp = 0.0f;
    float m_coolantFlow = 0.0f;
    bool m_pumpStatus = true;
    QString m_radiatorStatus = "NORMAL";

    // ==========================================================
    // WARNINGS & FAULTS
    // ==========================================================

    bool m_lowBatteryWarning = false;
    bool m_motorOverTempWarning = false;
    bool m_batteryOverTempWarning = false;
    bool m_communicationFault = false;
    bool m_lowRangeWarning = false;

    QString m_warningMessage;

    bool m_hasWarning = false;
    QString m_warningTimestamp;
    int m_historicalWarnings = 0;

    // ==========================================================
    // ENGINEER / POWERTRAIN STATUS
    // ==========================================================

    QString m_bmsStatus = "NORMAL";
    QString m_vcuStatus = "NORMAL";

    QString m_inverterStatus = "NORMAL";
    QString m_dcDcStatus = "NORMAL";
    QString m_motorControllerStatus = "NORMAL";
    QString m_driveSystemFault = "NONE";
    QString m_powerLimitState = "NONE";

    // ==========================================================
    // COMMUNICATION / TELEMETRY
    // ==========================================================

    bool m_simulationActive = true;

    QString m_uartStatus = "CONNECTED";
    QString m_parserStatus = "ACTIVE";
    QString m_loggerStatus = "READY";
    QString m_simulatorStatus = "RUNNING";

    int m_telemetryRate = 50;
    int m_frameInterval = 20;

    int m_framesReceived = 0;
    int m_invalidFrames = 0;
    int m_checksumErrors = 0;
    int m_packetLoss = 0;
};

#endif