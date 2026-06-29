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
#include <QDesktopServices>
#include <QtNetworkAuth/qoauth2authorizationcodeflow.h>
#include <QtNetworkAuth/qoauthhttpserverreplyhandler.h>
#include <QProcess>

SpotifyApiManager::SpotifyApiManager(QObject *parent)
    : QObject(parent), m_currentTrackIndex(-1)
{
    m_oauth.setAuthorizationUrl(
        QUrl("https://accounts.spotify.com/authorize"));

    m_oauth.setAccessTokenUrl(
        QUrl("https://accounts.spotify.com/api/token"));

    m_oauth.setClientIdentifier(
        "6cc04a9b35e14400b53f27df3212c8cf");

    m_replyHandler =
        new QOAuthHttpServerReplyHandler(8888, this);

    m_oauth.setReplyHandler(m_replyHandler);
    qDebug() << "Reply handler callback:" << m_replyHandler->callback();

    connect(&m_oauth,
            &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser,
            [](const QUrl &url)
    {
        qDebug() << "AUTH URL:";
        qDebug() << url.toString();
    #ifdef Q_OS_LINUX

            bool isWSL = false;

            QFile versionFile("/proc/version");

            if (versionFile.open(QIODevice::ReadOnly))
            {
                QString version =
                    QString::fromUtf8(versionFile.readAll());

                isWSL =
                    version.contains("Microsoft", Qt::CaseInsensitive) ||
                    version.contains("WSL", Qt::CaseInsensitive);
            }

            if (isWSL)
            {
                qDebug() << "WSL detected";
                qDebug() << "Opening Windows browser";

                QString command =
                    QString("Start-Process '%1'")
                        .arg(url.toString());

                QProcess::startDetached(
                    "powershell.exe",
                    QStringList()
                        << "-Command"
                        << QString("Start-Process \"%1\"")
                            .arg(url.toString()));
            }
            else
            {
                qDebug() << "Native Linux detected";

                QDesktopServices::openUrl(url);
            }

    #else

            qDebug() << "Windows/macOS detected";

            QDesktopServices::openUrl(url);

    #endif
        });

        connect(&m_oauth,
            &QOAuth2AuthorizationCodeFlow::granted,
            this,
            [this]()
    {
        qDebug() << "SPOTIFY LOGIN SUCCESS";
        qDebug() << "Access Token:";
        qDebug() << m_oauth.token();

        m_loggedIn = true;
        emit loggedInChanged();

        m_spotifyTimer.start(1000);

        QTimer::singleShot(250, this, [this]()
        {
            getCurrentTrack();
            getSpotifyQueue();
        });

        qDebug() << "Spotify polling started";

        QNetworkRequest request(
            QUrl("https://api.spotify.com/v1/me"));

        request.setRawHeader(
            "Authorization",
            QString("Bearer %1")
                .arg(m_oauth.token())
                .toUtf8());

        QNetworkReply *reply = m_network.get(request);

        connect(reply,
                &QNetworkReply::finished,
                [reply]()
        {
            qDebug() << reply->readAll();
            reply->deleteLater();
        });
    });

    connect(&m_oauth,
            &QOAuth2AuthorizationCodeFlow::requestFailed,
            this,
            [](QAbstractOAuth::Error error)
    {
        qDebug() << "OAuth Request Failed:";
    });

    connect(&m_spotifyTimer,
            &QTimer::timeout,
            this,
            [this]()
    {
        getCurrentTrack();
        getSpotifyQueue();
    });
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

    bool exists = false;

    for (const auto &track : m_queue)
    {
        if (track.id == m_tracks[index].id)
        {
            exists = true;
            break;
        }
    }

    if (!exists)
    {
        m_queue.append(m_tracks[index]);
        emit queueChanged();
    }

    QNetworkRequest request(
        QUrl(QString("https://api.spotify.com/v1/me/player/queue?uri=spotify:track:%1")
             .arg(m_tracks[index].id)));
    
    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());
    
    QNetworkReply *reply = m_network.post(request, QByteArray());
    
    connect(reply, &QNetworkReply::finished,
            this,
            [reply]()
    {
        qDebug() << "QUEUE TRACK:"
                 << reply->attribute(
                        QNetworkRequest::HttpStatusCodeAttribute);
    
        if (reply->error())
            qDebug() << reply->readAll();
    
        reply->deleteLater();
    });
    
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
        int status =
        reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 204)
        {
            reply->deleteLater();
            return;
        }

        if (reply->error())
        {
            qDebug() << reply->errorString();
            reply->deleteLater();
            return;
        }

        if (response.isEmpty())
        {
            reply->deleteLater();
            return;
        }

        QJsonParseError parseError;

        QJsonDocument doc =
            QJsonDocument::fromJson(response, &parseError);

        if (parseError.error != QJsonParseError::NoError)
        {
            qDebug() << parseError.errorString();

            reply->deleteLater();
            return;
        }
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
    if (index < 0 || index >= m_tracks.size())
        return;

    playTrack(m_tracks[index].id);

    loadLyrics(m_tracks[index].id);
}

