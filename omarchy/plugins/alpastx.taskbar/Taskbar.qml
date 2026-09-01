import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "TaskbarModel.js" as TaskbarModel

BarWidget {
  id: root
  moduleName: "alpastx.taskbar"

  readonly property var appLibrary: bar && bar.shell ? bar.shell.appLibrary : null
  readonly property int iconSize: Number(setting("iconSize", 18))
  readonly property int spacing: Number(setting("spacing", 4))
  readonly property int slotPadding: Number(setting("slotPadding", 4))
  readonly property int slotSize: Number(setting("slotSize", iconSize + slotPadding * 2))
  readonly property int highlightRadius: Number(setting("highlightRadius", 8))
  readonly property int highlightInset: Number(setting("highlightInset", 3))
  readonly property int islandInset: bar ? bar.islandInset : Style.space(2)
  readonly property int contentHeight: barSize - islandInset * 2
  readonly property var ignoreList: setting("ignoreList", [])
  readonly property var appIdsMapping: setting("appIdsMapping", ({}))
  readonly property color activeBackground: setting("activeBackground", "#93cee9")
  readonly property color hoverBackground: setting("hoverBackground", "#93cee9")
  readonly property string barScreenName: {
    var node = root
    while (node) {
      if ("screen" in node && node.screen && node.screen.name)
        return String(node.screen.name)
      node = node.parent
    }
    return ""
  }

  property int toplevelRevision: 0

  readonly property var toplevels: {
    var _ = root.toplevelRevision
    return TaskbarModel.visibleToplevels(
      ToplevelManager.toplevels.values || [],
      root.barScreenName,
      root.ignoreList
    )
  }

  visible: !vertical && toplevels.length > 0
  implicitWidth: visible ? row.implicitWidth : 0
  implicitHeight: contentHeight

  Component.onCompleted: if (appLibrary) appLibrary.refreshIcons()

  Connections {
    target: ToplevelManager.toplevels
    function onValuesChanged() { root.toplevelRevision++ }
  }

  Connections {
    target: ToplevelManager
    function onActiveToplevelChanged() { root.toplevelRevision++ }
  }

  function desktopEntryForAppId(appId) {
    var mapped = TaskbarModel.mapAppId(appId, appIdsMapping)
    var values = DesktopEntries.applications.values || []
    var normalized = TaskbarModel.normalizeId(mapped)

    for (var i = 0; i < values.length; i++) {
      var entry = values[i]
      if (!entry) continue
      if (TaskbarModel.normalizeId(entry.id) === normalized) return entry
      if (TaskbarModel.normalizeId(entry.startupClass) === normalized) return entry
    }

    for (var j = 0; j < values.length; j++) {
      var candidate = values[j]
      if (!candidate) continue
      var id = TaskbarModel.normalizeId(candidate.id)
      if (id.indexOf(normalized) >= 0 || normalized.indexOf(id) >= 0) return candidate
    }

    return null
  }

  function iconSourceFor(appId) {
    var entry = desktopEntryForAppId(appId)
    var iconName = entry ? entry.icon : TaskbarModel.mapAppId(appId, appIdsMapping)
    if (appLibrary) return appLibrary.iconSource(iconName)
    var themed = Quickshell.iconPath(iconName, true)
    if (themed.length > 0) return themed
    return Quickshell.iconPath("application-x-executable", true)
  }

  function tooltipFor(toplevel) {
    if (!toplevel) return ""
    return String(toplevel.title || toplevel.appId || "")
  }

  function tooltipTargetAt(localX, localY) {
    var point = { x: localX, y: localY }
    for (var i = 0; i < row.children.length; i++) {
      var child = row.children[i]
      if (!child || child === row || !child.visible || child.width <= 0 || child.height <= 0) continue

      var local = { x: point.x, y: point.y }
      try {
        local = root.mapToItem(child, point.x, point.y)
      } catch (e) {
        continue
      }

      if (local.x >= 0 && local.x <= child.width && local.y >= 0 && local.y <= child.height)
        return child
    }

    return null
  }

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: root.spacing

    Repeater {
      model: root.toplevels

      Item {
        id: taskButton
        required property var modelData

        readonly property var toplevel: modelData
        readonly property string tooltip: root.tooltipFor(toplevel)
        readonly property string tooltipText: tooltip
        readonly property bool tooltipHovered: visible && mouseArea.containsMouse
        readonly property bool isActive: toplevel && ToplevelManager.activeToplevel === toplevel

        implicitWidth: root.slotSize
        implicitHeight: root.slotSize
        width: root.slotSize
        height: root.slotSize

        BorderSurface {
          id: buttonSurface
          anchors.fill: parent
          anchors.margins: root.highlightInset
          radius: root.highlightRadius
          color: taskButton.isActive
            ? root.activeBackground
            : (mouseArea.containsMouse ? root.hoverBackground : "transparent")
          borderSpec: Border.none()

          Behavior on color {
            ColorAnimation { duration: 300; easing.type: Easing.OutCubic }
          }
        }

        Image {
          anchors.centerIn: parent
          width: root.iconSize
          height: root.iconSize
          fillMode: Image.PreserveAspectFit
          sourceSize.width: width * Screen.devicePixelRatio
          sourceSize.height: height * Screen.devicePixelRatio
          source: root.iconSourceFor(toplevel ? toplevel.appId : "")
          asynchronous: true
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton
          cursorShape: Qt.PointingHandCursor

          onEntered: if (root.bar) root.bar.showTooltip(taskButton, taskButton.tooltip)
          onExited: if (root.bar) root.bar.hideTooltip(taskButton)

          onClicked: function(mouse) {
            if (!taskButton.toplevel) return
            if (mouse.button === Qt.MiddleButton)
              taskButton.toplevel.close()
            else
              taskButton.toplevel.activate()
          }
        }
      }
    }
  }
}
