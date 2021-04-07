#include <QtCore/QObject>

namespace QtNative {
    class Control;
    class PushButton;
    class UserCredentialsInput;
}

class QtNativeControl : public QObject {
     Q_OBJECT
     Q_PROPERTY(qreal x READ x WRITE setX)
     Q_PROPERTY(qreal y READ y WRITE setY)
     Q_PROPERTY(qreal width READ width WRITE setWidth)
     Q_PROPERTY(qreal height READ height WRITE setHeight)

public:
    QtNativeControl(QObject *parent  = 0);
    QtNativeControl(QtNative::Control *control, QObject *parent  = 0);
    ~QtNativeControl();

    void setX(qreal x);
    qreal x() const;
    void setY(qreal y);
    qreal y() const;
    void setWidth(qreal width);
    qreal width() const;
    void setHeight(qreal height);
    qreal height() const;

protected:
    QtNative::Control *m_control = nullptr;
};

class QtNativePushButton : public QtNativeControl {
     Q_OBJECT
    Q_PROPERTY(QString caption READ caption WRITE setCaption)
public:
    QtNativePushButton(QObject *parent  = 0);

    void setCaption(const QString &caption);
    QString caption() const;

private:
    QtNative::PushButton *m_pushbutton;
};

class QtNativeUserCredentialsInput : public QtNativeControl {
    Q_OBJECT
    Q_PROPERTY(CredentialsType credentialsType READ credentialsType WRITE setCredentialsType)
public:
    QtNativeUserCredentialsInput(QObject *parent  = 0);

    enum CredentialsType { Username, Password };
    Q_ENUM(CredentialsType)

    void setCredentialsType(QtNativeUserCredentialsInput::CredentialsType credentialsType);
    QtNativeUserCredentialsInput::CredentialsType credentialsType() const;

private:
    QtNative::UserCredentialsInput *m_userCredentialsInput;
};