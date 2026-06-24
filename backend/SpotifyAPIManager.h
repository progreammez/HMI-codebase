#ifndef SPOTIFYAPIMANAGER_H
#define SPOTIFYAPIMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QList>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>

struct SpotifyTrack
{
    QString id;
    QString title;
    QString artist;
    QString album;
    QString imageUrl;
};

struct SpotifyLyricLine
{
    qint64 timestamp;
    QString text;
};

class SpotifyApiManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList trackTitles READ trackTitles NOTIFY searchResultsChanged)
    Q_PROPERTY(QVariantList tracks READ tracks NOTIFY searchResultsChanged)
    Q_PROPERTY(QString currentLyric READ currentLyric NOTIFY currentLyricChanged)
    Q_PROPERTY(QStringList lyricList READ lyricList NOTIFY lyricsChanged)
    Q_PROPERTY(QString selectedTitle READ selectedTitle NOTIFY selectedTrackChanged)
    Q_PROPERTY(QString selectedArtist READ selectedArtist NOTIFY selectedTrackChanged)
    Q_PROPERTY(QString selectedImageUrl READ selectedImageUrl NOTIFY selectedTrackChanged)
    Q_PROPERTY(QString selectedAlbum READ selectedAlbum NOTIFY selectedTrackChanged)

    // Dedicated Queue Subsystem Properties
    Q_PROPERTY(QStringList queueTitles READ queueTitles NOTIFY queueChanged)
    Q_PROPERTY(int currentTrackIndex READ currentTrackIndex NOTIFY currentTrackIndexChanged)

public:
    explicit SpotifyApiManager(QObject *parent = nullptr);

    Q_INVOKABLE void searchTracks(const QString &query);
    Q_INVOKABLE void loadLyrics(const QString &trackId);
    Q_INVOKABLE void selectTrack(int index);
    
    // Type-safe structural interfaces matching front-end layouts
    Q_INVOKABLE void addToQueue(int index);
    Q_INVOKABLE void playQueueTrack(int index);

    QStringList trackTitles() const;
    QVariantList tracks() const;
    QString currentLyric() const;
    QStringList lyricList() const;

    QString selectedTitle() const;
    QString selectedArtist() const;
    QString selectedImageUrl() const;
    QString selectedAlbum() const;

    // Queue read permissions properties
    QStringList queueTitles() const;
    int currentTrackIndex() const;

signals:
    void searchFinished(QString result);
    void searchResultsChanged();
    void currentLyricChanged();
    void lyricsChanged();
    void selectedTrackChanged();
    void queueChanged();
    void currentTrackIndexChanged();

private:
    QNetworkAccessManager m_network;
    QList<SpotifyTrack> m_tracks;

    QString loadApiKey();
    QVector<SpotifyLyricLine> m_lyrics;
    QStringList m_lyricList;
    QString m_currentLyric;

    QString m_selectedTitle;
    QString m_selectedArtist;
    QString m_selectedImageUrl;
    QString m_selectedAlbum;

    // Core vector structures containing the playlist queues
    QList<SpotifyTrack> m_queue;
    int m_currentTrackIndex = -1;
};

#endif // SPOTIFYAPIMANAGER_H