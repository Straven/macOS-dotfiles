#!/bin/bash

app_name="$1"
bundle_id="$2"

# Function to check if app is running
is_app_running() {
  pgrep -f "$app_name" >/dev/null
}

# Function to focus app window
focus_app() {
  local window_id
  window_id=$(yabai -m query --windows | jq -r ".[] |
    select(.app==\"$app_name\") | .id" | head -1)

  if [[ -n "$window_id" && "$window_id" != "null" ]]; then
    yabai -m window --focus "$window_id"
    return 0
  else
    osascript -e "tell application \"$app_name\" to activate" 2>/dev/null
    return $?
  fi
}

# Function to launch app
launch_app() {
  if [[ -n "$bundle_id" ]]; then
    open -b "$bundle_id"
  else
    open -a "$app_name"
  fi
}

# Main logic
if is_app_running; then
  if ! focus_app; then
    # Focus failed, try activating
    osascript -e "tell application \"$app_name\" to activate"
  fi
else
  launch_app
fi
