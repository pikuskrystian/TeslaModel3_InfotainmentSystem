import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: bottomBar
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: parent.height / 10
    color: "#111111"

    // thin top separator
    Rectangle {
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 1
        color: "#2a2a2a"
    }

    // ── state ─────────────────────────────────────────────────────────
    property bool locked:        false
    property bool hvacOn:        true
    property bool defrostFront:  false
    property bool defrostBack:   false
    property bool seatHeatL:     false
    property int  tempDriver:    20
    property int  tempPassenger: 20
    property bool isManual:      true
    property bool mediaPlaying:  false
    property int  volume:        15
    property int  minTemp:       15
    property int  maxTemp:       30

    function clampTemp(v) { return Math.max(minTemp, Math.min(maxTemp, v)) }

    readonly property real btnSize: height * 0.70

    // ══════════════════════════════════════════════════════════════════
    // LEFT GROUP — lock | hvac | defrost front | defrost back | seat heat
    // ══════════════════════════════════════════════════════════════════
    Row {
        id: leftGroup
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 14 }
        spacing: 6

        // Lock
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.locked ? "#ffffff22" : "transparent"
            border.color: bottomBar.locked ? "white" : "transparent"; border.width: 1
            Text { anchors.centerIn: parent; text: bottomBar.locked ? "🔒" : "🔓"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.locked = !bottomBar.locked }
        }

        // HVAC
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.hvacOn ? "#1565c033" : "transparent"
            border.color: bottomBar.hvacOn ? "#42a5f5" : "transparent"; border.width: 1
            Text { anchors.centerIn: parent; text: "❄"; font.pixelSize: parent.height * 0.44; color: bottomBar.hvacOn ? "#42a5f5" : "#aaa" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.hvacOn = !bottomBar.hvacOn }
        }

        // Defrost front
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.defrostFront ? "#e6510033" : "transparent"
            border.color: bottomBar.defrostFront ? "#ff9800" : "transparent"; border.width: 1
            Image {
                anchors.centerIn: parent
                source: "qrc:/ui/assets/defrostFront.png"
                width: parent.width * 0.65; height: parent.height * 0.65
                fillMode: Image.PreserveAspectFit
                opacity: bottomBar.defrostFront ? 1.0 : 0.4
            }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.defrostFront = !bottomBar.defrostFront }
        }

        // Defrost back
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.defrostBack ? "#e6510033" : "transparent"
            border.color: bottomBar.defrostBack ? "#ff9800" : "transparent"; border.width: 1
            Image {
                anchors.centerIn: parent
                source: "qrc:/ui/assets/defrostBack.png"
                width: parent.width * 0.65; height: parent.height * 0.65
                fillMode: Image.PreserveAspectFit
                opacity: bottomBar.defrostBack ? 1.0 : 0.4
            }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.defrostBack = !bottomBar.defrostBack }
        }

        // Seat heat
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.seatHeatL ? "#b71c1c33" : "transparent"
            border.color: bottomBar.seatHeatL ? "#ef5350" : "transparent"; border.width: 1
            Text { anchors.centerIn: parent; text: "🪑"; font.pixelSize: parent.height * 0.44; color: bottomBar.seatHeatL ? "#ef5350" : "#aaa" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.seatHeatL = !bottomBar.seatHeatL }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // CENTRE — driver temp | MANUAL/AUTO | passenger temp
    // ══════════════════════════════════════════════════════════════════
    Row {
        anchors.centerIn: parent
        spacing: 14

        // Driver temp
        TempIndicator {
            width: bottomBar.height * 0.82; height: width
            temperature: bottomBar.tempDriver
            onIncrease: bottomBar.tempDriver = bottomBar.clampTemp(bottomBar.tempDriver + 1)
            onDecrease: bottomBar.tempDriver = bottomBar.clampTemp(bottomBar.tempDriver - 1)
        }

        // MANUAL / AUTO
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: bottomBar.isManual ? "MANUAL" : "AUTO"
                font.pixelSize: 9; color: "#666"; font.letterSpacing: 1
            }
            Rectangle {
                width: 44; height: 14; radius: 7
                color: bottomBar.isManual ? "#333" : "#1565c0"
                Text { anchors.centerIn: parent; text: bottomBar.isManual ? "MAN" : "AUTO"; font.pixelSize: 8; color: "white" }
                MouseArea { anchors.fill: parent; onClicked: bottomBar.isManual = !bottomBar.isManual }
            }
        }

        // Passenger temp
        TempIndicator {
            width: bottomBar.height * 0.82; height: width
            temperature: bottomBar.tempPassenger
            onIncrease: bottomBar.tempPassenger = bottomBar.clampTemp(bottomBar.tempPassenger + 1)
            onDecrease: bottomBar.tempPassenger = bottomBar.clampTemp(bottomBar.tempPassenger - 1)
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // RIGHT GROUP — media controls | phone | volume
    // ══════════════════════════════════════════════════════════════════
    Row {
        id: rightGroup
        anchors { right: volumeBar.left; verticalCenter: parent.verticalCenter; rightMargin: 10 }
        spacing: 6

        // Prev
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6; color: "transparent"
            Text { anchors.centerIn: parent; text: "⏮"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent }
        }
        // Play/Pause
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6
            color: bottomBar.mediaPlaying ? "#ffffff15" : "transparent"
            border.color: bottomBar.mediaPlaying ? "#888" : "transparent"; border.width: 1
            Text { anchors.centerIn: parent; text: bottomBar.mediaPlaying ? "⏸" : "▶"; font.pixelSize: parent.height * 0.44; color: "#ccc" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.mediaPlaying = !bottomBar.mediaPlaying }
        }
        // Next
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6; color: "transparent"
            Text { anchors.centerIn: parent; text: "⏭"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent }
        }
        // Phone
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6; color: "transparent"
            Text { anchors.centerIn: parent; text: "📞"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent }
        }
        // Vol down
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6; color: "transparent"
            Text { anchors.centerIn: parent; text: "🔉"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.volume = Math.max(0, bottomBar.volume - 1) }
        }
        // Vol up
        Rectangle {
            width: bottomBar.btnSize; height: width; radius: 6; color: "transparent"
            Text { anchors.centerIn: parent; text: "🔊"; font.pixelSize: parent.height * 0.44; color: "#aaa" }
            MouseArea { anchors.fill: parent; onClicked: bottomBar.volume = Math.min(30, bottomBar.volume + 1) }
        }
    }

    // ── volume bar visualiser ─────────────────────────────────────────
    Row {
        id: volumeBar
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
        spacing: 3

        Repeater {
            model: 10
            Rectangle {
                width: 3
                height: bottomBar.height * (0.18 + index * 0.055)
                anchors.verticalCenter: parent.verticalCenter
                radius: 1
                color: index < Math.round(bottomBar.volume / 3) ? "#4caf50" : "#2a2a2a"
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }
}
