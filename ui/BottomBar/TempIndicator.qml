import QtQuick 2.15

Item {
    id: root

    property int temperature: 20
    property color textColor: "white"

    signal increase
    signal decrease

    // up arrow
    Item {
        id: arrowUpArea
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
        width: parent.width; height: parent.height * 0.28

        Canvas {
            anchors.centerIn: parent
            width: 10; height: 7
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.fillStyle = arrowUpMouse.containsMouse ? "white" : "#666"
                ctx.beginPath()
                ctx.moveTo(width / 2, 0)
                ctx.lineTo(0, height)
                ctx.lineTo(width, height)
                ctx.closePath()
                ctx.fill()
            }
            MouseArea {
                id: arrowUpMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.increase()
                onContainsMouseChanged: parent.requestPaint()
            }
        }
    }

    // temperature text
    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        text: root.temperature + "°"
        color: root.textColor
        font.pixelSize: Math.max(11, parent.height * 0.38)
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }

    // down arrow
    Item {
        id: arrowDownArea
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        width: parent.width; height: parent.height * 0.28

        Canvas {
            anchors.centerIn: parent
            width: 10; height: 7
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.fillStyle = arrowDownMouse.containsMouse ? "white" : "#666"
                ctx.beginPath()
                ctx.moveTo(width / 2, height)
                ctx.lineTo(0, 0)
                ctx.lineTo(width, 0)
                ctx.closePath()
                ctx.fill()
            }
            MouseArea {
                id: arrowDownMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.decrease()
                onContainsMouseChanged: parent.requestPaint()
            }
        }
    }
}
