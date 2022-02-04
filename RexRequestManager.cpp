#include "RexRequestManager.h"






void RexRequestManager::update()         // updates graphics + labels, runs on timer
{
    emit serverStatus(serverReplied);

    serverReplied = false;

    auto reqURL = m_url;
    reqURL.setPath("/api/data/mic/TRND");
    reqURL.setQuery("data&robot&mime=application/json");

    QString concatenated = reqURL.userName() + ":" + reqURL.password();
    QString headerData = "Basic " + concatenated.toLocal8Bit().toBase64();    // username+pass as part of url doesn't work

    auto req = QNetworkRequest(reqURL);
    req.setRawHeader("Authorization", headerData.toLocal8Bit());

    m_lastResponse = m_pManager->get(req);    

    connect(m_lastResponse, &QNetworkReply::finished, this, &RexRequestManager::replyReceived);   // define callback
}



void RexRequestManager::replyReceived()             // processing server response + sending to GUI
{
    if (!m_lastResponse)
        return;

    if (m_lastResponse->error() != QNetworkReply::NoError)
    {
        m_lastResponse->deleteLater();
        m_lastResponse = nullptr;
        return;
    }

    QString resp = m_lastResponse->readAll();
    m_lastResponse->deleteLater();
    m_lastResponse = nullptr;

    if (resp == "")
        return;

    QJsonDocument jsonResponse = QJsonDocument::fromJson(resp.toUtf8());
    QJsonObject jsonObject = jsonResponse.object();
    QJsonArray jsonArray = jsonObject["subitems"].toArray();

    QMap<QString, QJsonObject> resultDict;

    foreach(const QJsonValue & value, jsonArray) {      // make a dict

        QJsonObject obj = value.toObject();
        QString key = obj.keys()[0];                    // we only need single values

        resultDict.insert(key, obj.value(key).toObject());
    }


    QVector<QString> data;
    auto vals = { "u1", "u2", "u3", "u4" };     // what to send to GUI, order sensitive

    foreach(const QString& value, vals) {
        double tmp = resultDict[value].value("v").toDouble();
        data.append(QString::number(tmp));
    }

    serverReplied = true;
    emit newDataArrived(data);
}



void RexRequestManager::postResultReceived()
{
    if (!m_postResponse)
        return;

    if (m_postResponse->error() != QNetworkReply::NoError)
    {
        m_postResponse->deleteLater();
        m_postResponse = nullptr;
        return;
    }

    m_postResponse->deleteLater();          // just delete it so there's no memory leak
    m_postResponse = nullptr;
}



void RexRequestManager::sendRequest(QString param, double value)     // change server params. Format: ("CNB_DISTRB:YCN", "1")
{
    qDebug() << "Received request " << param << value;

    auto reqURL = m_url;
    reqURL.setPath("/api/data/mic/" + param);
    reqURL.setQuery("data&robot&mime=application/json");                       //  set REST params

    QString concatenated = reqURL.userName() + ":" + reqURL.password();
    QString headerData = "Basic " + concatenated.toLocal8Bit().toBase64();    // username+pass as part of url doesn't work

    auto req = QNetworkRequest(reqURL);
    req.setRawHeader("Authorization", headerData.toLocal8Bit());
    req.setRawHeader("Content-Type", QString("application/json").toLocal8Bit());   

    QByteArray data = QString("{\"v\":%1}").arg(value).toLocal8Bit();           // simple json template {v:value}

    if (m_pManager == nullptr)
        m_pManager = new QNetworkAccessManager();

    m_postResponse = m_pManager->post(req, data);
    connect(m_postResponse, &QNetworkReply::finished, this, &RexRequestManager::postResultReceived);   // define callback
}




void RexRequestManager::tryConnect(QUrl url)
{
    url.setPath("/api/data");
    url.setQuery("data&robot&mime=application/json");

    QString concatenated = url.userName() + ":" + url.password();
    QString headerData = "Basic " + concatenated.toLocal8Bit().toBase64();    // username+pass as part of url doesn't work

    auto req = QNetworkRequest(url);
    req.setRawHeader("Authorization", headerData.toLocal8Bit());

    if (m_pManager == nullptr)
        m_pManager = new QNetworkAccessManager();

    QNetworkReply* m_lastResponse = m_pManager->get(req);

    for (int i = 0; i < 30; ++i)
    {
        if (m_lastResponse->isFinished())
            break;

        qApp->processEvents();
        QThread::msleep(10);
    }

    bool connected = m_lastResponse->readAll() != "";

    qDebug() << "CONNECTED: " << m_lastResponse->readAll();

    m_lastResponse->deleteLater();

    emit serverStatus(connected);

    if (!connected)
        return;

    m_url = url;

    connect(&m_refreshTimer, &QTimer::timeout, this, &RexRequestManager::update);
    m_refreshTimer.start(50);
}

