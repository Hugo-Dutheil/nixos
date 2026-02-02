import Quickshell
import QtQuick.Window
import QtQuick.Controls
import QtQuick
import QtQuick.Shapes
import "../services" as Services
import ".."

Item {
  id: root
  anchors.fill: parent

  required property int popupYpos
  required property int popupHeight
  // readonly property alias popup: popup
  readonly property alias popup: popupLoader.popup
  readonly property alias tt: tooltip.tt_content

  MouseArea {
    id: hitbox
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: event => {
      if(event.button == Qt.LeftButton){
        popup.toggle();
        bar.focusGrab.active = popup.shown;
      }
      if(event.button == Qt.RightButton){
        Services.Network.toggleWifi();
      }
    }
    onEntered: {
      networkText.color = Globals.theme.accent3;
      tt.open();
      
    }
    onExited: {
      networkText.color = Globals.theme.accent1;
      tt.close();
    }

  }

  Text {
    id: networkText
    horizontalAlignment: Text.AlignHCenter
    anchors.fill: parent
    color: Globals.theme.accent1
    font.pixelSize: Globals.fonts.huge
    text: {
      if (Services.Network.scanning || !Services.Network.startupFinished)
        return "󱛇 ";
      if (Services.Network.ethernetConnected)
        return " ";
      if (!Services.Network.wifiEnabled)
        return "󰤮 ";
      if (Services.Network.active)
        return "󱚻 ";
      return "󱚼 ";
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
        name: "Network"
        popupHeight: 360
        popupWidth: 400
        yPos: popupYpos
        NetworkPopup {}
      }
    }
      
    Component {
      id: floatPopupComponent
      FloatPopup {
        id: popup
        ref: bar
        name: "Network"
        popupHeight: 360
        popupWidth: 400
        yPos: popupYpos
        NetworkPopup {}
      }
    }
  }

  Loader {
    id: tooltip
    sourceComponent: content
    property var tt_content: tooltip.item

    Component {
      id: content

      PopupWindow {
        id: wifiTooltip
        implicitWidth: 300
        implicitHeight: 50
        property int popupHeight: implicitHeight
        property int popupWidth: implicitWidth
        color: Globals.theme.background
        anchor.rect.x: bar.width
        anchor.rect.y: popupYpos
        property var ref: bar
        property color popupColor: ref.popupColor
        property bool shown: true
        visible: true

        Rectangle {
          anchors.fill: parent
          color: "transparent"

          Text {
            anchors.centerIn: parent
            color: Globals.theme.accent2
            text: "wifi " + (Services.Network.wifiEnabled 
                             ? "connected: " + Services.Network.connectionSpeed  
                             : (Services.Network.active ? "disconnected" : "off"))
          }

          Timer {
            id: getConnectionSpeed
            running: Services.Network.active && wifiTooltip.visible
            interval: 1000
            repeat: true
          }
        }

        function open(): void{
          console.log("openeing", wifiTooltip.implicitWidth, wifiTooltip.implicitHeight)
          wrapper.state = "visible";
          shown = true;
        }
        function close(): void{
          console.log("closing")
          wrapper.state = "hidden";
          shown = false;
        }


        Item {
          id: wrapper
          anchors.right: parent.right
          implicitWidth: 100
          implicitHeight: wifiTooltip.popupHeight + wifiTooltip.ref.radius * 2

          clip: true
          state: "hidden"

          states: [
            State {
              name: "hidden"
              PropertyChanges {
                wrapper.implicitWidth: 0
                wifiTooltip.visible: false
              }
            },
            State {
              name: "visible"
              PropertyChanges {
                wrapper.implicitWidth: wifiTooltip.popupWidth
                wifiTooltip.visible: true
              }
            }
          ]

          transitions: [
              Transition {
                  from: "visible"
                  to: "hidden"
                  SequentialAnimation {
                      NumberAnimation {
                          property: "implicitWidth"
                          duration: 200
                          easing.type: Easing.BezierSpline
                          easing.bezierCurve: [0.2, 0, 0, 1, 1, 1] // Standard deceleration curve
                      }
                      NumberAnimation {
                          target: wifiTooltip
                          property: "visible"
                          duration: 0
                      }
                  }
              },
              Transition {
                  from: "hidden"
                  to: "visible"
                  SequentialAnimation {
                      NumberAnimation {
                          target: wifiTooltip
                          property: "visible"
                          duration: 0
                      }
                      NumberAnimation {
                          property: "implicitWidth"
                          duration: 200
                          easing.type: Easing.BezierSpline
                          easing.bezierCurve: [0.05, 0, 0.15, 1, 1, 1] // Emphasized curve for entrance
                      }
                  }
              }
          ]
    
          Shape {
              id: popupShape
    
              width: wifiTooltip.popupWidth
              height: wifiTooltip.popupHeight + wifiTooltip.ref.radius * 2
    
              x: 0
    
              ShapePath {
                  id: mainPopupPath
                  strokeWidth: 0
                  strokeColor: "transparent"
                  fillColor: wifiTooltip.popupColor
    
                  startX: popupShape.width - 1 - wifiTooltip.ref.radius
                  startY: wifiTooltip.ref.radius
    
                  PathLine {
                      x: wifiTooltip.ref.radius
                      y: wifiTooltip.ref.radius
                  }
                  PathArc {
                      x: 0
                      y: wifiTooltip.ref.radius * 2
                      radiusX: wifiTooltip.ref.radius
                      radiusY: wifiTooltip.ref.radius
                      direction: PathArc.Counterclockwise
                  }
                  PathLine {
                      x: 0
                      y: popupShape.height - wifiTooltip.ref.radius * 2
                  }
                  PathArc {
                      x: wifiTooltip.ref.radius
                      y: popupShape.height - wifiTooltip.ref.radius
                      radiusX: wifiTooltip.ref.radius
                      radiusY: wifiTooltip.ref.radius
                      direction: PathArc.Counterclockwise
                  }
                  PathLine {
                      x: popupShape.width - 1 - wifiTooltip.ref.radius
                      y: popupShape.height - wifiTooltip.ref.radius
                  }
              }
    
              ShapePath {
                  id: transitionPath
                  strokeWidth: 0
                  strokeColor: "transparent"
                  fillColor: wifiTooltip.popupColor
    
                  startX: popupShape.width - 1
                  startY: 0
    
                  PathArc {
                      x: popupShape.width - 1 - wifiTooltip.ref.radius
                      y: wifiTooltip.ref.radius
                      radiusX: wifiTooltip.ref.radius
                      radiusY: wifiTooltip.ref.radius
                  }
                  PathLine {
                      x: popupShape.width - 1 - wifiTooltip.ref.radius
                      y: popupShape.height - wifiTooltip.ref.radius
                  }
                  PathArc {
                      x: popupShape.width - 1
                      y: popupShape.height
                      radiusX: wifiTooltip.ref.radius
                      radiusY: wifiTooltip.ref.radius
                  }
                  PathLine {
                      x: popupShape.width - 1
                      y: 0
                  }
              }
          }

          Item {
              id: contentContainer
              anchors {
                  fill: parent
                  margins: wifiTooltip.ref.padding
              }
              anchors.topMargin: wifiTooltip.ref.radius * 2
              anchors.bottomMargin: wifiTooltip.ref.radius * 2
          }
        }
      }
    }
  }
}
