local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Poll memory via vm_stat + sysctl. No external binary needed.
-- Calculates: (wired + active + compressor_occupied) * page_size / total_ram * 100
local MEM_CMD = "vm_stat | awk "
  .. "-v total=$(sysctl -n hw.memsize) "
  .. "-v psize=$(sysctl -n hw.pagesize) "
  .. "'/^Pages wired down:/{gsub(/\\./,\"\");w=$NF+0}"
  .. "/^Pages active:/{gsub(/\\./,\"\");a=$NF+0}"
  .. "/^Pages occupied by compressor:/{gsub(/\\./,\"\");c=$NF+0}"
  .. "END{printf \"%d\",int((w+a+c)*psize/total*100)}'"

local mem = sbar.add("graph", "widgets.memory", 42, {
  position = "right",
  update_freq = 3,
  graph = { color = colors.gold },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.memory },
  label = {
    string = "mem ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = settings.paddings + 6,
})

local function update_memory()
  sbar.exec(MEM_CMD, function(result)
    local used = tonumber(result)
    if not used then return end

    mem:push({ used / 100.0 })

    local color = colors.gold
    if used > 30 then
      if used < 60 then
        color = colors.yellow
      elseif used < 80 then
        color = colors.orange
      else
        color = colors.red
      end
    end

    mem:set({
      graph = { color = color },
      label = "mem " .. used .. "%",
    })
  end)
end

mem:subscribe("routine", update_memory)
mem:subscribe("forced", update_memory)

mem:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.memory.bracket", { mem.name }, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.memory.padding", {
  position = "right",
  width = settings.group_paddings,
})
