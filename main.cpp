#include <QApplication>
#include <QQmlApplicationEngine>
#include <QLocalServer>
#include <QLocalSocket>
#include <QWindow>
#include <windows.h>
#include <QMenu>
#include <QIcon>
#include <QSystemTrayIcon>
#include <chestcounter.h>

static const QString inst_Key=QStringLiteral("FNChestCounter_CJ0hn24");

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    //instance check
    QLocalSocket probe;
    probe.connectToServer(inst_Key);
    if(probe.waitForConnected(200)){
        AllowSetForegroundWindow(ASFW_ANY);//pull to foreground if running
        probe.write("raise");
        probe.flush();
        probe.waitForBytesWritten(200);
        return 0;
    }

    QLocalServer::removeServer(inst_Key);
    QLocalServer server;
    server.listen(inst_Key);

    QQmlApplicationEngine engine;

    //bring to foreground
    QObject::connect(&server, &QLocalServer::newConnection, &app, [&engine, &server] {
        QLocalSocket *c = server.nextPendingConnection();
        if (!c) return;
        c->readAll();
        c->deleteLater();

        QWindow *win = qobject_cast<QWindow *>(engine.rootObjects().value(0));
        if (win) {
            win->showNormal();          //unminimize
            win->raise();               //bring to front
            win->requestActivate();     //set winfocus via ASFW_ANY
        }
    });

    //quit if qml fails
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("FNChestCounter", "Main");

    //minimise to tray
    QWindow *win= qobject_cast<QWindow*>(engine.rootObjects().value(0));
    ChestCounter *chest =win ? win->findChild<ChestCounter*>():nullptr;
    auto raise =[win]{if(win){win->showNormal();win->raise();win->requestActivate();}};
    //menu options
    QMenu menu;
    QAction *showAct = menu.addAction("Show Counter");
    QAction *quitAct = menu.addAction("Exit");

    //load icon
    QSystemTrayIcon tray;
    QIcon icon(":/qt/qml/FNChestCounter/img/icon.ico");
    if(icon.isNull()) icon= app.windowIcon();

    //assign prpertys to tray
    tray.setIcon(icon);
    //display counter in tray when hovered
    if(chest){
        auto tip=[&tray,chest]{tray.setToolTip("Chest Opened: "+QString::number(chest->getChests()));};
        tip();
        QObject::connect(chest, &ChestCounter::c_opened,tip);
    }
    tray.setContextMenu(&menu);
    tray.show();

    //actions on trigg
    QObject::connect(showAct,&QAction::triggered,raise);
    QObject::connect(quitAct,&QAction::triggered,&app,&QApplication::quit);
    QObject::connect(&tray,&QSystemTrayIcon::activated,[raise,win](QSystemTrayIcon::ActivationReason r){
        if(r==QSystemTrayIcon::Trigger){
            if(win&&win->isVisible())win->hide();else raise();
        }
    });

    return QApplication::exec();
}
