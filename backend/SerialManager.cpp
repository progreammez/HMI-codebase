#include "SerialManager.h"

SerialManager::SerialManager(QObject *parent)
    : QObject(parent)
{
}

bool SerialManager::connectPort(const QString &portName)
{
    Q_UNUSED(portName)

    return false;
}

void SerialManager::disconnectPort()
{
}

bool SerialManager::isConnected() const
{
    return false;
}