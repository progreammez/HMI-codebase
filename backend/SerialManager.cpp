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
}

bool SerialManager::connectPort(
    const QString &portName
)
{
    m_serial.setPortName(portName);

    m_serial.setBaudRate(
        QSerialPort::Baud115200
    );

    return m_serial.open(
        QIODevice::ReadOnly
    );
}

void SerialManager::disconnectPort()
{
    m_serial.close();
}

bool SerialManager::isConnected() const
{
    return m_serial.isOpen();
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