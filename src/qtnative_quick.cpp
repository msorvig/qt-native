#include "qtnative_quick.h"
#include "qtnative_qml.h"

#include <QQuickWindow>

QtNativeControlItem::QtNativeControlItem(QQuickItem *parent)
:QQuickItem(parent)
{
    connect(this, &QQuickItem::windowChanged, [this](QQuickWindow *window){
        windowChanged(window);
    });
    connect(this, &QQuickItem::visibleChanged, [this](){
        visibleChanged();
    });
}

QtNativeControlItem::QtNativeControlItem(QtNativeControl *control, QQuickItem *parent)
:QQuickItem(parent)
,m_control(control)
{
    connect(this, &QQuickItem::windowChanged, [this](QQuickWindow *window){
        windowChanged(window);
    });
    connect(this, &QQuickItem::visibleChanged, [this](){
        visibleChanged();
    });
}

QtNativeControlItem::~QtNativeControlItem()
{
    delete m_control;
}

void QtNativeControlItem::componentComplete() 
{
    qDebug() << __PRETTY_FUNCTION__;
    QQuickItem::componentComplete();
}

void QtNativeControlItem::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    qDebug() << __PRETTY_FUNCTION__ << newGeometry << oldGeometry;
    m_control->setGeometry(newGeometry.x(), newGeometry.y(), newGeometry.width(), newGeometry.height());
}

void QtNativeControlItem::windowChanged(QQuickWindow* window)
{
    qDebug() << __PRETTY_FUNCTION__ << window;
    
    // Create root window control for the new window and reparent this item to it.
    //
    // FIXME: root control management: we only need one per QQuickWindow, not one per QtNativeControlItem
    QtNativeControl *windowControl = new QtNativeControl();
    windowControl->setWindow(window);
    m_control->setParent(windowControl);
}

void QtNativeControlItem::visibleChanged()
{
    qDebug() << __PRETTY_FUNCTION__;
}

//
//  QtNativePushButtonItem
//
QtNativePushButtonItem::QtNativePushButtonItem(QQuickItem *parent)
:QtNativeControlItem(new QtNativePushButton(), parent)
{
 
}

void QtNativePushButtonItem::setCaption(const QString &caption)
{
    static_cast<QtNativePushButton *>(QtNativeControlItem::m_control)->setCaption(caption);
}

QString QtNativePushButtonItem::caption() const
{
    return static_cast<QtNativePushButton *>(QtNativeControlItem::m_control)->caption();
}

//
//  QtNativeUserCredentialsInputItem
//
QtNativeUserCredentialsInputItem::QtNativeUserCredentialsInputItem(QQuickItem *parent)
:QtNativeControlItem(new QtNativeUserCredentialsInput(), parent)
{
 
}

void QtNativeUserCredentialsInputItem::setCredentialsType(QtNativeUserCredentialsInputItem::CredentialsType credentialsType)
{
    static_cast<QtNativeUserCredentialsInput *>(QtNativeControlItem::m_control)->setCredentialsType
        (QtNativeUserCredentialsInput::CredentialsType(int(credentialsType)));
}

QtNativeUserCredentialsInputItem::CredentialsType QtNativeUserCredentialsInputItem::credentialsType() const
{
    return QtNativeUserCredentialsInputItem::CredentialsType(
        static_cast<QtNativeUserCredentialsInput *>(QtNativeControlItem::m_control)->credentialsType());
}

//
//  QtNativeVideoPlayerItem
//
QtNativeVideoPlayerItem::QtNativeVideoPlayerItem(QQuickItem *parent)
:QtNativeControlItem(new QtNativeVideoPlayer(), parent)
{
 
}

void QtNativeVideoPlayerItem::setVideoSource(const QString &source)
{
    static_cast<QtNativeVideoPlayer *>(QtNativeControlItem::m_control)->setVideoSource(source);
}

QString QtNativeVideoPlayerItem::videoSource() const
{
    return static_cast<QtNativeVideoPlayer *>(QtNativeControlItem::m_control)->videoSource();
}
