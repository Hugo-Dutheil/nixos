import QtQuick
import Quickshell
import ".."

Item {
  id: root
  anchors.fill: parent
  property int popupYpos
  required property int popupHeight
  readonly property alias popup: popupLoader.popup
  
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      popup.toggle();
      bar.focusGrab.active = popup.shown;
    }
    onEntered: {
      icon.color = Globals.theme.accent3;
    }
    onExited: {
      icon.color = Globals.theme.accent1;
    }
  }
  Text {
    id: icon
    text: " "
    color: Globals.theme.accent1
    font.pointSize: Globals.fonts.xlarge
    anchors.centerIn: parent
  }

  Loader {
    id: popupLoader
    sourceComponent: Globals.popup === "FloatPopup" ? floatPopupComponent : regularPopupComponent

    property var popup: popupLoader.item

    Component {
      id: regularPopupComponent
      Popup {
        id: popup
        ref: bar
        popupWidth: 150
        popupHeight: root.popupHeight
        yPos: root.popupYpos
        name: "Tray"

        Rectangle {
          anchors.fill: parent
          color: "transparent"
//          TrayPopup {}
        }
      }
    }

    Component {
      id: floatPopupComponent

      FloatPopup {
        id: popup
        ref: bar
        popupWidth: 100
        popupHeight: root.popupHeight
        yPos: root.popupYpos
        name: "Tray"

        Rectangle {
          anchors.fill: parent
          color: "transparent"
          TrayPopup {}
        }
      }
    }
  }
}
