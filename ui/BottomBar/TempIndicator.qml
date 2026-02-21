import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 64
    height: 64

    property int temperature: 68
    property int minTemperature: 15
    property int maxTemperature: 32
    property color backgroundColor: "#1f1f1f"
    property color textColor: "white"

    function increaseTemp() {
        if (root.temperature < root.maxTemperature)
            root.temperature++
    }

    function decreaseTemp() {
        if (root.temperature > root.minTemperature)
            root.temperature--
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.backgroundColor
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        // Strzałka w górę – zwiększanie
        Item {
            width: 12
            height: 12
            anchors.horizontalCenter: parent.horizontalCenter

            Canvas {
                id: arrowUp
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle = root.textColor
                    ctx.beginPath()
                    ctx.moveTo(width / 2, 0)
                    ctx.lineTo(0, height)
                    ctx.lineTo(width, height)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.increaseTemp()
            }
        }

        // Temperatura na środku
        Text {
            text: root.temperature + "°"
            color: root.textColor
            font.pixelSize: Math.max(12, Math.min(28, root.height / 2.2))
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Strzałka w dół – zmniejszanie
        Item {
            width: 12
            height: 12
            anchors.horizontalCenter: parent.horizontalCenter

            Canvas {
                id: arrowDown
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle = root.textColor
                    ctx.beginPath()
                    ctx.moveTo(width / 2, height)
                    ctx.lineTo(0, 0)
                    ctx.lineTo(width, 0)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.decreaseTemp()
            }
        }
    }
}
