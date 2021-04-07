#include "qtnative.h"

#include <vector>
#include <iostream>

#import <AppKit/AppKit.h>

using namespace std;

//
// The macOS backend
// 
// The macOS backend is implemented in terms of Cocoa/AppKit. The
// native view type is NSView.
//

namespace QtNative {
    
//
// Control for the macOS backend
//
class ControlImp
{
public:
    Control *parent = nullptr;
    std::tuple<int, int, int, int> geometry;
    bool visible = false;
    void *native = nullptr;
    std::vector<Control *> children;
    
    NSWindow *window = nil; // Optional, top-level Control only. FIXME: move to separate type
    NSView *view = nil;
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
    // Control parent/child
    if (imp->parent) {
        std::vector<Control *> &children = parent->imp->children;
        children.erase(std::remove(children.begin(), children.end(), this), children.end());
    }
    imp->parent = parent;
    parent->imp->children.push_back(this);
    
    // NSView superview/subview
    [parent->imp->view addSubview:imp->view];
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
    int titlebar = 22;
    int flipy = imp->view.superview.frame.size.height - y - titlebar; // FIXME: flip correctly and handle parent change
    imp->view.frame = NSMakeRect(x, flipy, width, height);  
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
    imp->view.hidden = !visible;
    if (imp->window)
        [imp->window makeKeyAndOrderFront:nil];
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

    auto styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                     NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    NSRect frame = NSMakeRect(200, 200, 320, 200);
    auto window = [[NSWindow alloc] initWithContentRect:frame styleMask:styleMask
                                    backing:NSBackingStoreBuffered defer:NO];
    window.title = @"Qt Native Test Window";
    auto contentView = [[NSView alloc] init];
    window.contentView = contentView;

    Control *control = new Control();
    control->imp->view = contentView;
    control->imp->window = window;
    control->setVisible(false); // window is hidden by default, in order support hidden setup

    return control;
}

} // namespace

// App delegate for Demo/Testing purposes (normally the appliacation controls the delegate)
@interface QtNativeAppDelegate : NSObject <NSApplicationDelegate> {
    std::function<void(void)> m_startup;
}
- (QtNativeAppDelegate *) initWithStartupFunction:(std::function<void(void)>)startup;
@end

@implementation QtNativeAppDelegate

- (QtNativeAppDelegate *) initWithStartupFunction:(std::function<void(void)>)startup
{
    cout << __PRETTY_FUNCTION__ << endl;
    m_startup = startup;
    return self;
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
     cout << __PRETTY_FUNCTION__ << endl;
     m_startup();
}
@end

namespace QtNative {

void spinNativeEventLoop(int argc, char **argv, std::function<void(void)> startup)
{
    cout << __PRETTY_FUNCTION__ << endl;
    NSApplication *app =[NSApplication sharedApplication];
    app.delegate = [[QtNativeAppDelegate alloc] initWithStartupFunction:startup];
    NSApplicationMain(argc, const_cast<const char **>(argv));
}

} // namespace

//
// PushButton for the macOS backend
//

@interface QtNativePushButtonTarget: NSObject { }
@property std::function<void(void)> onClicked;
@end

@implementation QtNativePushButtonTarget
@synthesize onClicked;
- (void) onClick
{
    cout << __PRETTY_FUNCTION__ << endl;
    if (!!onClicked)
        onClicked();
}
@end

namespace QtNative {

class PushButtonImp: public ControlImp
{
public:
    PushButtonImp() {
        ControlImp::view = [NSButton buttonWithTitle:@"placeholder" target:target action:@selector(onClick)];        
    }
    QtNativePushButtonTarget *target = [QtNativePushButtonTarget new];
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
    static_cast<NSButton *>(imp->view).title = [NSString stringWithUTF8String:std::string(caption).c_str()];
}

std::string PushButton::text() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return std::string([static_cast<NSButton *>(imp->view).title UTF8String]);
}

void PushButton::setOnClickedCallback(std::function<void(void)> cb)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<PushButtonImp *>(imp)->target.onClicked = cb;
}

} // namespace

//
// UserCredentialsInput for the macOS backend
//

@interface QtNativeUserCredentialsInputTarget: NSObject <NSTextFieldDelegate> { }
@property std::function<void(string)> onTextEntered;
@end

@implementation QtNativeUserCredentialsInputTarget
@synthesize onTextEntered;

- (void)controlTextDidChange:(NSNotification *)notification
{
    cout << __PRETTY_FUNCTION__ << endl;
    if (!!onTextEntered) {
        std::string text = std::string([static_cast<NSTextField *>(notification.object).stringValue UTF8String]);
        onTextEntered(text);
    }
}
@end

namespace QtNative {

class UserCredentialsInputImp: public ControlImp
{
public:
    QtNativeUserCredentialsInputTarget *target = [QtNativeUserCredentialsInputTarget new];
    UserCredentialsInput::CredentialsType credentialsType = UserCredentialsInput::CredentialsType::Username;
};

UserCredentialsInput::UserCredentialsInput()
:Control(new UserCredentialsInputImp)
{
    cout << __PRETTY_FUNCTION__ << endl;
    setCredentialsType(static_cast<UserCredentialsInputImp *>(imp)->credentialsType);
}

UserCredentialsInput::~UserCredentialsInput()
{
    cout << __PRETTY_FUNCTION__ << endl;
}

void UserCredentialsInput::setCredentialsType(UserCredentialsInput::CredentialsType credentialsType)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<UserCredentialsInputImp *>(imp)->credentialsType = credentialsType;
    NSTextField *view = nil;
    switch (credentialsType) {
        case Username:
            view = [NSTextField new];
            view.contentType = NSTextContentTypeUsername;
        break;
        case Password:
            view = [NSSecureTextField new];
            view.contentType = NSTextContentTypePassword;
        break;
    }
    view.delegate = static_cast<UserCredentialsInputImp *>(imp)->target;
    static_cast<UserCredentialsInputImp *>(imp)->view = view;
}

UserCredentialsInput::CredentialsType UserCredentialsInput::credentialsType()
{
    cout << __PRETTY_FUNCTION__ << endl;
    return static_cast<UserCredentialsInputImp *>(imp)->credentialsType;
}

std::string UserCredentialsInput::text()
{
    cout << __PRETTY_FUNCTION__ << endl;
    return std::string([static_cast<NSTextField *>(imp->view).stringValue UTF8String]);
}

void UserCredentialsInput::setOnTextEnteredCallback(std::function<void(std::string)> cb)
{
    cout << __PRETTY_FUNCTION__ << endl;
    static_cast<UserCredentialsInputImp *>(imp)->target.onTextEntered = cb;
}

} // namespace QtNative
