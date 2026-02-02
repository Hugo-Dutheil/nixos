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
    readonly property string lockWallpaper: "wallpapers/newKittybg.jpg"
  };
  
  readonly property var galaxy: QtObject {
    readonly property color background: "#682958"
    readonly property color foreground: "#8345f7"
    readonly property color accent1: "#f2cbd4"
    readonly property color accent2: "#D6CBAF"
    readonly property color accent3: "#dd2a2a"
    readonly property color border: "#7a0000"
    readonly property color muted: "#442e3f"
    readonly property string wallpaper: "wallpapers/galaxy.jpg"
    readonly property string lockWallpaper: "wallpapers/newKittybg.jpg"
  };

  readonly property var galaxiussy: QtObject{
    readonly property color background: "#1E4B57"
    readonly property color foreground: "#5376C9"
    readonly property color accent1: "#9CA6BB"
    readonly property color accent2: "#5B5D5E"
    readonly property color accent3: "#288A85"
    readonly property color border: "#115451"
    readonly property color muted: "#2C2C2E"
    readonly property string wallpaper: "wallpapers/galaxiussy.jpeg"
    readonly property string lockWallpaper: "wallpapers/newKittybg.jpg"
  };
}
