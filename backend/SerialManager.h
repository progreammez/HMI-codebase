#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QTimer>

class SerialManager : public QObject
{
    Q_OBJECT

public:
    explicit SerialManager(QObject *parent = nullptr);

    // Opens the port. On failure (e.g. the STM32 hasn't enumerated yet at
    // boot) this returns false but ALSO arms an auto-reconnect timer, so the
    // link comes up on its own once the device appears -- the caller no
    // longer has to get the startup ordering exactly right.
    bool connectPort(const QString &portName);

    void disconnectPort();

    bool isConnected() const;

signals:
    void packetReceived(const QString &packet);

    void connectionLost();

private slots:
    void readData();
    void handleError(QSerialPort::SerialPortError error);
    void tryReconnect();

private:
    bool openPort();

    QSerialPort m_serial;
    QString m_buffer;

    QString m_portName;
    QTimer m_reconnectTimer;
    static constexpr int kReconnectIntervalMs = 2000;
};

#endif