void SpotifyApiManager::login()
{
    if (m_loggedIn)
        return;

    qDebug() << "Starting Spotify OAuth";

    m_oauth.setScope(
        "user-read-email "
        "user-read-playback-state "
        "user-modify-playback-state "
        "user-read-currently-playing");

    m_oauth.grant();
}

void SpotifyApiManager::getCurrentTrack()
{   
    QNetworkRequest request(
        QUrl("https://api.spotify.com/v1/me/player/currently-playing"));

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QNetworkReply *reply = m_network.get(request);

    connect(reply, &QNetworkReply::finished,
            this,
            [this, reply]()
    {
        QByteArray response = reply->readAll();

        QJsonDocument doc =
            QJsonDocument::fromJson(response);

        QJsonObject root =
            doc.object();

        QJsonObject item =
            root["item"].toObject();
        if (item.isEmpty())
        {
            reply->deleteLater();
            return;
        }

        bool newPlaying =
            root["is_playing"].toBool();

        qint64 newPosition =
            root["progress_ms"].toVariant().toLongLong();

        qint64 newDuration =
            item["duration_ms"].toVariant().toLongLong();

        QString newTitle =
            item["name"].toString();

        QJsonArray artists =
            item["artists"].toArray();

        QString newArtist;

        if (!artists.isEmpty())
        {
            newArtist =
                artists.first()
                    .toObject()["name"]
                    .toString();
        }

        QJsonArray images =
            item["album"]
                .toObject()["images"]
                .toArray();

        QString newImageUrl;

        if (!images.isEmpty())
        {
            newImageUrl =
                images.first()
                    .toObject()["url"]
                    .toString();
        }
            
        if (newPlaying != m_isPlaying)
        {
            m_isPlaying = newPlaying;
            emit playbackStateChanged();
        }

        if (newPosition != m_position ||
            newDuration != m_duration)
        {
            m_position = newPosition;
            m_duration = newDuration;

            emit playbackPositionChanged();
        }

        if (newTitle != m_selectedTitle)
        {
            qDebug() << "Song changed";

            m_selectedTitle = newTitle;
            m_selectedArtist = newArtist;
            m_selectedImageUrl = newImageUrl;

            emit selectedTrackChanged();
        }
    });
}

void SpotifyApiManager::previousTrack()
{
    QNetworkRequest request(
        QUrl("https://api.spotify.com/v1/me/player/previous"));

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QNetworkReply *reply =
        m_network.post(request, QByteArray());

    connect(reply,
            &QNetworkReply::finished,
            reply,
            &QNetworkReply::deleteLater);
}

void SpotifyApiManager::playPause()
{
    QString endpoint =
        m_isPlaying
        ? "https://api.spotify.com/v1/me/player/pause"
        : "https://api.spotify.com/v1/me/player/play";

    QNetworkRequest request{QUrl(endpoint)};

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QNetworkReply *reply =
        m_network.put(request, QByteArray());

    connect(reply,
            &QNetworkReply::finished,
            reply,
            &QNetworkReply::deleteLater);
}

