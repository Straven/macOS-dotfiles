#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ $MUTED == "true" ]]; then
  ICON=
  COLOR=$RED
elif [[ $VOLUME -gt 50 ]]; then
  ICON=
  COLOR=$GREEN
else
  ICON=
  COLOR=$YELLOW
fi

sketchybar --set "$NAME" icon="$ICON" \
  icon.color="$COLOR" \
  label="$VOLUME%"

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

#if [ "$SENDER" = "volume_change" ]; then
#  VOLUME="$INFO"
#
#  case "$VOLUME" in
#    [6-9][0-9]|100) ICON="󰕾"
#    ;;
#    [3-5][0-9]) ICON="󰖀"
#    ;;
#    [1-9]|[1-2][0-9]) ICON="󰕿"
#    ;;
#    *) ICON="󰖁"
#  esac
#
#  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
#fi
