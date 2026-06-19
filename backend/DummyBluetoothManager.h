#pragma once

#include <QObject>
#include <QStringList>

class DummyBluetoothManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString deviceName READ deviceName CONSTANT)
    Q_PROPERTY(bool connected READ connected CONSTANT)
    Q_PROPERTY(int battery READ battery CONSTANT)
    Q_PROPERTY(QString activeAudioDevice READ activeAudioDevice CONSTANT)
    Q_PROPERTY(QStringList connectedDeviceNames READ connectedDeviceNames CONSTANT)

public:
    explicit DummyBluetoothManager(QObject *parent = nullptr);

    QString deviceName() const { return ""; }
    bool connected() const { return false; }
    int battery() const { return -1; }
    QString activeAudioDevice() const { return ""; }
    QStringList connectedDeviceNames() const { return {}; }
};