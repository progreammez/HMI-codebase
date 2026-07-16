#pragma once

#include <QObject>
#include <QTimer>
#include <QStringList>

class BluetoothManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString deviceName READ deviceName NOTIFY deviceChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY deviceChanged)
    Q_PROPERTY(int battery READ battery NOTIFY deviceChanged)
    Q_PROPERTY(QString deviceIcon READ deviceIcon NOTIFY deviceChanged)
    Q_PROPERTY(QStringList availableDevices READ availableDevices NOTIFY availableDevicesChanged)
    Q_PROPERTY(QStringList availableDeviceNames READ availableDeviceNames NOTIFY availableDevicesChanged)
    Q_PROPERTY(QStringList availableDeviceMacs READ availableDeviceMacs NOTIFY availableDevicesChanged)
    Q_PROPERTY(QString activeAudioDevice READ activeAudioDevice NOTIFY deviceChanged)
    Q_PROPERTY(
    QStringList connectedDeviceNames
    READ connectedDeviceNames
    NOTIFY deviceChanged
)

public:
    explicit BluetoothManager(QObject *parent = nullptr);

    QString deviceName() const;
    bool connected() const;
    int battery() const;
    QString deviceIcon() const;
    QStringList availableDevices() const;
    QStringList availableDeviceNames() const;
    QStringList availableDeviceMacs() const;
    QString activeAudioDevice() const;
    QStringList connectedDeviceNames() const;
    Q_INVOKABLE void refresh();
    Q_INVOKABLE void scanDevices();
    Q_INVOKABLE void connectDevice(int index);
    Q_INVOKABLE void disconnectDevice(int index);

signals:
    void deviceChanged();
    void availableDevicesChanged();

private:
    QString m_deviceName = "No Device";
    QString m_deviceMac;
    QString m_deviceIcon = "audio-headset";
    QStringList m_availableDevices;
    QStringList m_availableDeviceNames;
    QStringList m_availableDeviceMacs;
    QString m_activeAudioDevice;
    QStringList m_connectedDeviceNames;
    bool m_connected = false;
    int m_battery = -1;

    QTimer m_refreshTimer;
};