void SpotifyApiManager::nextTrack()
{
    QNetworkRequest request(
        QUrl("https://api.spotify.com/v1/me/player/next"));

    request.setRawHeader(
        "Authorization",
        QString("Bearer %1")
            .arg(m_oauth.token())
            .toUtf8());

    QNetworkReply *reply =
        m_network.post(request, QByteArray());

    connect(reply,
            &QNetworkReply::finished,
            [reply]()
    {
        reply->deleteLater();
    });
}

void SpotifyApiManager::seek(qint64 position)
{
    QString url =
        QString(
            "https://api.spotify.com/v1/me/player/seek?position_ms=%1")
            .arg(position);

    QNetworkRequest request{QUrl(url)};

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QNetworkReply *reply =
        m_network.put(request, QByteArray());

    connect(reply,
            &QNetworkReply::finished,
            reply,
            &QNetworkReply::deleteLater);
}

void SpotifyApiManager::playTrack(const QString &trackId)
{
    QNetworkRequest request{QUrl("https://api.spotify.com/v1/me/player/play")};

    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "application/json");

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QJsonObject body;
    body["uris"] = QJsonArray{
        QString("spotify:track:%1").arg(trackId)
    };

    QNetworkReply *reply =
        m_network.put(request,
                      QJsonDocument(body).toJson());

    connect(reply,
            &QNetworkReply::finished,
            this,
            [reply]()
    {
        qDebug() << "PLAY TRACK:"
                 << reply->attribute(
                        QNetworkRequest::HttpStatusCodeAttribute);

        if (reply->error())
            qDebug() << reply->readAll();

        reply->deleteLater();
    });
}

void SpotifyApiManager::getSpotifyQueue()
{
    QNetworkRequest request(
        QUrl("https://api.spotify.com/v1/me/player/queue"));

    request.setRawHeader(
        "Authorization",
        QString("Bearer " + m_oauth.token()).toUtf8());

    QNetworkReply *reply = m_network.get(request);

    connect(reply,
            &QNetworkReply::finished,
            this,
            [this, reply]()
    {
        if (reply->error()) {
            reply->deleteLater();
            return;
        }

        QByteArray response = reply->readAll();

        int status =
            reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 204)
        {
            reply->deleteLater();
            return;
        }

        if (reply->error())
        {
            qDebug() << reply->errorString();
            reply->deleteLater();
            return;
        }

        if (response.isEmpty())
        {
            reply->deleteLater();
            return;
        }

        QJsonDocument doc =
            QJsonDocument::fromJson(response);

        QJsonObject root =
            doc.object();

        QJsonArray queue =
            root["queue"].toArray();

        m_queue.clear();

        for (const QJsonValue &value : queue)
        {
            QJsonObject track =
                value.toObject();

            SpotifyTrack item;

            item.id =
                track["id"].toString();

            item.title =
                track["name"].toString();

            item.artist =
                track["artists"]
                    .toArray()[0]
                    .toObject()["name"]
                    .toString();

            item.album =
                track["album"]
                    .toObject()["name"]
                    .toString();

            item.imageUrl =
                track["album"]
                    .toObject()["images"]
                    .toArray()[0]
                    .toObject()["url"]
                    .toString();

            m_queue.append(item);
        }

        emit queueChanged();

        reply->deleteLater();
    });
}

QStringList SpotifyApiManager::lyricList() const { return m_lyricList; }
QString SpotifyApiManager::currentLyric() const { return m_currentLyric; }
QString SpotifyApiManager::selectedTitle() const { return m_selectedTitle; }
QString SpotifyApiManager::selectedArtist() const { return m_selectedArtist; }
QString SpotifyApiManager::selectedImageUrl() const { return m_selectedImageUrl; }
QString SpotifyApiManager::selectedAlbum() const { return m_selectedAlbum; }