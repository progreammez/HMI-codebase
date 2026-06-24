// Storing state variables for the vehicle and providing a way to update them from the simulator

#ifndef VEHICLEDATA_H
#define VEHICLEDATA_H

#include <QObject>
#include <QString>

class VehicleData : public QObject
{
    Q_OBJECT // Define properties for the vehicle data that can be accessed and modified from QML
    /*
    Property Name  : speed
    Getter         : speed()
    Setter         : setSpeed()
    Signal         : speedChanged()
    */
    Q_PROPERTY(int rpm READ rpm WRITE setRpm NOTIFY rpmChanged)
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int batteryPercent READ batteryPercent WRITE setBatteryPercent NOTIFY batteryPercentChanged)

    Q_PROPERTY(int motorTemp READ motorTemp WRITE setMotorTemp NOTIFY motorTempChanged)
    Q_PROPERTY(int batteryTemp READ batteryTemp WRITE setBatteryTemp NOTIFY batteryTempChanged)
    Q_PROPERTY(int controllerTemp READ controllerTemp WRITE setControllerTemp NOTIFY controllerTempChanged)

    Q_PROPERTY(int rangeKm READ rangeKm WRITE setRangeKm NOTIFY rangeKmChanged)

    Q_PROPERTY(QString driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    Q_PROPERTY(QString gearState READ gearState WRITE setGearState NOTIFY gearStateChanged)

    Q_PROPERTY(bool leftIndicator READ leftIndicator WRITE setLeftIndicator NOTIFY leftIndicatorChanged)
    Q_PROPERTY(bool rightIndicator READ rightIndicator WRITE setRightIndicator NOTIFY rightIndicatorChanged)
    Q_PROPERTY(bool hazardLights READ hazardLights WRITE setHazardLights NOTIFY hazardLightsChanged)

    Q_PROPERTY(bool headlights READ headlights WRITE setHeadlights NOTIFY headlightsChanged)
    Q_PROPERTY(bool highBeam READ highBeam WRITE setHighBeam NOTIFY highBeamChanged)

    Q_PROPERTY(float motorPower READ motorPower WRITE setMotorPower NOTIFY motorPowerChanged)
    Q_PROPERTY(int regenLevel READ regenLevel WRITE setRegenLevel NOTIFY regenLevelChanged)

    Q_PROPERTY(float odometer READ odometer WRITE setOdometer NOTIFY odometerChanged)
    Q_PROPERTY(float tripDistance READ tripDistance WRITE setTripDistance NOTIFY tripDistanceChanged)
    
    Q_PROPERTY(float tripA READ tripA WRITE settripA NOTIFY tripAChanged)
    Q_PROPERTY(float tripB READ tripB WRITE settripB NOTIFY tripBChanged)

    Q_PROPERTY(bool lowBatteryWarning READ lowBatteryWarning WRITE setLowBatteryWarning NOTIFY lowBatteryWarningChanged)
    Q_PROPERTY(bool motorOverTempWarning READ motorOverTempWarning WRITE setMotorOverTempWarning NOTIFY motorOverTempWarningChanged)
    Q_PROPERTY(bool batteryOverTempWarning READ batteryOverTempWarning WRITE setBatteryOverTempWarning NOTIFY batteryOverTempWarningChanged)
    Q_PROPERTY(bool communicationFault READ communicationFault WRITE setCommunicationFault NOTIFY communicationFaultChanged)
    Q_PROPERTY(bool lowRangeWarning READ lowRangeWarning WRITE setLowRangeWarning NOTIFY lowRangeWarningChanged)
    Q_PROPERTY(QString warningMessage READ warningMessage WRITE setWarningMessage NOTIFY warningMessageChanged)

    Q_PROPERTY(bool hasWarning READ hasWarning WRITE setHasWarning NOTIFY hasWarningChanged)
    Q_PROPERTY(QString warningTimestamp READ warningTimestamp WRITE setWarningTimestamp NOTIFY warningTimestampChanged)
    Q_PROPERTY(int historicalWarnings READ historicalWarnings WRITE setHistoricalWarnings NOTIFY historicalWarningsChanged)

    Q_PROPERTY(bool simulationActive READ simulationActive WRITE setSimulationActive NOTIFY simulationActiveChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);
    // Getter functions
    int rpm() const;
    int speed() const;
    int batteryPercent() const;

    int motorTemp() const;
    int batteryTemp() const;
    int controllerTemp() const;

    int rangeKm() const;

    QString driveMode() const;
    QString gearState() const;

    bool leftIndicator() const;
    bool rightIndicator() const;
    bool hazardLights() const;
    
    bool headlights() const;
    bool highBeam() const;

    float motorPower() const;
    int regenLevel() const;

    float odometer() const;
    float tripDistance() const;
    float tripA() const;
    float tripB() const;

    bool lowBatteryWarning() const;
    bool motorOverTempWarning() const;
    bool batteryOverTempWarning() const;
    bool communicationFault() const;
    bool lowRangeWarning() const;
    QString warningMessage() const;
    bool simulationActive() const; // Backing getter for simulation configuration states

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

    // Setter functions
    /*
    Receive new value
    Store value
    Notify UI
    */
    void setRpm(int rpm);
    void setSpeed(int speed);
    void setBatteryPercent(int batteryPercent);

    void setMotorTemp(int motorTemp);
    void setBatteryTemp(int batteryTemp);
    void setControllerTemp(int controllerTemp);
    
    void setRangeKm(int rangeKm);

    void setDriveMode(const QString &driveMode);
    void setGearState(const QString &gearState);

    void setLeftIndicator(bool leftIndicator);
    void setRightIndicator(bool rightIndicator);
    void setHazardLights(bool hazardLights);

    void setHeadlights(bool headlights);
    void setHighBeam(bool highBeam);

    void setMotorPower(float motorPower);
    void setRegenLevel(int regenLevel);

    void setOdometer(float odometer);
    void setTripDistance(float tripDistance);
       
    void settripA(float tripA);
    void settripB(float tripB);

    void setLowBatteryWarning(bool lowBatteryWarning);
    void setMotorOverTempWarning(bool motorOverTempWarning);
    void setBatteryOverTempWarning(bool batteryOverTempWarning);
    void setCommunicationFault(bool communicationFault);
    void setLowRangeWarning(bool lowRangeWarning);
    void setWarningMessage(const QString &warningMessage);
    void setSimulationActive(bool active);

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

signals:
    // Signals to notify the UI when a value changes
    void rpmChanged();
    void speedChanged();
    void batteryPercentChanged();

    void motorTempChanged();
    void batteryTempChanged();
    void controllerTempChanged();

    void rangeKmChanged();

    void driveModeChanged();
    void gearStateChanged();

    void leftIndicatorChanged();
    void rightIndicatorChanged();
    void hazardLightsChanged();

    void headlightsChanged();
    void highBeamChanged();

    void motorPowerChanged();
    void regenLevelChanged();

    void odometerChanged();
    void tripDistanceChanged();
    void tripAChanged();
    void tripBChanged();
    
    void lowBatteryWarningChanged();
    void motorOverTempWarningChanged();
    void batteryOverTempWarningChanged();
    void communicationFaultChanged();
    void lowRangeWarningChanged();
    void warningMessageChanged();
    
    void telemetryChanged();
    void hasWarningChanged();
    void warningTimestampChanged();
    void historicalWarningsChanged();
    void simulationActiveChanged();

private:
    // Member variables to store the current state of the vehicle
    int m_rpm;
    int m_speed;
    int m_batteryPercent;

    int m_motorTemp;
    int m_batteryTemp;
    int m_controllerTemp;
    
    int m_rangeKm;

    QString m_driveMode;
    QString m_gearState;

    bool m_leftIndicator;
    bool m_rightIndicator;
    bool m_hazardLights;

    bool m_headlights;
    bool m_highBeam;

    float m_motorPower;
    int m_regenLevel;

    float m_odometer;
    float m_tripDistance;
    float m_tripA;
    float m_tripB;

    bool m_lowBatteryWarning;
    bool m_motorOverTempWarning;
    bool m_batteryOverTempWarning;
    bool m_communicationFault;
    bool m_lowRangeWarning;
    QString m_warningMessage;

    bool m_hasWarning = false;
    QString m_warningTimestamp;
    int m_historicalWarnings = 0;
    bool m_simulationActive = true;
};

#endif