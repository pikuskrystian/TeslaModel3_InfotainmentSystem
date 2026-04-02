import QtQuick 2.15
import QtQuick3D
import QtQuick3D.AssetUtils

Item {
    id: root
    property real modelRotationY: -30
    property real cameraZ: 2600

    View3D {
        id: view3d
        anchors.fill: parent

        PerspectiveCamera {
            position: Qt.vector3d(0, 120, root.cameraZ)
            eulerRotation: Qt.vector3d(-6, 0, 0)
            clipNear: 1
            clipFar: 10000
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-45, 45, 0)
            brightness: 1.2
            castsShadow: false
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(30, -60, 0)
            brightness: 0.5
            castsShadow: false
        }
        PointLight {
            position: Qt.vector3d(0, 200, 0)
            brightness: 0.3
            quadraticFade: 0.0
        }

        environment: SceneEnvironment {
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            backgroundMode: SceneEnvironment.Color
            clearColor: "#1a1a1a"
        }

        Node {
            eulerRotation.y: root.modelRotationY

            RuntimeLoader {
                id: runtimeLoader
                source: "qrc:/ui/assets/tesla_model_3.glb"
                onStatusChanged: {
                    if (status === RuntimeLoader.Error)
                        console.warn("RuntimeLoader error:", errorString)
                }
            }
        }
    }

    // Loading spinner
    Column {
        anchors.centerIn: parent
        spacing: 8
        visible: runtimeLoader.status === RuntimeLoader.Loading ||
                 runtimeLoader.status === RuntimeLoader.Error ||
                 runtimeLoader.status === RuntimeLoader.Empty

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: runtimeLoader.status === RuntimeLoader.Loading ? "Loading"
                : runtimeLoader.status === RuntimeLoader.Error   ? "Error"
                : "🚗"
            font.pixelSize: 36
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: runtimeLoader.status === RuntimeLoader.Loading ? "Loading model…"
                : runtimeLoader.status === RuntimeLoader.Error   ? "Failed to load model"
                : "No model"
            font.pixelSize: 11
            color: runtimeLoader.status === RuntimeLoader.Error ? "#e53935" : "#555"
        }
    }

    // Drag to rotate + scroll to zoom
    MouseArea {
        anchors.fill: parent
        property real lastX: 0
        onPressed:         (mouse) => { lastX = mouse.x }
        onPositionChanged: (mouse) => {
            if (pressed) {
                root.modelRotationY += (mouse.x - lastX) * 0.5
                lastX = mouse.x
            }
        }
        onWheel: (wheel) => {
            root.cameraZ = Math.max(400, Math.min(6000, root.cameraZ - wheel.angleDelta.y * 2))
        }
    }
}
