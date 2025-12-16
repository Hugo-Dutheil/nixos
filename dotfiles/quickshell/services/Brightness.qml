pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string target: ""
  property string brightnessPercentage: ""
  property int brightness: NaN
  
  onBrightnessChanged: findBrightnessPercentage.running = true;

  Process {
    id: findTarget

    running: true
    command: ["sh", "-c", `brightnessctl -m | awk -F"," '{print $1}'`]
    stdout: StdioCollector {
      onStreamFinished: target = this.text.replace(/\n/g, "")
    }
  }

  Process {
    id: findBrightness
    running: true
    command: ["sh", "-c", `brightnessctl -m | awk -F"," '{print $3}'`]
    stdout : StdioCollector {
      onStreamFinished: { 
        brightness = parseInt(this.text.replace(/\n/g, ""));
      }
    }
  }
  Timer {
    running: true
    repeat: true
    interval: 100
    onTriggered: findBrightness.running = true;
  }

  Process {
    id: findBrightnessPercentage
    
    running: true
    command: ["sh", "-c", `brightnessctl -m | awk -F"," '{print $4}'`]

    stdout: StdioCollector {
      onStreamFinished: brightnessPercentage = this.text
    }
  }


  function changeBrightness( val: int) : void {
    if (val < 0 || val > 255) {
      console.log("Error from Brightness.qml: invalid value input");
      return;
    }
    brightness = val
    changeBrightness.running = true;
    return;
  }
  Process {
    id: changeBrightness

    running: false
    command: ["sh", "-c", `brightnessctl -d ${target} set ${brightness}`]
    onExited: findBrightnessPercentage.running = true
  }
  
}
