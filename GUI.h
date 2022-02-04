#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QMap>
#include <QObject>
#include <QCoreApplication>


class GUI : public QObject
{
    Q_OBJECT

public:
    void create(QObject* mainComponent);


public slots:
    void connectClick();
    void angleResetClick();
    void nudgeClick();
    void disturbClick();
    void newDataArrived(QVector<QString> data);
    void serverStatus(bool connected);
signals:
    void clicked();
    void sendRequest(QString param, double value);
    void tryConnect(QUrl url);  



private:
    const QStringList QMLObjList = { "mainPanel", "connectionPanel", "authLabel",
                                    "hostField", "usernameField", "passwordField",
                                    "connectButton", "mycanvas", "initialAngleEdit",
                                    "initialAngleResetButton", "nudgeButton", "disturbanceButton", 
                                    "ballAngleInfo", "motorAngleInfo", "motorSpeedInfo", 
                                    "connectionStatus"};

    bool registerObject(const QString& name);
    void setLabelText(QString labelName, QString text, double value);

    QMap<QString, QObject*> m_objects;
    QObject* m_root;

};
