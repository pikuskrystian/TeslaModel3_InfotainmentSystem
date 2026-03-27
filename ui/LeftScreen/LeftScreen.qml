import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: leftScreen

    anchors {
        left: parent.left
        right: rightScreen.left
        bottom: bottomBar.top
        top: parent.top
    }
    color: "#1a1a1a"

    // ── Simulated state ────────────────────────────────────────────────
    property int    speed:       72
    property int    speedLimit:  80
    property real   batteryPct:  0.74
    property int    rangeKm:     289
    property real   outsideTemp: 18.5
    property string gear:        "D"
    property real   powerPct:    0.35

    property bool doorFL: false
    property bool doorFR: false
    property bool doorRL: false
    property bool doorRR: false
    property bool trunk:  false
    property bool frunk:  false
    property bool headlights: false

    // ── Animated demo loop ─────────────────────────────────────────────
    Timer {
        interval: 50; running: true; repeat: true
        property real t: 0
        onTriggered: {
            t += 0.02
            leftScreen.speed      = Math.round(60 + 20 * Math.sin(t * 0.7))
            leftScreen.powerPct   = 0.4 * Math.sin(t * 0.9)
            leftScreen.batteryPct = Math.max(0.05, 0.74 - t * 0.0003)
            leftScreen.rangeKm    = Math.round(leftScreen.batteryPct * 390)
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // TOP-LEFT — big speedometer + PRND
    // ══════════════════════════════════════════════════════════════════
    Column {
        id: speedoBlock
        anchors {
            top: parent.top; left: parent.left
            topMargin: 14; leftMargin: 16
        }
        spacing: 6

        // Speed number
        Text {
            text: leftScreen.speed
            font.pixelSize: 72; font.bold: true
            color: (leftScreen.speedLimit > 0 && leftScreen.speed > leftScreen.speedLimit)
                   ? "#e53935" : "white"
            Behavior on color { ColorAnimation { duration: 300 } }
        }
        Text {
            text: "km/h"; font.pixelSize: 13; color: "#888"
            leftPadding: 4
        }

        // PRND strip
        Row {
            spacing: 10
            Repeater {
                model: ["P","R","N","D"]
                delegate: Item {
                    width: 26; height: 34
                    Rectangle {
                        anchors.fill: parent; radius: 4
                        color: modelData === leftScreen.gear ? "#ffffff" : "transparent"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    Text {
                        anchors.centerIn: parent; text: modelData
                        font.pixelSize: 17; font.bold: true
                        color: modelData === leftScreen.gear ? "#1a1a1a" : "#555"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    MouseArea { anchors.fill: parent; onClicked: leftScreen.gear = modelData }
                }
            }
        }
    }

    // Speed limit sign — top-left, below speedo
    Item {
        visible: leftScreen.speedLimit > 0
        anchors {
            top: speedoBlock.bottom; left: parent.left
            topMargin: 8; leftMargin: 20
        }
        width: 40; height: 40
        Rectangle { anchors.fill: parent; radius: width/2; color: "white"; border.color: "#e53935"; border.width: 4 }
        Text { anchors.centerIn: parent; text: leftScreen.speedLimit; font.pixelSize: 13; font.bold: true; color: "#111" }
    }

    // ══════════════════════════════════════════════════════════════════
    // TOP-RIGHT — battery panel
    // ══════════════════════════════════════════════════════════════════
    Column {
        id: batteryPanel
        anchors {
            top: parent.top; right: parent.right
            topMargin: 14; rightMargin: 16
        }
        spacing: 6

        // % and range on one line
        Row {
            anchors.right: parent.right
            spacing: 6
            Text {
                text: Math.round(leftScreen.batteryPct * 100) + "%"
                font.pixelSize: 22; font.bold: true
                color: leftScreen.batteryPct < 0.2 ? "#e53935"
                     : leftScreen.batteryPct < 0.4 ? "#ff9800" : "#4caf50"
                Behavior on color { ColorAnimation { duration: 400 } }
            }
            Text {
                text: leftScreen.rangeKm + " km"
                font.pixelSize: 14; color: "#888"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Battery bar
        Item {
            width: 100; height: 20
            anchors.right: parent.right

            Rectangle {
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                width: parent.width - 7; radius: 4
                color: "#2a2a2a"; border.color: "#444"; border.width: 1

                Rectangle {
                    anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 2 }
                    width: Math.max(4, (parent.width - 4) * leftScreen.batteryPct)
                    radius: 3
                    color: leftScreen.batteryPct < 0.2 ? "#e53935"
                         : leftScreen.batteryPct < 0.4 ? "#ff9800" : "#4caf50"
                    Behavior on width { NumberAnimation { duration: 400 } }
                    Behavior on color { ColorAnimation { duration: 400 } }
                }
            }
            // terminal nub
            Rectangle {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                width: 6; height: 10; radius: 2; color: "#444"
            }
        }

        // Outside temp
        Row {
            anchors.right: parent.right
            spacing: 4
            Text { text: "⛅"; font.pixelSize: 13 }
            Text { text: leftScreen.outsideTemp.toFixed(1) + "°C"; font.pixelSize: 13; color: "#aaa" }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // POWER / REGEN BAR
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: powerBar
        anchors {
            top: batteryPanel.bottom
            left: parent.left; right: parent.right
            topMargin: 8; leftMargin: 16; rightMargin: 16
        }
        height: 20

        Repeater {
            model: 9
            Rectangle {
                x: (index / 8) * powerBar.width
                anchors.verticalCenter: parent.verticalCenter
                width: 1; height: index === 4 ? 14 : 8; color: "#444"
            }
        }
        Rectangle {
            visible: leftScreen.powerPct < 0
            anchors { right: parent.horizontalCenter; top: parent.top; bottom: parent.bottom; margins: 4 }
            width: Math.abs(leftScreen.powerPct) * (parent.width / 2)
            color: "#4caf50"; radius: 3
            Behavior on width { NumberAnimation { duration: 80 } }
        }
        Rectangle {
            visible: leftScreen.powerPct > 0
            anchors { left: parent.horizontalCenter; top: parent.top; bottom: parent.bottom; margins: 4 }
            width: leftScreen.powerPct * (parent.width / 2)
            color: "#e0e0e0"; radius: 3
            Behavior on width { NumberAnimation { duration: 80 } }
        }
        Text { anchors { left: parent.left; verticalCenter: parent.verticalCenter } text: "REGEN"; font.pixelSize: 8; color: "#555" }
        Text { anchors { right: parent.right; verticalCenter: parent.verticalCenter } text: "PWR"; font.pixelSize: 8; color: "#555" }
    }

    // ══════════════════════════════════════════════════════════════════
    // 3D CAR VIEWER
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: carArea
        anchors {
            top: powerBar.bottom; left: parent.left; right: parent.right; bottom: lightsRow.top
            topMargin: 100; bottomMargin: 4
        }

        CarViewer {
            id: carViewer
            anchors {
                top: parent.top; left: parent.left; right: parent.right
                bottom: doorRow.top; bottomMargin: 4
            }

            NumberAnimation on modelRotationY {
                id: autoRotate
                from: -30; to: 330
                duration: 18000
                loops: Animation.Infinite
                running: true
            }
        }

        // Door / trunk strip
        Row {
            id: doorRow
            anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 2 }
            spacing: 6

            Repeater {
                model: [
                    { label: "FL",    prop: "doorFL" },
                    { label: "FR",    prop: "doorFR" },
                    { label: "RL",    prop: "doorRL" },
                    { label: "RR",    prop: "doorRR" },
                    { label: "FRUNK", prop: "frunk"  },
                    { label: "TRUNK", prop: "trunk"  }
                ]
                delegate: Rectangle {
                    width: modelData.label.length > 2 ? 46 : 28
                    height: 22; radius: 4
                    color: leftScreen[modelData.prop]
                           ? (modelData.label === "FRUNK" || modelData.label === "TRUNK" ? "#e65100" : "#c62828")
                           : "#222"
                    border.color: leftScreen[modelData.prop] ? "#ff7043" : "#3a3a3a"; border.width: 1
                    Text {
                        anchors.centerIn: parent; text: modelData.label
                        font.pixelSize: 9; font.bold: leftScreen[modelData.prop]
                        color: leftScreen[modelData.prop] ? "white" : "#555"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            leftScreen[modelData.prop] = !leftScreen[modelData.prop]
                            autoRotate.running = false
                            resumeTimer.restart()
                        }
                    }
                }
            }
        }

        Timer { id: resumeTimer; interval: 4000; onTriggered: autoRotate.running = true }
    }

    // ══════════════════════════════════════════════════════════════════
    // BOTTOM STATUS ROW
    // ══════════════════════════════════════════════════════════════════
    Row {
        id: lightsRow
        anchors {
            bottom: parent.bottom; left: parent.left; right: parent.right
            bottomMargin: 10; leftMargin: 16; rightMargin: 16
        }
        height: 28; spacing: 12

        Rectangle {
            width: 32; height: 28; radius: 4
            color: leftScreen.headlights ? "#1565c0" : "#2a2a2a"
            border.color: leftScreen.headlights ? "#42a5f5" : "#444"; border.width: 1
            Text { anchors.centerIn: parent; text: "🔆"; font.pixelSize: 14 }
            MouseArea { anchors.fill: parent; onClicked: leftScreen.headlights = !leftScreen.headlights }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatTime(new Date(), "hh:mm")
            font.pixelSize: 14; color: "#888"
            Timer { interval: 10000; running: true; repeat: true; onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm") }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: leftScreen.doorFL || leftScreen.doorFR || leftScreen.doorRL || leftScreen.doorRR || leftScreen.trunk || leftScreen.frunk
            text: "⚠ Door/Trunk open"; font.pixelSize: 11; color: "#ff9800"
        }
    }
}
