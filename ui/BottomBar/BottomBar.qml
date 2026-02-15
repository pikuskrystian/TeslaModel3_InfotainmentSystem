import QtQuick 2.15

Rectangle {
    id: bottomBar
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: parent.height / 12
    color: "black"

    Image {
        id: electricCarIcon
        source: "qrc:/ui/assets/electric-car.png"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 1
        }
        height: parent.height * 0.6
        width: height
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: defrostBackIcon
        source: "qrc:/ui/assets/defrostBack.png"
        anchors {
            left: electricCarIcon.right
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 1
        }
        height: parent.height * 0.6
        width: height
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: defrostFrontIcon
        source: "qrc:/ui/assets/defrostFront.png"
        anchors {
            left: defrostBackIcon.right
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 1
        }
        height: parent.height * 0.6
        width: height
        fillMode: Image.PreserveAspectFit
    }

    TempIndicator {
        id: tempIndicator
        anchors {
            left: defrostFrontIcon.right
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 0.5
        }
        width: parent.height * 1.2
        height: width
        temperature: 22
    }
}
