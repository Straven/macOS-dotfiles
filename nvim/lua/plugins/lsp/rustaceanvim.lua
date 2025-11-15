return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended to pin to major version
  lazy = false, -- This plugin is already lazy
  opts = {
    -- Plugin configuration
    tools = {
      -- Hover actions
      hover_actions = {
        auto_focus = false,
        border = "rounded",
        width = 60,
        height = 20,
      },

      -- Inlay hints
      inlay_hints = {
        auto = true,
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },

      -- Runnables
      runnables = {
        use_telescope = true,
      },

      -- Debuggables
      debuggables = {
        use_telescope = true,
      },

      -- Code actions
      code_actions = {
        ui_select_fallback = false,
      },

      -- Float window styling
      float_win_config = {
        border = "rounded",
        max_width = 100,
        max_height = 30,
      },

      -- Reload workspace on Cargo.toml changes
      reload_workspace_from_cargo_toml = true,
    },

    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        -- Custom keymaps for Rust
        local opts = { buffer = bufnr, silent = true }

        -- Rust-specific keymaps
        vim.keymap.set("n", "<leader>rr", function()
          vim.cmd.RustLsp("run")
        end, vim.tbl_extend("force", opts, { desc = "Rust Run" }))

        vim.keymap.set("n", "<leader>rt", function()
          vim.cmd.RustLsp("testables")
        end, vim.tbl_extend("force", opts, { desc = "Rust Test" }))

        vim.keymap.set("n", "<leader>rd", function()
          vim.cmd.RustLsp("debuggables")
        end, vim.tbl_extend("force", opts, { desc = "Rust Debug" }))

        vim.keymap.set("n", "<leader>re", function()
          vim.cmd.RustLsp("expandMacro")
        end, vim.tbl_extend("force", opts, { desc = "Rust Expand Macro" }))

        vim.keymap.set("n", "<leader>rc", function()
          vim.cmd.RustLsp("openCargo")
        end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

        vim.keymap.set("n", "<leader>rp", function()
          vim.cmd.RustLsp("parentModule")
        end, vim.tbl_extend("force", opts, { desc = "Parent Module" }))

        vim.keymap.set("n", "<leader>rj", function()
          vim.cmd.RustLsp("joinLines")
        end, vim.tbl_extend("force", opts, { desc = "Join Lines" }))

        vim.keymap.set("n", "<leader>rh", function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end, vim.tbl_extend("force", opts, { desc = "Hover Actions" }))

        vim.keymap.set("n", "<leader>rk", function()
          vim.cmd.RustLsp("moveItem", "up")
        end, vim.tbl_extend("force", opts, { desc = "Move Item Up" }))

        vim.keymap.set("n", "<leader>rj", function()
          vim.cmd.RustLsp("moveItem", "down")
        end, vim.tbl_extend("force", opts, { desc = "Move Item Down" }))

        -- Structural Search and Replace
        vim.keymap.set("n", "<leader>rsr", function()
          vim.cmd.RustLsp("ssr")
        end, vim.tbl_extend("force", opts, { desc = "Structural Search Replace" }))

        -- Explain Error
        vim.keymap.set("n", "<leader>rex", function()
          vim.cmd.RustLsp("explainError")
        end, vim.tbl_extend("force", opts, { desc = "Explain Error" }))

        -- Render Diagnostics
        vim.keymap.set("n", "<leader>rrd", function()
          vim.cmd.RustLsp("renderDiagnostic")
        end, vim.tbl_extend("force", opts, { desc = "Render Diagnostic" }))
      end,

      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          -- Cargo settings
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
            buildScripts = {
              enable = true,
            },
            cfgs = {
              debug_assertions = true,
              procmacro2_semver_exempt = true,
            },
          },

          -- Proc macro settings
          procMacro = {
            enable = true,
            ignored = {
              leptos_macro = {
                "component",
                "server",
              },
            },
          },

          -- Files and workspace settings
          files = {
            watcher = "notify",
            excludeDirs = {
              ".direnv",
              ".git",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              ".venv",
            },
          },

          -- Diagnostics
          diagnostics = {
            enable = true,
            experimental = {
              enable = true,
            },
            enableExperimental = true,
            disabled = {
              "unresolved-proc-macro",
            },
            remapPrefix = {
              ["/rustc/"] = "https://github.com/rust-lang/rust/blob/master/",
            },
          },

          -- Completion settings
          completion = {
            callable = {
              snippets = "fill_arguments",
            },
            postfix = {
              enable = false,
            },
            privateEditable = {
              enable = true,
            },
            fullFunctionSignatures = {
              enable = false,
            },
          },

          -- Call hierarchy
          callHierarchy = {
            enable = true,
          },

          -- Highlighting and semantics
          semanticHighlighting = {
            strings = {
              enable = true,
            },
          },

          -- Inlay hints (detailed configuration)
          inlayHints = {
            bindingModeHints = {
              enable = false,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 25,
            },
            closureReturnTypeHints = {
              enable = "never", -- Can be "always", "never", "with_block"
            },
            discriminantHints = {
              enable = "never", -- Can be "always", "never", "fieldless"
            },
            lifetimeElisionHints = {
              enable = "never", -- Can be "always", "never", "skip_trivial"
              useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = {
              enable = true,
            },
            reborrowHints = {
              enable = "never", -- Can be "always", "never", "mutable"
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },

          -- Lens settings
          lens = {
            enable = true,
            debug = {
              enable = true,
            },
            implementations = {
              enable = true,
            },
            references = {
              adt = {
                enable = false,
              },
              enumVariant = {
                enable = false,
              },
              method = {
                enable = false,
              },
              trait = {
                enable = false,
              },
            },
            run = {
              enable = true,
            },
          },

          -- Hover and documentation
          hover = {
            actions = {
              enable = true,
              implementations = {
                enable = true,
              },
              references = {
                enable = true,
              },
              run = {
                enable = true,
              },
            },
            documentation = {
              enable = true,
            },
            links = {
              enable = true,
            },
          },

          -- Assist settings
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
            importMergeBehavior = "last",
            importGroup = true,
          },

          -- Check settings
          check = {
            command = "clippy",
            features = "all",
          },

          -- Workspace symbol search
          workspace = {
            symbol = {
              search = {
                scope = "workspace_and_dependencies",
                kind = "only_types",
              },
            },
          },
        },
      },
    },

    -- DAP configuration for debugging
    dap = {
      adapter = {
        type = "executable",
        command = "lldb-vscode",
        name = "rt_lldb",
      },
    },
  },
}
