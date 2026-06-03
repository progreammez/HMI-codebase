#ifndef SPOTIFYAPIMANAGER_H
#define SPOTIFYAPIMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QVector>

struct SpotifyTrack
{
    QString id;
    QString title;
    QString artist;
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

public:
    explicit SpotifyApiManager(QObject *parent = nullptr);

    Q_INVOKABLE void searchTracks(const QString &query);
    Q_INVOKABLE void loadLyrics(const QString &trackId);
    Q_INVOKABLE void selectTrack(int index);
    QStringList trackTitles() const;

    QVariantList tracks() const;
    QString currentLyric() const;
    QStringList lyricList() const;

    QString selectedTitle() const;
    QString selectedArtist() const;
    QString selectedImageUrl() const;

signals:
    void searchFinished(QString result);
    void searchResultsChanged();
    void currentLyricChanged();
    void lyricsChanged();
    void selectedTrackChanged();

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
};

#endif