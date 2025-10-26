#!/bin/bash

# Get current keyboard layout
LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | awk -F'"' '{print $4}')

# Or use this alternative for input source:
# LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID | sed 's/.*\.//')

sketchybar --set $NAME label="$LAYOUT"
