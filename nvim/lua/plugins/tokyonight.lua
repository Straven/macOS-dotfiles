return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "storm",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    cache = false, -- disable for developing, enable later

    on_colors = function(colors)
      -- === Backgrounds ===
      -- bg (#24283b) kept as Tokyo Night Storm tribute
      colors.bg_dark = "#1a0e28"
      colors.bg_dark1 = "#0d0818"
      colors.bg_float = "#1a0e28"
      colors.bg_highlight = "#241535"
      colors.bg_popup = "#1a0e28"
      colors.bg_search = "#4B233E"
      colors.bg_sidebar = "#1a0e28"
      colors.bg_statusline = "#1a0e28"
      colors.bg_visual = "#372050"

      -- === Foregrounds ===
      colors.fg = "#DED09F"
      colors.fg_dark = "#C0CDCC"
      colors.fg_float = "#DED09F"
      colors.fg_gutter = "#4B233E"
      colors.fg_sidebar = "#C0CDCC"

      -- === Core palette ===
      colors.blue = "#9D7CD8" -- bright purple (primary accent)
      colors.blue0 = "#4B233E" -- dark purple
      colors.blue1 = "#76c8e0" -- blue
      colors.blue2 = "#7dcfff" -- cyan
      colors.blue5 = "#C0CDCC" -- light
      colors.blue6 = "#e8dff5" -- white
      colors.blue7 = "#372050" -- bg2
      colors.cyan = "#7dcfff" -- cyan accent
      colors.green = "#9ed072" -- green
      colors.green1 = "#73daca" -- bright teal (readable on dark)
      colors.green2 = "#41a6b5" -- mid teal
      colors.magenta = "#b57bee" -- purple
      colors.magenta2 = "#fc5d7c" -- hot pink/red
      colors.orange = "#ef7b3e" -- vibrant orange (sketchybar)
      colors.purple = "#9D7CD8" -- bright purple
      colors.red = "#fc5d7c" -- red
      colors.red1 = "#822F36" -- dark red
      colors.teal = "#76c8e0" -- blue
      colors.yellow = "#f5e642" -- flash yellow ⚡

      -- === UI elements ===
      colors.black = "#0d0818"
      colors.border = "#4B233E"
      colors.border_highlight = "#9D7CD8"
      colors.comment = "#7a6b99"
      colors.dark3 = "#7a6b99"
      colors.dark5 = "#A88E71" -- beige (visible muted text)
      colors.terminal_black = "#4B233E"

      -- === Diagnostics ===
      colors.error = "#fc5d7c"
      colors.warning = "#f5e642"
      colors.info = "#7dcfff"
      colors.hint = "#9ed072"

      -- === Git ===
      colors.git = {
        add = "#9ed072",
        change = "#7dcfff",
        delete = "#fc5d7c",
        ignore = "#7a6b99",
      }

      -- === Diff ===
      colors.diff = {
        add = "#1a2e1a",
        change = "#1a1e35",
        delete = "#3a1525",
        text = "#372050",
      }
    end,

    on_highlights = function(hl, c)
      -- Dashboard header in flash yellow
      hl.DashboardHeader = { fg = c.yellow }

      -- Cursor line
      hl.CursorLine = { bg = "#241535" }
      hl.CursorLineNr = { fg = "#f5e642", bold = true }

      -- Matching brackets
      hl.MatchParen = { fg = "#f5e642", bold = true }

      -- Selection
      hl.Visual = { bg = "#372050" }

      -- Search
      hl.Search = { fg = "#1a0e28", bg = "#f5e642" }
      hl.IncSearch = { fg = "#1a0e28", bg = "#ef7b3e" }

      -- Completion menu
      hl.PmenuSel = { fg = "#1a0e28", bg = "#9D7CD8" }

      -- Line numbers
      hl.LineNr = { fg = "#7a6b99" }

      -- Strings in warm cream/beige to stand out
      hl["@string"] = { fg = "#A88E71" }

      -- Keywords pop with bright purple
      hl["@keyword"] = { fg = "#9D7CD8", italic = true }
      hl["@keyword.return"] = { fg = "#fc5d7c", italic = true }

      -- Functions in cyan
      hl["@function"] = { fg = "#7dcfff" }
      hl["@function.call"] = { fg = "#7dcfff" }
      hl["@function.builtin"] = { fg = "#76c8e0" }

      -- Variables in cream
      hl["@variable"] = { fg = "#DED09F" }
      hl["@property"] = { fg = "#b57bee" }

      -- Booleans/numbers in orange
      hl["@boolean"] = { fg = "#ef7b3e" }
      hl["@number"] = { fg = "#ef7b3e" }

      -- Comments stay muted grey
      hl["@comment"] = { fg = "#7a6b99", italic = true }

      -- Types in teal
      hl["@type"] = { fg = "#73daca" }
      hl["@type.builtin"] = { fg = "#73daca", italic = true }

      -- Operators
      hl["@operator"] = { fg = "#C0CDCC" }

      -- Punctuation subtle
      hl["@punctuation.bracket"] = { fg = "#A88E71" }
      hl["@punctuation.delimiter"] = { fg = "#7a6b99" }
    end,
  },
}
