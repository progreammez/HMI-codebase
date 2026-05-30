#include "LocalMusicPlayer.h"

#include <QUrl>

LocalMusicPlayer::LocalMusicPlayer(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);

    m_player->setAudioOutput(m_audioOutput);

    m_audioOutput->setVolume(0.5);

    m_player->setSource(
    QUrl::fromLocalFile(
        "/mnt/c/Users/Aditya/OneDrive/Desktop/Mugic/Angrezi/The Less I Know The Better.mp3"
        )
    );
}

void LocalMusicPlayer::play()
{
    m_player->play();
}