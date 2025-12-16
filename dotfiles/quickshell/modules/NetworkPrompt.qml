import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Popup {
  id: popup
  width: 350
  height: 200
  modal: true
  focus: true
  required property string ssid
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

  function buildNmcliCommand(connection, interfaceName) {
    console.log("building nmcli command", connection.security, interfaceName);
    var ssid = connection.ssid;
    var conName = ssid;
    var saveFlag = connection.save ? [] : ["--temporary"];
    var cmd = [];

    // Base command
    var base = [
      "pkexec", "nmcli", "connection", "add",
      "type", "wifi",
      "ifname", interfaceName,
      "con-name", conName,
      "ssid", ssid
    ];

    switch (connection.security) {
      case "open":
        cmd = base.concat(["wifi-sec.key-mgmt", "none"]).concat(saveFlag);
        break;

      case "wep":
        cmd = base.concat([
          "wifi-sec.key-mgmt", "none",
          "802-11-wireless-security.wep-key0", connection.psk
        ]).concat(saveFlag);
        break;

      case "wpa-psk":
        console.log("selected wpa-psk as security");
        cmd = base.concat([
          "wifi-sec.key-mgmt", "wpa-psk",
          "wifi-sec.psk", connection.psk
        ]).concat(saveFlag);
        break;

      case "wpa-eap":
        cmd = base.concat([
          "wifi-sec.key-mgmt", "wpa-eap",
          "802-1x.eap", "peap",
          "802-1x.identity", connection.identity,
          "802-1x.password", connection.password,
          "802-1x.phase2-auth", "mschapv2",
          "802-1x.altsubject-matches", ""
        ]).concat(saveFlag);
        break;

    default:
      cmd = [];
      break;
    }

    callNmcli.command = cmd;
    callNmcli.running = true;
  }

  Process {
    id: callNmcli
    running: false
  }

  Rectangle {
    color: "#D6CBAF"
    anchors.fill: parent
    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 12
      spacing: 10

      TextField {
        id: ssidField
        placeholderText: "Network SSID"
        text: popup.ssid
        Layout.fillWidth: true
        selectByMouse: true
      }

      ComboBox {
        id: securityCombo
        Layout.fillWidth: true
        model: [ "Open", "WEP", "WPA/WPA2 Personal", "WPA2-Enterprise (EAP)" ]
        currentIndex: 2
      }

      TextField {
        id: passwordField
        placeholderText: "Password (leave empty for open networks)"
        echoMode: TextInput.Password
        Layout.fillWidth: true
        visible: securityCombo.currentIndex !== 0 // hide for open
      }

      TextField {
        id: identityField
        placeholderText: "Identity (username) — for EAP"
        Layout.fillWidth: true
        visible: securityCombo.currentIndex === 3
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        CheckBox {
          id: saveCheck
          text: "Save network"
          checked: true
        }

        Item { Layout.fillWidth: true } // spacer

        Button {
          text: "Cancel"
          onClicked: {
            popup.close()
          }
        }

        Button {
          id: connectBtn
          text: "Connect"
          enabled: true
          property var interfaceName: ""
          onClicked: {
            if (ssidField.text.trim() === "") {
              ssidField.text = popup.ssid;
            }
            var sec = "open"
            switch (securityCombo.currentIndex) {
              case 0: sec = "open"; break
              case 1: sec = "wep"; break
              case 2: sec = "wpa-psk"; break
              case 3: sec = "wpa-eap"; break
            }

            var connection = {
              ssid: ssidField.text,
              security: sec,
              save: saveCheck.checked
            }
            if (sec === "wpa-psk" || sec === "wep") {
              connection.psk = passwordField.text
            } else if (sec === "wpa-eap") {
              connection.identity = identityField.text
              connection.password = passwordField.text
            } else { // open
                // no password
            }
            getInterfaceName.running = true;
            buildNmcliCommand(connection, interfaceName);
            popup.close();
          }
          Process {
            id: getInterfaceName
            command: ["sh", "-c", "nmcli -t -f DEVICE,TYPE device | awk -F: '$2==\"wifi\" {print $1; exit}'"]

            stdout: StdioCollector {
              onStreamFinished: {
                connectBtn.interfaceName = this.text.trim();
                console.log("Detected WiFi interface:", this.text.trim());
              }
            }
          }
        }
      }
    }
  }
}
