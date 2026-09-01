import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "alpastx.network"

  readonly property color barText: root.bar ? root.bar.barForeground : Color.bar.text
  readonly property color downloadColor: {
    var custom = setting("downloadColor", "")
    return custom ? Qt.color(custom) : barText
  }
  readonly property color uploadColor: {
    var custom = setting("uploadColor", "")
    return custom ? Qt.color(custom) : Util.alpha(barText, 0.72)
  }
  readonly property int rateFontSize: Style.font.caption
  readonly property int hPad: Style.space(6)
  readonly property int islandInset: bar ? bar.islandInset : Style.space(2)
  readonly property int contentHeight: Math.max(1, barSize - islandInset * 2)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property string rateFontFamily: Style.font.family

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = barButton
    if ("hostWidget" in target) target.hostWidget = root
  }

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  readonly property var panel: panelLoader.item
  readonly property string connectionKind: panel ? panel.kind : "disconnected"
  readonly property bool showBandwidth: panel && panel.showBarBandwidth === true
  readonly property string downText: panel ? panel.barDownloadText : ""
  readonly property string upText: panel ? panel.barUploadText : ""
  readonly property string linkedText: panel ? panel.barLinkedText : ""
  readonly property string tooltipText: panel ? panel.barTooltipText : "Disconnected"

  implicitWidth: barButton.implicitWidth
  implicitHeight: barButton.implicitHeight

  function triggerPress(button) {
    if (button === Qt.RightButton && root.bar) root.bar.run("omarchy-shell shell toggle alpastx.network")
    else root.togglePanel()
  }

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  Item {
    id: barButton
    implicitWidth: contentRow.implicitWidth + root.hPad * 2
    implicitHeight: root.contentHeight

    property bool pressable: true
    property bool interactive: true

    function triggerPress(button) {
      root.triggerPress(button)
    }

    Row {
      id: contentRow
      anchors.centerIn: parent
      spacing: Style.space(3)

      Text {
        textFormat: Text.PlainText
        visible: root.linkedText !== ""
        text: root.linkedText
        color: root.barText
        font.family: root.fontFamily
        font.pixelSize: Style.font.bodySmall
        font.bold: true
        elide: Text.ElideRight
        maximumLineCount: 1
        width: Math.min(implicitWidth, Style.space(72))
        anchors.verticalCenter: parent.verticalCenter
      }

      Row {
        visible: root.showBandwidth
        spacing: Style.space(4)
        anchors.verticalCenter: parent.verticalCenter

        Row {
          spacing: Style.space(1)
          visible: root.downText !== ""
          anchors.verticalCenter: parent.verticalCenter

          Text {
            textFormat: Text.PlainText
            text: "↓"
            color: root.downloadColor
            font.family: root.fontFamily
            font.pixelSize: root.rateFontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            textFormat: Text.PlainText
            text: root.downText
            color: root.downloadColor
            font.family: root.rateFontFamily
            font.pixelSize: root.rateFontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        Row {
          spacing: Style.space(1)
          visible: root.upText !== ""
          anchors.verticalCenter: parent.verticalCenter

          Text {
            textFormat: Text.PlainText
            text: "↑"
            color: root.uploadColor
            font.family: root.fontFamily
            font.pixelSize: root.rateFontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            textFormat: Text.PlainText
            text: root.upText
            color: root.uploadColor
            font.family: root.rateFontFamily
            font.pixelSize: root.rateFontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: function(mouse) { barButton.triggerPress(mouse.button) }
      onEntered: if (root.bar) root.bar.showTooltip(root, root.tooltipText)
      onExited: if (root.bar) root.bar.hideTooltip(root)
    }
  }
}
