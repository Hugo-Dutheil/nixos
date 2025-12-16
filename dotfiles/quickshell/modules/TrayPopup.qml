import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import "../services/" as Services
import ".."

Item {
  id: root
  anchors.fill: parent
  anchors.topMargin: Globals.spacing.small
  anchors.leftMargin: Globals.spacing.small
  
  
  anchors {
    fill: parent
    topMargin: Globals.spacing.small
    leftMargin: Globals.spacing.samll
    rightMargin: Globals.spacing.small
  }


  GridLayout {
    id: trayGrid
    anchors.fill: parent
    
    readonly property real spacing: 0.1
    columnSpacing: spacing
    rowSpacing: spacing
    layoutDirection: Qt.LeftToRight
    columns: 4


    Repeater {
      id: trayItems

      model: SystemTray.items
      TrayItem{}
    }
  }
}
