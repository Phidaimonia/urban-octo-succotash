#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QObject>

#include "GUI.cpp"
#include "RexRequestManager.cpp"




int main(int argc, char **argv)
{
     const QString layoutFileName = "semestralka.qml";

     QGuiApplication app(argc, argv);
     QQmlEngine engine;
     QQmlComponent component(&engine, layoutFileName);

     app.setApplicationDisplayName(QString("Semestralka"));

     GUI myGUI;
     myGUI.create(component.create());

     RexRequestManager updater;  
    
     QObject::connect(&updater, &RexRequestManager::newDataArrived, &myGUI, &GUI::newDataArrived);
     QObject::connect(&myGUI, &GUI::sendRequest , &updater, &RexRequestManager::sendRequest);

     QObject::connect(&updater, &RexRequestManager::serverStatus, &myGUI, &GUI::serverStatus);
     QObject::connect(&myGUI, &GUI::tryConnect, &updater, &RexRequestManager::tryConnect);

     return app.exec();
}
