#ifndef _QTNATIVE_H_
#define _QTNATIVE_H_

#include <tuple>
#include <memory>
#include <string_view>

// Qt Native C++ API

namespace QtNative  {

// Control base class wich defines common properties like
// geometry and visibility status.
class ControlImp;
class Control
{
public:
    Control();
    ~Control();
    Control(const Control&) = delete;
    void operator=(const Control&) = delete;

    // Parent controls visually embeds and owns child controls.
    void setParent(Control *parent);
    Control *parent() const;

    void setGeometry(int x, int y, int width, int height);
    std::tuple<int, int, int, int> geometry() const;

    void setVisible(bool visible);
    bool visible() const;

    // Control owns a native contol. The spesific type is
    // platform dependent:
    //  - macOS: NSView *
    //  - web: emscripten::val * (containng HTML Element)
    //  - null: nullptr
    // User code can access the control
    void setNativeControl(void *native);
    void *nativeControl() const;

protected:
    Control(ControlImp *imp);
    ControlImp *imp;

    friend Control *createNativeWindowControl();
};

// Convenience functions for creating a native window and
// spinning a native eventloop. Normally this will be
// taken care of by the hosting application, but we provide
// stand-alone implementations here for demo and testing puroses.
Control *createNativeWindowControl();
void spinNativeEventLoop(int argc, char **argv, std::function<void(void)> startup);

// A native push button
//
// The native control for PushButton is:
//    macOS: NSButton
class PushButtonImp;
class PushButton: public Control {
public:
    PushButton();
    ~PushButton();
    void setText(std::string_view caption);
    std::string text() const;
    void setOnClickedCallback(std::function<void(void)> cb);
};

// A native user credentials line edit
//
// The native control for PushButton is:
//    macOS: NSTextEdit
class UserCredentialsInput: public Control {
public:
    enum CredentialsType {
        Username,
        Password
    };

    UserCredentialsInput();
    ~UserCredentialsInput();
    void setCredentialsType(CredentialsType credentialsType);
    CredentialsType credentialsType();
    std::string text();
    void setOnTextEnteredCallback(std::function<void(std::string)> cb);
};

} // namespace QtNative

#endif
