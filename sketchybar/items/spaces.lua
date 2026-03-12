local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspace_names = {
  "General", "Work", "Dev", "Media", "Game",
  "Ghostty", "Zed", "Obsidian", "Claude", "External", "Zen"
}

local popup_width = 160
local current_workspace = ""

sbar.add("event", "aerospace_workspace_change")

-- ── Single workspace pill ─────────────────────────────────────

local space_display = sbar.add("item", "space.display", {
  icon = {
    font = { family = settings.font.numbers },
    string = "…",
    padding_left = 12,
    padding_right = 6,
    color = colors.flash,
  },
  label = {
    padding_right = 12,
    color = colors.grey,
    font = "sketchybar-app-font:Regular:16.0",
    y_offset = -1,
    string = "",
  },
  padding_right = 1,
  padding_left = 1,
  background = {
    color = colors.bg1,
    border_width = 1,
    height = 26,
    border_color = colors.flash,
  },
  popup = { align = "center" },
})

local space_bracket = sbar.add("bracket", { space_display.name }, {
  background = {
    color = colors.transparent,
    border_color = colors.purple,
    height = 28,
    border_width = 2,
  }
})

sbar.add("item", "space.padding.display", {
  width = settings.group_paddings,
})

-- ── App icons for current workspace ──────────────────────────

local function update_app_icons(name)
  sbar.exec("aerospace list-windows --workspace " .. name .. " --json 2>/dev/null", function(result)
    local icon_line = ""
    local no_app = true
    for app_name in result:gmatch('"app%-name"%s*:%s*"([^"]+)"') do
      no_app = false
      local lookup = app_icons[app_name]
      icon_line = icon_line .. (lookup or app_icons["Default"] or "")
    end
    sbar.animate("tanh", 10, function()
      space_display:set({ label = { string = no_app and "" or icon_line } })
    end)
  end)
end

-- ── Popup workspace items ─────────────────────────────────────

local popup_items = {}

for _, name in ipairs(workspace_names) do
  local item = sbar.add("item", "space.popup." .. name, {
    position = "popup." .. space_display.name,
    width = popup_width,
    align = "center",
    icon = { drawing = false },
    label = {
      string = name,
      color = colors.white,
      font = {
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"],
        size = 13.0,
      },
    },
    background = {
      color = colors.bg1,
      corner_radius = 6,
      height = 28,
    },
    padding_left = 4,
    padding_right = 4,
  })

  item:subscribe("mouse.clicked", function()
    space_display:set({ popup = { drawing = false } })
    sbar.exec("aerospace workspace " .. name)
  end)

  popup_items[name] = item
end

-- ── Highlight active workspace in popup ───────────────────────

local function highlight_popup(focused)
  for name, item in pairs(popup_items) do
    local active = (name == focused)
    item:set({
      label = { color = active and colors.flash or colors.white },
      background = { color = active and colors.bg2 or colors.bg1 },
    })
  end
end

-- ── Update pill label and popup highlight ────────────────────

local function update(focused)
  current_workspace = focused
  space_display:set({ icon = { string = focused } })
  highlight_popup(focused)
  update_app_icons(focused)
end

-- ── AeroSpace workspace change event ─────────────────────────

space_display:subscribe("aerospace_workspace_change", function(env)
  update(env.FOCUSED_WORKSPACE)
end)

-- ── Toggle popup ──────────────────────────────────────────────

space_display:subscribe("mouse.clicked", function()
  local showing = space_display:query().popup.drawing == "on"
  if showing then
    space_display:set({ popup = { drawing = false } })
  else
    highlight_popup(current_workspace)
    space_display:set({ popup = { drawing = true } })
  end
end)

space_display:subscribe("mouse.exited.global", function()
  space_display:set({ popup = { drawing = false } })
end)

-- ── Startup: set initial state ────────────────────────────────

sbar.exec("aerospace list-workspaces --focused", function(result)
  local focused = result:gsub("%s+", "")
  update(focused)
end)

-- ── Spaces indicator (menu swap toggle) ───────────────────────

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = { string = currently_on and icons.switch.off or icons.switch.on }
  })
end)

spaces_indicator:subscribe("mouse.entered", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")
end)
