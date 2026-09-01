-- Converted from looknfeel.conf.

hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 2,
    border_size = 2,
  },

  decoration = {
    rounding = 8,

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
    },
  },

  layout = {
    -- Keep this commented behavior available as a Lua override if you want it later.
    -- single_window_aspect_ratio = { 1, 1 },
  },

  animations = {
    enabled = true,
  },
})
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

-- browser float window fix
hl.on("window.open", function(w)
  if w.class ~= "firefox" then return end
  if w.initial_title ~= "Mozilla Firefox" then return end

  local ff_windows = hl.get_windows({ class = "firefox" })
  if #ff_windows <= 1 then return end

  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
      if tw.address ~= w.address then return end
      if tw.title == ""
          or tw.title == "Mozilla Firefox"
          or tw.title == "about:blank"
          or tw.title:match("^about:.*Mozilla Firefox$") then return end

      sub:remove()

      if tw.title:match("^Extension:") then
          hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
          hl.dispatch(hl.dsp.window.center({ window = tw }))
          hl.dispatch(hl.dsp.focus({ window = tw }))
      else
          hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
      end
  end)
end)

