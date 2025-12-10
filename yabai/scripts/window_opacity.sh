#!/bin/bash

# Define apps
transparent_apps="^(Ghostty|Obsidian|Zed|Claude|Monica|Firefox|VSCodium)$"
opacity_value=0.75

# Get focused window app name
focused_app=$(yabai -m query --windows --window | jq -r '.app')

# Check if app is in transparent list
if echo "$focused_app" | grep -qE "$transparent_apps"; then
  # Transparent app focused
  yabai -m config active_window_opacity "$opacity_value"
  yabai -m config normal_window_opacity 0.00001
else
  # Non-transparent app focused
  yabai -m config active_window_opacity 1.0
  yabai -m config normal_window_opacity 1.0
fi
