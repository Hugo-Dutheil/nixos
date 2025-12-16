pragma Singleton

import qs
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property list<int> values: Array(Globals.visualiserBars)

  Connections {
    target: Globals

    function onVisualiserBarsChanged() {
      root.values = Array(Globals.visualiserBars);
      cavaProc.running = false;
      cavaProc.running = true;
    }
  }

  Process {
    id: cavaProc

    running: true

    command: ["sh", "-c", `printf '[general]\nframerate=60\nbars=${Globals.visualiserBars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100\n[smoothing]\nnoise_reduction=85\nmonstercat=1\ngravity=120\n[eq]\n1=0.8\n2=0.9\n3=1\n4=1.1\n5=1.2' | cava -p /dev/stdin`]

    stdout: SplitParser {
      onRead: data => {
        root.values = data.split(";");
      }
    }
  }
}
