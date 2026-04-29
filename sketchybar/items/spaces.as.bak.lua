local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspace_names = {
	"General",
	"Work",
	"Dev",
	"Media",
	"Game",
	"Ghostty",
	"Zed",
	"Obsidian",
	"Claude",
	"External",
	"Zen",
}

local workspace_icons = {
	General = "􀎞", -- house
	Work = "􀈮", -- briefcase.fill
	Dev = "􀙚", -- chevron.left.forwardslash.chevron.right
	Media = "􀊖", -- play.rectangle
	Game = "􀛸", -- gamecontroller
	Ghostty = "􀪏", -- terminal
	Zed = "􀤸", -- curlybraces
	Obsidian = "􀈕", -- doc.text.fill
	Claude = "􀌪", -- bubble.left
	External = "􀢹", -- display
	Zen = "􀎬", -- globe
}

local popup_width = 200
local current_workspace = ""
local current_front_app = ""

sbar.add("event", "aerospace_workspace_change")

-- ── Single workspace pill ─────────────────────────────────────

local space_display = sbar.add("item", "space.display", {
	icon = {
		font = { family = settings.font.numbers },
		string = "…",
		padding_left = 12,
		padding_right = 12,
		color = colors.flash,
	},
	label = { drawing = false },
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
	},
})

-- --- App items for current workspace ------------------------------

local MAX_APP_ITEMS = 20
local app_item_pool = {}

for i = 1, MAX_APP_ITEMS do
	local item = sbar.add("item", "space.app." .. i, {
		icon = {
			font = "sketchybar-app-font:Regular:16.0",
			string = "",
			color = colors.grey,
			padding_left = 4,
			padding_right = 4,
			y_offset = -1,
		},
		label = { drawing = false },
		background = { drawing = false },
		padding_left = 1,
		padding_right = 1,
		drawing = false,
	})

	app_item_pool[i] = { item = item, window_id = nil, app_name = nil }

	item:subscribe("mouse.clicked", function()
		local wid = app_item_pool[i].window_id
		if wid then
			sbar.exec("aerospace focus --window-id " .. wid)
		end
	end)
end

sbar.add("item", "space.padding.display", {
	width = settings.group_paddings,
})

-- ── Highlight focused app in app items ──────────────────────────

local function highlight_front_app(front_app)
	for i = 1, MAX_APP_ITEMS do
		local entry = app_item_pool[i]
		if entry.app_name then
			local is_focused = (entry.app_name == front_app)
			entry.item:set({
				icon = { color = is_focused and colors.flash or colors.grey },
			})
		end
	end
end

-- --- Update app items for workspace -------------------------------

local function update_app_icons(name)
	sbar.exec("aerospace list-windows --workspace " .. name .. " --json 2>/dev/null", function(result)
		-- sbar.exec with --json returns a parsed Lua table, not a string
		local windows = {}
		if type(result) == "table" then
			for _, win in ipairs(result) do
				local wid = win["window-id"]
				local app = win["app-name"]
				if wid and app then
					table.insert(windows, { id = tostring(wid), app = app })
				end
			end
		end

		sbar.animate("tanh", 10, function()
			for i = 1, MAX_APP_ITEMS do
				local w = windows[i]
				if w then
					local lookup = app_icons[w.app] or app_icons["Default"] or ":default:"
					local is_focused = (w.app == current_front_app)
					app_item_pool[i].window_id = w.id
					app_item_pool[i].app_name = w.app
					app_item_pool[i].item:set({
						drawing = true,
						icon = { string = lookup, color = is_focused and colors.flash or colors.grey },
					})
				else
					app_item_pool[i].item:set({ drawing = false })
					app_item_pool[i].window_id = nil
					app_item_pool[i].app_name = nil
				end
			end
		end)
	end)
end

-- ── Popup workspace items ─────────────────────────────────────

local popup_items = {}

for _, name in ipairs(workspace_names) do
	local ws_icon = workspace_icons[name] or ""
	local item = sbar.add("item", "space.popup." .. name, {
		position = "popup." .. space_display.name,
		width = popup_width,
		align = "center",
		icon = {
			string = ws_icon,
			color = colors.white,
			font = {
				family = settings.font.numbers,
				size = 14.0,
			},
			padding_left = 8,
			padding_right = 4,
		},
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
			icon = { color = active and colors.flash or colors.grey },
			label = { color = active and colors.flash or colors.white },
			background = { color = active and colors.bg2 or colors.bg1 },
		})
	end
end

-- ── Update pill label highlights ────────────────────

local function update(focused)
	current_workspace = focused
	local ws_icon = workspace_icons[focused] or ""
	local display_text = ws_icon ~= "" and (ws_icon .. "" .. focused) or focused
	space_display:set({ icon = { string = display_text } })
	highlight_popup(focused)
	update_app_icons(focused)
end

-- ── AeroSpace workspace change event ─────────────────────────

space_display:subscribe("aerospace_workspace_change", function(env)
	update(env.FOCUSED_WORKSPACE)
end)

-- ── Front app change — update app item highlights ────────────

space_display:subscribe("front_app_switched", function(env)
	current_front_app = env.INFO
	highlight_front_app(current_front_app)
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
	sbar.exec(
		"osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'",
		function(app_result)
			current_front_app = app_result:gsub("%s+$", "")
			update(focused)
		end
	)
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
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = { string = currently_on and icons.switch.off or icons.switch.on },
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
			label = { width = "dynamic" },
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
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
	sbar.trigger("swap_menus_and_spaces")
end)
