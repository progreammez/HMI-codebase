#pragma once

#include <QObject>

class DriverInput : public QObject
{
    Q_OBJECT

public:
    explicit DriverInput(QObject *parent = nullptr);

    bool eventFilter(QObject *obj, QEvent *event) override;

signals:

    // Driving
    void acceleratePressed(bool);
    void brakePressed(bool);

    // Gear
    void gearChanged(QString);

    // Lights
    void headlightsPressed();
    void highBeamPressed();

    // Indicators
    void leftIndicatorPressed();
    void rightIndicatorPressed();
    void hazardPressed();

    // Charging
    void chargingPressed();

    // Regen
    void regenPressed();

    // Cruise
    void cruisePressed();

    // Handbrake
    void handBrakePressed();
};