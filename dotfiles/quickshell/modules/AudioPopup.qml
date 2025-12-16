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
        Item {
            implicitHeight: 40
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Button {
                id: muteButton
                background: Rectangle {
                    color: "transparent"
                }
                icon.source: "../icons/muted.svg"
                icon.color: Globals.theme.accent1
                icon.height: parent.height * 0.7
                icon.width: parent.height * 0.7
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    Services.Audio.toggleMute();
                }
                onEntered: {
                    muteButton.icon.color = Globals.theme.accent3;
                }
                onExited: {
                    muteButton.icon.color = Globals.theme.accent1;
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Slider {
                id: volumeSlider
                anchors.fill: parent
                from: 0
                value: Services.Audio.volume
                to: 1
                orientation: Qt.Vertical
                onMoved: {
                    Services.Audio.setVolume(volumeSlider.value);
                }

                background: Rectangle {
                    color: Globals.theme.accent1
                    x: (volumeSlider.availableWidth - width + volumeSlider.leftPadding)/2
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    implicitWidth: 10
                    implicitHeight: 4
//                    width: volumeSlider.availableWidth
//                    height: implicitHeight
                    width: implicitWidth
                    height: volumeSlider.availableHeight
                    radius: height / 2

                    Rectangle {
                        color: Globals.theme.muted
                        height: volumeSlider.visualPosition * parent.height
                        width: parent.width
                        radius: height / 2
                    }
                }

                handle: Rectangle {
                    x: (volumeSlider.availableWidth - width)/2 + volumeSlider.leftPadding
                    y: volumeSlider.topPadding + volumeSlider.visualPosition* (volumeSlider.availableHeight - height)
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: height / 2
                    color: Globals.theme.accent3
                }
            }
        }
    }
}
