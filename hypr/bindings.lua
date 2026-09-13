-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Rebind defaults to match previous shortcuts.
-- hl.unbind("SUPER + F")
-- hl.unbind("SUPER + T")
-- hl.unbind("SUPER + W")
-- hl.unbind("SUPER + L")
-- hl.unbind("SUPER + P")
-- hl.unbind("SUPER + X")
-- hl.unbind("SUPER + comma")
-- hl.unbind("SUPER + RETURN")
-- hl.unbind("SUPER + SHIFT + RETURN")
-- hl.unbind("SUPER + SHIFT + B")
-- hl.unbind("SUPER + SHIFT + F")
-- hl.unbind("SUPER + K")
-- hl.unbind("SUPER + ESCAPE")
-- hl.unbind("SUPER + PRINT")
-- hl.unbind("PRINT")
-- hl.unbind("SUPER + CTRL + L")
-- hl.unbind("SUPER + CTRL + E")

-- 
-- 
-- o.bind("SUPER + T", "Terminal", { omarchy = "terminal" })
-- 
-- 
-- o.bind("SUPER + X", "System menu", "omarchy-menu toggle system")
-- o.bind("F11", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
-- 
-- o.bind("SUPER + W", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
-- 
-- 
-- 


--custom unbinds
hl.unbind("SUPER + slash") -- Monitor scaling up
hl.unbind("SUPER + alt + slash") -- Monitor scaling down
hl.unbind("SUPER + K") -- Keybindings menu
hl.unbind("SUPER + RETURN") -- Terminal
hl.unbind("SUPER + T") -- Toggle floating/tiling
hl.unbind("SUPER + SHIFT + RETURN") -- Browser
hl.unbind("ALT + TAB") -- Focus next window / reveal active window on top
hl.unbind("CTRL + ALT + TAB") -- Focus next monitor
hl.unbind("SHIFT + ALT + TAB") -- Focus previous window / reveal active window on top
hl.unbind("SHIFT + CTRL + ALT + TAB") -- Focus previous monitor
hl.unbind("SUPER + mouse:273") -- Resize window
hl.unbind("SUPER + S") -- Toggle scratchpad
hl.unbind("SUPER + ALT + S") -- Move window to scratchpad
hl.unbind("SUPER + comma") -- Dismiss last notification
hl.unbind("SUPER + ALT + comma") -- Invoke last notification
hl.unbind("SUPER + CTRL + comma") -- Toggle silencing notifications
hl.unbind("SUPER + BACKSPACE") -- Toggle window transparency
hl.unbind("SUPER + CTRL + I") -- Toggle locking on idle
hl.unbind("SUPER + CTRL + BACKSPACE") -- Toggle single-window square aspect
hl.unbind("SUPER + CTRL + Delete") -- Toggle laptop display
hl.unbind("SUPER + CTRL + F") -- Tiled full screen
hl.unbind("SUPER + CTRL + H") -- Hardware menu
hl.unbind("SUPER + CTRL + P") -- Power panel
hl.unbind("SUPER + CTRL + Q") -- Calculator
hl.unbind("SUPER + CTRL + SPACE") -- Background switcher
hl.unbind("SUPER + CTRL + T") -- Activity
hl.unbind("SUPER + CTRL + Z") -- Zoom in
hl.unbind("SHIFT + ALT + D") -- Download video from web app
hl.unbind("SHIFT + ALT + L") -- Copy URL from web app
hl.unbind("SUPER + ALT + BRACKETLEFT") -- Make webcam overlay smaller
hl.unbind("SUPER + ALT + BRACKETRIGHT") -- Make webcam overlay larger
hl.unbind("SUPER + ALT + Home") -- Save window width
hl.unbind("SUPER + Home") -- Restore window width
hl.unbind("SUPER + SHIFT + F") -- File manager
hl.unbind("SUPER + F") -- Full screen
hl.unbind("SUPER + X") -- Universal cut
hl.unbind("SUPER + ALT + F") -- Full width
hl.unbind("SUPER + W") -- Close window
hl.unbind("CTRL + ALT + DELETE") -- Close all windows
hl.unbind("SUPER + CTRL + L") -- Lock system
hl.unbind("SUPER + X") -- System menu
hl.unbind("SUPER + CTRL + E") -- Emoji picker
hl.unbind("SUPER + PRINT") -- Color picker
hl.unbind("SUPER + ESCAPE") -- System menu
hl.unbind("SUPER + P") -- Pseudo window
hl.unbind("PRINT") -- Screenshot
hl.unbind("SUPER + ALT + RETURN") -- Tmux
hl.unbind("SUPER + CTRL + RETURN") -- Herdr
hl.unbind("SUPER + CTRL + RETURN") -- Herdr
hl.unbind("SUPER +SHIFT + B") -- Browser
hl.unbind("SUPER + SHIFT + ALT + F") -- File manager (cwd)
hl.unbind("SUPER + CTRL + TAB") -- Former workspace
hl.unbind("SUPER + SHIFT + TAB") -- Previous workspace
hl.unbind("SUPER + TAB") -- Next workspace
hl.unbind("ALT + TAB") -- Focus next window / reveal active window on top
hl.unbind("SUPER + L") -- Toggle workspace layout
hl.unbind("SUPER + P") -- Pseudo window
hl.unbind("SUPER + SHIFT + A") -- ChatGPT
hl.unbind("SUPER + SHIFT + ALT + A") -- Grok
hl.unbind("SUPER + SHIFT + ALT + DOWN") -- Move workspace to down monitor
hl.unbind("SUPER + SHIFT + ALT + E") -- New email
hl.unbind("SUPER + SHIFT + ALT + G") -- WhatsApp
hl.unbind("SUPER + SHIFT + ALT + UP") -- Move workspace to up monitor
hl.unbind("SUPER + SHIFT + ALT + X") -- X Post
hl.unbind("SUPER + SHIFT + BACKSPACE") -- Toggle window gaps
hl.unbind("SUPER + SHIFT + C") -- Calendar
hl.unbind("SUPER + SHIFT + CTRL + A") -- Agent
hl.unbind("SUPER + SHIFT + CTRL + G") -- Google Messages
hl.unbind("SUPER + SHIFT + CTRL + R") -- Clear reminders
hl.unbind("SUPER + SHIFT + D") -- Docker
hl.unbind("SUPER + SHIFT + E") -- Email
hl.unbind("SUPER + SHIFT + G") -- Signal
hl.unbind("SUPER + SHIFT + M") -- Music
hl.unbind("SUPER + SHIFT + N") -- Editor
hl.unbind("SUPER + SHIFT + O") -- Obsidian
hl.unbind("SUPER + SHIFT + P") -- Google Photos
hl.unbind("SUPER + SHIFT + S") -- Google Maps
hl.unbind("SUPER + SHIFT + SLASH") -- Passwords
hl.unbind("SUPER + SHIFT + SPACE") -- Toggle top bar
hl.unbind("SUPER + SHIFT + X") -- X
hl.unbind("SUPER + SHIFT + Y") -- YouTube
hl.unbind("SUPER + ALT + code:10") -- Switch to group window 1
hl.unbind("SUPER + ALT + code:11") -- Switch to group window 2
hl.unbind("SUPER + ALT + code:12") -- Switch to group window 3
hl.unbind("SUPER + ALT + code:13") -- Switch to group window 4
hl.unbind("SUPER + ALT + code:14") -- Switch to group window 5
hl.unbind("SUPER + ALT + DOWN") -- Move window to group on bottom
hl.unbind("SUPER + ALT + G") -- Move active window out of group
hl.unbind("SUPER + ALT + LEFT") -- Move window to group on left
hl.unbind("SUPER + ALT + mouse_down") -- Next window in group
hl.unbind("SUPER + ALT + mouse_up") -- Previous window in group
hl.unbind("SUPER + ALT + RIGHT") -- Move window to group on right
hl.unbind("SUPER + ALT + TAB") -- Next window in group
hl.unbind("SUPER + ALT + UP") -- Move window to group on top
hl.unbind("SUPER + CTRL + LEFT") -- Move grouped window focus left
hl.unbind("SUPER + CTRL + RIGHT") -- Move grouped window focus right
hl.unbind("SUPER + G") -- Toggle window grouping
hl.unbind("SUPER + ALT + SHIFT + TAB") -- Previous window in group
hl.unbind("ALT + XF86AudioLowerVolume") -- Volume down precise
hl.unbind("ALT + XF86AudioPlay") -- Next track
hl.unbind("ALT + XF86AudioRaiseVolume") -- Volume up precise
hl.unbind("ALT + XF86MonBrightnessDown") -- Brightness down precise
hl.unbind("ALT + XF86MonBrightnessUp") -- Brightness up precise
hl.unbind("SHIFT + ALT + XF86AudioPlay") -- Previous track
hl.unbind("SHIFT + XF86AudioMute") -- Switch audio output
hl.unbind("SHIFT + XF86AudioPause") -- Switch media source
hl.unbind("SHIFT + XF86AudioPlay") -- Switch media source
hl.unbind("SHIFT + XF86MonBrightnessDown") -- Brightness minimum
hl.unbind("SHIFT + XF86MonBrightnessUp") -- Brightness maximum
hl.unbind("SUPER + ALT + K") -- Tmux keybindings
hl.unbind("SUPER + CTRL + K") -- Herdr keybindings

-- custom binds

o.bind("SUPER + B", "Browser", { omarchy = "browser" }) -- Open browser
o.bind("SUPER + SLASH", "Keybindings", "omarchy-menu-keybindings") -- Open keybindings menu
o.bind("SUPER + T", "Open terminal", { omarchy = "terminal" }) -- Open terminal
o.bind("SUPER + R", "Resize window", hl.dsp.window.resize()) -- Resize active window
o.bind("CTRL + SHIFT + ESCAPE", "Activity", { tui = "btop" }) -- Open activity monitor
o.bind("SUPER + F", "File manager", { omarchy = "nautilus" }) -- Open file manager
o.bind("SUPER + X", "System menu", "omarchy-menu toggle system") -- Open system menu
o.bind("SUPER + Q", "Close window", hl.dsp.window.close()) -- Close active window
o.bind("SUPER + W", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating/tiling
o.bind("SUPER + L", "Lock system", "omarchy-system-lock") -- Lock screen
o.bind("SUPER + comma", "Emojis", "omarchy-shell shell toggle omarchy.emojis") -- Open emoji picker
o.bind("SUPER + P", "Color picker", "pkill hyprpicker || hyprpicker -a") -- Open color picker
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot") -- Take screenshot
o.bind("CTRL + ALT + BACKSPACE", "Toggle top bar", "omarchy-toggle-bar") -- Toggle top bar with Alt + Ctrl; Hyprland cannot distinguish left/right modifiers
hl.unbind("SUPER + LEFT") -- Focus on left window
hl.unbind("SUPER + RIGHT") -- Focus on right window
hl.unbind("SUPER + UP") -- Focus on above window
hl.unbind("SUPER + DOWN") -- Focus on below window

-- custom mouse
hl.bind("code:106", hl.dsp.window.drag(), { mouse = true }) -- Move window with mouse drag
hl.bind("Page_Up", hl.dsp.focus({ workspace = "r+1" })) -- Switch to next workspace
hl.bind("Page_Down", hl.dsp.focus({ workspace = "r-1" })) -- Switch to previous workspace

-- Move window focus from Super+Arrow to Super+Ctrl+Arrow (Hyprland submaps)


o.bind("SUPER + LEFT", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
o.bind("SUPER + RIGHT", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))
o.bind("SUPER + ALT + LEFT", "Move window to previous workspace", hl.dsp.window.move({ workspace = "r-1" }))
o.bind("SUPER + ALT + RIGHT", "Move window to next workspace", hl.dsp.window.move({ workspace = "r+1" }))

hl.bind("SUPER + CTRL", hl.dsp.submap("window-focus"))

hl.define_submap("window-focus", function()
  hl.bind("LEFT", hl.dsp.focus({ direction = "l" }), { repeating = true })
  hl.bind("RIGHT", hl.dsp.focus({ direction = "r" }), { repeating = true })
  hl.bind("UP", hl.dsp.focus({ direction = "u" }), { repeating = true })
  hl.bind("DOWN", hl.dsp.focus({ direction = "d" }), { repeating = true })
  hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

hl.bind("SUPER + CTRL + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + CTRL + UP", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + CTRL + DOWN", hl.dsp.focus({ direction = "d" }))

