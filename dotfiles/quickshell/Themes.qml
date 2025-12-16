pragma Singleton

import Quickshell
import QtQuick

Singleton {

  // background: arbitrary which looks best
  // foreground: text color so oposite of background
  // accent1: primary flashy color
  // accent2: same tint as accent1 but darker or lighter depending on background
  // accent3: secondary flashy color
  // border: rather light muted
  // muted: mix between background and foreground
  
  // megalinee is a legacy theme 

  readonly property var forest: QtObject {
    readonly property color background: "#2b281c"
    readonly property color foreground: "#304C22"
    readonly property color accent1: "#DCAD37"
    readonly property color accent2: "#D6CBAF"
    readonly property color accent3: "#10AF40"
    readonly property color border: "#B5B35B"
    readonly property color muted: "#483d00"
    readonly property string wallpaper: "wallpapers/newKittybg.jpg"
  }
}
