import Quickshell
import Quickshell.Io
import QtQuick
import "./"

PanelWindow {
  id: root

  color: "transparent"
  anchors {
    left: true
    right: true
    top: true
    bottom: true
  }
  aboveWindows: false
  focusable: false
  exclusionMode: ExclusionMode.Ignore
  readonly property bool changeTheme: Globals.launchNextTheme
  property int pointer1: Globals.initialTheme
  property int pointer2: (Globals.initialTheme + 1)%Globals.themes.length

  onChangeThemeChanged: {
    transitionTheme();
  }
  function transitionTheme(){
    console.log("Called here");
//    imageContainer.state = changeTheme ? "showAlt" : "showIm";
    changeTheme ? showAlt() : showIm();
    console.log("Changed theme to", imageContainer.state);
    return;
  }
  function showAlt(){
    altShow.running = true;
    imHide.running = true;
    return;
  }
  function showIm(){
    imShow.running = true;
    altHide.running = true;
    return;
  }
  Item {
    id: imageContainer
    anchors.fill: parent
    state: "showIm"
    Image {
      id: image
      opacity: 1
      source: Globals.themes[pointer1].wallpaper
      anchors.fill: parent
      fillMode: Image.PreserveAspectCrop
      cache: true
      asynchronous: true
      // smooth: false
    }

    Image {
      id: altImage
      source: Globals.themes[pointer2].wallpaper
      opacity: 0
      anchors.fill: parent
      fillMode: Image.PreserveAspectCrop
      cache: true
      asynchronous: true
    }
    
    OpacityAnimator {
      id: imShow
      target: image
      from: 0
      to: 1
      duration: 300
      running: false
    }
    OpacityAnimator {
      id: imHide
      target: image
      from: 1
      to: 0
      duration: 300
      running: false
      onFinished: {
        root.pointer1 = (root.pointer2 + 1)%Globals.themes.length;
        Globals.initialTheme = root.pointer2;
        tracker.running = false;
      }
    }
    OpacityAnimator {
      id: altShow
      target: altImage
      from: 0
      to: 1
      duration: 300
      running: false
    }
    OpacityAnimator {
      id: altHide
      target: altImage
      from: 1
      to: 0
      duration: 300
      running: false
      onFinished: {
        root.pointer2 = (root.pointer1 + 1)%Globals.themes.length;
        Globals.initialTheme = root.pointer1;
        tracker.running = false;
      }
    }
  }
}
