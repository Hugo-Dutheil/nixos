import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Effects
import QtQml
import Quickshell.Services.Mpris
import ".."
import "../services" as Services


PopupWindow {
  id: root
  required property var ref


  readonly property int maxHeight: 1280
  readonly property int maxWidth: 1920

  readonly property int marginSizeWidth: root.maxWidth/4
  readonly property int marginSizeHeight: root.maxHeight/4
  readonly property int availableHeight: root.maxHeight - 2*marginSizeHeight
  readonly property int availableWidth: root.maxHeight - 2*marginSizeWidth

  readonly property var player: Services.MediaPlayer.activePlayer

  implicitWidth: maxWidth
  implicitHeight: maxHeight
  color: "transparent"

  property bool debug: false
  property string stateValue: root.debug ? "visible" : "hidden"
  property bool shown: debug ? true : false
  readonly property string name: "mediaFullScreen"

  visible : debug ? true : false
  anchor.window: ref

  property var collapse: function () {
    exitFullScreen();
  }

  property var toggle: function () {
      root.stateValue === "hidden" ? root.state = "visible" : root.state = "hidden";
      shown = root.state === "visible";
      ref.collapseAllBut(name);
  }


  function exitFullScreen () {
    root.stateValue = "hidden";
    root.shown = false;
  }

  function enterFullScreen () {
    root.stateValue = "visible";
    root.shown = true;
    ref.collapseAllBut(name);
  }

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
      innerX += 20;
      innerY += 20;
    }

    let smoothed = smoothValues(rawValues, 0.8);  // adjust smoothing factor (0 = no smoothing, 1 = full)

    for (var i = 0; i < Globals.visualiserBars; i++) {
 angle = i * 2 * Math.PI / Globals.visualiserBars;
        value = Math.max(1, smoothed[i]) ;
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

  Item {
    id: wrapper
    
    opacity: 1
    clip: true
    state: root.stateValue
    anchors.fill: parent

    ClippingRectangle {
      id: background
      anchors.fill: parent
      anchors.centerIn: parent
      color: "black"

      Image {
        id: background_image

        anchors.fill: parent

        source: player.trackArtUrl || "../icons/UnknownTrack.png"
        asynchronous: false
        fillMode: Image.PreserveAspectCrop
      }
      MultiEffect {
        source: background_image
        anchors.fill: background_image
        blurMultiplier: 2
        blurEnabled: true
        blur: 1.0
        brightness: -0.3
        contrast: -0.5
      }
    }

    RowLayout {
      anchors.centerIn: parent
      implicitHeight: root.maxHeigth/3
      implicitWidth: root.maxWidth/2

      anchors{ 
        fill: parent
        leftMargin: root.marginSizeWidth
        rightMargin: root.marginSizeWidth
        topMargin: root.marginSizeHeight
        bottomMargin: root.marginSizeHeight
      }

      Item {
        id: cavaInterface
        implicitHeight: root.maxHeight/2
        implicitWidth: root.maxWidth/4

        Shape {
          id: visualiser

          readonly property real centerX: width / 2
          readonly property real centerY: height / 2
          readonly property real innerX: cover.implicitWidth / 2
          readonly property real innerY: cover.implicitHeight / 2
          property color colour: Globals.theme.accent2

          anchors.centerIn: parent
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

          readonly property int coverSize: Math.min(root.maxWidth/5, root.maxHeight/5)

          anchors.verticalCenter: parent.verticalCenter
          anchors.horizontalCenter: parent.horizontalCenter

          implicitWidth: coverSize
          implicitHeight: coverSize

          color: "transparent"
          radius: Infinity
          border.width: 5
          border.color: Globals.theme.foreground

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

        implicitHeight: root.maxHeight/6
        implicitWidth: root.maxWidth/4
        width: implicitWidth
        Rectangle {
          color: Globals.theme.background
          radius: Globals.radius
          border.color: Globals.theme.accent1
          border.width: Globals.spacing.small
          anchors.fill:parent
          anchors.centerIn: parent
        }

        ColumnLayout {
          id: mprisLayout
          anchors.fill: parent
          anchors.leftMargin: Globals.spacing.medium
          anchors.rightMargin: Globals.spacing.medium
          anchors.topMargin: Globals.spacing.medium
          anchors.bottomMargin: Globals.spacing.medium
          anchors.centerIn: parent
          Item {
            id: title
            implicitHeight: mprisLayout.height/5 
            Layout.alignment: Qt.AlignHCenter
            Text {
              anchors.centerIn: parent
              text: (player.trackTitle.length < 30 ? player.trackTitle : player.trackTitle.substring(0,27) + "...") || "Unknown Title"
              font.pointSize: (text.length < 20) ? Globals.fonts.xlarge : ((text.length < 30) ? Globals.fonts.large : Globals.fonts.medium)
              color: Globals.theme.accent1
            }
          }
          Item {
            id: artist
            implicitHeight: mprisLayout.height/ 5
            Layout.alignment: Qt.AlignHCenter
            Text {
              anchors.centerIn: parent
              text:  player.trackArtist || "Unknown Artist"
              font.pointSize: ((text.length < 20) ? Globals.fonts.medium : Globals.fonts.small)
              color: Globals.theme.accent2
            }
          }
          Item {
            id: options

            Layout.alignment: Qt.AlignHCenter
            implicitHeight: mprisLayout.height/5
            implicitWidth: mprisLayout.width/3

            RowLayout{
              anchors.centerIn: parent
              Layout.fillHeight: true
              Layout.maximumWidth: parent.implicitWidth/3
              spacing: parent.implicitWidth/3
          
              Item {
                id: back
                implicitHeight: mprisLayout.height /5

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
                implicitHeight: mprisLayout.height /5

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
                implicitHeight: mprisLayout.height /5

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
            id: timeStamps
            Layout.fillWidth: true
            implicitHeight: mprisLayout.height/ 10

            RowLayout{
              anchors.fill: parent
              spacing: mprisInterface.width * 0.8

              Text {
                id: currentTime
                text: "0:0"
                color: Globals.theme.accent2
                font.pointSize: Globals.fonts.medium
              }
              Text {
                id: songLengths

                font.pointSize: Globals.fonts.small
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
                  color: Globals.theme.border
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
    }

    states: [
      State {
        name: "hidden"
        PropertyChanges {
          wrapper.implicitHeight: 10
          wrapper.opacity: 0.5
          root.visible: false;
        }
      },

      State {
        name: "visible"
        PropertyChanges {
          wrapper.implicitHeight: root.maxHeight
          wrapper.opacity: 1
          root.visible:true;
        }
      }
    ]

    transitions : [
      Transition {
        from: "visible"
        to: "hidden"
        SequentialAnimation {
          NumberAnimation{
            property: "implicitHeight"
            duration: 0
          }
        
          NumberAnimation {
            property: "opacity"
            duration: 100
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.2, 0, 0, 1, 1, 1] // Standard deceleration curve
          }
        }
      },
      Transition{
        from: "visible"
        to: "hidden"
        SequentialAnimation {
          NumberAnimation {
            property: "opacity"
            duration: 100
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.05, 0, 0.15, 1, 1, 1] // Emphasized curve for entrance
          }
          NumberAnimation {
            property: "implicitHeight"
            duration: 0
          }
        }
      }
    ]
  }
  
  Component {
    id: comp
    Item{}
  }
}
