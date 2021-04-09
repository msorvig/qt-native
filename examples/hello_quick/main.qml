import QtQuick
import QtNative 0.1

Rectangle {
    color: "steelblue"

    UserCredentialsInput  {
        id: password
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        width: 100
        height: 25
        credentialsType: UserCredentialsInput.Password
    }

    Rectangle {
        id: rotatingBox
        color: "lightsteelblue"
        anchors.top : password.bottom + 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 200

        RotationAnimator on rotation {
            from: 0;
            to: 3600;
            duration: 80000
        }
    }

    VideoPlayer {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 400
        height: 200
        videoSource: "BigBuckBunny_512kb.mp4"
    }
}
