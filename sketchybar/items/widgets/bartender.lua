local colors = require("colors")
local settings = require("settings")

local bartender = sbar.add("item", "widgets.bartender", {
  position = "right",
  icon = {
    string = "􀞫",
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 16.0,
    },
    color = colors.flash,
    padding_left = 9,
    padding_right = 0,
  },
  label = { drawing = false },
  padding_left = 0,
  padding_right = 5,
})

sbar.add("bracket", "widgets.bartender.bracket", { bartender.name }, {
  background = { color = colors.bg1, border_color = colors.flash },
})

sbar.add("item", "widgets.bartender.padding", {
  position = "right",
  width = 6,
})

-- Bartender 6 Setapp's AppleScript suite is declared but its handlers are not
-- wired up (returns -1717 for every Bartender Suite verb), so we drive it via
-- the global hotkey the user configured in Bartender Settings + macOS focus.
bartender:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec(
      [[open -b com.surteesstudios.Bartender-setapp; ]] ..
      [[sleep 0.15; ]] ..
      [[osascript -e 'tell application "System Events" to keystroke "," using command down']]
    )
  else
    sbar.exec(
      [[osascript -e 'tell application "System Events" to keystroke "b" using {command down, shift down}']]
    )
  end
end)
