#!/usr/bin/env bash
# Selective window opacity. Transparent apps fade inactive windows; everything
# else stays fully opaque.

non_transparent_apps="(Safari|Zen Browser|WhatsApp|Google Chrome|Microsoft Word|Microsoft Excel|Preview|Finder|Visual Studio Code|Spotify|Music|TV|Megogo|Notes|Microsoft PowerPoint)"
transparent_apps="(Ghostty|Obsidian|Zed|Claude|Monica|Firefox|VSCodium|Kitty|IntelliJ IDEA|cmux)"
opacity_value=0.75

focused_app=$(yabai -m query --windows --window 2>/dev/null | jq -r '.app // empty')
[[ -z "$focused_app" ]] && exit 0

if echo "$focused_app" | grep -qE "^${transparent_apps}$"; then
  yabai -m config active_window_opacity "$opacity_value"
  yabai -m config normal_window_opacity 0.00001
elif echo "$focused_app" | grep -qE "^${non_transparent_apps}$"; then
  yabai -m config active_window_opacity 1.0
  yabai -m config normal_window_opacity 1.0
else
  yabai -m config active_window_opacity 1.0
  yabai -m config normal_window_opacity 1.0
fi
