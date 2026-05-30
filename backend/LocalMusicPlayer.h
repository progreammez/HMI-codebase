#ifndef LOCALMUSICPLAYER_H
#define LOCALMUSICPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>

class LocalMusicPlayer : public QObject
{
    Q_OBJECT

public:
    explicit LocalMusicPlayer(QObject *parent = nullptr);

    void play();

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
};

#endif