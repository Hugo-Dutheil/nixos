import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../widgets" as Widgets
import ".."

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
    
    ColumnLayout {
        spacing: Globals.padding
        anchors.fill: parent
        RowLayout{
          spacing: Globals.padding
          Layout.fillWidth: true
          Layout.fillHeight: true
          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout {
              id: textInfoLayout
              spacing: 0
              anchors.fill: parent
              Text {
                id: powerText
                Layout.alignment: Qt.AlignTop
                text: moduleRef.isDocked ? "Device is docked" : moduleRef.isCharging ? "Charging at: " + (UPower.displayDevice.changeRate).toFixed(2) + " W" : "Discharging at: " + (UPower.displayDevice.changeRate).toFixed(2) + " W"
                color: Globals.theme.accent1
                font.pointSize: Globals.fonts.small
                font.bold: true
                Layout.bottomMargin: -Globals.spacing.small
              }

              Text {
                id: currentProfileText
                Layout.alignment: Qt.AlignTop
                property string timeTo: {
                    if (UPowerDeviceState.charging) {
                      var time = UPower.displayDevice.timeToFull
                    } else {
                      var time = UPower.displayDevice.timeToEmpty
                    }
                    var ret = Math.floor(time / 3600) + "h" + Math.floor((time % 3600) / 60);
                    return ret;
                }
                text: root.moduleRef.isDocked ? "No battery change" : root.moduleRef.isCharging ? "Battery full in: " + timeTo : "Battery empty in: " + timeTo
                color: Globals.theme.accent1
                font.pointSize: Globals.fonts.small
              }
            }
          }

          Item{
            id: hypridle
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            readonly property int size: 60
            implicitHeight: size
            implicitWidth: size
            property bool hypridleState: true
            property color rectColor: !hypridleState ? Globals.theme.accent1 : Globals.theme.accent2

            function toggleHypridle(){
              if (hypridle.hypridleState) {
                Quickshell.execDetached({
                  command: Machines.current.hypridleStopCommand,
                });
              } else {
                Quickshell.execDetached({
                  command: Machines.current.hypridleStartCommand,
                });
              }
              hypridle.hypridleState = !hypridle.hypridleState;
            }
            Rectangle  {
              id: caffeine_button
              anchors.fill:parent
              radius: Globals.radius
              color: hypridle.rectColor
              border.width: 3
              border.color: Globals.theme.border
//              border.color: "white"
              Text {
                id: icon
                anchors.fill:parent
                anchors.centerIn: parent
                color: (hypridle.hypridleState ? Globals.theme.accent1 : Globals.theme.background)
                font.pointSize: Globals.fonts.xlarge
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: hypridle.hypridleState ? "󰾪 ":" "
              }

              MouseArea {
                id: hitbox
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                  hypridle.toggleHypridle();
                  icon.text = (hypridle.hypridleState ? "󰾪 ":" ");
                }
                onEntered: {
                  icon.color = Globals.theme.accent3;
                }
                onExited: {
                  icon.color = (hypridle.hypridleState ? Globals.theme.muted : Globals.theme.background                                                 );
                }
              }
            }
          }

          Item{
            id: buffer
            implicitWidth: 30
          }
        }

        Item {
            id: powerProfile
            implicitHeight: 70
            Layout.fillWidth: true

            property string currentProfile

            state: Globals.powerProfile
            states: [
                State {
                    name: "eco"
                    PropertyChanges {
                        selector.x: root.width / 2 - selector.width / 2 - profiles.buttonSize * 2
                        ecoButton.icon.color: Globals.theme.accent1
                    }
                },
                State {
                    name: "balanced"
                    PropertyChanges {
                        selector.x: root.width / 2 - selector.width / 2
                        balancedButton.icon.color: Globals.theme.accent1
                    }
                },
                State {
                    name: "performance"
                    PropertyChanges {
                        selector.x: root.width / 2 - selector.width / 2 + profiles.buttonSize * 2
                        performanceButton.icon.color: Globals.theme.accent1
                    }
                }
            ]

            transitions: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        target: selector
                        property: "x"
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            Rectangle {
                id: background
                color: Globals.theme.accent1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 5 * profiles.buttonSize + 2 * Globals.spacing.small
                implicitHeight: profiles.buttonSize + Globals.spacing.small * 2
                radius: profiles.buttonSize / 2 + Globals.spacing.small
            }
            Rectangle {
                id: selector
                color: Globals.theme.accent2
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: profiles.buttonSize
                implicitHeight: profiles.buttonSize
                radius: profiles.buttonSize / 2
            }
            RowLayout {
                id: profiles
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                property int buttonSize: 35
                spacing: buttonSize
                uniformCellSizes: true
                Item {
                    id: eco
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: parent.buttonSize
                    implicitHeight: parent.buttonSize
                    Button {
                        id: ecoButton
                        background: Rectangle {
                            color: "transparent"
                        }
                        anchors.fill: parent
                        icon.source: "../icons/leaf.svg"
                        icon.width: parent.implicitWidth * 0.75
                        icon.height: parent.implicitWidth * 0.75
                        icon.color: Globals.theme.muted
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            powerProfile.state = "eco";
                            Globals.powerProfile = "powersave";
                            ecoProcess.running = true;
                            paddingTimer.running = true;
                        }
                    }
                }
                Item {
                    id: balanced
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: parent.buttonSize
                    implicitHeight: parent.buttonSize
                    Button {
                        id: balancedButton
                        background: Rectangle {
                            color: "transparent"
                        }
                        anchors.fill: parent
                        icon.source: "../icons/balance.svg"
                        icon.width: parent.implicitWidth * 0.8
                        icon.height: parent.implicitWidth * 0.8
                        icon.color: Globals.theme.muted
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            powerProfile.state = "balanced";
                            Globals.powerProfile = "balanced";
                            balancedProcess.running = true;
                            paddingTimer.running = true;
                        }
                    }
                }
                Item {
                    id: performance
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: parent.buttonSize
                    implicitHeight: parent.buttonSize
                    Button {
                        id: performanceButton
                        background: Rectangle {
                            color: "transparent"
                        }
                        anchors.fill: parent
                        icon.source: "../icons/rocket.svg"
                        icon.width: parent.implicitWidth * 0.65
                        icon.height: parent.implicitWidth * 0.65
                        icon.color: Globals.theme.muted
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            powerProfile.state = "performance";
                            Globals.powerProfile = "desktop";
                            performanceProcess.running = true;
                            paddingTimer.running = true;
                        }
                    }
                }
            }
        }
    }
    Process {
        id: ecoProcess
        command: Machines.current.ecoCommand
        running: false
    }
    Process {
        id: balancedProcess
        command: Machines.current.balancedCommand
        running: false
    }
    Process {
        id: performanceProcess
        command: Machines.current.performanceCommand
        running: false
    }
    Process {
        id: currentProfileProcess
        command: Machines.current.getterCommand
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                powerProfile.currentProfile = (this.text.split(" ")[Machines.current.getterStringSplitIndex]).trim();
            }
        }
    }
    Process {
        id: init
        command: Machines.current.getterCommand
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                powerProfile.currentProfile = (this.text.split(" ")[Machines.current.getterStringSplitIndex]).trim();
                if (powerProfile.currentProfile === Machines.current.profiles[0]) {
                    powerProfile.state = "eco";
                } else if (powerProfile.currentProfile === Machines.current.profiles[1]) {
                    powerProfile.state = "balanced";
                } else if (powerProfile.currentProfile === Machines.current.profiles[2]) {
                    powerProfile.state = "performance";
                } else {
                    powerProfile.state = "balanced";
                    balancedProcess.running = true;
                }
            }
        }
    }
    Timer {
        id: paddingTimer
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            currentProfileProcess.running = true;
        }
    }
}
