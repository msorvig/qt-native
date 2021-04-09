#include <QQuickItem>

//
//
// Native controls as QQuickItems
//
// FIXME: Find way to re-use/inherit from classes in qtnative_qml.h,
//        in order to avoid duplicating the API here.
//
//

class QtNativeControl;

class QtNativeControlItem: public QQuickItem {
     Q_OBJECT
public:
    QtNativeControlItem(QQuickItem *parent = 0);
    QtNativeControlItem(QtNativeControl *control, QQuickItem *parent  = 0);
    ~QtNativeControlItem();
protected:
    void componentComplete() override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    void windowChanged(QQuickWindow *window);
    void visibleChanged();
    
    QtNativeControl *m_control = nullptr;
};

class QtNativePushButtonItem: public QtNativeControlItem {
    Q_OBJECT
    Q_PROPERTY(QString caption READ caption WRITE setCaption)
public:
    QtNativePushButtonItem(QQuickItem *parent = 0);

    void setCaption(const QString &caption);
    QString caption() const;
};

class QtNativeUserCredentialsInputItem: public QtNativeControlItem {
    Q_OBJECT
    Q_PROPERTY(CredentialsType credentialsType READ credentialsType WRITE setCredentialsType)
public:
    QtNativeUserCredentialsInputItem(QQuickItem *parent = 0);

    enum CredentialsType { Username, Password };
    Q_ENUM(CredentialsType)

    void setCredentialsType(QtNativeUserCredentialsInputItem::CredentialsType credentialsType);
    QtNativeUserCredentialsInputItem::CredentialsType credentialsType() const;
};

class QtNativeVideoPlayerItem: public QtNativeControlItem {
    Q_OBJECT
    Q_PROPERTY(QString videoSource READ videoSource WRITE setVideoSource)
public:
    QtNativeVideoPlayerItem(QQuickItem *parent = 0);

    void setVideoSource(const QString &source);
    QString videoSource() const;
};

