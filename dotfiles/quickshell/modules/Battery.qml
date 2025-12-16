import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    anchors.fill: parent
    property int popupYpos
    required property int popupHeight
    readonly property alias popup: popupLoader.popup

    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
    readonly property bool isDocked: chargeState != UPowerDeviceState.Charging && UPower.displayDevice.changeRate <= 0.01
    readonly property real percentage: UPower.displayDevice.percentage
    readonly property bool isLow: percentage <= 0.15
    property string storedProfile: Globals.powerProfile


    SequentialAnimation {
      id: blinkAnimation
      running: (root.isLow && !root.isCharging)
      loops: Animation.Infinite
      
      PropertyAnimation {
        target: batteryModule
        property: "color"
        to: Globals.theme.background
        duration: 1500
      }
      PropertyAnimation {
        target: batteryModule
        property: "color"
        to: "#ad020c"
        duration: 1500
      }
    }
    onIsLowChanged: {
      updateAllColors();
      if (isLow && !(isCharging || Globals.powerProfile === "powersave")){
        console.log("Changing to powerSave");
        storedProfile = Globals.powerProfile;
        Globals.powerProfile = "powersave";
        changePowerProfile.command = Machines.current.ecoCommand;
      } else {
        switch(storedProfile){
          case "powersave": {
            changePowerProfile.command = Machines.current.ecoCommand;
            Globals.powerProfile = "powersave";
            break;

          }
          case "balanced":{
            changePowerProfile.command = Machines.current.balancedCommand;

            Globals.powerProfile = "balanced";
            break;
          }
          case "desktop":{
            changePowerProfile.command = Machines.current.performanceCommand;
            
            Globals.powerProfile = "desktop";
            break;
          }
        }
      }
      changePowerProfile.running = true;
    }

    Process {
      id: changePowerProfile
      running: false
    }

    onIsChargingChanged: {
      updateAllColors();
      if (isLow && !(isCharging || Globals.powerProfile === "powersave")){
        console.log("Changing to powerSave");
        storedProfile = Globals.powerProfile;
        Globals.powerProfile = "powersave";
        changePowerProfile.command = Machines.current.ecoCommand;
      } else {
        switch(storedProfile){
          case "powersave": {
            changePowerProfile.command = Machines.current.ecoCommand;
            Globals.powerProfile = "powersave";
            break;

          }
          case "balanced":{
            changePowerProfile.command = Machines.current.balancedCommand;

            Globals.powerProfile = "balanced";
            break;
          }
          case "desktop":{
            changePowerProfile.command = Machines.current.performanceCommand;
            
            Globals.powerProfile = "desktop";
            break;
          }
        }
      }
      changePowerProfile.running = true;
    }

    onIsDockedChanged: updateAllColors()
    
    function updateBatteryColor() {
      if (!(root.isLow && !root.isCharging)) {
        // Only update color if we're not currently blinking
        batteryModule.color = isCharging ? Globals.theme.accent1 : "transparent";
      }
    }
      
      // Initialize color
    Component.onCompleted: {
      chooseColor();
    }

    function chooseColor() {
      updateBatteryColor();
      if (root.isCharging) {
        return Globals.theme.background;
      } else if (isLow){
        return "#d0c6ad";
      } else {
        return Globals.theme.accent1;
      }
    }

    function updateAllColors(){
      updateBatteryColor();
      var color = chooseColor();
      iconText.color = color;
      percentageText.color = color;
      return;
    }
    function findBatteryGlyph() {
      chooseColor()
      if (root.isDocked) {
        return "󰇅";
      } else if (root.isCharging) {
        return "󰂄";
      } else {
        if (0.80 < percentage) {return " ";};
        if (0.60 < percentage) {return " ";};
        if (0.30 < percentage) {return " ";};
        if (0.15 < percentage) {return " ";};
        return " ";
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {
        popup.toggle();
        bar.focusGrab.active = popup.shown;
      }
      onEntered: {
        var color = Globals.theme.accent3;
        iconText.color = color;
        percentageText.color = color;
      }
      onExited: {
        updateAllColors();
      }
    }

    ColumnLayout {
      id: layout
      spacing: -8
      anchors.fill: parent

      Text {
        id: iconText
        Layout.alignment: Qt.AlignHCenter
        color: chooseColor()
        font.pointSize: Globals.fonts.xlarge
        text: findBatteryGlyph()
      }

      Text {
        id: percentageText
        Layout.alignment: Qt.AlignHCenter
        color: chooseColor()
        font.pointSize: Globals.fonts.small
        text: (root.percentage * 100).toFixed(0) + "%"
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
          popupWidth: 360
          popupHeight: root.popupHeight
          yPos: root.popupYpos
          name: "Battery"

          Rectangle {
            anchors.fill: parent
            color: "transparent"
            BatteryPopup {
              popupWidth: 360
              moduleRef: batteryContent
            }
          }
        }
      }

      Component {
        id: floatPopupComponent
        FloatPopup {
          id: popup
          ref: bar
          popupWidth: 360
          popupHeight: root.popupHeight
          yPos: root.popupYpos
          name: "Battery"

          Rectangle {
            anchors.fill: parent
            color: "transparent"
            BatteryPopup {
              popupWidth: 360
              moduleRef: batteryContent
          }
        }
      }
    }
  }
}
