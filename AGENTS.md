# Agent instructions — alpastx Omarchy dotfiles

Give this file to an AI assistant (Cursor, Claude Code, Codex, etc.) when installing or changing this setup on an Omarchy Linux machine.

This repo is **end-user Omarchy customization**, not Omarchy source. It adds an island status bar, `alpastx.*` plugins, a `bluegirl` theme overlay, HackBench branding, and a few Hyprland overrides.

## First steps

1. Confirm the machine runs **Omarchy 4 (Quattro)** with Hyprland: `omarchy version`.
2. Read `README.md` and `install.sh` before touching files.
3. Prefer `./install.sh` from the repo root over hand-copying, unless the user already has a carefully customized `~/.config/omarchy` they do not want moved.

`install.sh` **renames the entire** `~/.config/omarchy` directory to a timestamped backup, then deploys this repo. Warn the user before running it if they have other Omarchy config they care about.

## Hard rules

- **Never edit** `/usr/share/omarchy/` or other package-owned files. Updates overwrite them.
- **Never replace** all of `/boot/limine.conf`. Only merge the themed header from `limine/limine.conf.header` above the auto-generated `/+Omarchy` entries.
- **Never symlink** plugin directories. Omarchy rejects plugin trees that contain symlinks. Copy `omarchy/plugins/alpastx.*` into `~/.config/omarchy/plugins/`.
- Edit only:
  - this repo
  - `~/.config/omarchy/`
  - `~/.config/hypr/`
- For stock Omarchy widgets (`omarchy.clock`, `omarchy.workspaces`, …), clone with `omarchy plugin clone <id>` instead of editing packaged copies.
- Do not commit secrets (`.env`, keys, `~/.config` dumps that include credentials).
- Do not force-push, skip git hooks, or rewrite git config unless the user asks.

## Layout

```
omarchy/shell.json              Bar layout (islands, widget order)
omarchy/plugins/alpastx.*/      Custom Quickshell plugins (copy, do not symlink)
omarchy/themes/bluegirl/        Theme overlay (colors, bar, fonts, icons)
omarchy/branding/               Screensaver / About ASCII + Plymouth PNG
omarchy/hooks/theme-set.d/      gtk-arc-blackest (keeps GTK theme after theme set)
hypr/looknfeel.lua              Gaps, blur, animations, window rules
hypr/bindings.lua               Extra keybinds
hypr/input.lua                  Touchpad workspace swipe
limine/limine.conf.header       Boot menu title + Bluegirl / AMOLED colors
install.sh                      Deploy to ~/.config
```

Live config lives in `~/.config/omarchy` and `~/.config/hypr`. After install, `shell.json` and the Hyprland lua files are **symlinked** back to this repo unless `ALPASTX_DOTFILES_COPY=1`.

## Commands

```bash
./install.sh                              # deploy (backs up ~/.config/omarchy)
ALPASTX_DOTFILES_COPY=1 ./install.sh      # copy instead of symlink lua/json
omarchy restart shell                     # reload bar / plugins
omarchy theme set bluegirl                # apply overlay colors
omarchy theme current
omarchy bar --help
omarchy plugin clone omarchy.workspaces   # customize a stock widget
```

`shell.json` and files under `~/.config/omarchy/plugins/` hot-reload on save. If a plugin change does not appear: `omarchy-shell shell rescanPlugins` or `omarchy restart shell`.

After Hyprland lua edits: `hyprctl reload` then `hyprctl configerrors`.

Privileged work: `sudo` in a terminal. Use `pkexec` only when there is no TTY. Do not wrap commands that already call `sudo` themselves (`omarchy plymouth set` does).

## Branding and boot

Screensaver / About: `~/.config/omarchy/branding/screensaver.txt` and `about.txt`.

HackBench wordmark source: `omarchy/branding/hackbench` (ASCII). Rendered splash: `omarchy/branding/hackbench-plymouth.png`.

Plymouth disk-unlock + SDDM login (rebuilds initramfs):

```bash
omarchy plymouth set '#000000' '#cdd6f4' ~/.config/omarchy/branding/hackbench-plymouth.png
```

Run that as the user, not as root. Logo must be a regular PNG, not a symlink.

Limine: merge `limine/limine.conf.header` into `/boot/limine.conf`. Keep existing boot entries. `omarchy refresh limine` restores the stock Tokyo Night header and would wipe HackBench colors.

## Typical user requests

| Ask | Do |
|-----|----|
| Install this bar | `./install.sh`, then `omarchy theme set bluegirl` if they want that palette |
| Move a widget | Edit `omarchy/shell.json` or `omarchy bar move …` |
| Restyle the bar | Overlay files in `omarchy/themes/bluegirl/` (especially `shell.bar.toml`, `colors.toml`) |
| Change screensaver text | Edit `omarchy/branding/screensaver.txt` |
| Change boot title / colors | Edit `limine/limine.conf.header` and merge into `/boot/limine.conf` |
| Change unlock splash | New PNG → `omarchy plymouth set '#000000' '#cdd6f4' <png>` |
| Customize a stock widget | `omarchy plugin clone …`, then edit the clone under `~/.config/omarchy/plugins/` |
| Reset bar to Omarchy default | `omarchy refresh shell` (destroys this layout until reinstall) |

## Do not

- Put custom plugins under `/usr/share/omarchy/shell/plugins/`
- Edit `/usr/share/omarchy/themes/` — overlay in `~/.config/omarchy/themes/bluegirl/` instead
- Run `omarchy refresh limine` or `omarchy plymouth reset` unless the user wants stock Omarchy branding back
- Assume Waybar is in use — this bar is Omarchy shell / Quickshell
