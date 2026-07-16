#include "SerialManager.h"

SerialManager::SerialManager(QObject *parent)
    : QObject(parent)
{
    connect(
        &m_serial,
        &QSerialPort::readyRead,
        this,
        &SerialManager::readData
    );

    connect(
        &m_serial,
        &QSerialPort::errorOccurred,
        this,
        &SerialManager::handleError
    );

    m_reconnectTimer.setInterval(kReconnectIntervalMs);
    connect(
        &m_reconnectTimer,
        &QTimer::timeout,
        this,
        &SerialManager::tryReconnect
    );
}

bool SerialManager::openPort()
{
    m_serial.setPortName(m_portName);

    m_serial.setBaudRate(
        QSerialPort::Baud115200
    );

    const bool ok = m_serial.open(QIODevice::ReadOnly);

    if (ok)
    {
        m_buffer.clear();          // drop any partial frame from a prior link
        m_reconnectTimer.stop();
    }

    return ok;
}

bool SerialManager::connectPort(
    const QString &portName
)
{
    m_portName = portName;

    if (openPort())
        return true;

    // Device not present yet -- keep trying in the background.
    m_reconnectTimer.start();
    return false;
}

void SerialManager::disconnectPort()
{
    m_reconnectTimer.stop();

    if (m_serial.isOpen())
        m_serial.close();
}

bool SerialManager::isConnected() const
{
    return m_serial.isOpen();
}

void SerialManager::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::NoError)
        return;

    // A resource error means the device vanished (cable pulled, STM reset).
    // Close and let the reconnect timer bring it back when it reappears.
    if (error == QSerialPort::ResourceError ||
        error == QSerialPort::PermissionError ||
        error == QSerialPort::DeviceNotFoundError)
    {
        if (m_serial.isOpen())
            m_serial.close();

        emit connectionLost();

        if (!m_portName.isEmpty() && !m_reconnectTimer.isActive())
            m_reconnectTimer.start();
    }
}

void SerialManager::tryReconnect()
{
    if (m_serial.isOpen())
    {
        m_reconnectTimer.stop();
        return;
    }

    openPort();   // stops the timer itself on success
}

void SerialManager::readData()
{
    m_buffer += m_serial.readAll();

    while (m_buffer.contains('\n'))
    {
        int index =
            m_buffer.indexOf('\n');

        QString packet =
            m_buffer.left(index).trimmed();

        m_buffer.remove(
            0,
            index + 1
        );

        emit packetReceived(packet);
    }
}
