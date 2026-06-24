#include "SpotifyAPIManager.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QDebug>
#include <QUrlQuery>

SpotifyApiManager::SpotifyApiManager(QObject *parent)
    : QObject(parent), m_currentTrackIndex(-1)
{
}

QString SpotifyApiManager::loadApiKey()
{
    QFile file("../config/api_keys.json");

    if (!file.open(QIODevice::ReadOnly))
    {
        qDebug() << "Failed to open api_keys.json";
        return "";
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);

    return doc.object().value("rapid_api_key").toString();
}

QStringList SpotifyApiManager::trackTitles() const
{
    QStringList titles;
    for (const auto &track : m_tracks)
        titles.append(track.title);
    return titles;
}

QVariantList SpotifyApiManager::tracks() const
{
    QVariantList result;
    for (const auto &track : m_tracks)
    {
        QVariantMap item;
        item["id"] = track.id;
        item["title"] = track.title;
        item["artist"] = track.artist;
        item["imageUrl"] = track.imageUrl;
        result.append(item);
    }
    return result;
}

// ====================================================================
// CORE PLAYLIST QUEUE STORAGE MANAGERS
// ====================================================================

QStringList SpotifyApiManager::queueTitles() const
{
    QStringList titles;
    for (const auto &track : m_queue) {
        titles.append(track.title);
    }
    return titles;
}

int SpotifyApiManager::currentTrackIndex() const
{
    return m_currentTrackIndex;
}

void SpotifyApiManager::addToQueue(int index)
{
    if (index < 0 || index >= m_tracks.size()) {
        qDebug() << "❌ Backend C++: Queue insertion rejected. Out of bounds index:" << index;
        return;
    }

    m_queue.append(m_tracks[index]);
    
    if (m_currentTrackIndex == -1) {
        m_currentTrackIndex = 0;
        emit currentTrackIndexChanged();
    }

    emit queueChanged();
    qDebug() << "⚡ Backend C++: Successfully Queued Spotify Track:" << m_tracks[index].title;
}

void SpotifyApiManager::playQueueTrack(int index)
{
    if (index < 0 || index >= m_queue.size())
        return;

    m_currentTrackIndex = index;
    emit currentTrackIndexChanged();

    m_selectedTitle = m_queue[index].title;
    m_selectedArtist = m_queue[index].artist;
    m_selectedAlbum = m_queue[index].album;
    m_selectedImageUrl = m_queue[index].imageUrl;
    
    emit selectedTrackChanged();
    loadLyrics(m_queue[index].id);
    
    qDebug() << "▶ Backend C++: Commencing Queue Track Playback on Index:" << index << "Track:" << m_selectedTitle;
}

// ====================================================================
// RAPID-API NETWORK COMMUNICATION PIPELINES
// ====================================================================

void SpotifyApiManager::searchTracks(const QString &query)
{
    QString apiKey = loadApiKey();

    if (apiKey.isEmpty())
    {
        qDebug() << "No API Key Found";
        return;
    }

    QUrl url("https://spotify23.p.rapidapi.com/search/?q="
        + QUrl::toPercentEncoding(query)
        + "&type=tracks&offset=0&limit=5&numberOfTopResults=5");

    QNetworkRequest request(url);
    request.setRawHeader("X-RapidAPI-Key", apiKey.toUtf8());
    request.setRawHeader("X-RapidAPI-Host", "spotify23.p.rapidapi.com");

    QNetworkReply *reply = m_network.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject root = doc.object();
        QJsonArray items = root["tracks"].toObject()["items"].toArray();

        m_tracks.clear();

        for (const auto &item : items)
        {
            QJsonObject data = item.toObject()["data"].toObject();
            SpotifyTrack track;

            track.id = data["id"].toString();
            track.title = data["name"].toString();
            track.album = data["albumOfTrack"].toObject()["name"].toString();

            QJsonArray artistItems = data["artists"].toObject()["items"].toArray();
            if (!artistItems.isEmpty())
            {
                track.artist = artistItems[0].toObject()["profile"].toObject()["name"].toString();
            }

            QJsonArray sources = data["albumOfTrack"].toObject()["coverArt"].toObject()["sources"].toArray();
            if (!sources.isEmpty())
            {
                track.imageUrl = sources[0].toObject()["url"].toString();
            }

            m_tracks.append(track);
        }

        emit searchResultsChanged();
        emit searchFinished(QString::fromUtf8(response));
        reply->deleteLater();
    });
}

void SpotifyApiManager::loadLyrics(const QString &trackId)
{
    QString apiKey = loadApiKey();
    QUrl url("https://spotify23.p.rapidapi.com/track_lyrics/");

    QUrlQuery query;
    query.addQueryItem("id", trackId);
    url.setQuery(query);

    QNetworkRequest request(url);
    request.setRawHeader("X-RapidAPI-Key", apiKey.toUtf8());
    request.setRawHeader("X-RapidAPI-Host", "spotify23.p.rapidapi.com");

    QNetworkReply *reply = m_network.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject root = doc.object();
        QJsonArray lines = root["lyrics"].toObject()["lines"].toArray();

        m_lyrics.clear();
        m_lyricList.clear();

        for (auto line : lines)
        {
            QJsonObject obj = line.toObject();
            SpotifyLyricLine lyric;

            lyric.timestamp = obj["startTimeMs"].toString().toLongLong();
            lyric.text = obj["words"].toString();

            m_lyrics.append(lyric);
            m_lyricList.append(lyric.text);
        }

        emit lyricsChanged();
        reply->deleteLater();
    });
}

void SpotifyApiManager::selectTrack(int index)
{
    if(index < 0 || index >= m_tracks.size())
        return;

    m_selectedTitle = m_tracks[index].title;
    m_selectedArtist = m_tracks[index].artist;
    m_selectedAlbum = m_tracks[index].album;
    m_selectedImageUrl = m_tracks[index].imageUrl;

    emit selectedTrackChanged();
    loadLyrics(m_tracks[index].id);
}

QStringList SpotifyApiManager::lyricList() const { return m_lyricList; }
QString SpotifyApiManager::currentLyric() const { return m_currentLyric; }
QString SpotifyApiManager::selectedTitle() const { return m_selectedTitle; }
QString SpotifyApiManager::selectedArtist() const { return m_selectedArtist; }
QString SpotifyApiManager::selectedImageUrl() const { return m_selectedImageUrl; }
QString SpotifyApiManager::selectedAlbum() const { return m_selectedAlbum; }