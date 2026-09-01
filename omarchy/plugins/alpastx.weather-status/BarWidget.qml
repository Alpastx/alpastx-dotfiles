import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "alpastx.weather-status"

  readonly property var defaultIndicatorEntries: ["Dnd", "StayAwake"]
  readonly property var indicatorEntries: indicatorEntriesFromSettings(settings)
  property bool indicatorAreaHovered: false
  property bool indicatorItemHovered: false
  readonly property bool alwaysShowIndicators: setting("alwaysShow", true) === true
  readonly property real indicatorIconSize: Number(setting("iconSize", Style.font.iconLarge))
  readonly property real indicatorSlotSize: Number(setting("slotSize", Style.bar.iconSlot))
  readonly property bool revealInactiveIndicators: alwaysShowIndicators || indicatorAreaHovered || indicatorItemHovered || (bar && bar.centerSectionRevealHeld === true && bar.centerHoverRevealSuppressed !== true)

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function entryId(entry) {
    if (typeof entry === "string") return entry
    if (Util.isPlainObject(entry)) {
      var id = entry["id"]
      if (id !== undefined && id !== null && String(id) !== "") return String(id)
    }
    return ""
  }

  function indicatorEntriesFromSettings(settings) {
    var source = defaultIndicatorEntries
    if (settings.items && typeof settings.items.length === "number" && settings.items.length > 0)
      source = settings.items

    var result = []
    for (var i = 0; i < source.length; i++) {
      var id = entryId(source[i])
      if (id !== "") result.push(source[i])
    }
    return result
  }

  function setIndicatorAreaHovered(hovered) {
    indicatorAreaHovered = hovered
    if (hovered) indicatorHideTimer.stop()
    else indicatorHideTimer.restart()
  }

  function setIndicatorItemHovered(hovered) {
    if (hovered) {
      indicatorItemHovered = true
      indicatorHideTimer.stop()
    } else {
      indicatorHideTimer.restart()
    }
  }

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = weatherButton
    if ("hostWidget" in target) target.hostWidget = root
  }

  function refresh() {
    if (panelLoader.item && panelLoader.item.refresh) panelLoader.item.refresh()
  }

  function togglePanel() {
    if (panelLoader.item && panelLoader.item.toggle) panelLoader.item.toggle()
  }

  function open() {
    if (panelLoader.item && panelLoader.item.openFromHotkey) panelLoader.item.openFromHotkey()
  }

  function close() {
    if (panelLoader.item && panelLoader.item.close) panelLoader.item.close()
  }

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Timer {
    id: indicatorHideTimer
    interval: 120
    onTriggered: {
      if (!root.indicatorAreaHovered)
        root.indicatorItemHovered = false
    }
  }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("../alpastx.weather/Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  readonly property bool weatherVisible: panelLoader.item && panelLoader.item.label !== ""
  readonly property real contentWidth: statusRow.implicitWidth
  readonly property real contentHeight: Math.max(statusRow.implicitHeight, root.barSize)

  visible: weatherVisible || indicatorEntries.length > 0
  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Row {
    id: statusRow
    anchors.centerIn: parent
    spacing: 0

    Repeater {
      model: root.indicatorEntries

      IndicatorSlot {
        required property var modelData
        entry: modelData
      }
    }

    BarIconButton {
      id: weatherButton
      visible: root.weatherVisible
      bar: root.bar
      text: panelLoader.item ? panelLoader.item.label : ""
      slotSize: root.indicatorSlotSize
      fontSize: root.indicatorIconSize
      opticalSize: Math.max(root.indicatorIconSize, Style.bar.iconCanvas)
      tooltipText: ""

      onPressed: function(b) {
        if (!root.bar) return
        if (b === Qt.RightButton) root.bar.run("omarchy-notification-send \"$(omarchy-weather-status)\"")
        else if (b === Qt.MiddleButton) root.refresh()
        else root.togglePanel()
      }
    }
  }

  HoverHandler {
    onHoveredChanged: root.setIndicatorAreaHovered(hovered)
  }

  component IndicatorSlot: Item {
    id: indicatorSlot

    required property var entry
    readonly property string indicatorId: root.entryId(entry)
    readonly property real reservedSlotSize: root.indicatorSlotSize

    implicitWidth: root.vertical ? Math.max(root.barSize, reservedSlotSize) : reservedSlotSize
    implicitHeight: root.vertical ? reservedSlotSize : Math.max(root.barSize, reservedSlotSize)
    width: implicitWidth
    height: implicitHeight

    Loader {
      id: indicatorSource
      anchors.centerIn: parent
      source: indicatorSlot.indicatorId ? Qt.resolvedUrl("../alpastx.indicators/indicators/" + indicatorSlot.indicatorId + ".qml") : ""
      onLoaded: indicatorSlot.injectProps()
      onStatusChanged: if (status === Loader.Error) console.warn("Weather-status indicator loader error", indicatorSlot.indicatorId, source)
    }

    Connections {
      target: root
      ignoreUnknownSignals: true
      function onIndicatorIconSizeChanged() { indicatorSlot.injectProps() }
      function onIndicatorSlotSizeChanged() { indicatorSlot.injectProps() }
    }

    HoverHandler {
      onHoveredChanged: root.setIndicatorItemHovered(hovered)
    }

    onEntryChanged: injectProps()

    function injectProps() {
      var target = indicatorSource.item
      if (!target) return
      if ("bar" in target) target.bar = root.bar
      if ("moduleName" in target) target.moduleName = indicatorId
      if ("settings" in target) target.settings = ({})
      if ("indicatorBlock" in target) target.indicatorBlock = "single"
      if ("indicatorHost" in target) target.indicatorHost = root
      if ("activeOverride" in target) target.activeOverride = null

      var slotSize = root.indicatorSlotSize
      var iconSize = root.indicatorIconSize
      if ("slotSize" in target) target.slotSize = slotSize
      if ("fontSize" in target) target.fontSize = iconSize
      if ("opticalSize" in target) target.opticalSize = Math.max(iconSize, Style.bar.iconCanvas)
      if ("fixedWidth" in target) target.fixedWidth = root.vertical ? -1 : slotSize
      if ("fixedHeight" in target) target.fixedHeight = root.vertical ? slotSize : -1
    }
  }
}
