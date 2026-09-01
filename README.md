# alpastx-dotfiles

Custom [Omarchy](https://omarchy.org) Quattro status bar setup: three rounded “island” bar sections (left, center, right), a centered taskbar, and a transparent top strip. Includes ten `alpastx.*` shell plugins, bar layout (`shell.json`), a `bluegirl` theme overlay, and Hyprland animation/window rules from the same session.

**Not included:** stock `omarchy.*` widgets (menu, clock, workspaces, bluetooth, audio, etc.). Those ship with Omarchy; this repo only adds the custom plugins and the bar layout that references them.

## Requirements

- **Omarchy 4** (Quattro shell)
- **Hyprland** (for `looknfeel.lua` animations and window rules)
- **jq** and **bash** — used by `alpastx.quadrant` sampler scripts
- **NetworkManager** — `alpastx.network` Wi‑Fi panel
- **curl** (optional) — `alpastx.weather` forecast fetch
- Nerd Font icons in the bar (theme / Omarchy default)

## Quick install

```bash
cd ~/Desktop/alpastx-dotfiles   # or wherever you cloned this repo
chmod +x install.sh
./install.sh
```

The installer:

1. Backs up existing `~/.config/omarchy` (timestamped) if present
2. Symlinks `shell.json` and `hypr/looknfeel.lua` into `~/.config`
3. **Copies** plugin folders into `~/.config/omarchy/plugins/` (Omarchy rejects symlinks inside plugins)
4. Copies the `bluegirl` theme overlay
5. Runs `omarchy restart shell`

Set `ALPASTX_DOTFILES_COPY=1` before running to copy instead of symlink for `shell.json` and `looknfeel.lua`.

### Manual install

```bash
cp -a omarchy/shell.json ~/.config/omarchy/
cp -a omarchy/plugins/alpastx.* ~/.config/omarchy/plugins/
mkdir -p ~/.config/omarchy/themes/bluegirl
cp -a omarchy/themes/bluegirl/* ~/.config/omarchy/themes/bluegirl/
cp -a hypr/looknfeel.lua ~/.config/hypr/
omarchy restart shell
```

Apply the theme overlay if you use `bluegirl`:

```bash
omarchy theme set bluegirl
```

## Bar layout (`omarchy/shell.json`)

| Zone | Widgets |
|------|---------|
| **Left island** | `omarchy.menu`, `omarchy.workspaces`, `omarchy.clock`, keyboard layout, system update, **`alpastx.tray`** (last, inner edge toward center) |
| **Center island** | `alpastx.indicators` (recording, reminder, night light), **`alpastx.taskbar`** (focused), `alpastx.weather-status` (DND, stay awake + weather) |
| **Right island** | `alpastx.network`, `alpastx.ip`, `alpastx.quadrant`, stock audio/bluetooth/monitor/power, `alpastx.power-menu` |

Bar shell: `alpastx.custom-bar` (`centerAnchor`: `alpastx.taskbar`, transparent top bar).
Tray placement: `shell.json` lists `alpastx.tray` on the left section; `alpastx.custom-bar` pins the tray to the inner end of that island so the drawer opens toward the center.


## Plugins

| Plugin | Purpose |
|--------|---------|
| **alpastx.custom-bar** | Three rounded islands on a transparent strip; replaces stock bar chrome |
| **alpastx.taskbar** | Centered open-app icons with active-window highlight |
| **alpastx.indicators** | Manual state pills: screen recording, reminders, night light, dictation, DND, stay awake |
| **alpastx.weather-status** | DND + stay-awake grouped with weather in one center pill |
| **alpastx.weather** | Weather pill and detail popup (used by weather-status) |
| **alpastx.tray** | System tray; configured always expanded |
| **alpastx.network** | Wi‑Fi list, connection state, upload/download rates |
| **alpastx.ip** | Local IPv4 pill; click to copy (`ip.sh` bundled in plugin) |
| **alpastx.quadrant** | CPU / GPU / memory / disk segments with tabbed detail panel |
| **alpastx.power-menu** | Lock, logout, reboot, shutdown menu |

No Waybar scripts are required — `alpastx.ip` ships its own `ip.sh`; other plugins use Omarchy/QML and shell helpers.

## Theme overlay (`omarchy/themes/bluegirl/`)

- `shell.bar.toml` — bar colors, height, font scaling
- `shell.font.toml` — bar font settings
- `colors.toml` — palette overrides
- `icons.theme` — icon theme hint for the shell

## Hyprland (`hypr/looknfeel.lua`)

Session tweaks: gaps, blur, custom animation curves, workspace/window rules for special workspaces, and a Firefox float fix for extension popups.

## Credits

- **alpastx.custom-bar** — forked from [Island Bar](https://github.com/Alpastx/Omarchy-Custom-Bar) (Alpastx)
- **alpastx.quadrant** — adapted from [BVisagie/omarchy-quadrant](https://github.com/BVisagie/omarchy-quadrant); network segment stripped for this layout
- Other `alpastx.*` plugins — personal customizations for this bar

## Repository layout

```
alpastx-dotfiles/
├── README.md
├── install.sh
├── .gitignore
├── omarchy/
│   ├── shell.json
│   ├── plugins/
│   │   └── alpastx.*/
│   └── themes/
│       └── bluegirl/
└── hypr/
    └── looknfeel.lua
```

## Push to GitHub

```bash
cd ~/Desktop/alpastx-dotfiles
git init          # already done if you used this folder as shipped
git add .
git commit -m "Initial alpastx Omarchy bar dotfiles"
gh repo create alpastx-dotfiles --private --source=. --push
```

Adjust visibility and remote name as you prefer.
