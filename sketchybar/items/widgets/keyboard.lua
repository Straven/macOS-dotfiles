local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

--- Layout map: input source ID suffix -> display label
local layout_map = {
    ["ABC"] = "ABC",
    ["Ukrainian-PC"] = "UA",
    ["Russian"] = "RU",
}

--- Switch map: display label → menu item name as it appears in the input source menu
local switch_map = {
  ["ABC"] = "com.apple.keylayout.ABC",
  ["UA"]  = "com.apple.keylayout.Ukrainian-PC",
  ["RU"]  = "com.apple.keylayout.Russian",
}

--- Order for popup list
local layout_order = { "ABC", "UA", "RU" }

local popup_width = 180

-- ── Main item ────────────────────────────────────────────────
local keyboard = sbar.add("item", "widgets.keyboard", {
    position = "right",
    icon = {
        string = "󰌌",
        font = {
            style = settings.font.style_map["Regular"],
            size = 16.0,
        },
        padding_left = 9,
        padding_right = 0,
        color = colors.purple,
    },
    label = {
        font = { family = settings.font.numbers },
        color = colors.purple,
        padding_right = 5,
    },
    padding_left = 0,
    padding_right = 5,
    update_freq = 2,
    popup = { align = "center" },
})

sbar.add("bracket", "widgets.keyboard.bracket", { keyboard.name }, {
    background = { color = colors.bg1, border_color = colors.purple },
})

sbar.add("item", { position = "right", width = 6 })

-- ── Helpers ──────────────────────────────────────────────────

local function get_current_layout(callback)
  sbar.exec(
    "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID | sed 's/.*\\.//'",
    function(raw)
      local clean = raw:gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")
      callback(clean)
    end
  )
end

local function update_label()
  get_current_layout(function(clean)
    local display = layout_map[clean] or clean:sub(1, 3):upper()
    keyboard:set({ label = { string = display } })
  end)
end

keyboard:subscribe({ "routine", "forced", "system_woke" }, update_label)

-- ── Popup: layout items ──────────────────────────────────────

local layout_items = {}

for _, display in ipairs(layout_order) do
  local menu_name = switch_map[display]

  local item = sbar.add("item", "keyboard.layout." .. display, {
    position = "popup." .. keyboard.name,
    width = popup_width,
    align = "center",
    icon = { drawing = false },
    label = {
      string = display,
      color = colors.white,
      font = {
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"],
        size = 14.0,
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
    sbar.exec("macism " .. menu_name, function()
        keyboard:set({ popup = { drawing = false } })
        sbar.delay(0.3, update_label)
      end
    )
  end)

  layout_items[display] = item
end

-- ── Popup: separator ─────────────────────────────────────────

sbar.add("item", "keyboard.popup.sep", {
  position = "popup." .. keyboard.name,
  width = popup_width,
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    height = 1,
  },
  padding_top = 3,
  padding_bottom = 3,
})

-- ── Popup: settings button ───────────────────────────────────

local settings_btn = sbar.add("item", "keyboard.popup.settings", {
  position = "popup." .. keyboard.name,
  width = popup_width,
  align = "center",
  icon = {
    string = icons.gear,
    color = colors.grey,
    padding_right = 6,
  },
  label = {
    string = "Input Methods",
    color = colors.grey,
  },
  padding_left = 4,
  padding_right = 4,
})

settings_btn:subscribe("mouse.clicked", function()
  keyboard:set({ popup = { drawing = false } })
  sbar.exec("open 'x-apple.systempreferences:com.apple.Keyboard-Settings.extension?InputSources'")
end)

-- ── Popup highlight: current active layout ───────────────────

local function highlight_current()
  get_current_layout(function(clean)
    local current = layout_map[clean] or clean:sub(1, 3):upper()
    for display, item in pairs(layout_items) do
      local active = (display == current)
      item:set({
        label = { color = active and colors.flash or colors.white },
        background = { color = active and colors.bg2 or colors.bg1 },
      })
    end
  end)
end

-- ── Toggle popup ─────────────────────────────────────────────

keyboard:subscribe("mouse.clicked", function()
  local showing = keyboard:query().popup.drawing == "on"
  if showing then
    keyboard:set({ popup = { drawing = false } })
  else
    highlight_current()
    keyboard:set({ popup = { drawing = true } })
  end
end)

keyboard:subscribe("mouse.exited.global", function()
  keyboard:set({ popup = { drawing = false } })
end)
