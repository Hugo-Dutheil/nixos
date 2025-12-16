import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import QtQml
import Quickshell.Services.Mpris
import ".."
import "../services" as Services

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
  readonly property var player: Services.MediaPlayer.activePlayer


  function smoothValues(values, strength) {
      let result = [];
      for (let i = 0; i < values.length; i++) {
          let prev = values[i - 1] ?? values[i];
          let next = values[i + 1] ?? values[i];
          result[i] = (prev + values[i] + next) / 3 * strength + values[i] * (1 - strength);
      }
      return result;
  }


  function calculatePoints(centerX: int, centerY: int, innerX: int, innerY: int) : var {
    var resultPoint;
    resultPoint = Array.from({length: Globals.visualiserBars}, (_, i) => ({ value: 0}));
    var value = 0;
    var angle = 0;
    let rawValues = Services.Cava.values;
    let allZeros = true;
    for (var i = 0; i < rawValues.length; ++i){
      if (rawValues[i] != 0){
        allZeros = false;
        break;
      }
    }
    if(!allZeros){
      innerX += 10;
      innerY += 10;
    }

    let smoothed = smoothValues(rawValues, 0.8);  // adjust smoothing factor (0 = no smoothing, 1 = full)

    for (var i = 0; i < Globals.visualiserBars; i++) {
 angle = i * 2 * Math.PI / Globals.visualiserBars;
        value = Math.max(1, smoothed[i]) / 4;
        resultPoint[i] = Qt.point(
            centerX + (innerX + value) * Math.cos(angle),
            centerY + (innerY + value) * Math.sin(angle)
        );
      }
    return resultPoint;
  }


  function catmullRomToBezier(p0, p1, p2, p3, tension = 0.8) {
    return {
      cp1: Qt.point(
        p1.x + (p2.x - p0.x) / 6 * tension,
        p1.y + (p2.y - p0.y) / 6 * tension
      ),
      cp2: Qt.point(
        p2.x - (p3.x - p1.x) / 6 * tension,
        p2.y - (p3.y - p1.y) / 6 * tension
      )
    };
  }

  function togglePlay() {
    player.togglePlaying();
  }

  RowLayout {
    spacing: Globals.padding
    anchors.fill: parent
    Item {
      id: cavaInterface
      Layout.fillHeight: true
      implicitWidth: 175
      Shape {
        id: visualiser

        readonly property real centerX: width / 2
        readonly property real centerY: height / 2
        readonly property real innerX: cover.implicitWidth / 2
        readonly property real innerY: cover.implicitHeight / 2
        property color colour: Globals.theme.accent2

        anchors.centerIn: cover
        anchors.fill: parent
        asynchronous: true
        preferredRendererType: Shape.CurveRenderer
//          data: visualiserBars.instances
        Canvas {
          id: visualiserCircle
          anchors.fill: parent
          property var points: [] 
          onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0,0, visualiserCircle.width, visualiserCircle.height);
            points = calculatePoints(visualiser.centerX, visualiser.centerY, visualiser.innerX - Globals.spacing.small, visualiser.innerY-Globals.spacing.small);
            ctx.strokeStyle = visualiser.colour;
            ctx.lineWidth = 2;

            ctx.beginPath();
            ctx.moveTo(points[0].x, points[0].y);
            for (let i = 0; i < points.length; i++) {
              let p0 = points[(i - 1 + points.length) % points.length];
              let p1 = points[i % points.length];
              let p2 = points[(i + 1) % points.length];
              let p3 = points[(i + 2) % points.length];
              let { cp1, cp2 } = catmullRomToBezier(p0, p1, p2, p3);

              ctx.bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, p2.x, p2.y);
            };

            ctx.fillStyle = Globals.theme.accent2
            ctx.globalAlpha = 0.7
            ctx.fill("evenodd")
            ctx.stroke();
          }

          Timer {
            onTriggered: visualiserCircle.requestPaint()
            repeat: true
            interval: 1000/60
            running: true
          }
        }
      }

//        UNCOMMENT HERE TO HAVE BARS INSTEAD OF THE ZONE

