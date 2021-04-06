
Qt Native - Cross Platform Native UI with C++ and Qt (Prototype)
================================================================

Qt Company spring 2021 hackaton project
---------------------------------------

Many applications are mostly cross-platform, but could benefit from having easy access
to one or two native controls such as a password text input or a video player.

This project provides a cross-platform C++ API, with a few prototype backends (well,
currently only the null backend).

Platforms:

* Null

Controls:

* PushButton
* UserCredentialsInput (username/password)

Usage
-----

From C++: include qtnative.h and add one of the qtnative_foo.cpp files to the build
(depending on platform). Use the API in the QtNative namespace to create the native
controls and to set properties. Then get the native instance using Control::nativeControl() -
this native instance can be added to the native UI hiearchy.
