import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "../modules" as Modules

BarPart {
  property var moduleSizes: [200, 250]
  property alias mediaPopup: mediaContent.popup
  property alias mediaFs: mediaContent.fullScreen

  ColumnLayout {
    id: layout
    spacing: Globals.spacing.small
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
    }
    uniformCellSizes: false
    Item {
      id: workspacesModule
      Layout.fillWidth: true
      property int index: 0
      implicitHeight: moduleSizes[index]
      Modules.Workspaces {
        id: workspacesContent
        popupYpos: bar.height - (moduleSizes[0] / 2 + Globals.radius)
      }
    }

    Item {
      id: mediaModule
      Layout.fillWidth: true
      property int popupHeight: 50
      property int index: 1
      implicitHeight: moduleSizes[index]
      Modules.Media {
        id: mediaContent
        popupYpos: (moduleSizes[0] / 3 + Globals.radius + moduleSizes[1]/2)
        popupHeight: mediaModule.popupHeight
      }
    }
  }
}
