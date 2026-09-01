# Alpastx Custom Bar

[![Omarchy](https://img.shields.io/badge/Omarchy-Quattro-111111)](https://omarchy.org)
[![License: MIT](https://img.shields.io/github/license/Alpastx/Omarchy-Custom-Bar)](LICENSE)
[![kind: bar](https://img.shields.io/badge/kind-bar-5b5b5b)](https://omarchy.org/manual/shell-plugins)

Alpastx's custom [Omarchy](https://omarchy.org) bar (`kind: "bar"`): three rounded
islands (left, center, right) on a transparent strip. Widget layout, clicks, and
panels follow the stock bar behavior.

Plugin id: `alpastx.custom-bar`

## Fork & upstream

Forked from **[Island Bar](https://github.com/mscurtescu/omarchy-island-bar)** by
[Marius Scurtescu](https://github.com/mscurtescu) (`mscurtescu.island-bar`, MIT).
Island Bar is itself a fork of Omarchy's stock bar plugin at
`$OMARCHY_PATH/shell/plugins/bar/`.

### Customizations in this fork

- **Multi-pill left island** — menu, workspaces, status (clock / keyboard / update), and tray each get their own capsule
- **Multi-pill right island** — network, IP, quadrant, main modules, and power menu as separate capsules
- **Center anchor** — `centerAnchor` in `shell.json` keeps one module at the true bar center; siblings render as before/after pills
- **Tray pinning** — `alpastx.tray` / `omarchy.tray` pinned to the inner edge of its section so the drawer opens toward the center
- **Per-entry center pills** — each center layout entry gets its own island capsule

See `UPSTREAM.txt` for the Omarchy package version this copy started from.

## Install

```bash
omarchy plugin add https://github.com/Alpastx/Omarchy-Custom-Bar.git --enable
omarchy bar use alpastx.custom-bar
```

## Local copy (development)

Omarchy rejects symlinks in plugin folders, so copy (do not link):

```bash
rsync -a --delete --exclude '.git' --exclude '.gitignore' \
  ~/path/to/Omarchy-Custom-Bar/ \
  ~/.config/omarchy/plugins/alpastx.custom-bar/
omarchy plugin validate ~/.config/omarchy/plugins/alpastx.custom-bar
omarchy-shell shell rescanPlugins
omarchy bar use alpastx.custom-bar
```

Edit in the git repo, then rsync again. The shell reloads plugin files under
`~/.config/omarchy/plugins/` on save.

## Switch back

```bash
omarchy bar reset   # stock omarchy.bar
```

`omarchy plugin remove alpastx.custom-bar` removes the plugin directory and
restores the stock bar.

## Tracking upstream

After `omarchy update`, diff against upstream bar sources:

```bash
diff -u "$OMARCHY_PATH/shell/plugins/bar/Bar.qml" Bar.qml
diff -u "$OMARCHY_PATH/shell/plugins/bar/BarModel.js" BarModel.js
```

Also compare against [Island Bar](https://github.com/mscurtescu/omarchy-island-bar)
when merging upstream island-bar changes.

## License

MIT — Omarchy's bar (David Heinemeier Hansson), Island Bar (Marius Scurtescu),
and this fork (Alpastx). See [LICENSE](LICENSE).
