#include "GUI.h"





void GUI::create(QObject* root)
{

    if (!root)
    {
        qDebug() << "Bad QML layout";
        return;
    }

    m_root = root;

    for each (QString objName in QMLObjList)   // odkazy na jednotlive elementy - propojeni s QML
        if (!registerObject(objName))
        {
            qDebug() << "Can't find object:" << objName;
            return;
        }


    connect(m_objects["connectButton"],           SIGNAL(clicked()), this, SLOT(connectClick()));
    connect(m_objects["initialAngleResetButton"], SIGNAL(clicked()), this, SLOT(angleResetClick()));
    connect(m_objects["nudgeButton"],             SIGNAL(clicked()), this, SLOT(nudgeClick()));
    connect(m_objects["disturbanceButton"],       SIGNAL(clicked()), this, SLOT(disturbClick()));


    qDebug() << "Init: success";
}



void GUI::connectClick()
{
    QString host = m_objects["hostField"]->property("text").toString();
    QString username = m_objects["usernameField"]->property("text").toString();
    QString password = m_objects["passwordField"]->property("text").toString();

    auto url = QUrl(host);
    url.setUserName(username);
    url.setPassword(password);

    emit tryConnect(url);    // ask requestManager to check credentials. Reply -> serverStatus(bool)
}


void GUI::angleResetClick()
{
    bool result = false;
    double val = m_objects["initialAngleEdit"]->property("text").toDouble(&result);  // read angle value

    if (!result) return;

    emit sendRequest(QString("CNR_y0:ycn"), val);           // set the angle
    emit sendRequest(QString("MP_INTEG_RST:BSTATE"), 1);    // reset state
}


void GUI::nudgeClick()
{
    emit sendRequest(QString("MP_NUDGE:BSTATE"), 1);
}


void GUI::disturbClick()
{
    QString buttonText = m_objects["disturbanceButton"]->property("text").toString();

    int value = 1;
    if (buttonText.contains("ON"))
        value = 0;

    buttonText = (value == 0) ? "OFF" : "ON";
    m_objects["disturbanceButton"]->setProperty("text", buttonText);

    emit sendRequest(QString("CNB_DISTRB:YCN"), value);
}



bool GUI::registerObject(const QString& name)
{
    QObject* objPtr = m_root->findChild<QObject*>(name, Qt::FindChildrenRecursively);
    if(objPtr)
    {
        m_objects[name] = objPtr;
        return true;
    }
    return false;
}



void GUI::setLabelText(QString labelName, QString text, double value)
{
    m_objects[labelName]->setProperty("text", text.arg(QString::number(value, 'f', 2)));
}



void GUI::newDataArrived(QVector<QString> data)    // angles from requestManager
{
    // update text labels
    setLabelText("motorAngleInfo", "Motor angle:  %1 deg",  data[0].toDouble() * 180 / M_PI);
    setLabelText("motorSpeedInfo", "Motor speed: %1 deg/s", data[1].toDouble() * 180 / M_PI);
    setLabelText("ballAngleInfo" , "Ball angle:    %1 deg", data[2].toDouble() * 180 / M_PI);


    // redraw canvas
    m_objects["mycanvas"]->setProperty("spoolAngle",  data[0].toDouble() + M_PI / 2.0);  // 90deg shift
    m_objects["mycanvas"]->setProperty("ballAngle", data[2].toDouble() + M_PI / 2.0);

    QMetaObject::invokeMethod(m_objects["mycanvas"], "drawAll");
    QMetaObject::invokeMethod(m_objects["mycanvas"], "requestPaint");

}




void GUI::serverStatus(bool connected)   // received by requestManager
{
    if (!connected)
    {
        m_objects["connectionStatus"]->setProperty("text", "NOT CONNECTED");
        m_objects["connectionStatus"]->setProperty("color", "red");
        return;
    }
    else
    {
        m_objects["connectionStatus"]->setProperty("text", "CONNECTED");
        m_objects["connectionStatus"]->setProperty("color", "green");

        m_objects["mainPanel"]->setProperty("visible", true);
        m_objects["connectionPanel"]->setProperty("visible", false);
    }
}

