#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>

class SerialManager : public QObject
{
    Q_OBJECT

public:
    explicit SerialManager(QObject *parent = nullptr);

    bool connectPort(const QString &portName);

    void disconnectPort();

    bool isConnected() const;

signals:
    void packetReceived(const QString &packet);

    void connectionLost();

private:
};

#endif // SERIALMANAGER_H