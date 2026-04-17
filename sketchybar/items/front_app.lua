local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    font = "sketchybar-app-font:Regular:16.0",
    string = "",
    color = colors.white,
    padding_left = 4,
    padding_right = 4,
    y_offset = -1,
  },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  local lookup = app_icons[env.INFO] or app_icons["Default"] or ":default:"
  front_app:set({
    icon = { string = lookup },
    label = { string = env.INFO },
  })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

sbar.exec(
  "osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'",
  function(app_result)
    local app_name = app_result:gsub("%s+$", "")
    local lookup = app_icons[app_name] or app_icons["Default"] or ":default:"
    front_app:set({
      icon = { string = lookup },
      label = { string = app_name },
    })
  end
)
