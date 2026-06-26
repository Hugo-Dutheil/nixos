import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import "paths" as Paths
import "barParts" as BarParts
import "services" as Services
import "./"

PanelWindow {
  id: root

  readonly property var player: Services.MediaPlayer.activePlayer
  color: "transparent"
  implicitWidth: Globals.barWidth
  exclusiveZone: Globals.barWidth - Globals.padding

  anchors {
    top: true
    right: true
    bottom: true
  }

  property var focusGrab: focusGrab

  property int padding: Globals.padding
  property int radius: Globals.radius
  property int spacing: Globals.spacing.small
  property color popupColor: Globals.theme.background

  property list<var> popups: [top.mediaFs, top.mediaPopup, mid.clockPopup, bot.lockPopup, bot.batteryPopup, bot.wifiPopup, bot.bluetoothPopup, bot.audioPopup, bot.brightnessPopup]

  function collapseAllBut(name) {
    let nameInPopups = false;
    for(let i = 0; i < root.popups.length; ++i){
      nameInPopups = (root.popups[i].name === name || nameInPopups);
    }
    root.popups.forEach(function (popup) {
      if (popup.name !== name && nameInPopups) {
        popup.collapse();
      }
    });
  }

  FocusScope {
    id: keyboardBinds
    focus: true
    property bool metaPressed: false
    Keys.onPressed: event => {
      switch(event.key){
        case Qt.Key_Escape : {
          root.popups.forEach(function (popup) {
            popup.collapse();
          });

          focusGrab.active = false;
          break;
        }

        case Qt.Key_Space: {
          if(top.mediaPopup.shown){
            player.togglePlaying();
          }
          break;
        }
        case Qt.Key_Left: {
          if(top.mediaPopup.shown){
            player.canGoPrevious ? Qt.callLater(() => player.previous()) : null
            event.accepted = true;
          }
          break;
        }

        case Qt.Key_Right: {
          if(top.mediaPopup.shown){
            player.canGoNext ? Qt.callLater(() => player.next()) : null
            event.accepted = true;
          } 
          break;
        }

        case Qt.Key_N: {
          if (metaPressed){
            Globals.cycleTheme();
          }
        }

        case Qt.Key_Meta: {
          metaPressed = true;
          break;
        }
      }
    }
    Keys.onReleased: event=> {
      if (event.key === Qt.Key_Meta) {
        metaPressed = false;
      }
    }
  }


  Paths.Bar {}

  ColumnLayout {
    id: barParts
    spacing: 0
    uniformCellSizes: true
    anchors.fill: parent
    Rectangle {
      width: Globals.barWidth - 2 * Globals.padding
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: Globals.barExtrema * 2
      Layout.fillHeight: true
      color: "transparent"
      BarParts.Top {
        id: top
        bar: root
      }
    }
    Rectangle {
      width: Globals.barWidth - 2 * Globals.padding
      Layout.alignment: Qt.AlignHCenter
      Layout.fillHeight: true
      color: "transparent"
      BarParts.Mid {
        id: mid
        bar: root
      }
    }
    Rectangle {
      width: Globals.barWidth - 2 * Globals.padding
      Layout.alignment: Qt.AlignHCenter
      Layout.bottomMargin: Globals.barExtrema * 2
      Layout.fillHeight: true
      color: "transparent"
      BarParts.Bot {
        id: bot
        bar: root
      }
    }
  }

  //    GlobalShortcut {
  //        name: "toggle"
  //        onPressed: {
  //            root.visible = !root.visible;
  //            root.popups.forEach(function (popup) {
  //                popup.collapse();
  //            });
  //        }
  //    }
  //    GlobalShortcut {
  //        name: "lock"
  //        onPressed: {
  //            if (!root.visible)
  //                return;
  //            if (bot.lockPopup.shown) {
  //                bot.lockPopup.collapse();
  //                focusGrab.active = false;
  //                return;
  //            }
  //            bot.lockPopup.show();
  //            focusGrab.active = true;
  //        }
  //      }

  GlobalShortcut {
    name: "cycleTheme"
    onPressed: {
      console.log("Cycling to next theme...");
      Globals.launchNextTheme = !Globals.launchNextTheme;
    }
  }


  HyprlandFocusGrab {
    id: focusGrab
    windows: [root, ...root.popups]
    onCleared: {
      root.popups.forEach(function (popup) {
        popup.collapse();
      });
    }
  }
}
