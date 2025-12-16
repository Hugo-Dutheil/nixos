pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Singleton {
  id: root

  readonly property list<SystemTrayItem> items: SystemTray.items

  Component.onCompleted: {
    console.log("SystemTray initialized. Waiting for items...")
    for (let i = 0; i < items.length; ++i) {
      console.log("Item", i, ":", items[i])
    }
  }

  onItemsChanged: {
    console.log("SystemTray items changed. New items:")
    for (let i = 0; i < items.length; ++i) {
      console.log("Item", i, ":", items[i])
    }
  }
}

