#include "qtnative_qml.h"
#include "qtnative.h"

#include <tuple>

QtNativeControl::QtNativeControl(QObject *parent)
    :QObject(parent)
    ,m_control(new QtNative::Control())
{

}

QtNativeControl::QtNativeControl(QtNative::Control *control, QObject *parent)
    :QObject(parent)
    ,m_control(control)
{
    m_control->setVisible(true);
}

QtNativeControl::~QtNativeControl()
{
    delete m_control;
}

void QtNativeControl::setX(qreal x)
{
    auto [_, y, w, h] = m_control->geometry();
    m_control->setGeometry(x, y, w, h);
}

qreal QtNativeControl::x() const
{
    return std::get<0>(m_control->geometry());
}

void QtNativeControl::setY(qreal y)
{
    auto [x, _, w, h] = m_control->geometry();
    m_control->setGeometry(x, y, w, h);
}

qreal QtNativeControl::y() const
{
    return std::get<1>(m_control->geometry());
}

void QtNativeControl::setWidth(qreal w)
{
    auto [x, y, _, h] = m_control->geometry();
    m_control->setGeometry(x, y, w, h);
}

qreal QtNativeControl::width() const
{
    return std::get<2>(m_control->geometry());
}

void QtNativeControl::setHeight(qreal h)
{
    auto [x, y, w, _] = m_control->geometry();
    m_control->setGeometry(x, y, w, h);
}

qreal QtNativeControl::height() const
{
    return std::get<3>(m_control->geometry());
}

//
// QtNativePushButton
//

QtNativePushButton::QtNativePushButton(QObject *parent)
    : QtNativeControl(new QtNative::PushButton(), parent)
{

}

void QtNativePushButton::setCaption(const QString &caption)
{
    static_cast<QtNative::PushButton *>(QtNativeControl::m_control)->setText(caption.toStdString());
}

QString QtNativePushButton::caption() const
{
    return QString::fromStdString(static_cast<QtNative::PushButton *>(QtNativeControl::m_control)->text());
}

//
// QtNativeUserCredentialsInput
//

QtNativeUserCredentialsInput::QtNativeUserCredentialsInput(QObject *parent)
    : QtNativeControl(new QtNative::UserCredentialsInput(), parent)
{

}

void QtNativeUserCredentialsInput::setCredentialsType(QtNativeUserCredentialsInput::CredentialsType credentialsType)
{
    static_cast<QtNative::UserCredentialsInput *>(QtNativeControl::m_control)->setCredentialsType
        (QtNative::UserCredentialsInput::CredentialsType(int(credentialsType)));
}

QtNativeUserCredentialsInput::CredentialsType QtNativeUserCredentialsInput::credentialsType() const
{
    return QtNativeUserCredentialsInput::CredentialsType(
        static_cast<QtNative::UserCredentialsInput *>(QtNativeControl::m_control)->credentialsType());
}

//
// QtNativeVideoPlayer
//

QtNativeVideoPlayer::QtNativeVideoPlayer(QObject *parent)
    : QtNativeControl(new QtNative::VideoPlayer(), parent)
{

}

void QtNativeVideoPlayer::setVideoSource(const QString &source)
{
    static_cast<QtNative::VideoPlayer *>(QtNativeControl::m_control)->setVideoSource(source.toStdString());
}

QString QtNativeVideoPlayer::videoSource() const
{
    return QString::fromStdString(static_cast<QtNative::VideoPlayer *>(QtNativeControl::m_control)->videoSource());
}