//      Variants {
//          id: visualiserBars
//
//          model: Array.from({
//              length: Globals.visualiserBars
//          }, (_, i) => i)
//
//          ShapePath {
//              id: visualiserBar
//
//              required property int modelData
//              readonly property int value: Math.max(1, Services.Cava.values[modelData])
//
//              readonly property real angle: modelData * 2 * Math.PI / Globals.visualiserBars
//              readonly property real magnitude: value/5
//              readonly property real cos: Math.cos(angle)
//              readonly property real sin: Math.sin(angle)
//              readonly property real clippingSize: 2*strokeWidth
//
//              strokeWidth: 360 / Globals.visualiserBars - Globals.spacing.small
//              strokeColor: Globals.theme.accent2
//              capStyle: ShapePath.RoundCap
//
//
//              startX: visualiser.centerX + (visualiser.innerX + strokeWidth / 2 - clippingSize) * cos
//              startY: visualiser.centerY + (visualiser.innerY + strokeWidth / 2 - clippingSize) * sin
//
//              PathLine {
//                  x: visualiser.centerX + (visualiser.innerX + visualiserBar.strokeWidth / 2 + visualiserBar.magnitude) * visualiserBar.cos
//                  y: visualiser.centerY + (visualiser.innerY + visualiserBar.strokeWidth / 2 + visualiserBar.magnitude) * visualiserBar.sin
//              }
//          }
//        }
//      }

      ClippingRectangle {
        id: cover

        readonly property int coverSize: 100

        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent

        implicitWidth: coverSize
        implicitHeight: coverSize

        color: Globals.theme.accent1
        radius: Infinity
        border.width: 5
        border.color: Globals.theme.foreground

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onClicked: goToSpotify.running = true;
        }
        Process {
          id: goToSpotify
          running: false
          command: ["hyprctl", "dispatch", "workspace", "special:spotify"]
        }

        Image {
            id: image

            anchors.fill: parent

            source: player.trackArtUrl || "../icons/UnknownTrack.png"
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: width
            sourceSize.height: height
            property real rotAngle: 0
            transform: Rotation {origin.x: image.width/2; origin.y:image.height/2; axis {x:0; y:0; z:1} angle: image.rotAngle}
        
            Timer {
              id: findRotation
              interval: 1000/60
              repeat: true
              running: player.isPlaying
              readonly property real omega: 2*Math.PI/20
              onTriggered: {
                image.rotAngle += omega
              } 
            } 
        }
      }
    }  
    Item {
      id: mprisInterface

      Layout.fillHeight: true
      implicitWidth: 250
      width: implicitWidth
      ColumnLayout {
        anchors.fill: parent
        implicitWidth: 100
        Item {
          id: title

          Layout.fillWidth: true
          implicitHeight: 10
          Text {
            anchors.centerIn: parent
            text: (player.trackTitle.length < 30 ? player.trackTitle : player.trackTitle.substring(0,27) + "...") || "Unknown Title"
            font.pointSize: (text.length < 10) ? Globals.fonts.medium : ((text.length < 20) ? Globals.fonts.small : Globals.fonts.xsmall)
            color: Globals.theme.accent1
          }
        }
        Item {
          id: artist
          Layout.fillWidth: true
          implicitHeight: 10
          Text {
            anchors.centerIn: parent
            text:  player.trackArtist || "Unknown Artist"
            font.pointSize: ((text.length < 20) ? Globals.fonts.small : Globals.fonts.xsmall)
            color: Globals.theme.accent2
          }
        }
        Item {
          id: options

          Layout.fillWidth: true
          implicitHeight: 10
          RowLayout{
            anchors.centerIn: parent
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Globals.spacing.medium

            Item {
              id: back
              implicitWidth: mprisInterface.implicitWidth /3
              Text {
                text: "󰒮"
                anchors.centerIn: parent
                font.pointSize: Globals.fonts.xlarge
                color: Globals.theme.accent1
                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: player.canGoPrevious ? player.previous() : null
                }
              }
            }

            Item {
              id:togglePlay
              implicitWidth: mprisInterface.implicitWidth /3
              Layout.fillHeight: parent

              Text {
                text: player.isPlaying ? "" : "" 
                anchors.centerIn: parent
                font.pointSize: Globals.fonts.xlarge
                color: Globals.theme.accent1

                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: { player.isPlaying ? (player.canPause ? player.pause() : null) : (player.canPause ? player.play() : null) }
                }
              }
            }

            Item{
              id: skip
              implicitWidth: mprisInterface.implicitWidth / 3
              Layout.fillHeight: parent

              Text {
                text: "󰒭"
                anchors.centerIn: parent
                font.pointSize: Globals.fonts.xlarge
                color: Globals.theme.accent1
                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: player.canGoNext ? player.next() : null
                }
              }
            }
          }
        }
        Item {
          Layout.fillWidth: true
          id: timeStamps
          RowLayout{
            spacing: mprisInterface.width * 0.75
            Text {
              id: currentTime
              text: "0:0"
              color: Globals.theme.accent2
            }
            Text {
              id: songLengths

              property var seconds: Math.floor(player.length) %60
              text: Math.floor(player.length/60) + ":" + ((seconds < 10) ? "0"+seconds : seconds)
              color: Globals.theme.accent2
            }
          }
        }
        Item {
          id: progressBar
          Layout.fillWidth: true
          implicitHeight: 15
          Slider {
            id: bar
            anchors.fill: parent
            from: 0
            value: player.position
            to: player.length
            onMoved: {
              player.position = bar.value;
            }

            background: Rectangle {
              color: Globals.theme.accent2
              x: bar.leftPadding + bar.availableWidth / 2 - width  / 2
              y: (bar.availableHeight - height + bar.topPadding) / 2

              implicitWidth: 200
              implicitHeight: 5
              width: bar.availableWidth
              height: implicitHeight
              radius: height / 2

              Rectangle {
                color: Globals.theme.muted
                height: parent.height
                width: bar.visualPosition * parent.width
                radius: height / 2
              }
            }

            handle: Rectangle {
//              x: (bar.availableWidth - width)/2 + bar.leftPadding
//              y: bar.topPadding + bar.visualPosition * (bar.availableHeight - height)
              x: bar.leftPadding + bar.visualPosition * (bar.availableWidth - width)
              y: (bar.availableHeight -height)/2 + bar.topPadding
              implicitWidth: 5
              implicitHeight: 15
              color: Globals.theme.accent3
            }
          }
        }
        Timer {
          id: refreshHandle
          running: true
          repeat: true
          interval: 1000
          property var seconds: Math.floor(player.position) %60
          onTriggered: {
            if (player != null) { 
              bar.value = player.position; 
              seconds = Math.floor(player.position) %60;
              currentTime.text = Math.floor(player.position/60) + ":" + ((seconds < 10) ? "0"+seconds : seconds);
            }
          }
        }
      }
    }

    Item {
      id: mediaSoundBar
      Layout.fillHeight: true
      implicitWidth: 20
      ColumnLayout {
        anchors.fill: parent
        Item {
          implicitHeight: 40
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          Button {
            id: muteButton

            anchors.centerIn: parent
            background: Rectangle {
              color: "transparent"
            }
            icon.source: "../icons/audio.svg"
            icon.color: Globals.theme.accent1
            icon.height: parent.height * 0.7
            icon.width: parent.height * 0.7
          }
          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            property real previousVolume: 0
            property bool muted: false
            onClicked: {
              if (!muted) {
                previousVolume = player.volume;
                player.volume = 0;
                muteButton.icon.source = "../icons/muted.svg"
              } else {
                player.volume = previousVolume;
                muteButton.icon.source = "../icons/audio.svg"
              }
              muted = !muted;
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
            value: player.volume
            to: 1
            orientation: Qt.Vertical
            onMoved: {
              player.volume = volumeSlider.value
            }

            background: Rectangle {
              color: Globals.theme.accent1
              x: (volumeSlider.availableWidth - width + volumeSlider.leftPadding)/2
              y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
              implicitWidth: 10
              implicitHeight: 4
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
  }
}
