pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
  readonly property int barWidth: 70
  readonly property int padding: 3
  readonly property int radius: 7

  readonly property string popup: "Popup"

  readonly property int barExtrema: 8
  readonly property int workspacesGap: 5

  readonly property string terminal: "kitty"
  readonly property string browser: "zen-twilight"

  readonly property var themes: [Themes.forest, Themes.galaxy, Themes.galaxiussy]
  property int initialTheme: 0
  readonly property var theme: themes[initialTheme]
  property bool launchNextTheme: false

  readonly property var fonts: QtObject {
    readonly property int huge: 28
    readonly property int xlarge: 24
    readonly property int large: 18
    readonly property int medium: 14
    readonly property int small: 12
    readonly property int xsmall: 10
    readonly property int tiny: 8
  }
  readonly property var spacing: QtObject {
    readonly property int large: 12
    readonly property int medium: 8
    readonly property int small: 5
  }

  readonly property int launcherWidth: 700
  readonly property int launcherHeight: 400
  readonly property int visualiserBars: 20

  readonly property string machine: "thinkpad"
  property string powerProfile: ""

  Process {
    id: getCurrentProfile
    running: true
    command: ["tuned-adm", "active", "|", "awk", "{print", "$4}"]
    stdout: StdioCollector {
      onStreamFinished: {
        powerProfile = this.text;
      }
    }
  }
}
