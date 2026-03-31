import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: bottomBar
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: parent.height / 10
    color: "#111111"

    Rectangle { anchors { top: parent.top; left: parent.left; right: parent.right } height: 1; color: "#2a2a2a" }

    // ── state ──────────────────────────────────────────────────────────
    property bool carActive:    false
    property bool defrostFront: false
    property bool defrostBack:  false
    property bool seatHeatL:    false
    property bool seatHeatR:    false
    property bool hvacOn:       true
    property int  tempDriver:    20
    property int  tempPassenger: 20
    property bool isManual:     true
    property bool musicActive:  false
    property bool phoneActive:  false
    property real volume:       0.5
    property int  minTemp:      15
    property int  maxTemp:      30

    function clampTemp(v) { return Math.max(minTemp, Math.min(maxTemp, v)) }
    readonly property real iconSize: height * 0.46

    // ── helper: one icon button ────────────────────────────────────────
    // used inline below as Rectangle with Image inside

    // ══════════════════════════════════════════════════════════════════
    // CENTRE — anchored first so left/right can reference it
    // ══════════════════════════════════════════════════════════════════
    Row {
        id: centreGroup
        anchors.centerIn: parent
        spacing: 14

        TempIndicator {
            width: bottomBar.height * 0.82; height: width
            temperature: bottomBar.tempDriver
            onIncrease: bottomBar.tempDriver = bottomBar.clampTemp(bottomBar.tempDriver + 1)
            onDecrease: bottomBar.tempDriver = bottomBar.clampTemp(bottomBar.tempDriver - 1)
        }

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

        TempIndicator {
            width: bottomBar.height * 0.82; height: width
            temperature: bottomBar.tempPassenger
            onIncrease: bottomBar.tempPassenger = bottomBar.clampTemp(bottomBar.tempPassenger + 1)
            onDecrease: bottomBar.tempPassenger = bottomBar.clampTemp(bottomBar.tempPassenger - 1)
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // LEFT PANEL — fills space between left edge and centre
    // 4 buttons spread evenly
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: leftPanel
        anchors {
            left: parent.left
            right: centreGroup.left
            top: parent.top; bottom: parent.bottom
        }

        // We place 4 buttons by dividing leftPanel into 4 equal slots
        Repeater {
            model: [
                { src: "qrc:/ui/assets/car_icon.png",              prop: "carActive",    activeColor: "#ffffff" },
                { src: "qrc:/ui/assets/windshield_defrost.png",     prop: "defrostFront", activeColor: "#ff9800" },
                { src: "qrc:/ui/assets/windshield_defrost_rear.png",prop: "defrostBack",  activeColor: "#ff9800" },
                { src: "qrc:/ui/assets/seat_heat_left.png",         prop: "seatHeatL",    activeColor: "#ef5350" }
            ]

            delegate: Item {
                x: (index + 0.5) * (leftPanel.width / 4) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: bottomBar.height * 0.78
                height: width

                Rectangle {
                    anchors.fill: parent; radius: 6
                    color: bottomBar[modelData.prop] ? Qt.rgba(
                               Qt.color(modelData.activeColor).r,
                               Qt.color(modelData.activeColor).g,
                               Qt.color(modelData.activeColor).b, 0.15) : "transparent"
                    border.color: bottomBar[modelData.prop] ? modelData.activeColor : "transparent"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                Image {
                    anchors.centerIn: parent
                    width: bottomBar.iconSize; height: bottomBar.iconSize
                    source: modelData.src
                    fillMode: Image.PreserveAspectFit
                    opacity: bottomBar[modelData.prop] ? 1.0 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: bottomBar[modelData.prop] = !bottomBar[modelData.prop]
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // RIGHT PANEL — fills space between centre and right edge
    // seat_heat_right | music_note | mobile_2 | volume icon + slider
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: rightPanel
        anchors {
            left: centreGroup.right
            right: parent.right
            top: parent.top; bottom: parent.bottom
        }

        // 3 icon buttons spread across first 3 slots
        Repeater {
            model: [
                { src: "qrc:/ui/assets/seat_heat_right.png", prop: "seatHeatR",   activeColor: "#ef5350" },
                { src: "qrc:/ui/assets/music_note.png",       prop: "musicActive", activeColor: "#42a5f5" },
                { src: "qrc:/ui/assets/mobile_2.png",         prop: "phoneActive", activeColor: "#42a5f5" }
            ]

            delegate: Item {
                // slots: 0, 1, 2 out of 4 total slots in rightPanel
                x: (index + 0.5) * (rightPanel.width / 4) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: bottomBar.height * 0.78
                height: width

                Rectangle {
                    anchors.fill: parent; radius: 6
                    color: bottomBar[modelData.prop] ? Qt.rgba(
                               Qt.color(modelData.activeColor).r,
                               Qt.color(modelData.activeColor).g,
                               Qt.color(modelData.activeColor).b, 0.15) : "transparent"
                    border.color: bottomBar[modelData.prop] ? modelData.activeColor : "transparent"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                Image {
                    anchors.centerIn: parent
                    width: bottomBar.iconSize; height: bottomBar.iconSize
                    source: modelData.src
                    fillMode: Image.PreserveAspectFit
                    opacity: bottomBar[modelData.prop] ? 1.0 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: bottomBar[modelData.prop] = !bottomBar[modelData.prop]
                }
            }
        }

        // Volume — occupies slot 3 (last quarter of rightPanel)
        Item {
            x: 3 * (rightPanel.width / 4)
            width: rightPanel.width / 4
            anchors { top: parent.top; bottom: parent.bottom }

            Row {
                anchors.centerIn: parent
                spacing: 6

                // volume icon — mute toggle
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: bottomBar.iconSize; height: bottomBar.iconSize
                    fillMode: Image.PreserveAspectFit
                    source: bottomBar.volume <= 0   ? "qrc:/ui/assets/volume_off_24dp.png"
                          : bottomBar.volume < 0.35 ? "qrc:/ui/assets/volume_mute_24dp.png"
                          : bottomBar.volume < 0.65 ? "qrc:/ui/assets/volume_down_24dp.png"
                                                    : "qrc:/ui/assets/volume_up_24dp.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: bottomBar.volume = bottomBar.volume > 0 ? 0 : 0.5
                    }
                }

                // slider
                Item {
                    width: 70; height: 20
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        height: 3; radius: 2; color: "#2a2a2a"

                        Rectangle {
                            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                            width: parent.width * bottomBar.volume
                            radius: 2; color: "#4caf50"
                            Behavior on width { NumberAnimation { duration: 100 } }
                        }
                    }

                    Rectangle {
                        x: (parent.width - width) * bottomBar.volume
                        anchors.verticalCenter: parent.verticalCenter
                        width: 11; height: 11; radius: 6; color: "white"
                        Behavior on x { NumberAnimation { duration: 100 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked:         (mouse) => bottomBar.volume = Math.max(0, Math.min(1, mouse.x / width))
                        onPositionChanged: (mouse) => { if (pressed) bottomBar.volume = Math.max(0, Math.min(1, mouse.x / width)) }
                    }
                }
            }
        }
    }
}
