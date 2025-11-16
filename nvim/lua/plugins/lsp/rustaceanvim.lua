return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false,
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        hover_actions = {
          auto_focus = false,
          border = "rounded",
          width = 60,
          height = 20,
        },
        runnables = {
          use_telescope = true,
        },
        debuggables = {
          use_telescope = true,
        },
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          print("🦀 Rust LSP attached!") -- Debug message

          local opts = { buffer = bufnr, silent = true }

          -- Rust-specific keymaps under <leader>mr
          vim.keymap.set("n", "<leader>mrr", function()
            vim.cmd.RustLsp("run")
          end, vim.tbl_extend("force", opts, { desc = "Run" }))

          vim.keymap.set("n", "<leader>mrt", function()
            vim.cmd.RustLsp("testables")
          end, vim.tbl_extend("force", opts, { desc = "Test" }))

          vim.keymap.set("n", "<leader>mrd", function()
            vim.cmd.RustLsp("debuggables")
          end, vim.tbl_extend("force", opts, { desc = "Debug" }))

          vim.keymap.set("n", "<leader>mre", function()
            vim.cmd.RustLsp("expandMacro")
          end, vim.tbl_extend("force", opts, { desc = "Expand Macro" }))

          vim.keymap.set("n", "<leader>mrc", function()
            vim.cmd.RustLsp("openCargo")
          end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

          vim.keymap.set("n", "<leader>mrp", function()
            vim.cmd.RustLsp("parentModule")
          end, vim.tbl_extend("force", opts, { desc = "Parent Module" }))

          vim.keymap.set("n", "<leader>mrj", function()
            vim.cmd.RustLsp("joinLines")
          end, vim.tbl_extend("force", opts, { desc = "Join Lines" }))

          vim.keymap.set("n", "<leader>mrh", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, vim.tbl_extend("force", opts, { desc = "Hover Actions" }))

          vim.keymap.set("n", "<leader>mrk", function()
            vim.cmd.RustLsp("moveItem", "up")
          end, vim.tbl_extend("force", opts, { desc = "Move Item Up" }))

          vim.keymap.set("n", "<leader>mrJ", function()
            vim.cmd.RustLsp("moveItem", "down")
          end, vim.tbl_extend("force", opts, { desc = "Move Item Down" }))

          vim.keymap.set("n", "<leader>mrs", function()
            vim.cmd.RustLsp("ssr")
          end, vim.tbl_extend("force", opts, { desc = "Structural Search Replace" }))

          vim.keymap.set("n", "<leader>mrx", function()
            vim.cmd.RustLsp("explainError")
          end, vim.tbl_extend("force", opts, { desc = "Explain Error" }))

          vim.keymap.set("n", "<leader>mrD", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, vim.tbl_extend("force", opts, { desc = "Render Diagnostic" }))
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    }
  end,
}
