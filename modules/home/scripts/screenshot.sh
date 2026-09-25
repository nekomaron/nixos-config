#!/usr/bin/env bash
set -euo pipefail

MODE="$1"
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILE="$SAVE_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

case "$MODE" in
  full)
    grim "$FILE"
    ;;
  region)
    GEOM=$(slurp) || exit 0
    grim -g "$GEOM" "$FILE"
    ;;
  *)
    echo "Usage: screenshot.sh [full|region]" >&2
    exit 1
    ;;
esac

wl-copy < "$FILE"
notify-send "Screenshot" "$(basename "$FILE") を保存しました．(clipboard&LocaleDisk)" \
  --icon="$FILE"
