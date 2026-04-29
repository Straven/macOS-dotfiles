#!/usr/bin/env bash
# Idempotent space configuration: labels, per-space layouts, display assignments.
# Re-runnable: safe to invoke from yabairc or on hyper-r reload.

set -u

# Workspace map: index → label (1-based)
SPACE_LABELS=(
  "General"      # 1
  "Work"         # 2
  "Dev"          # 3
  "Media"        # 4
  "Game"         # 5
  "Ghostty"      # 6
  "Kitty"        # 7
  "Zed"          # 8
  "IntellijIDEA" # 9
  "Obsidian"     # 10
  "Claude"       # 11
  "External"     # 12
  "Zen"          # 13
  "Scratch1"     # 14
  "Scratch2"     # 15
)

# Layout per label
declare -A SPACE_LAYOUTS=(
  [General]="bsp"
  [Work]="bsp"
  [Dev]="bsp"
  [Media]="bsp"
  [Game]="stack"
  [Ghostty]="stack"
  [Kitty]="stack"
  [Zed]="stack"
  [IntellijIDEA]="stack"
  [Obsidian]="stack"
  [Claude]="stack"
  [External]="bsp"
  [Zen]="bsp"
  [Scratch1]="bsp"
  [Scratch2]="bsp"
)

# Spaces that prefer display 2 if available, else display 1
DISPLAY_2_TARGETS=("External" "Zen")

# Verify space count matches expected
ACTUAL_COUNT=$(yabai -m query --spaces 2>/dev/null | jq 'length' 2>/dev/null)
EXPECTED=${#SPACE_LABELS[@]}
if [[ -z "$ACTUAL_COUNT" ]] || [[ "$ACTUAL_COUNT" -lt "$EXPECTED" ]]; then
  echo "yabai/spaces.sh: WARNING - found ${ACTUAL_COUNT:-0} spaces, expected $EXPECTED. Create the missing spaces in Mission Control." >&2
  exit 1
fi

# Apply labels by index
for i in "${!SPACE_LABELS[@]}"; do
  idx=$((i + 1))
  label="${SPACE_LABELS[$i]}"
  yabai -m space "$idx" --label "$label" 2>/dev/null || true
done

# Apply layouts by label
for label in "${SPACE_LABELS[@]}"; do
  layout="${SPACE_LAYOUTS[$label]}"
  yabai -m space "$label" --layout "$layout" 2>/dev/null || true
done

# Assign display 2 targets (with fallback to display 1)
DISPLAY_COUNT=$(yabai -m query --displays 2>/dev/null | jq 'length' 2>/dev/null)
TARGET_DISPLAY=1
if [[ "${DISPLAY_COUNT:-1}" -ge 2 ]]; then
  TARGET_DISPLAY=2
fi

for label in "${DISPLAY_2_TARGETS[@]}"; do
  yabai -m space "$label" --display "$TARGET_DISPLAY" 2>/dev/null || true
done

echo "yabai/spaces.sh: applied labels + layouts (${EXPECTED} spaces, display target=${TARGET_DISPLAY} for ${DISPLAY_2_TARGETS[*]})"
