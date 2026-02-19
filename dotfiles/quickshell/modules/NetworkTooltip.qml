import QtQuick
import Quickshell
import ".."
import "../services" as Services


Item {
  id: root

  anchors {
    fill: parent
    topMargin: Globals.spacing.small
    leftMargin: Globals.spacing.small
    rightMargin: Globals.spacing.small
  }

  property int popupWidth
  property var moduleRef


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
      running: Services.Network.active && networkTooltip.visible
      interval: 1000
      repeat: true
      onTriggered: {
        Services.Network.updateConnectionSpeed();
      }
    }
  }
}
