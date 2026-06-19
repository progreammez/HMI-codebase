#include "BluetoothManager.h"

#include <QProcess>
#include <QRegularExpression>
#include <QDebug>

BluetoothManager::BluetoothManager(QObject *parent)
    : QObject(parent)
{
    connect(
        &m_refreshTimer,
        &QTimer::timeout,
        this,
        &BluetoothManager::refresh
    );

    m_refreshTimer.start(5000);

    refresh();
}

QString BluetoothManager::deviceName() const
{
    return m_deviceName;
}

bool BluetoothManager::connected() const
{
    return m_connected;
}

int BluetoothManager::battery() const
{
    return m_battery;
}

QString BluetoothManager::deviceIcon() const
{
    return m_deviceIcon;
}

QStringList BluetoothManager::availableDevices() const
{
    return m_availableDevices;
}

QStringList BluetoothManager::availableDeviceNames() const
{
    return m_availableDeviceNames;
}

QStringList BluetoothManager::availableDeviceMacs() const
{
    return m_availableDeviceMacs;
}

QString BluetoothManager::activeAudioDevice() const
{
    return m_activeAudioDevice;
}

QStringList BluetoothManager::connectedDeviceNames() const
{
    return m_connectedDeviceNames;
}

void BluetoothManager::refresh()
{
    // =========================
    // CONNECTED DEVICES
    // =========================

    QProcess process;

    process.start(
        "bluetoothctl",
        QStringList() << "devices" << "Connected"
    );

    process.waitForFinished();

    QString output =
        process.readAllStandardOutput();

    m_connectedDeviceNames.clear();

    QStringList connectedLines =
        output.split('\n', Qt::SkipEmptyParts);

    for (const QString &line : connectedLines)
    {
        QRegularExpression rx(
            R"(Device\s+([0-9A-F:]+)\s+(.+))"
        );

        auto match = rx.match(line);

        if (match.hasMatch())
        {
            m_connectedDeviceNames.append(
                match.captured(2).trimmed()
            );
        }
    }

    qDebug()
        << "CONNECTED DEVICES:"
        << m_connectedDeviceNames;

    m_connected =
        !m_connectedDeviceNames.isEmpty();

    // =========================
    // FIRST CONNECTED DEVICE
    // =========================

    m_deviceMac.clear();

    if (m_connected)
    {
        QRegularExpression rx(
            R"(Device\s+([0-9A-F:]+)\s+(.+))"
        );

        auto match =
            rx.match(output);

        if (match.hasMatch())
        {
            m_deviceMac =
                match.captured(1);
        }
    }

    // =========================
    // DEVICE INFO
    // =========================

    QString info;

    if (!m_deviceMac.isEmpty())
    {
        QProcess infoProcess;

        infoProcess.start(
            "bluetoothctl",
            QStringList()
                << "info"
                << m_deviceMac
        );

        infoProcess.waitForFinished();

        info =
            infoProcess.readAllStandardOutput();
    }

    QRegularExpression batteryRx(
        R"(Battery Percentage:\s+0x[0-9A-Fa-f]+\s+\((\d+)\))"
    );

    auto batteryMatch =
        batteryRx.match(info);

    if (batteryMatch.hasMatch())
    {
        m_battery =
            batteryMatch.captured(1).toInt();
    }
    else
    {
        m_battery = -1;
    }

    QRegularExpression iconRx(
        R"(Icon:\s+(.+))"
    );

    auto iconMatch =
        iconRx.match(info);

    if (iconMatch.hasMatch())
    {
        m_deviceIcon =
            iconMatch.captured(1).trimmed();
    }

    // =========================
    // PIPEWIRE ACTIVE AUDIO
    // =========================

    QProcess audioProcess;

    audioProcess.start(
        "wpctl",
        QStringList() << "status"
    );

    audioProcess.waitForFinished();

    QString wpctlOutput =
        audioProcess.readAllStandardOutput();

    QRegularExpression activeSinkRx(
        R"(Sinks:[\s\S]*?\*\s+\d+\.\s+(.+?)\s+\[vol:)"
    );

    auto sinkMatch =
        activeSinkRx.match(wpctlOutput);

    if (sinkMatch.hasMatch())
    {
        m_activeAudioDevice =
            sinkMatch.captured(1).trimmed();

        qDebug()
            << "Active audio:"
            << m_activeAudioDevice;
    }
    else
    {
        m_activeAudioDevice.clear();
    }

    // =========================
    // MAIN DEVICE SHOWN IN UI
    // =========================

    if (!m_activeAudioDevice.isEmpty())
    {
        m_deviceName =
            m_activeAudioDevice;

        m_connected = true;
    }
    else if (!m_connectedDeviceNames.isEmpty())
    {
        m_deviceName =
            m_connectedDeviceNames.first();
    }
    else
    {
        m_deviceName = "No Device";
        m_connected = false;
    }

    emit deviceChanged();
}

void BluetoothManager::scanDevices()
{
    QProcess process;
    m_availableDeviceNames.clear();
    m_availableDeviceMacs.clear();

    process.start(
        "bash",
        QStringList()
            << "-c"
            << "bluetoothctl devices"
    );

    process.waitForFinished();

    QString output = process.readAllStandardOutput();

    QStringList lines =
        output.split('\n', Qt::SkipEmptyParts);


    for (const QString &line : lines)
    {
        QRegularExpression rx(R"(Device\s+([0-9A-F:]+)\s+(.+))");

        auto match = rx.match(line);

        
        if(match.hasMatch())
        {
            m_availableDeviceMacs.append(match.captured(1));
            m_availableDeviceNames.append(match.captured(2));
        }
    }

    emit availableDevicesChanged();
}

void BluetoothManager::connectDevice(int index)
{
    if(index < 0 ||
       index >= m_availableDeviceMacs.size())
        return;

    QString mac =
        m_availableDeviceMacs[index];

    QProcess::execute(
        "bluetoothctl",
        QStringList()
            << "connect"
            << mac
    );

    QTimer::singleShot(
        2000,
        this,
        &BluetoothManager::refresh
    );
}

void BluetoothManager::disconnectDevice(int index)
{
    if(index < 0 ||
       index >= m_availableDeviceMacs.size())
        return;

    QString mac = m_availableDeviceMacs[index];

    QProcess::execute(
        "bluetoothctl",
        QStringList()
            << "disconnect"
            << mac
    );
    QTimer::singleShot(
        2000,
        this,
        &BluetoothManager::refresh
    );
}