import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

import "../modules" as Modules
BarPart {
    id: root
    moduleSizes: [30, 60, 30, 40, 60, 60, 40]

    property alias brightnessPopup: brightnessContent.popup
    property alias batteryPopup: batteryContent.popup
    property alias wifiPopup: wifiContent.popup
    property alias bluetoothPopup: bluetoothContent.popup
    property alias audioPopup: audioContent.popup
    property alias lockPopup: lockContent.popup
    property alias trayPopup: trayContent.popup

    function calculatePopupYpos(index, popupHeight) {
        return bar.height - ((2 + index) * Globals.spacing.small + root.sumSizesUntil(index) + (root.moduleSizes[index] / 2) + (popupHeight / 2) + Globals.radius);
    }

    ColumnLayout {
        id: layout
        spacing: Globals.spacing.small
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        
        Rectangle {
          id: trayModule
          color: "transparent"
          Layout.fillWidth: true
          property int index: 6
          property int popupHeight: 150
          implicitHeight: root.moduleSizes[index]
          Modules.Tray {
            id: trayContent
            popupYpos: root.calculatePopupYpos(trayModule.index, trayModule.popupHeight)
            popupHeight: trayModule.popupHeight
          }
        }

        Rectangle {
          id: brightnessModule
          color: "transparent"
          Layout.fillWidth: true
          property int index: 5
          property int popupHeight: 240
          implicitHeight: root.moduleSizes[index]
          Modules.Brightness {
            id: brightnessContent
            popupYpos: root.calculatePopupYpos(brightnessModule.index, brightnessModule.popupHeight)
            popupHeight: brightnessModule.popupHeight
          }
        }
        Rectangle {
            id: audioModule
            color: "transparent"
            Layout.fillWidth: true
            property int index: 4
            property int popupHeight: 240
            implicitHeight: root.moduleSizes[index]
            Modules.Audio {
                id: audioContent
                popupYpos: root.calculatePopupYpos(audioModule.index, audioModule.popupHeight)
                popupHeight: audioModule.popupHeight
            }
        }
        Rectangle {
            id: bluetoothModule
            color: "transparent"
            Layout.fillWidth: true
            property int index: 3
            property int popupHeight: 400
            implicitHeight: root.moduleSizes[index]
            Modules.Bluetooth {
                id: bluetoothContent
                popupYpos: root.calculatePopupYpos(bluetoothModule.index, bluetoothModule.popupHeight)
                popupHeight: bluetoothModule.popupHeight
            }
        }
        Rectangle {
            id: wifiModule
            color: "transparent"
            Layout.fillWidth: true
            property int index: 2
            property int popupHeight: 360
            implicitHeight: root.moduleSizes[index]
            Modules.Network {
                id: wifiContent
                popupYpos: root.calculatePopupYpos(wifiModule.index, wifiModule.popupHeight)
                popupHeight: wifiModule.popupHeight
            }
        }
        Rectangle {
            id: batteryModule
            color: "transparent"
            radius: Globals.radius
            Layout.fillWidth: true
            property int index: 1
            property int popupHeight: 190
            implicitHeight: root.moduleSizes[index]
            Modules.Battery {
                id: batteryContent
                popupYpos: root.calculatePopupYpos(batteryModule.index, batteryModule.popupHeight)
                popupHeight: batteryModule.popupHeight
            }
        }
        Rectangle {
            id: lockModule
            color: "transparent"
            Layout.fillWidth: true
            property int index: 0
            implicitHeight: root.moduleSizes[0]
            Modules.Lock {
                id: lockContent
            }
        }
    }
}
