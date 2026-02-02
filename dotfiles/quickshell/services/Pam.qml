pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pam

Singleton {
  id: root

  readonly property var context: Pam.PamContext
  

}
