import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../services" as Services
import "../widgets" as Widgets
import ".."

Item {
    id: root
    anchors.fill: parent
    anchors.topMargin: Globals.spacing.small
    anchors.leftMargin: Globals.spacing.small
    readonly property alias wifiPrompt: promptBoxLoader.popup

    ColumnLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true
            implicitHeight: 60
            Item {
                id: toggleInfo
                Layout.fillWidth: true
                implicitHeight: 30

                Widgets.Switch {
                    id: toggle
                    widgetWidth: 40
                    widgetHeight: 20
                    toggleFunction: Services.Network.toggleWifi
                    toggleState: Services.Network.wifiEnabled
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    id: toggleText
                    color: Globals.theme.accent1
                    anchors {
                        left: toggle.right
                        verticalCenter: parent.verticalCenter
                    }
                    padding: Globals.spacing.small
                    font.pixelSize: Globals.fonts.medium
                    text: Services.Network.wifiEnabled ? "On" : "Off"
                }

                Text {
                    id: activeInfo
                    color: Globals.theme.accent1
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    padding: Globals.spacing.small
                    font.pixelSize: Globals.fonts.medium
                    font.weight: Font.Bold
                    text: {
                        if (Services.Network.scanning || !Services.Network.startupFinished)
                            return "Scanning...";
                        if (!Services.Network.wifiEnabled)
                            return "";
                        if (!Services.Network.active)
                            return "Not connected";
                        if (Services.Network.ethernetConnected)
                            return "Ethernet connected";
                        return Services.Network.active.ssid;
                    }
                }
            }
            Item {
                id: rescanButton
                Layout.fillWidth: true
                implicitHeight: 30
                Text {
                    id: rescanText
                    // leftPadding: Globals.spacing.small
                    anchors.bottom: parent.bottom
                    color: Globals.theme.accent2
                    font.pixelSize: Globals.fonts.large
                    font.weight: Font.Bold
                    text: " "

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Services.Network.rescanWifi();
                        }
                        onEntered: {
                            rescanText.color = Globals.theme.accent3;
                        }
                        onExited: {
                            rescanText.color = Globals.theme.accent2;
                        }
                    }
                }
            }
        }

        Component {
            id: networkDelegate
            Item {
                id: item

                required property string ssid
                required property bool active
                required property string security

                height: 30
                width: parent.width

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        networkText.color = Globals.theme.accent3;
                    }
                    onExited: {
                        networkText.color = item.active ? Globals.theme.accent1 : Globals.theme.accent2;
                    }
                    onClicked: {
                      if (item.active) {
                        Services.Network.disconnectFromNetwork();
                        return;
                      }
                      if (Services.Network.isConnectedWifi()) {
                        console.log("Already connected to network, disconnecting")
                        Services.Network.disconnectFromNetwork();
                        console.log("disconnected.")
                      }
                      attemptConnection.connectionSSID = item.ssid;
                      promptBoxLoader.ssid = item.ssid;
                      attemptConnection.running = true;
                    }

                    Process{
                      id: attemptConnection
                      property string connectionSSID
                      property bool connectionExits: false
                      running: false
                      command: ["nmcli", "connection", "show"]
                      stdout: StdioCollector {
                        onStreamFinished: {
                          const connections = text.trim().split("\n");
                          connections.forEach(line => {
                              if (line.includes(item.ssid)) {
                                attemptConnection.connectionExits = true; 
                              }
                          });
                          if (attemptConnection.connectionExits){
                            Services.Network.connectToNetwork(item.ssid);
                          } else {
                            wifiPrompt.open();
                          }
                        }
                      }
                    }
                }

                Text {
                    id: networkText
                    color: item.active ? Globals.theme.accent1 : Globals.theme.accent2
                    font.pixelSize: Globals.fonts.medium
                    anchors {
                        left: parent.left
                        // leftMargin: Globals.spacing.small
                        verticalCenter: parent.verticalCenter
                    }
                    text: item.ssid
                }
                Text {
                    id: securityText
                    color: Globals.theme.accent2
                    font.pixelSize: Globals.fonts.small
                    anchors {
                        right: parent.right
                        rightMargin: Globals.spacing.small
                        verticalCenter: parent.verticalCenter
                    }
                    text: item.security ? " (" + item.security + ")" : ""
                }
            }
        }

        Item {
            id: networksList
            Layout.fillWidth: true
            Layout.fillHeight: true
            ListView {
                id: networkListView
                anchors.fill: parent
                spacing: Globals.padding
                model: Services.Network.networks

                delegate: networkDelegate

                displayMarginBeginning: -(2 * Globals.spacing.small)
                displayMarginEnd: -(2 * Globals.spacing.small)
            }
        }
      }

      Loader {
        id: promptBoxLoader
        property string ssid: ""
        sourceComponent: floatPopupComponent
        property var popup: promptBoxLoader.item

        Component {
          id: floatPopupComponent
          NetworkPrompt{
            ssid: promptBoxLoader.ssid;
          }
        }
      }
}
