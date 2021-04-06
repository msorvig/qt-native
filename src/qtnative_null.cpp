#include "qtnative.h"

#include <vector>
#include <iostream>

using namespace std;

//
// The Null backend
// 
// The null backend prints the function name, and then does nothing.
//

namespace QtNative {
    
//
// Control for the Null backend
//
class ControlImp
{
public:
    Control *parent = nullptr;
    std::tuple<int, int, int, int> geometry;
    bool visible = false;
    void *native = nullptr;
    std::vector<Control *> children;
};
    
Control::Control()
:imp(new ControlImp())
{
    cout << __PRETTY_FUNCTION__ << endl;
}

Control::~Control()
{
    cout << __PRETTY_FUNCTION__ << endl;
    for (Control *child : imp->children)
        delete child;

    delete imp;
}

Control::Control(ControlImp *imp)
:imp(imp)
{
    cout << __PRETTY_FUNCTION__ << endl;    
}

void Control::setParent(Control *parent)
{
    cout << __PRETTY_FUNCTION__ << endl;
    if (imp->parent) {
        std::vector<Control *> &children = parent->imp->children;
        children.erase(std::remove(children.begin(), children.end(), this), children.end());
     }
    imp->parent = parent;
    parent->imp->children.push_back(this);
}

Control *Control::parent() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return imp->parent;
}

void Control::setGeometry(int x, int y, int width, int height)
{
    cout << __PRETTY_FUNCTION__ << endl;
    imp->geometry = make_tuple(x, y, width, height);
}

std::tuple<int, int, int, int> Control::geometry() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return imp->geometry;
}

void Control::setVisible(bool visible)
{
    cout << __PRETTY_FUNCTION__ << endl;
    imp->visible = visible;
}

bool Control::visible() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return imp->visible;
}

void Control::setNativeControl(void *native)
{
    cout << __PRETTY_FUNCTION__ << endl;
}

void *Control::nativeControl() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return nullptr;
}

Control *createNativeWindowControl()
{
    cout << __PRETTY_FUNCTION__ << endl;
    Control *control = new Control();
    control->setVisible(false); // window is hidden by default, in order support hidden setup
    return control;
}

void spinNativeEventLoopAndNeverReturn()
{
    cout << __PRETTY_FUNCTION__ << endl;
}

//
// PushButton for the Null backend
//
class PushButtonImp: public ControlImp
{
public:
    std::string caption;
    std::function<void(void)> onClicked;
};

PushButton::PushButton()
:Control(new PushButtonImp())
{
    cout << __PRETTY_FUNCTION__ << endl;
}

PushButton::~PushButton()
{
    cout << __PRETTY_FUNCTION__ << endl;
}

void PushButton::setText(std::string_view caption)
{
    cout << __PRETTY_FUNCTION__ << " " << caption << endl;
    static_cast<PushButtonImp *>(imp)->caption = caption;
}

std::string PushButton::text() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return static_cast<PushButtonImp *>(imp)->caption;
}

void PushButton::setOnClickedCallback(std::function<void(void)> cb)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<PushButtonImp *>(imp)->onClicked = cb;
    static_cast<PushButtonImp *>(imp)->onClicked();
}

//
// UserCredentialsInput for the Null backend
//
class UserCredentialsInputImp: public ControlImp
{
public:
    UserCredentialsInput::CredentialsType credentialsType = UserCredentialsInput::CredentialsType::Username;
    std::function<void(std::string)> onTextEntered;
    std::string text = "hunter2";
};

UserCredentialsInput::UserCredentialsInput()
:Control(new UserCredentialsInputImp)
{
    cout << __PRETTY_FUNCTION__ << endl;
}

UserCredentialsInput::~UserCredentialsInput()
{
    cout << __PRETTY_FUNCTION__ << endl;
}

void UserCredentialsInput::setCredentialsType(UserCredentialsInput::CredentialsType credentialsType)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<UserCredentialsInputImp *>(imp)->credentialsType = credentialsType;
}

UserCredentialsInput::CredentialsType UserCredentialsInput::credentialsType()
{
    cout << __PRETTY_FUNCTION__ << endl;
    return static_cast<UserCredentialsInputImp *>(imp)->credentialsType;
}

std::string UserCredentialsInput::text()
{
    cout << __PRETTY_FUNCTION__ << endl;
    return static_cast<UserCredentialsInputImp *>(imp)->text;
}

void UserCredentialsInput::setOnTextEnteredCallback(std::function<void(std::string)> cb)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<UserCredentialsInputImp *>(imp)->onTextEntered = cb;
    static_cast<UserCredentialsInputImp *>(imp)->onTextEntered(static_cast<UserCredentialsInputImp *>(imp)->text);
}

} // namespace QtNative
