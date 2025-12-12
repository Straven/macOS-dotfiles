#!/bin/bash

# ============================================================================
# Smart Window Opacity Toggle
# Toggles between current opacity and 100% (opaque)
# Remembers the previous opacity value
# ============================================================================

STATE_FILE="/tmp/yabai_opacity_state_$(yabai -m query --windows --window | jq -r '.id')"

# Get current window opacity
current_opacity=$(yabai -m query --windows --window | jq -r '.opacity')

# Convert to percentage for display
current_percent=$(printf "%.0f" "$(awk "BEGIN {print $current_opacity * 100}")")

case "$1" in
toggle)
  # Check if we're at 100%
  if [ "$(awk "BEGIN {print ($current_opacity >= 0.99)}")" -eq 1 ]; then
    # Currently opaque, restore previous opacity
    if [ -f "$STATE_FILE" ]; then
      previous_opacity=$(cat "$STATE_FILE")
      yabai -m window --opacity "$previous_opacity"
      previous_percent=$(printf "%.0f" "$(awk "BEGIN {print $previous_opacity * 100}")")
      osascript -e "display notification \"Restored: ${previous_percent}%\" with title \"Window Opacity\""
    else
      # No previous state, use default 75%
      yabai -m window --opacity 0.75
      osascript -e 'display notification "Window opacity: 75%" with title "Window Opacity"'
    fi
  else
    # Currently transparent, save current and make opaque
    echo "$current_opacity" >"$STATE_FILE"
    yabai -m window --opacity 1.0
    osascript -e "display notification \"Saved ${current_percent}% → 100%\" with title \"Window Opacity\""
  fi
  ;;

increase)
  # Increase opacity by 10%
  new_opacity=$(awk "BEGIN {print $current_opacity + 0.1}")
  if [ "$(awk "BEGIN {print ($new_opacity > 1.0)}")" -eq 1 ]; then
    new_opacity=1.0
  fi
  yabai -m window --opacity "$new_opacity"
  new_percent=$(printf "%.0f" "$(awk "BEGIN {print $new_opacity * 100}")")
  osascript -e "display notification \"${new_percent}%\" with title \"Window Opacity\""
  ;;

decrease)
  # Decrease opacity by 10%
  new_opacity=$(awk "BEGIN {print $current_opacity - 0.1}")
  if [ "$(awk "BEGIN {print ($new_opacity < 0.5)}")" -eq 1 ]; then
    new_opacity=0.5
  fi
  yabai -m window --opacity "$new_opacity"
  new_percent=$(printf "%.0f" "$(awk "BEGIN {print $new_opacity * 100}")")
  osascript -e "display notification \"${new_percent}%\" with title \"Window Opacity\""
  ;;

*)
  echo "Usage: $0 [toggle|increase|decrease]"
  exit 1
  ;;
esac
