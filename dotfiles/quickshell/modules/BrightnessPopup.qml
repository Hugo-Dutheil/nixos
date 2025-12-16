import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services" as Services
import ".."

Item {
  id: root
  anchors {
      fill: parent
      leftMargin: Globals.spacing.small
      rightMargin: Globals.spacing.small
  }

  ColumnLayout {
    anchors.fill: parent
    Text {
      id: icon
      Layout.alignment: Qt.AlignHCenter
      color: Globals.theme.accent1
      font.pointSize: Globals.fonts.large
      text: " "
    }
    Item {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Slider {
        id: brightnessSlider
        anchors.fill: parent
        from: 0
        value: Services.Brightness.brightness
        to: 255
        orientation: Qt.Vertical
        onMoved: {
          Services.Brightness.changeBrightness(brightnessSlider.value)
        }

        background: Rectangle {
          color: Globals.theme.accent1
          x: (brightnessSlider.availableWidth - width + brightnessSlider.leftPadding)/2
          y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
          implicitWidth: 10
          implicitHeight: 4
//                    width: brightnessSlider.availableWidth
//                    height: implicitHeight
          width: implicitWidth
          height: brightnessSlider.availableHeight
          radius: height / 2

          Rectangle {
            color: Globals.theme.muted
            height: brightnessSlider.visualPosition * parent.height
            width: parent.width
            radius: height / 2
          }
        }

        handle: Rectangle {
          x: (brightnessSlider.availableWidth - width)/2 + brightnessSlider.leftPadding
          y: brightnessSlider.topPadding + brightnessSlider.visualPosition* (brightnessSlider.availableHeight - height)
          implicitWidth: 16
          implicitHeight: 16
          radius: height / 2
          color: Globals.theme.accent3
        }
      }
    }
  }
}
