return {
  {
    "mrcjkb/rustaceanvim",
    config = function()
      -- Autocommands for Rust development
      local rust_group = vim.api.nvim_create_augroup("RustCustom", { clear = true })

      -- Auto-format on save for Rust files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        group = rust_group,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
        desc = "Format Rust code on save",
      })

      -- Auto-save when running tests or builds
      vim.api.nvim_create_autocmd("User", {
        pattern = "RustaceanBeforeRunnable",
        group = rust_group,
        callback = function()
          vim.cmd("wall") -- Save all buffers
        end,
        desc = "Save all buffers before running Rust commands",
      })

      -- Set specific options for Rust files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        group = rust_group,
        callback = function()
          local opts = { buffer = true }
          -- Enable inlay hints by default for Rust
          vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

          -- Rust-specific buffer options
          vim.opt_local.colorcolumn = "100" -- Rust standard line length
          vim.opt_local.textwidth = 100
        end,
        desc = "Set Rust-specific options",
      })
    end,
  },
}
