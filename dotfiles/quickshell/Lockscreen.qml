import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../services/Pam.qml"
import "../"

PanelWindow {
  id: root
  visible: false
  focusable: true
  exclusionMode: ExclusionMode.Ignore
  aboveWindows: true
  property string state: "hidden"
  color: "transparent"
  
  Component.onCompleted: show()

  function show() {
    root.visible = true
    root.state = "visible"
    localFocusGrab.active = true;
  }

  function hide() {
    root.visible = false
    root.state = "hidden"
    localFocusGrab.active = false;
  }

  FocusScope{
    focus: true
    Keys.onPressed: event => {
      if (event.key === Qt.Key_Escape){
        hide();
      }
    }
  }
  implicitWidth: 600
  anchors {
    top: true
    bottom: true
    right: true
  }
  
//  anchors {
//    top: true
//    bottom: true
//    left: true
//    right: true
//  }

  Image {
    id: lockBackground
    anchors.fill: parent
    source: Globals.theme.lockWallpaper
    fillMode: Image.PreserveAspectCrop 
  }

  RowLayout {
    id: widgetLayout
    spacing: 200

    SystemClock{
      id: clock
      precision: SystemClock.Minutes
    }

    Rectangle {
      id: inputContainer
      height: 100
      width: 300
      Layout.alignment: Qt.AlignHCenter
      color: Globals.theme.background
      radius: height/2
      TextInput {
        // Type in password
        id: inputField
        
        anchors.fill: parent
        echoMode: TextInput.Password
        passwordCharacter: "*"
        cursorVisible: false
        selectByMouse: false
        padding: Globals.padding
      }
    }
  } 
  
  HyprlandFocusGrab {
    id: localFocusGrab
    windows: [root]
  }
}
