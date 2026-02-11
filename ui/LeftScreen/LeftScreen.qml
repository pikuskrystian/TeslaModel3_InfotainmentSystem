import QtQuick 2.15
import QtQuick.Window 2.15
import Qt3D.Core 2.15
import Qt3D.Render 2.15
import Qt3D.Input 2.15
import Qt3D.Extras 2.15

Rectangle {
    id:leftScreen

    anchors{
        left: parent.left
        right: rightScreen.left
        bottom: bottomBar.top
        top: parent.top
    }

}
