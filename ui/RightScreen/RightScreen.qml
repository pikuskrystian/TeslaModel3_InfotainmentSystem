import QtQuick 2.15
import QtLocation
import QtPositioning

Rectangle {
    id: rightScreen
    width: parent.width * 2/3

    anchors {
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }

    // ── Playlist ───────────────────────────────────────────────────────
    property int currentTrack: 0
    property bool playing: false
    property real volume: 0.7
    property real progress: 0.0   // 0.0 – 1.0

    readonly property var playlist: [
        { title: "Blinding Lights",      artist: "The Weeknd",        duration: "3:20" },
        { title: "As It Was",            artist: "Harry Styles",       duration: "2:37" },
        { title: "Levitating",           artist: "Dua Lipa",           duration: "3:23" },
        { title: "Stay",                 artist: "The Kid LAROI",      duration: "2:21" },
        { title: "Heat Waves",           artist: "Glass Animals",      duration: "3:59" },
        { title: "Shivers",              artist: "Ed Sheeran",         duration: "3:27" },
        { title: "Bad Habits",           artist: "Ed Sheeran",         duration: "3:51" },
        { title: "Industry Baby",        artist: "Lil Nas X",          duration: "3:32" },
        { title: "Peaches",              artist: "Justin Bieber",      duration: "3:18" },
        { title: "Save Your Tears",      artist: "The Weeknd",         duration: "3:36" }
    ]

    function nextTrack() {
        currentTrack = (currentTrack + 1) % playlist.length
        progress = 0
    }
    function prevTrack() {
        currentTrack = (currentTrack - 1 + playlist.length) % playlist.length
        progress = 0
    }

    // progress ticker when playing
    Timer {
        interval: 500
        running: rightScreen.playing
        repeat: true
        onTriggered: {
            rightScreen.progress = Math.min(1.0, rightScreen.progress + 0.5 / 180)
            if (rightScreen.progress >= 1.0) {
                rightScreen.nextTrack()
                rightScreen.progress = 0
            }
        }
    }

    // ── Map ────────────────────────────────────────────────────────────
    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: musicPlayer.top
        }
        plugin: mapPlugin
        center: QtPositioning.coordinate(52.13, 21.00)
        zoomLevel: 14
        property geoCoordinate startCentroid

        PinchHandler {
            id: pinch
            target: null
            onActiveChanged: if (active) {
                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                map.zoomLevel += Math.log2(delta)
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                map.bearing -= delta
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }
        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }
        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }
    }

    // lock icon overlay on map
    Image {
        id: lockIcon
        source: "qrc:/ui/assets/open_locker.png"
        width: 48; height: 48
        anchors { left: parent.left; top: parent.top; margins: 10 }
        fillMode: Image.PreserveAspectFit
    }

    // ── Music Player Bar ───────────────────────────────────────────────
    Rectangle {
        id: musicPlayer
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 72
        color: "#0d0d0d"

        // top border
        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: 1; color: "#2a2a2a"
        }

        // progress bar along the very top edge
        Rectangle {
            anchors { top: parent.top; left: parent.left }
            height: 2
            width: parent.width * rightScreen.progress
            color: "#4caf50"
            Behavior on width { NumberAnimation { duration: 500 } }
        }

        // ── album art placeholder ──────────────────────────────────────
        Rectangle {
            id: albumArt
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 14 }
            width: 46; height: 46; radius: 4
            color: "#1e1e1e"
            border.color: "#333"; border.width: 1

            // spinning disc effect when playing
            Rectangle {
                anchors.centerIn: parent
                width: 28; height: 28; radius: 14
                color: "#2a2a2a"
                border.color: "#444"; border.width: 1

                Rectangle {
                    anchors.centerIn: parent
                    width: 8; height: 8; radius: 4
                    color: "#555"
                }

                RotationAnimation on rotation {
                    running: rightScreen.playing
                    from: 0; to: 360
                    duration: 3000
                    loops: Animation.Infinite
                }
            }

            // genre colour strip on left edge
            Rectangle {
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                width: 3; radius: 2
                color: {
                    var colors = ["#e53935","#8e24aa","#1e88e5","#43a047","#fb8c00","#00acc1"]
                    return colors[rightScreen.currentTrack % colors.length]
                }
            }
        }

        // ── track info ────────────────────────────────────────────────
        Column {
            anchors {
                left: albumArt.right; leftMargin: 12
                verticalCenter: parent.verticalCenter
            }
            spacing: 3

            Text {
                text: rightScreen.playlist[rightScreen.currentTrack].title
                font.pixelSize: 14; font.bold: true
                color: "white"
            }
            Text {
                text: rightScreen.playlist[rightScreen.currentTrack].artist
                font.pixelSize: 11
                color: "#888"
            }
            Text {
                text: rightScreen.playlist[rightScreen.currentTrack].duration
                font.pixelSize: 10
                color: "#555"
            }
        }

        // ── controls ──────────────────────────────────────────────────
        Row {
            anchors.centerIn: parent
            spacing: 8

            // Prev
            Rectangle {
                width: 36; height: 36; radius: 18
                color: prevMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Text { anchors.centerIn: parent; text: "⏮"; font.pixelSize: 16; color: "#ccc" }
                MouseArea {
                    id: prevMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: rightScreen.prevTrack()
                }
            }

            // Play / Pause
            Rectangle {
                width: 44; height: 44; radius: 22
                color: "#4caf50"
                Text {
                    anchors.centerIn: parent
                    text: rightScreen.playing ? "⏸" : "▶"
                    font.pixelSize: 18
                    color: "white"
                    leftPadding: rightScreen.playing ? 0 : 2
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: rightScreen.playing = !rightScreen.playing
                }
                scale: playMouse.containsMouse ? 1.08 : 1.0
                Behavior on scale { NumberAnimation { duration: 120 } }
                MouseArea {
                    id: playMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: rightScreen.playing = !rightScreen.playing
                }
            }

            // Next
            Rectangle {
                width: 36; height: 36; radius: 18
                color: nextMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Text { anchors.centerIn: parent; text: "⏭"; font.pixelSize: 16; color: "#ccc" }
                MouseArea {
                    id: nextMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: rightScreen.nextTrack()
                }
            }
        }

        // ── volume ────────────────────────────────────────────────────
        Row {
            anchors {
                right: parent.right; verticalCenter: parent.verticalCenter
                rightMargin: 16
            }
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: rightScreen.volume <= 0 ? "🔇"
                    : rightScreen.volume < 0.5 ? "🔉" : "🔊"
                font.pixelSize: 16; color: "#888"
                MouseArea { anchors.fill: parent; onClicked: rightScreen.volume = rightScreen.volume > 0 ? 0 : 0.7 }
            }

            // volume slider track
            Item {
                width: 90; height: 20
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                    height: 3; radius: 2; color: "#333"

                    Rectangle {
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: parent.width * rightScreen.volume
                        radius: 2; color: "#4caf50"
                        Behavior on width { NumberAnimation { duration: 100 } }
                    }
                }

                // knob
                Rectangle {
                    x: (parent.width - width) * rightScreen.volume
                    anchors.verticalCenter: parent.verticalCenter
                    width: 12; height: 12; radius: 6
                    color: "white"
                    Behavior on x { NumberAnimation { duration: 100 } }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked:        (mouse) => rightScreen.volume = Math.max(0, Math.min(1, mouse.x / width))
                    onPositionChanged:(mouse) => { if (pressed) rightScreen.volume = Math.max(0, Math.min(1, mouse.x / width)) }
                }
            }
        }
    }
}
