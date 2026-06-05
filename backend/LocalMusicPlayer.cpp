#include "LocalMusicPlayer.h"

#include <QUrl>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>
#include <QMediaMetaData>
#include <QDebug>

LocalMusicPlayer::LocalMusicPlayer(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);

    m_player->setAudioOutput(m_audioOutput);

    m_volume = 50;
    m_audioOutput->setVolume(0.5);

    QDir musicDir("/home/notbigboi/EV_HMI/assets/music/");

    QStringList filters;
    filters << "*.mp3";

    m_playlist = musicDir.entryList(filters,QDir::Files);

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

    connect(
        m_player,
        &QMediaPlayer::metaDataChanged,
        this,
        [this]()
        {
            QString artist =
                m_player->metaData().value(
                    QMediaMetaData::ContributingArtist
                ).toString();

            QString album =
                m_player->metaData().value(
                    QMediaMetaData::AlbumTitle
                ).toString();

            if (!artist.isEmpty())
                m_artistName = artist;

            if (!album.isEmpty())
                m_albumName = album;

            emit artistNameChanged();
            emit albumNameChanged();
        }
    );

    connect(
        m_player,
        &QMediaPlayer::positionChanged,
        this,
        [this](qint64 position)
        {
            updateCurrentLyric(position);
        });
}

void LocalMusicPlayer::loadTrack(int index)
{
    if (index < 0 || index >= m_playlist.size())
        return;

    m_currentIndex = index;

    QString songPath = "/home/notbigboi/EV_HMI/assets/music/" + m_playlist[index];
    QString coverPath = "/home/notbigboi/EV_HMI/assets/albumcovers/" + QFileInfo(songPath).baseName() + ".png";

    if (QFile::exists(coverPath))
    {
        m_albumArtUrl =
            QUrl::fromLocalFile(coverPath).toString();
    }
    else
    {
        m_albumArtUrl =
            "qrc:/assets/music/placeholder/default_cover.png";
    }

    m_trackTitle = QFileInfo(songPath).baseName();

    emit trackTitleChanged();
    emit currentTrackIndexChanged();
    m_artistName = "Unknown Artist";
    m_albumName = "Unknown Album";

    emit artistNameChanged();
    emit albumNameChanged();
    emit albumArtUrlChanged();

    loadLyrics(m_trackTitle);

    m_player->setSource(QUrl::fromLocalFile(songPath));
}

void LocalMusicPlayer::loadLyrics(const QString &trackName)
{
    m_lyrics.clear();
    m_lyricList.clear();

    QString filePath = "../assets/music/lyrics/" + trackName + ".lrc";

    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "FAILED OPEN:" << filePath;
        return;
    }

    QTextStream in(&file);

    QRegularExpression re(
        R"(\[(\d+):(\d+\.\d+)\](.*))");

    while (!in.atEnd())
    {   
        QString line = in.readLine();

        auto match = re.match(line);

        if (!match.hasMatch())
        {
            qDebug() << "NO MATCH" << line;
            continue;
        }

        int minutes =
            match.captured(1).toInt();

        double seconds =
            match.captured(2).toDouble();

        QString text =
            match.captured(3).trimmed();

        LyricLine lyric;

        lyric.timestamp =
            (minutes * 60000)
            + (seconds * 1000);

        lyric.text = text;

        m_lyrics.append(lyric);
        m_lyricList.append(text);
    }
    emit lyricsLoadedChanged();
}

void LocalMusicPlayer::updateCurrentLyric(
    qint64 position)
{
    for (int i = m_lyrics.size() - 1;
         i >= 0;
         --i)
    {
        if (position >=
            m_lyrics[i].timestamp)
        {
            if (m_currentLyric != m_lyrics[i].text)
            {
                m_currentLyric = m_lyrics[i].text;
                m_currentLyricIndex = i;

                m_previousLyric =
                    (i > 0)
                        ? m_lyrics[i - 1].text
                        : "";

                m_nextLyric =
                    (i < m_lyrics.size() - 1)
                        ? m_lyrics[i + 1].text
                        : "";

                emit currentLyricChanged();
                emit currentLyricIndexChanged();
            }
            return;
        }
    }
}

void LocalMusicPlayer::playTrack(int index)
{
    if (index < 0 || index >= m_playlist.size())
        return;

    loadTrack(index);

    m_player->play();

    emit isPlayingChanged();
}

QStringList LocalMusicPlayer::playlistTitles() const
{
    QStringList titles;

    for (const QString &track : m_playlist)
    {
        titles.append(QFileInfo(track).baseName());
    }

    return titles;
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
    int totalSeconds = m_player->position() / 1000;

    int minutes = totalSeconds / 60;

    int seconds = totalSeconds % 60;

    return QString("%1:%2")
        .arg(minutes)
        .arg(seconds, 2, 10, QChar('0'));
}

QString LocalMusicPlayer::totalTime() const
{
    int totalSeconds = m_player->duration() / 1000;

    int minutes = totalSeconds / 60;

    int seconds = totalSeconds % 60;

    return QString("%1:%2")
        .arg(minutes)
        .arg(seconds, 2, 10, QChar('0'));
}

bool LocalMusicPlayer::isPlaying() const
{
    return m_player->playbackState() == QMediaPlayer::PlayingState;
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

int LocalMusicPlayer::volume() const
{
    return m_volume;
}

bool LocalMusicPlayer::muted() const
{
    return m_muted;
}

void LocalMusicPlayer::play()
{
    m_player->play();
}

void LocalMusicPlayer::pause()
{
    m_player->pause();
}

QString LocalMusicPlayer::artistName() const
{
    return m_artistName;
}

QString LocalMusicPlayer::albumName() const
{
    return m_albumName;
}

QString LocalMusicPlayer::albumArtUrl() const
{
    return m_albumArtUrl;
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
    m_shuffleEnabled = !m_shuffleEnabled;

    emit shuffleEnabledChanged();
}

void LocalMusicPlayer::toggleRepeat()
{
    m_repeatEnabled = !m_repeatEnabled;

    emit repeatEnabledChanged();
}

void LocalMusicPlayer::nextTrack()
{
    if (m_playlist.isEmpty())
        return;

    if (m_shuffleEnabled)
    {
        m_currentIndex = QRandomGenerator::global()->bounded(m_playlist.size());
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
        m_currentIndex = m_playlist.size() - 1;
    }

    loadTrack(m_currentIndex);

    play();
}

void LocalMusicPlayer::setVolume(int volume)
{
    if (volume < 0)
        volume = 0;

    if (volume > 100)
        volume = 100;

    if (m_volume == volume)
        return;

    m_volume = volume;

    m_audioOutput->setVolume(m_volume / 100.0);

    emit volumeChanged();
}

void LocalMusicPlayer::setMuted(bool muted)
{
    if (m_muted == muted)
        return;

    m_muted = muted;

    m_audioOutput->setMuted(m_muted);

    emit mutedChanged();
}

void LocalMusicPlayer::toggleMute()
{
    setMuted(!m_muted);
}

QString LocalMusicPlayer::currentLyric() const
{
    return m_currentLyric;
}

QString LocalMusicPlayer::previousLyric() const
{
    return m_previousLyric;
}

QString LocalMusicPlayer::nextLyric() const
{
    return m_nextLyric;
}

QStringList LocalMusicPlayer::lyricList() const
{
    return m_lyricList;
}

int LocalMusicPlayer::currentLyricIndex() const
{
    return m_currentLyricIndex;
}