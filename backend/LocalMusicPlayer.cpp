#include "LocalMusicPlayer.h"

#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>

LocalMusicPlayer::LocalMusicPlayer(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);

    m_player->setAudioOutput(m_audioOutput);

    m_audioOutput->setVolume(0.5);

    QDir musicDir(
        "/home/aditya/HMI-codebase/assets/music"
    );

    QStringList filters;
    filters << "*.mp3";

    m_playlist =
        musicDir.entryList(
            filters,
            QDir::Files
        );

    if (!m_playlist.isEmpty())
    {
        loadTrack(0);
    }

    connect(
        m_player,
        &QMediaPlayer::durationChanged,
        this,
        &LocalMusicPlayer::durationChanged
    );

    connect(
        m_player,
        &QMediaPlayer::positionChanged,
        this,
        &LocalMusicPlayer::positionChanged
    );

    connect(
        m_player,
        &QMediaPlayer::playbackStateChanged,
        this,
        &LocalMusicPlayer::isPlayingChanged
    );

    connect(
        m_player,
        &QMediaPlayer::mediaStatusChanged,
        this,
        [this](QMediaPlayer::MediaStatus status)
        {
            if (status == QMediaPlayer::EndOfMedia)
            {
                if (m_repeatEnabled)
                {
                    m_player->setPosition(0);
                    m_player->play();
                }
                else
                {
                    nextTrack();
                }
            }
        }
    );
}

void LocalMusicPlayer::loadTrack(int index)
{
    if (index < 0 || index >= m_playlist.size())
        return;

    m_currentIndex = index;

    QString songPath =
        "/home/aditya/HMI-codebase/assets/music/"
        + m_playlist[index];

    m_trackTitle =
        QFileInfo(songPath).baseName();

    emit trackTitleChanged();
    emit currentTrackIndexChanged();

    m_player->setSource(
        QUrl::fromLocalFile(songPath)
    );
}

QString LocalMusicPlayer::trackTitle() const
{
    return m_trackTitle;
}

qint64 LocalMusicPlayer::duration() const
{
    return m_player->duration();
}

qint64 LocalMusicPlayer::position() const
{
    return m_player->position();
}

QString LocalMusicPlayer::currentTime() const
{
    int totalSeconds =
        m_player->position() / 1000;

    int minutes =
        totalSeconds / 60;

    int seconds =
        totalSeconds % 60;

    return QString("%1:%2")
        .arg(minutes)
        .arg(seconds, 2, 10, QChar('0'));
}

QString LocalMusicPlayer::totalTime() const
{
    int totalSeconds =
        m_player->duration() / 1000;

    int minutes =
        totalSeconds / 60;

    int seconds =
        totalSeconds % 60;

    return QString("%1:%2")
        .arg(minutes)
        .arg(seconds, 2, 10, QChar('0'));
}

bool LocalMusicPlayer::isPlaying() const
{
    return m_player->playbackState()
           == QMediaPlayer::PlayingState;
}

float LocalMusicPlayer::volume() const
{
    return m_audioOutput->volume();
}

void LocalMusicPlayer::setVolume(float value)
{
    if (value < 0.0f)
        value = 0.0f;

    if (value > 1.0f)
        value = 1.0f;

    m_audioOutput->setVolume(value);

    emit volumeChanged();
}

int LocalMusicPlayer::currentTrackIndex() const
{
    return m_currentIndex + 1;
}

int LocalMusicPlayer::trackCount() const
{
    return m_playlist.size();
}

bool LocalMusicPlayer::shuffleEnabled() const
{
    return m_shuffleEnabled;
}

bool LocalMusicPlayer::repeatEnabled() const
{
    return m_repeatEnabled;
}

void LocalMusicPlayer::play()
{
    m_player->play();
}

void LocalMusicPlayer::pause()
{
    m_player->pause();
}

void LocalMusicPlayer::togglePlayback()
{
    if (isPlaying())
        pause();
    else
        play();
}

void LocalMusicPlayer::seek(qint64 position)
{
    m_player->setPosition(position);
}

void LocalMusicPlayer::toggleShuffle()
{
    m_shuffleEnabled =
        !m_shuffleEnabled;

    emit shuffleEnabledChanged();
}

void LocalMusicPlayer::toggleRepeat()
{
    m_repeatEnabled =
        !m_repeatEnabled;

    emit repeatEnabledChanged();
}

void LocalMusicPlayer::nextTrack()
{
    if (m_playlist.isEmpty())
        return;

    if (m_shuffleEnabled)
    {
        m_currentIndex =
            QRandomGenerator::global()->bounded(
                m_playlist.size()
            );
    }
    else
    {
        m_currentIndex++;

        if (m_currentIndex >= m_playlist.size())
        {
            m_currentIndex = 0;
        }
    }

    loadTrack(m_currentIndex);

    play();
}

void LocalMusicPlayer::previousTrack()
{
    if (m_playlist.isEmpty())
        return;

    m_currentIndex--;

    if (m_currentIndex < 0)
    {
        m_currentIndex =
            m_playlist.size() - 1;
    }

    loadTrack(m_currentIndex);

    play();
}