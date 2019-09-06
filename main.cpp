#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <boardmodel.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //! [registertype]
    qmlRegisterType<BoardModel>("BoardModel", 1, 0, "BoardModel");
    //! [registertype]

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
