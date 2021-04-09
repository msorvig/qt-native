
Qt Native - Cross Platform Native UI with C++ and Qt (Prototype)
================================================================

Qt Company spring 2021 hackaton project
---------------------------------------

Many applications are mostly cross-platform, but could benefit from having easy access
to one or two native controls such as a password text input or a video player.

This project provides a cross-platform C++ API, with one prototype backend.

Platforms:

* Null
* macOS

Controls:

* PushButton
* UserCredentialsInput (username/password)
* VideoPlayer

Usage
-----

From C++: include qtnative.h and add one of the qtnative_foo.cpp files to the build
(depending on platform). Use the API in the QtNative namespace to create the native
controls and to set properties. Then get the native instance using Control::nativeControl()
this native instance can be added to the UI hiearchy. For example:

    QWindow *buttonWindow = QWindow::fromWinId((WId)button->nativeControl());
    QWiddget *buttonWidget = QWidget::createWindowContainer(buttonWindow);

From QML: Register types from qtnative_quick.h, instantiate items from QML:

    VideoPlayer {
        width: 400
        height: 200
        videoSource: "BigBuckBunny_512kb.mp4"
    }
