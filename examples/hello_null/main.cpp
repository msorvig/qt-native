#include <memory>
#include <iostream>

#include <qtnative.h>

int main(int argc, char**argv) {
    
    // Create Window
    std::unique_ptr<QtNative::Control> window(QtNative::createNativeWindowControl());

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
    userName->setParent(window.get());
    userName->setGeometry(10, 50, 100, 25);
    userName->setOnTextEnteredCallback([](std::string text){
        std::cout << "username " << text << std::endl;
    });

    QtNative::UserCredentialsInput *password = new QtNative::UserCredentialsInput();
    password->setParent(window.get());
    password->setGeometry(150, 50, 100, 25);
    password->setOnTextEnteredCallback([](std::string text){
        std::cout << "password " << text << std::endl;
    });
    
    // Show window
    window->setVisible(true);
    QtNative::spinNativeEventLoopAndNeverReturn();
}