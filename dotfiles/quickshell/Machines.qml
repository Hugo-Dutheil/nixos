pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property var current: thinkpad
    readonly property var thinkpad: QtObject {
        readonly property var profiles: ["powersave", "balanced", "desktop"]
        readonly property var getterCommand: ["tuned-adm", "active"]
        readonly property int getterStringSplitIndex: 3
        readonly property var ecoCommand: ["tuned-adm", "profile", "powersave"]
        readonly property var balancedCommand: ["tuned-adm", "profile", "balanced"]
        readonly property var performanceCommand: ["tuned-adm", "profile", "desktop"]
        readonly property var hypridleStartCommand: ["systemctl", "--user", "enable", "--now", "hypridle"]
        readonly property var hypridleStopCommand: ["systemctl", "--user", "disable", "--now", "hypridle"]
    }
}
