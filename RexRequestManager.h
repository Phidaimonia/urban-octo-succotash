#include <QTimer>
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QCoreApplication>



class RexRequestManager : public QObject
{
    Q_OBJECT

public:
    void update();

signals:
    void newDataArrived(QVector<QString> data);
    void serverStatus(bool connected);

public slots:
    void sendRequest(QString param, double value);
    void replyReceived();
    void postResultReceived();
    void tryConnect(QUrl url);

private:
    QUrl m_url;
    QNetworkAccessManager* m_pManager = nullptr;
    QNetworkReply* m_lastResponse;
    QNetworkReply* m_postResponse;
    QTimer m_refreshTimer;
    bool serverReplied = true;
};

