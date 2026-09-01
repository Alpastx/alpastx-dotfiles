import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "alpastx.power-menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    tooltipText: "System"
    onPressed: function(b) {
      if (!root.bar) return
      if (b === Qt.RightButton) root.bar.run("omarchy-system-lock")
      else root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"power-menu\"}'")
    }
  }
}
