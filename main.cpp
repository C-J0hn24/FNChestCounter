#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLocalServer>
#include <QLocalSocket>
#include <QWindow>
#include <windows.h>

static const QString inst_Key=QStringLiteral("FNChestCounter_CJ0hn24");

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

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

    return QGuiApplication::exec();
}
