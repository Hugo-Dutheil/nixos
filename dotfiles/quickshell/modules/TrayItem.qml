//@ pragma UseQApplication

import Quickshell
import Quickshell.Widgets
import QtQuick
import Quickshell.Services.SystemTray
import ".."

Item {
  MouseArea {
      id: root

      required property SystemTrayItem modelData

      implicitHeight: 20
      implicitWidth: 20
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton){
//          menu.open();
          modelData.activate();
        }
        else {
          modelData.secondaryActivate();
        }
//        if (mouse.button === Qt.LeftButton) {
//          modelData.display(parent, 0, 0)
//        }
      }
      IconImage {
        id: icon

        anchors.fill: parent
        source: {
          let icon = root.modelData.icon;
          if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
          }
          return icon;
        }
//        colour: Globals.theme.accent1
        layer.enabled: Globals.theme.accent2
    }
  }

//  QsMenuAnchor {
//    id: menu
//    menu: modelData.menu
//    function open() {
//      menu.open();
//    }
//  }
}
