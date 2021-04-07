import QtQuick
import QtNative 0.1

Rectangle {
    color: "darkgrey"

    PushButton {
        x : 20
        y: 10
        width: 100
        height: 25

        caption: "qml button!"
    }

    UserCredentialsInput  {
        x : 20
        y: 30
        width: 100
        height: 25

        credentialsType: UserCredentialsInput.Password
    }
}
