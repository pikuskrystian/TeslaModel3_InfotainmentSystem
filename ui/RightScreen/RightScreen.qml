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
    property real progress: 0.0

    readonly property var playlist: [
        { title: "Blinding Lights",   artist: "The Weeknd",     duration: "3:20" },
        { title: "As It Was",         artist: "Harry Styles",   duration: "2:37" },
        { title: "Levitating",        artist: "Dua Lipa",       duration: "3:23" },
        { title: "Stay",              artist: "The Kid LAROI",  duration: "2:21" },
        { title: "Heat Waves",        artist: "Glass Animals",  duration: "3:59" },
        { title: "Shivers",           artist: "Ed Sheeran",     duration: "3:27" },
        { title: "Bad Habits",        artist: "Ed Sheeran",     duration: "3:51" },
        { title: "Industry Baby",     artist: "Lil Nas X",      duration: "3:32" },
        { title: "Peaches",           artist: "Justin Bieber",  duration: "3:18" },
        { title: "Save Your Tears",   artist: "The Weeknd",     duration: "3:36" }
    ]

    function nextTrack() { currentTrack = (currentTrack + 1) % playlist.length; progress = 0 }
    function prevTrack() { currentTrack = (currentTrack - 1 + playlist.length) % playlist.length; progress = 0 }

    Timer {
        interval: 500; running: rightScreen.playing; repeat: true
        onTriggered: {
            rightScreen.progress = Math.min(1.0, rightScreen.progress + 0.5 / 180)
            if (rightScreen.progress >= 1.0) { rightScreen.nextTrack(); rightScreen.progress = 0 }
        }
    }

    // ── Map ────────────────────────────────────────────────────────────
    Plugin { id: mapPlugin; name: "osm" }

    Map {
        id: map
        anchors { top: parent.top; left: parent.left; right: parent.right; bottom: musicPlayer.top }
        plugin: mapPlugin
        center: QtPositioning.coordinate(52.13, 21.00)
        zoomLevel: 14
        property geoCoordinate startCentroid

        PinchHandler {
            id: pinch; target: null
            onActiveChanged: if (active) { map.startCentroid = map.toCoordinate(pinch.centroid.position, false) }
            onScaleChanged:   (delta) => { map.zoomLevel += Math.log2(delta); map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position) }
            onRotationChanged:(delta) => { map.bearing -= delta; map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position) }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad : PointerDevice.Mouse
            rotationScale: 1/120; property: "zoomLevel"
        }
        DragHandler { id: drag; target: null; onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y) }
        Shortcut { enabled: map.zoomLevel < map.maximumZoomLevel; sequences: [StandardKey.ZoomIn];  onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1) }
        Shortcut { enabled: map.zoomLevel > map.minimumZoomLevel; sequences: [StandardKey.ZoomOut]; onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1) }
    }

    Image {
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

        Rectangle { anchors { top: parent.top; left: parent.left; right: parent.right } height: 1; color: "#2a2a2a" }

        // progress bar
        Rectangle {
            anchors { top: parent.top; left: parent.left }
            height: 2; width: parent.width * rightScreen.progress; color: "#4caf50"
            Behavior on width { NumberAnimation { duration: 500 } }
        }

        // ── album art ─────────────────────────────────────────────────
        Rectangle {
            id: albumArt
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 14 }
            width: 46; height: 46; radius: 4; color: "#1e1e1e"
            border.color: "#333"; border.width: 1

            Rectangle {
                anchors.centerIn: parent; width: 28; height: 28; radius: 14
                color: "#2a2a2a"; border.color: "#444"; border.width: 1
                Rectangle { anchors.centerIn: parent; width: 8; height: 8; radius: 4; color: "#555" }
                RotationAnimation on rotation { running: rightScreen.playing; from: 0; to: 360; duration: 3000; loops: Animation.Infinite }
            }
            Rectangle {
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                width: 3; radius: 2
                color: ["#e53935","#8e24aa","#1e88e5","#43a047","#fb8c00","#00acc1"][rightScreen.currentTrack % 6]
            }
        }

        // ── track info ────────────────────────────────────────────────
        Column {
            anchors { left: albumArt.right; leftMargin: 12; verticalCenter: parent.verticalCenter }
            spacing: 3
            Text { text: rightScreen.playlist[rightScreen.currentTrack].title; font.pixelSize: 14; font.bold: true; color: "white" }
            Text { text: rightScreen.playlist[rightScreen.currentTrack].artist; font.pixelSize: 11; color: "#888" }
            Text { text: rightScreen.playlist[rightScreen.currentTrack].duration; font.pixelSize: 10; color: "#555" }
        }

        // ── playback controls ─────────────────────────────────────────
        Row {
            anchors.centerIn: parent
            spacing: 8

            // Prev
            Rectangle {
                width: 36; height: 36; radius: 18
                color: prevMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Image { anchors.centerIn: parent; width: 22; height: 22; source: "qrc:/ui/assets/prev.png"; fillMode: Image.PreserveAspectFit; opacity: prevMouse.containsMouse ? 1.0 : 0.6 }
                MouseArea { id: prevMouse; anchors.fill: parent; hoverEnabled: true; onClicked: rightScreen.prevTrack() }
            }

            // Play/Pause
            Rectangle {
                width: 44; height: 44; radius: 22; color: "#737270"
                scale: playMouse.containsMouse ? 1.08 : 1.0
                Behavior on scale { NumberAnimation { duration: 120 } }
                Image { anchors.centerIn: parent; width: 24; height: 24; source: rightScreen.playing ? "qrc:/ui/assets/pause.png" : "qrc:/ui/assets/play.png"; fillMode: Image.PreserveAspectFit }
                MouseArea { id: playMouse; anchors.fill: parent; hoverEnabled: true; onClicked: rightScreen.playing = !rightScreen.playing }
            }

            // Next
            Rectangle {
                width: 36; height: 36; radius: 18
                color: nextMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Image { anchors.centerIn: parent; width: 22; height: 22; source: "qrc:/ui/assets/next.png"; fillMode: Image.PreserveAspectFit; opacity: nextMouse.containsMouse ? 1.0 : 0.6 }
                MouseArea { id: nextMouse; anchors.fill: parent; hoverEnabled: true; onClicked: rightScreen.nextTrack() }
            }
        }

        // ── right side: search + publish icons ────────────────────────
        Row {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 16 }
            spacing: 10

            // Search
            Rectangle {
                width: 36; height: 36; radius: 18
                color: searchMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Image { anchors.centerIn: parent; width: 22; height: 22; source: "qrc:/ui/assets/search.png"; fillMode: Image.PreserveAspectFit; opacity: searchMouse.containsMouse ? 1.0 : 0.6 }
                MouseArea { id: searchMouse; anchors.fill: parent; hoverEnabled: true }
            }

            // Publish (share/upload)
            Rectangle {
                width: 36; height: 36; radius: 18
                color: publishMouse.containsMouse ? "#222" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
                Image { anchors.centerIn: parent; width: 22; height: 22; source: "qrc:/ui/assets/publish.png"; fillMode: Image.PreserveAspectFit; opacity: publishMouse.containsMouse ? 1.0 : 0.6 }
                MouseArea { id: publishMouse; anchors.fill: parent; hoverEnabled: true }
            }
        }
    }
}
