#!/usr/bin/env bash
# Idempotent space configuration: labels, per-space layouts, display assignments.
# Layout is 9 spaces on d1 + 1 space on d2 = 10 total.
# Assumes Mission Control already has the correct space count split per display.

set -u

# Workspace map: index → label (1-based, in Mission Control left-to-right order
# across BOTH displays — d1 first 9, d2 last 1).
SPACE_LABELS=(
  "General"   # 1   d1
  "Work"      # 2   d1
  "Terminal"  # 3   d1   (was "Ghostty")
  "Dev"       # 4   d1
  "Media"     # 5   d1
  "Obsidian"  # 6   d1
  "Claude"    # 7   d1
  "Game"      # 8   d1
  "Scratch"   # 9   d1
  "External"  # 10  d2
)

# All bsp; stack mode triggered cross-display drift on macOS Tahoe.
declare -A SPACE_LAYOUTS=(
  [General]="bsp"
  [Work]="bsp"
  [Terminal]="bsp"
  [Dev]="bsp"
  [Media]="bsp"
  [Obsidian]="bsp"
  [Claude]="bsp"
  [Game]="bsp"
  [Scratch]="bsp"
  [External]="bsp"
)

# Verify space count matches expected.
ACTUAL_COUNT=$(yabai -m query --spaces 2>/dev/null | jq 'length' 2>/dev/null)
EXPECTED=${#SPACE_LABELS[@]}
if [[ -z "$ACTUAL_COUNT" ]] || [[ "$ACTUAL_COUNT" -lt "$EXPECTED" ]]; then
  echo "yabai/spaces.sh: WARNING - found ${ACTUAL_COUNT:-0} spaces, expected $EXPECTED. Adjust in Mission Control." >&2
  exit 1
fi

# Apply labels by index.
for i in "${!SPACE_LABELS[@]}"; do
  idx=$((i + 1))
  label="${SPACE_LABELS[$i]}"
  yabai -m space "$idx" --label "$label" 2>/dev/null || true
done

# Apply layouts by label.
for label in "${SPACE_LABELS[@]}"; do
  layout="${SPACE_LAYOUTS[$label]}"
  yabai -m space "$label" --layout "$layout" 2>/dev/null || true
done

echo "yabai/spaces.sh: applied labels + layouts (${EXPECTED} spaces)"
