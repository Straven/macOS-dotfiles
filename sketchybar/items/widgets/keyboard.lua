local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Keyboard layout mapping
local layout_map = {
	["ABC"] = "ABC",
	-- ["U.S."] = "EN",
	["Ukrainian-PC"] = "UA",
	["Russian"] = "RU",
	-- Add more mappings here as needed
}

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
		color = colors.tn_green,
	},
	label = {
		font = { family = settings.font.numbers },
		color = colors.tn_green,
		padding_right = 5,
	},
	padding_left = 0,
	padding_right = 5,
	update_freq = 2,
})

keyboard:subscribe({ "routine", "forced", "system_woke" }, function()
	sbar.exec(
		"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID | sed 's/.*\\.//'",
		function(layout)
		    local clean_layout = layout:gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")
			-- If available use mapping, otherwise - first 3 characters
			local display_layout = layout_map[clean_layout] or clean_layout:sub(1, 3):upper()
			keyboard:set({ label = { string = display_layout } })
		end
	)
end)

sbar.add("bracket", "widgets.keyboard.bracket", { keyboard.name }, {
	background = { color = colors.tn_black3, border_color = colors.tn_green },
})

-- Add padding
sbar.add("item", {
	position = "right",
	width = 6,
})
