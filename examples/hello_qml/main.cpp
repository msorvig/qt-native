#include <QtQuick/QQuickView>
#include <QGuiApplication>

#include <qtnative_qml.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QtNativeControl>("QtNative", 0, 1, "Control");
    qmlRegisterType<QtNativePushButton>("QtNative", 0, 1, "PushButton");
    qmlRegisterType<QtNativeUserCredentialsInput>("QtNative", 0, 1, "UserCredentialsInput");

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:///main.qml"));
    view.show();
    return app.exec();
}