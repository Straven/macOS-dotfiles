#!/usr/bin/env bash
# Idempotent space configuration: labels, per-space layouts, display assignments.
# Layout is 9 spaces on d1 + 1 space on d2 = 10 total when both displays are connected.
# When d2 is disconnected, the External label is skipped and a warning is printed.
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
# Kept as a single constant rather than a per-label associative array so the
# script works on stock macOS bash 3.2 (no `declare -A` support).
DEFAULT_LAYOUT="bsp"

# Detect how many spaces yabai actually sees. With one display, that's 9; with
# both connected, 10. We label whichever subset is present rather than aborting,
# so skhd/sketchybar still work in single-display mode.
ACTUAL_COUNT=$(yabai -m query --spaces 2>/dev/null | jq 'length' 2>/dev/null)
EXPECTED=${#SPACE_LABELS[@]}
if [[ -z "$ACTUAL_COUNT" || "$ACTUAL_COUNT" -eq 0 ]]; then
  echo "yabai/spaces.sh: ERROR - yabai returned no spaces. Is yabai running?" >&2
  exit 1
fi
if [[ "$ACTUAL_COUNT" -lt "$EXPECTED" ]]; then
  echo "yabai/spaces.sh: NOTE - found $ACTUAL_COUNT spaces, expected $EXPECTED (d2 likely disconnected). Labeling the $ACTUAL_COUNT present." >&2
elif [[ "$ACTUAL_COUNT" -gt "$EXPECTED" ]]; then
  echo "yabai/spaces.sh: WARNING - found $ACTUAL_COUNT spaces, expected $EXPECTED. Extra spaces will be left unlabeled." >&2
fi

APPLY_COUNT=$ACTUAL_COUNT
if [[ "$APPLY_COUNT" -gt "$EXPECTED" ]]; then
  APPLY_COUNT=$EXPECTED
fi

# Apply labels by index for whichever spaces exist.
for (( i=0; i<APPLY_COUNT; i++ )); do
  idx=$((i + 1))
  label="${SPACE_LABELS[$i]}"
  yabai -m space "$idx" --label "$label" 2>/dev/null || true
done

# Apply layouts by label, but only for labels that were actually assigned.
for (( i=0; i<APPLY_COUNT; i++ )); do
  label="${SPACE_LABELS[$i]}"
  yabai -m space "$label" --layout "$DEFAULT_LAYOUT" 2>/dev/null || true
done

echo "yabai/spaces.sh: applied labels + layouts (${APPLY_COUNT}/${EXPECTED} spaces)"
