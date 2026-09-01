function normalizeId(value) {
  return String(value || "").trim().toLowerCase()
}

function mapAppId(appId, mapping) {
  var key = String(appId || "")
  if (!mapping) return key
  if (mapping[key]) return String(mapping[key])
  var lower = key.toLowerCase()
  if (mapping[lower]) return String(mapping[lower])
  return key
}

function shouldIgnore(appId, ignoreList) {
  var id = normalizeId(appId)
  if (!id) return true
  for (var i = 0; i < ignoreList.length; i++) {
    if (normalizeId(ignoreList[i]) === id) return true
  }
  return false
}

function screenNames(toplevel) {
  var result = []
  var screens = toplevel && toplevel.screens ? toplevel.screens : []
  for (var i = 0; i < screens.length; i++) {
    if (screens[i] && screens[i].name) result.push(String(screens[i].name))
  }
  return result
}

function onScreen(toplevel, screenName) {
  if (!screenName) return true
  var names = screenNames(toplevel)
  if (names.length === 0) return true
  for (var i = 0; i < names.length; i++) {
    if (names[i] === screenName) return true
  }
  return false
}

function visibleToplevels(values, screenName, ignoreList) {
  var out = []
  for (var i = 0; i < values.length; i++) {
    var toplevel = values[i]
    if (!toplevel) continue
    if (shouldIgnore(toplevel.appId, ignoreList)) continue
    if (!onScreen(toplevel, screenName)) continue
    out.push(toplevel)
  }
  return out
}
