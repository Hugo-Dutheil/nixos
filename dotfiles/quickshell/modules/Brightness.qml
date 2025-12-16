import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import ".."
import "../services/" as Services

Item {
  id: root
  anchors.fill: parent
  required property int popupHeight
  required property int popupYpos
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
      percentage.color = Globals.theme.accent3;
    }
    onExited: {
      icon.color = Globals.theme.accent1;
      percentage.color = Globals.theme.accent1;
    }
  }
  
  ColumnLayout {
    id: layout
    spacing: 0
    anchors.fill: parent

    Text {
      id: icon
      Layout.alignment: Qt.AlignHCenter
      color: Globals.theme.accent1
      font.pointSize: Globals.fonts.xlarge
      text: " "
    }
    Text{
      id: percentage
      Layout.alignment: Qt.AlignHCenter
      color: Globals.theme.accent1
      font.pointSize: Globals.fonts.small
      text: Services.Brightness.brightnessPercentage === NaN ? "0%" : Services.Brightness.brightnessPercentage
    }
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
        name: "Brightness"
        popupHeight: root.popupHeight
        popupWidth: 40
        yPos: root.popupYpos
        BrightnessPopup {}
      }
    }

    Component {
        id: floatPopupComponent
        FloatPopup {
            id: popup
            ref: bar
            name: "Brightness"
            popupHeight: root.popupHeight
            popupWidth: 40
            yPos: root.popupYpos
            BrightnessPopup {}
        }
    }
  }

}
