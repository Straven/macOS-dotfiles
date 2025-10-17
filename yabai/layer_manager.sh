#!/usr/bin/env bash

# Load app variables from shared configuration
source "$HOME/.config/yabai/apps.sh"

# File to store last focused non-transparent window ID
LAST_NON_TRANSPARENT="/tmp/yabai_last_non_transparent_window"

# Get focused window info
FOCUSED_ID="$YABAI_WINDOW_ID"
FOCUSED_APP=$(yabai -m query --windows --window "$FOCUSED_ID" 2>/dev/null | jq -r '.app')

# Check if app is in non-transparent list
is_non_transparent() {
  for app in "${NON_TRANSPARENT_APPS[@]}"; do
    [[ "$1" == "$app" ]] && return 0
  done
  return 1
}

# Check if app is in transparent list
is_transparent() {
  for app in "${TRANSPARENT_APPS[@]}"; do
    [[ "$1" == "$app" ]] && return 0
  done
  return 1
}

# Handle focus change
if is_non_transparent "$FOCUSED_APP"; then
  # Save as last non-transparent window
  echo "$FOCUSED_ID" >"$LAST_NON_TRANSPARENT"

  # Reset all windows to normal layer
  yabai -m query --windows --space | jq -r '.[].id' | while read -r wid; do
    yabai -m window "$wid" --layer normal 2>/dev/null
  done

elif is_transparent "$FOCUSED_APP"; then
  # Get last non-transparent window
  LAST_NON_TRANSPARENT_ID=$(cat "$LAST_NON_TRANSPARENT" 2>/dev/null)

  if [[ -n "$LAST_NON_TRANSPARENT_ID" ]] && yabai -m query --windows --window "$LAST_NON_TRANSPARENT_ID" &>/dev/null; then
    # Set last non-transparent to below
    yabai -m window "$LAST_NON_TRANSPARENT_ID" --layer below 2>/dev/null

    # Set current transparent to above
    yabai -m window "$FOCUSED_ID" --layer above 2>/dev/null
  fi
fi
