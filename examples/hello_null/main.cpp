#include <memory>
#include <iostream>

#include <qtnative.h>

int main(int argc, char **argv) {

    std::unique_ptr<QtNative::Control> window;

    auto startup = [&window](){
        // Create Window
        window.reset(QtNative::createNativeWindowControl());

        // Add button
        QtNative::PushButton *button = new QtNative::PushButton();
        button->setParent(window.get());
        button->setGeometry(10, 10, 100, 25);
        button->setText("Button");
        button->setOnClickedCallback([](){
            std::cout << "Button Clicked" << std::endl;
        });

        // Add username/password edit
        QtNative::UserCredentialsInput *userName = new QtNative::UserCredentialsInput();
        userName->setCredentialsType(QtNative::UserCredentialsInput::Username);
        userName->setParent(window.get());
        userName->setGeometry(10, 50, 100, 25);
        userName->setOnTextEnteredCallback([](std::string text){
            std::cout << "username " << text << std::endl;
        });

        QtNative::UserCredentialsInput *password = new QtNative::UserCredentialsInput();
        userName->setCredentialsType(QtNative::UserCredentialsInput::Password);
        password->setParent(window.get());
        password->setGeometry(150, 50, 100, 25);
        password->setOnTextEnteredCallback([](std::string text){
            std::cout << "password " << text << std::endl;
        });

        QtNative::VideoPlayer *videoPlayer = new QtNative::VideoPlayer();
        videoPlayer->setParent(window.get());
        videoPlayer->setVideoSource("BigBuckBunny_512kb.mp4");
        videoPlayer->setGeometry(10, 200, 200, 100);

        // Show window
        window->setVisible(true);
    };

    QtNative::spinNativeEventLoop(argc, argv, startup);
}