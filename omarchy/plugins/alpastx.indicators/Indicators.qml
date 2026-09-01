import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "alpastx.indicators"

  readonly property var defaultIndicatorEntries: [ "ScreenRecording", "Reminder", "NightLight", "Dnd", "StayAwake" ]
  readonly property var indicatorEntries: indicatorEntriesFromSettings(settings)
  property bool indicatorAreaHovered: false
  property bool indicatorItemHovered: false
  readonly property bool alwaysShowIndicators: setting("alwaysShow", false) === true
  readonly property real indicatorIconSize: Number(setting("iconSize", Style.font.iconLarge))
  readonly property real indicatorSlotSize: Number(setting("slotSize", Style.bar.iconSlot))
  readonly property bool revealInactiveIndicators: alwaysShowIndicators || indicatorAreaHovered || indicatorItemHovered || (bar && bar.centerSectionRevealHeld === true && bar.centerHoverRevealSuppressed !== true)

  signal refreshRequested()

  function entryId(entry) {
    if (typeof entry === "string") return entry
    if (Util.isPlainObject(entry)) {
      var id = entry["id"]
      if (id !== undefined && id !== null && String(id) !== "") return String(id)
    }
    return ""
  }

  function entrySettings(entry) {
    if (!Util.isPlainObject(entry)) return {}
    var copy = {}
    for (var key in entry) {
      if (key === "id") continue
      copy[key] = entry[key]
    }
    return copy
  }

  function indicatorEntriesFromSettings(settings) {
    var source = defaultIndicatorEntries
    if (settings.items && typeof settings.items.length === "number" && settings.items.length > 0) source = settings.items
    else if (settings.indicators && typeof settings.indicators.length === "number" && settings.indicators.length > 0) source = settings.indicators

    var result = []
    for (var i = 0; i < source.length; i++) {
      var item = source[i]
      if (typeof item !== "string" && item !== null && typeof item === "object") {
        try {
          item = JSON.parse(JSON.stringify(item))
        } catch (error) {
        }
      }
      var id = entryId(item)
      if (id !== "") result.push(item)
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

  function refresh() { root.refreshRequested() }

  readonly property real reservedBlockWidth: root.vertical
    ? Math.max(indicatorBlock.implicitWidth, root.barSize)
    : indicatorBlock.implicitWidth
  readonly property real reservedBlockHeight: root.vertical
    ? indicatorBlock.implicitHeight
    : Math.max(indicatorBlock.implicitHeight, root.barSize)

  implicitWidth: reservedBlockWidth
  implicitHeight: reservedBlockHeight

  IpcHandler {
    target: "alpastx.indicators"

    function refresh(): void {
      root.broadcast("refresh")
    }
  }

  Timer {
    id: indicatorHideTimer
    interval: 120
    onTriggered: {
      if (!root.indicatorAreaHovered)
        root.indicatorItemHovered = false
    }
  }

  Component.onCompleted: root.refreshRequested()

  Item {
    id: indicatorBlockHost

    anchors.centerIn: parent
    implicitWidth: indicatorBlock.implicitWidth
    implicitHeight: indicatorBlock.implicitHeight
    width: implicitWidth
    height: implicitHeight

    HoverHandler {
      onHoveredChanged: root.setIndicatorAreaHovered(hovered)
    }

    IndicatorBlock {
      id: indicatorBlock

      anchors.centerIn: parent
      indicatorsModule: root
      indicatorEntries: root.indicatorEntries
      indicatorBlock: "single"
      horizontal: !root.vertical
    }
  }

  HoverHandler {
    onHoveredChanged: root.setIndicatorAreaHovered(hovered)
  }

  component IndicatorBlock: Item {
    id: indicatorBlockRoot

    property var indicatorEntries: []
    property var indicatorsModule: null
    property string indicatorBlock: "single"
    property bool horizontal: true

    implicitWidth: blockLoader.item ? blockLoader.item.implicitWidth : 0
    implicitHeight: blockLoader.item ? blockLoader.item.implicitHeight : 0
    width: implicitWidth
    height: implicitHeight

    Loader {
      id: blockLoader

      anchors.centerIn: parent
      sourceComponent: indicatorBlockRoot.horizontal ? horizontalIndicatorBlock : verticalIndicatorBlock
    }

    Component {
      id: horizontalIndicatorBlock

      Row {
        spacing: 0

        Repeater {
          model: indicatorBlockRoot.indicatorEntries

          IndicatorLoader {
            required property var modelData
            indicatorsModule: indicatorBlockRoot.indicatorsModule
            entry: modelData
            indicatorBlock: indicatorBlockRoot.indicatorBlock
          }
        }
      }
    }

    Component {
      id: verticalIndicatorBlock

      Column {
        spacing: 0

        Repeater {
          model: indicatorBlockRoot.indicatorEntries

          IndicatorLoader {
            required property var modelData
            indicatorsModule: indicatorBlockRoot.indicatorsModule
            entry: modelData
            indicatorBlock: indicatorBlockRoot.indicatorBlock
          }
        }
      }
    }
  }

  component IndicatorLoader: Item {
    id: indicatorSlot

    required property var entry
    property var indicatorsModule: null
    required property string indicatorBlock
    readonly property string indicatorId: root.entryId(entry)
    readonly property var indicatorSettings: root.entrySettings(entry)
    readonly property real reservedSlotSize: root.indicatorSlotSize

    implicitWidth: root.vertical ? Math.max(root.barSize, reservedSlotSize) : reservedSlotSize
    implicitHeight: root.vertical ? reservedSlotSize : Math.max(root.barSize, reservedSlotSize)
    width: implicitWidth
    height: implicitHeight

    readonly property var barRef: root.bar

    onEntryChanged: injectProps()
    onIndicatorBlockChanged: injectProps()
    onIndicatorSettingsChanged: injectProps()
    onIndicatorsModuleChanged: injectProps()
    onBarRefChanged: injectProps()

    Loader {
      id: indicatorSource

      anchors.centerIn: parent
      source: indicatorSlot.indicatorId ? Qt.resolvedUrl("indicators/" + indicatorSlot.indicatorId + ".qml") : ""
      onLoaded: indicatorSlot.injectProps()
      onStatusChanged: if (status === Loader.Error) console.warn("Indicator loader error", indicatorSlot.indicatorId, source)
    }

    Connections {
      target: root
      ignoreUnknownSignals: true
      function onIndicatorIconSizeChanged() { indicatorSlot.injectProps() }
      function onIndicatorSlotSizeChanged() { indicatorSlot.injectProps() }
    }

    function injectProps() {
      var target = indicatorSource.item
      if (!target) return
      if ("bar" in target) target.bar = root.bar
      if ("moduleName" in target) target.moduleName = indicatorId
      if ("settings" in target) target.settings = indicatorSettings
      if ("indicatorBlock" in target) target.indicatorBlock = indicatorBlock
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
