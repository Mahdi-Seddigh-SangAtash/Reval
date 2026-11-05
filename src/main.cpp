#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Sets both the title bar icon and the Windows taskbar icon
    app.setWindowIcon(QIcon(u":/Reval/resources/reval.png"_s));

    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/Reval/qml/Main.qml"_s);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}