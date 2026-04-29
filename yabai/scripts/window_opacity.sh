#!/usr/bin/env bash
# Per-window opacity: when a "transparent" app is focused, fade other windows
# on the SAME space. Windows on other spaces/displays stay at 1.0 — keeps
# d2 (External) fully visible regardless of d1 focus.

transparent_apps_regex='^(Ghostty|Obsidian|Zed|Claude|Monica|Firefox|VSCodium|Kitty|IntelliJ IDEA|cmux)$'
focused_opacity=0.75
faded_opacity=0.00001
normal_opacity=1.0

focused=$(yabai -m query --windows --window 2>/dev/null)
[[ -z "$focused" ]] && exit 0

focused_id=$(echo "$focused" | jq -r '.id // empty')
focused_app=$(echo "$focused" | jq -r '.app // empty')
focused_space=$(echo "$focused" | jq -r '.space // empty')
[[ -z "$focused_id" ]] && exit 0

if [[ "$focused_app" =~ $transparent_apps_regex ]]; then
  is_transparent=1
else
  is_transparent=0
fi

yabai -m query --windows 2>/dev/null | jq -r '.[] | "\(.id) \(.space)"' | while read -r id space; do
  if [[ "$is_transparent" -eq 1 && "$space" == "$focused_space" ]]; then
    if [[ "$id" == "$focused_id" ]]; then
      yabai -m window "$id" --opacity "$focused_opacity" 2>/dev/null
    else
      yabai -m window "$id" --opacity "$faded_opacity" 2>/dev/null
    fi
  else
    yabai -m window "$id" --opacity "$normal_opacity" 2>/dev/null
  fi
done
