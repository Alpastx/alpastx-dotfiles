function parseIpStatus(raw) {
  var data = Util.parseModuleJson(raw)
  var text = String(data.text || "").trim()
  var klass = data.class || ""
  if (Array.isArray(klass)) klass = klass[0] || ""

  var tooltip = String(data.tooltip || "")
  if (!tooltip && text && text !== "-") tooltip = text + "\n\nClick to copy"

  return {
    ip: text,
    kind: klass || "down",
    interface: String(data.interface || ""),
    tooltip: tooltip
  }
}
