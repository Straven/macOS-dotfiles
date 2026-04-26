-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80,120"

vim.opt.wrap = false
vim.opt.linebreak = true

vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.o.pummaxwidth = 80

vim.opt.completeopt:append("nearest")
vim.opt.diffopt:append({ "indent-heuristic", "inline:char" })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true }, -- only show under the line you're on
  severity_sort = true,
  float = { border = "rounded" },
})

vim.o.exrc = true
