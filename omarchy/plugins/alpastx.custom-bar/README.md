# Alpastx Custom Bar

[![Omarchy](https://img.shields.io/badge/Omarchy-Quattro-111111)](https://omarchy.org)
[![License: MIT](https://img.shields.io/github/license/Alpastx/Omarchy-Custom-Bar)](LICENSE)
[![kind: bar](https://img.shields.io/badge/kind-bar-5b5b5b)](https://omarchy.org/manual/shell-plugins)

Alpastx's custom [Omarchy](https://omarchy.org) bar (`kind: "bar"`): three rounded
islands (left, center, right) on a transparent strip. Widget layout, clicks, and
panels follow the stock bar behavior.

Plugin id: `alpastx.custom-bar`

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

## Upstream

Forked from [mscurtescu/omarchy-island-bar](https://github.com/mscurtescu/omarchy-island-bar).
The bar engine is based on Omarchy's first-party plugin at
`$OMARCHY_PATH/shell/plugins/bar/`. See `UPSTREAM.txt` for the Omarchy package
this copy started from.

After `omarchy update`, diff against upstream bar sources:

```bash
diff -u "$OMARCHY_PATH/shell/plugins/bar/Bar.qml" Bar.qml
diff -u "$OMARCHY_PATH/shell/plugins/bar/BarModel.js" BarModel.js
```

## License

MIT — Omarchy's bar (David Heinemeier Hansson) plus this overlay.
