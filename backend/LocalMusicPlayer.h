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

    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)

    Q_PROPERTY(int currentTrackIndex READ currentTrackIndex NOTIFY currentTrackIndexChanged)
    Q_PROPERTY(int trackCount READ trackCount NOTIFY trackCountChanged)

    Q_PROPERTY(bool shuffleEnabled READ shuffleEnabled NOTIFY shuffleEnabledChanged)
    Q_PROPERTY(bool repeatEnabled READ repeatEnabled NOTIFY repeatEnabledChanged)

public:
    explicit LocalMusicPlayer(QObject *parent = nullptr);

    QString trackTitle() const;

    qint64 duration() const;
    qint64 position() const;

    QString currentTime() const;
    QString totalTime() const;

    bool isPlaying() const;

    float volume() const;
    void setVolume(float value);

    int currentTrackIndex() const;
    int trackCount() const;

    bool shuffleEnabled() const;
    bool repeatEnabled() const;

    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void togglePlayback();

    Q_INVOKABLE void nextTrack();
    Q_INVOKABLE void previousTrack();

    Q_INVOKABLE void seek(qint64 position);

    Q_INVOKABLE void toggleShuffle();
    Q_INVOKABLE void toggleRepeat();

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

private:
    void loadTrack(int index);

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;

    QStringList m_playlist;

    int m_currentIndex = 0;

    bool m_shuffleEnabled = false;
    bool m_repeatEnabled = false;

    QString m_trackTitle;
};

#endif