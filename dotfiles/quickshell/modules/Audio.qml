import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services" as Services
import ".."

Item {
    id: root
    anchors.fill: parent
    required property int popupYpos
    required property int popupHeight
    readonly property alias popup: popupLoader.popup

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        Button {
            id: audioIcon
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle {
                color: "transparent"
            }
            icon.source: Services.Audio.muted ? "../icons/muted.svg" : "../icons/audio.svg"
            icon.width: parent.width * 0.5
            icon.height: parent.width * 0.5
            icon.color: Globals.theme.accent1
        }

        Text {
            id: volumeText
            Layout.alignment: Qt.AlignHCenter
            color: Globals.theme.accent1
            font.pixelSize: Globals.fonts.medium
            text: Services.Audio.volume === NaN ? "0%" : (Services.Audio.volume * 100).toFixed(0) + "%"
        }
    }

    MouseArea {
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: (mouse)=> {
        if (mouse.button == Qt.LeftButton)
          popup.toggle();
          bar.focusGrab.active = popup.shown;
        if (mouse.button == Qt.RightButton)
          Services.Audio.toggleMute();
      }
      onEntered: {
        audioIcon.icon.color = Globals.theme.accent3;
        volumeText.color = Globals.theme.accent3;
      }
      onExited: {
        audioIcon.icon.color = Globals.theme.accent1;
        volumeText.color = Globals.theme.accent1;
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
                name: "Audio"
                popupHeight: root.popupHeight
                popupWidth: 40
                yPos: root.popupYpos
                AudioPopup {}
            }
        }

        Component {
            id: floatPopupComponent
            FloatPopup {
                id: popup
                ref: bar
                name: "Audio"
                popupHeight: root.popupHeight
                popupWidth: 40
                yPos: root.popupYpos
                AudioPopup {}
            }
        }
    }
}
