return {
  "saghen/blink.cmp",
  enabled = true,
  -- Use the latest version for best features and performance
  version = "*",

  opts = {
    -- Appearance settings
    appearance = {
      -- Use nerdfont icons (you have mini.icons loaded)
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },

    -- Completion behavior
    completion = {
      -- Automatically show completion menu
      menu = {
        auto_show = true,
        draw = {
          -- Show treesitter highlights in completion menu
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },

      -- Documentation window settings
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
        },
      },

      -- Ghost text (inline suggestions)
      ghost_text = {
        enabled = true,
      },

      -- Auto-insert brackets after function/method completion
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },

      -- Trigger completion automatically
      trigger = {
        show_on_insert_on_trigger_character = true,
      },
    },

    -- Keybindings
    keymap = {
      preset = "default",

      -- Show/hide completion
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },

      -- Accept completion
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },

      -- Navigate completion menu
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },

      -- Scroll documentation
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },

    -- Sources configuration
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },

      -- Per-filetype sources
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 90, -- Highest priority
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 80, -- High priority
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            global_snippets = { "all" },
            extended_filetypes = {},
            ignored_filetypes = {},
          },
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 5,
          opts = {
            max_items = 5,
            min_keyword_length = 3,
          },
        },
      },
    },

    -- Signature help (function parameters)
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },

    -- Fuzzy matching configuration
    fuzzy = {
      use_typo_resistance = true,
      use_frecency = true,
      use_proximity = true,
      max_items = 200,
      sorts = { "score", "sort_text" },
      prebuilt_binaries = {
        download = true,
      },
    },
  },

  -- Optional: Add additional sources
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
}
