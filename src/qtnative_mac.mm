#include "qtnative.h"

#include <vector>
#include <iostream>

#import <AppKit/AppKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

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

    NSView *view = nil;
};

Control::Control()
:imp(new ControlImp())
{
    cout << __PRETTY_FUNCTION__ << endl;
}

Control::Control(void *nativeControl)
:imp(new ControlImp())
{
    cout << __PRETTY_FUNCTION__ << endl;
    imp->view = static_cast<NSView *>(nativeControl);
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

// https://stackoverflow.com/questions/4166879/how-to-print-a-control-hierarchy-in-cocoa
NSString * hierarchicalDescriptionOfView(NSView *view, NSUInteger level)
{

  // Ready the description string for this level
  NSMutableString * builtHierarchicalString = [NSMutableString string];

  // Build the tab string for the current level's indentation
  NSMutableString * tabString = [NSMutableString string];
  for (NSUInteger i = 0; i <= level; i++)
    [tabString appendString:@"\t"];

  // Get the view's title string if it has one
  NSString * titleString = ([view respondsToSelector:@selector(title)]) ? [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"\"%@\" ", [(NSButton *)view title]]] : @"";

  // Append our own description at this level
  [builtHierarchicalString appendFormat:@"\n%@<%@: %p> %@(%li subviews)", tabString, [view className], view, titleString, [[view subviews] count]];  
  [builtHierarchicalString appendFormat:@" hidden %d frame %@", view.hidden, NSStringFromRect(view.frame)];  

  // Recurse for each subview ...
  for (NSView * subview in [view subviews])
    [builtHierarchicalString appendString: hierarchicalDescriptionOfView(subview, (level + 1))];
                                                                          

  return builtHierarchicalString;
}

namespace {
    void applyGeoometry(NSView *view, std::tuple<int, int, int, int> geometry) {

        // We need a valid view, but also a valid parent view in
        // order to resolve the geometry (possibly flipping it).
        if (view == nil)
            return;
        if (view.superview == nil)
            return;
        bool isFLipped = view.superview.isFlipped;
        bool isSuperContentView = view.window.contentView == view.superview;
        auto [x, y, w, h] = geometry;
        int titlebar = 22;
        int flipy = isFLipped ? y : view.superview.frame.size.height - y -titlebar;
        view.frame = NSMakeRect(x, flipy, w, h);
    }
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
    
    // apply geometry
    applyGeoometry(imp->view, imp->geometry);
    
    
//    cout << " isFlipped " << isFLipped << endl;
    
//    cout << "view" << imp->view
//    NSLog(@"%@", hierarchicalDescriptionOfView(parent->imp->view, 0));
}

Control *Control::parent() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return imp->parent;
}

void Control::setGeometry(int x, int y, int width, int height)
{
    cout << __PRETTY_FUNCTION__ << " isFlipped " << imp->view.superview.isFlipped << endl;
    imp->geometry = make_tuple(x, y, width, height);
    applyGeoometry(imp->view, imp->geometry);
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
    if (NSWindow *window = imp->view.window) {
        if (window.contentView == imp->view)
            [window makeKeyAndOrderFront:nil];        
    }
}

bool Control::visible() const
{
    cout << __PRETTY_FUNCTION__ << endl;
    return imp->visible;
}

void Control::setNativeControl(void *nativeControl)
{
    cout << __PRETTY_FUNCTION__ << " " << nativeControl << endl;
    imp->view = static_cast<NSView *>(nativeControl);
    setVisible(true);
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
    NSRect frame = NSMakeRect(200, 200, 500, 400);
    auto window = [[NSWindow alloc] initWithContentRect:frame styleMask:styleMask
                                    backing:NSBackingStoreBuffered defer:NO];
    window.title = @"Qt Native Test Window";
    auto contentView = [[NSView alloc] init];
    window.contentView = contentView;

    Control *control = new Control(contentView);
//    control->setVisible(false); // window is hidden by default, in order support hidden setup

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
    cout << __PRETTY_FUNCTION__  << " " << credentialsType << endl;
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

//
// VideoPlayer for the mac backend
//
class VideoPlayerImp: public ControlImp
{
public:
    std::string videoSource;
};

VideoPlayer::VideoPlayer()
:Control(new VideoPlayerImp)
{
    AVPlayerView *view = [AVPlayerView new];

    view.showsFullScreenToggleButton = YES;
    view.allowsPictureInPicturePlayback = YES;

    Control::imp->view = view;

    cout << __PRETTY_FUNCTION__ << endl;
}

VideoPlayer::~VideoPlayer()
{
    cout << __PRETTY_FUNCTION__ << endl;
}

void VideoPlayer::setVideoSource(std::string_view source)
{
    cout << __PRETTY_FUNCTION__ << " " << source << endl;

    NSURL *url = [NSURL fileURLWithPath: [NSString stringWithUTF8String:std::string(source).c_str()]];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    static_cast<AVPlayerView *>(Control::imp->view).player = player;
    static_cast<VideoPlayerImp *>(Control::imp)->videoSource  = source;
}

std::string VideoPlayer::videoSource()
{
    cout << __PRETTY_FUNCTION__ << endl;
    return static_cast<VideoPlayerImp *>(imp)->videoSource;
}


} // namespace QtNative
