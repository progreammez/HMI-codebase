#include "DriverInput.h"

#include <QEvent>
#include <QKeyEvent>

DriverInput::DriverInput(QObject *parent)
    : QObject(parent)
{
    qDebug() << "DriverInput created:" << this;
}

bool DriverInput::eventFilter(QObject *, QEvent *event)
{
    if (event->type() != QEvent::KeyPress &&
        event->type() != QEvent::KeyRelease)
        return false;

    auto *key = static_cast<QKeyEvent*>(event);

    if (key->isAutoRepeat())
        return true;   // swallow repeats too, don't let them bubble

    bool handled = true;

    switch (key->key())
    {
    case Qt::Key_W:
        emit acceleratePressed(event->type() == QEvent::KeyPress);
        break;

    case Qt::Key_S:
        emit brakePressed(event->type() == QEvent::KeyPress);
        break;

    default:
        if (event->type() == QEvent::KeyRelease)
        {
            handled = false; // no release behavior for toggle-only keys
        }
        break;
    }

    if (event->type() == QEvent::KeyPress)
    {
        switch (key->key())
        {
        case Qt::Key_U: emit gearChanged("P"); break;
        case Qt::Key_I: emit gearChanged("R"); break;
        case Qt::Key_O: emit gearChanged("N"); break;
        case Qt::Key_P: emit gearChanged("D"); break;
        case Qt::Key_H: emit headlightsPressed(); break;
        case Qt::Key_B: emit highBeamPressed(); break;
        case Qt::Key_J: emit leftIndicatorPressed(); break;
        case Qt::Key_K: emit hazardPressed(); break;
        case Qt::Key_L: emit rightIndicatorPressed(); break;
        case Qt::Key_R: emit regenPressed(); break;
        case Qt::Key_C: emit cruisePressed(); break;
        case Qt::Key_M: emit chargingPressed(); break;
        case Qt::Key_Space: emit handBrakePressed(); break;
        case Qt::Key_V: emit driveModePressed(); break;
        default:
            handled = false;
            break;
        }
    }

    if (handled)
        event->accept();

    return handled;
}