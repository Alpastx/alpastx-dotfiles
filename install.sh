#!/usr/bin/env bash
# Deploy alpastx Omarchy bar dotfiles to ~/.config
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${HOME}/.config"
OMARCHY="${CONFIG}/omarchy"
HYPR="${CONFIG}/hypr"
TS="$(date +%Y%m%d%H%M%S)"

echo "==> alpastx-dotfiles install"
echo "    Source: ${SCRIPT_DIR}"
echo "    Target: ${CONFIG}"
echo

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    local backup="${path}.bak.${TS}"
    echo "    Backup: ${path} -> ${backup}"
    mv "$path" "$backup"
  fi
}

deploy_tree() {
  local src="$1"
  local dest="$2"
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src/" "$dest/"
  else
    cp -a "$src/." "$dest/"
  fi
}

link_or_copy() {
  local src="$1"
  local dest="$2"
  backup_if_exists "$dest"
  mkdir -p "$(dirname "$dest")"
  if [[ "${ALPASTX_DOTFILES_COPY:-}" == "1" ]]; then
    cp -a "$src" "$dest"
    echo "    Copied: ${dest}"
  else
    ln -sf "$src" "$dest"
    echo "    Symlinked: ${dest} -> ${src}"
  fi
}

# Backup existing omarchy config (plugins + shell.json + themes overlay)
if [[ -d "$OMARCHY" ]]; then
  backup_if_exists "$OMARCHY"
fi

echo "==> Deploying omarchy/"
mkdir -p "$OMARCHY"

# shell.json
link_or_copy "${SCRIPT_DIR}/omarchy/shell.json" "${OMARCHY}/shell.json"

# plugins (copy — Omarchy rejects symlinks inside plugin folders)
echo "==> Deploying plugins (copy)"
for plugin in "${SCRIPT_DIR}"/omarchy/plugins/alpastx.*; do
  [[ -d "$plugin" ]] || continue
  name="$(basename "$plugin")"
  dest="${OMARCHY}/plugins/${name}"
  backup_if_exists "$dest"
  mkdir -p "${OMARCHY}/plugins"
  deploy_tree "$plugin" "$dest"
  echo "    Plugin: ${name}"
done

# theme overlay
echo "==> Deploying theme overlay: bluegirl"
deploy_tree "${SCRIPT_DIR}/omarchy/themes/bluegirl" "${OMARCHY}/themes/bluegirl"
echo "    Theme: ${OMARCHY}/themes/bluegirl"

# Hyprland looknfeel
echo "==> Deploying hypr/looknfeel.lua"
link_or_copy "${SCRIPT_DIR}/hypr/looknfeel.lua" "${HYPR}/looknfeel.lua"

# Restart shell
echo "==> Restarting Omarchy shell"
if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell
else
  echo "    Warning: 'omarchy' not found — run 'omarchy restart shell' manually."
fi

echo
echo "Done. Backups use suffix .bak.${TS} if anything was replaced."
echo "Set ALPASTX_DOTFILES_COPY=1 to copy instead of symlink shell.json and looknfeel.lua."
