import Quickshell
import QtQuick
import QtQuick.Layouts
import "../modules" as Modules
import ".."

BarPart {
  id: root
  property int bottomPadding: 200
  moduleSizes: [bottomPadding, 60, bottomPadding]
  property alias clockPopup: clockContent.popup

  function calculatePopupYpos(index, popupHeight) {
      return (2/3)*bar.height - ((2 + index) * Globals.spacing.small + root.sumSizesUntil(index) + (root.moduleSizes[index] / 2) + (popupHeight / 2) + Globals.radius);
    }

  ColumnLayout {
    id: layout
    spacing: Globals.spacing.small
    anchors {
      left: parent.left
      right: parent.right
      bottom: parent.bottom
      }
    Item {
      id: padding
      property int index: 0
      implicitHeight: root.moduleSizes[index]
    }
    Item {
      id: clockModule
      Layout.fillWidth: true
      property int popupHeight: 60
      property int index: 1
      implicitHeight: root.moduleSizes[index]
      Modules.Clock {
          id: clockContent
          popupYpos: root.calculatePopupYpos(clockModule.index, clockModule.popupHeight)
          popupHeight: clockModule.popupHeight
      }
    }
    Item {
      id: toppadding
      property int index: 2
      implicitHeight: root.moduleSizes[index]
    }
  }
}
