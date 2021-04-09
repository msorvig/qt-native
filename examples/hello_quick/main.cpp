#include <QtQuick/QQuickView>
#include <QGuiApplication>

#include <qtnative_quick.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//    qmlRegisterType<QtNativeControlItem>("QtNative", 0, 1, "Control");
    qmlRegisterType<QtNativePushButtonItem>("QtNative", 0, 1, "PushButton");
    qmlRegisterType<QtNativeUserCredentialsInputItem>("QtNative", 0, 1, "UserCredentialsInput");
    qmlRegisterType<QtNativeVideoPlayerItem>("QtNative", 0, 1, "VideoPlayer");

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:///main.qml"));
    view.resize(500, 300);
    view.show();
    return app.exec();
}