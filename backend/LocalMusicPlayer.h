#ifndef LOCALMUSICPLAYER_H
#define LOCALMUSICPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QStringList>

class LocalMusicPlayer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString trackTitle READ trackTitle NOTIFY trackTitleChanged)

    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)

    Q_PROPERTY(QString currentTime READ currentTime NOTIFY positionChanged)
    Q_PROPERTY(QString totalTime READ totalTime NOTIFY durationChanged)

    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)

    Q_PROPERTY(int currentTrackIndex READ currentTrackIndex NOTIFY currentTrackIndexChanged)
    Q_PROPERTY(int trackCount READ trackCount NOTIFY trackCountChanged)

    Q_PROPERTY(bool shuffleEnabled READ shuffleEnabled NOTIFY shuffleEnabledChanged)
    Q_PROPERTY(bool repeatEnabled READ repeatEnabled NOTIFY repeatEnabledChanged)

    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)

    Q_PROPERTY(QString artistName READ artistName NOTIFY artistNameChanged)
    Q_PROPERTY(QString albumName READ albumName NOTIFY albumNameChanged)

    Q_PROPERTY(QString albumArtUrl READ albumArtUrl NOTIFY albumArtUrlChanged)

public:
    explicit LocalMusicPlayer(QObject *parent = nullptr);

    QString trackTitle() const;
    QString artistName() const;
    QString albumName() const;

    qint64 duration() const;
    qint64 position() const;

    QString currentTime() const;
    QString totalTime() const;

    QString albumArtUrl() const;

    bool isPlaying() const;

    int currentTrackIndex() const;
    int trackCount() const;

    bool shuffleEnabled() const;
    bool repeatEnabled() const;

    int volume() const;
    bool muted() const;

    void setVolume(int volume);
    void setMuted(bool muted);

    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void togglePlayback();

    Q_INVOKABLE void nextTrack();
    Q_INVOKABLE void previousTrack();

    Q_INVOKABLE void seek(qint64 position);

    Q_INVOKABLE void toggleShuffle();
    Q_INVOKABLE void toggleRepeat();

    Q_INVOKABLE void toggleMute();

signals:
    void trackTitleChanged();

    void durationChanged();
    void positionChanged();

    void isPlayingChanged();

    void volumeChanged();

    void currentTrackIndexChanged();
    void trackCountChanged();

    void shuffleEnabledChanged();
    void repeatEnabledChanged();

    void mutedChanged();

    void artistNameChanged();
    void albumNameChanged();

    void albumArtUrlChanged();

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;

    QStringList m_playlist;

    int m_currentIndex = 0;

    bool m_shuffleEnabled = false;
    bool m_repeatEnabled = false;

    void loadTrack(int index);

    QString m_trackTitle;

    int m_volume = 50;
    bool m_muted = false;
    QString m_artistName = "Unknown Artist";
    QString m_albumName = "Unknown Album";
    QString m_albumArtUrl;
};

#endif