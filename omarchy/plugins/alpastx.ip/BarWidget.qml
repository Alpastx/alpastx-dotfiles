import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as IpModel

BarWidget {
  id: root
  moduleName: "alpastx.ip"

  readonly property color barText: root.bar ? root.bar.barForeground : Color.bar.text
  readonly property color textColor: {
    var custom = setting("textColor", "")
    return custom ? Qt.color(custom) : barText
  }
  readonly property color ipTextColor: root.connectionKind === "down"
    ? Util.alpha(root.textColor, 0.72)
    : root.textColor
  readonly property int hPad: Style.space(8)
  readonly property int islandInset: bar ? bar.islandInset : Style.space(2)
  readonly property int contentHeight: Math.max(1, barSize - islandInset * 2)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property int pollIntervalSec: Math.max(1, Number(setting("interval", 5)))
  readonly property url scriptUrl: Qt.resolvedUrl("ip.sh")

  property string displayIp: "-"
  property string tooltipText: "No IP address"
  property string connectionKind: "down"

  function updateFromRaw(raw) {
    var data = IpModel.parseIpStatus(raw)
    displayIp = data.ip || "-"
    tooltipText = data.tooltip || displayIp
    connectionKind = data.kind || "down"
  }

  function copyIp() {
    if (!root.bar) return
    root.bar.run("bash " + Util.shellQuote(String(scriptUrl).replace(/^file:\/\//, "")) + " --copy")
  }

  implicitWidth: barButton.implicitWidth
  implicitHeight: barButton.implicitHeight

  Process {
    id: ipProc
    command: ["bash", String(root.scriptUrl).replace(/^file:\/\//, "")]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateFromRaw(text)
    }
  }

  Timer {
    interval: root.pollIntervalSec * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!ipProc.running) ipProc.running = true
    }
  }

  Item {
    id: barButton
    implicitWidth: ipLabel.implicitWidth + root.hPad * 2
    implicitHeight: root.contentHeight

    property bool pressable: true
    property bool interactive: true

    function triggerPress(button) {
      if (button === Qt.LeftButton) root.copyIp()
    }

    Text {
      id: ipLabel
      anchors.centerIn: parent
      textFormat: Text.PlainText
      text: root.displayIp
      color: root.ipTextColor
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      font.bold: true
      elide: Text.ElideRight
      maximumLineCount: 1
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: function(mouse) { barButton.triggerPress(mouse.button) }
      onEntered: if (root.bar) root.bar.showTooltip(root, root.tooltipText)
      onExited: if (root.bar) root.bar.hideTooltip(root)
    }
  }
}
