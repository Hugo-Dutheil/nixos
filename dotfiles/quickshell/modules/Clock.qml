import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    anchors.fill: parent
    property int popupYpos
    required property int popupHeight
    readonly property alias popup: popupLoader.popup

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            popup.toggle();
            bar.focusGrab.active = popup.shown;
        }
        onEntered: {
            timeDisplay.color = Globals.theme.accent3;
        }
        onExited: {
            timeDisplay.color = Globals.theme.accent1;
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    ColumnLayout {
        id: layout
        spacing: -10

        anchors {
            fill: parent
        }
        Text {
          id: timeDisplay
          Layout.alignment: Qt.AlignCenter
          color: Globals.theme.accent1
          font.pointSize: Globals.fonts.xlarge
          font.bold: true

          lineHeight: 0.65

          Process {
            id: timeRefresh
            command: ["date", "+%H:%M"]
            running: true
            stdout: StdioCollector {
              property var time: this.text.split(":")
              onStreamFinished: timeDisplay.text = time[0] + "\n" + time[1]
            }
          }

          Timer {
            interval: 100
            repeat: true
            running: true
            onTriggered: timeRefresh.running = true
          }
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
            popupWidth: 120
            popupHeight: root.popupHeight
            yPos: popupYpos
            name: "Clock"

            Item {
                anchors.fill: parent

              Text {
                anchors.centerIn: parent
                color: Globals.theme.accent1
                font.pixelSize: Globals.fonts.medium
                text: Qt.formatDateTime(clock.date, "dddd") + ",\n" + Qt.formatDateTime(clock.date, "dd-MM-yyyy")
              }
            }
          }
        }

        Component {
            id: floatPopupComponent
            FloatPopup {
                id: popup
                ref: bar
                popupWidth: 120
                popupHeight: root.popupHeight
                yPos: popupYpos
                name: "Clock"

                Item {
                    anchors.fill: parent

                    Text {
                        anchors.centerIn: parent
                        color: Globals.theme.foreground
                        font.pixelSize: Globals.fonts.medium
                        text: Qt.formatDateTime(clock.date, "dd-MM-yyyy")
                    }
                }
            }
        }
    }
}
