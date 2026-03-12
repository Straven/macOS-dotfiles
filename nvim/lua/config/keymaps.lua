-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end)

-- Lua development
vim.keymap.set("n", "<leader>mls", function()
  local filepath = vim.fn.expand("%:p")

  -- Check if current file is a Lua file
  if vim.fn.expand("%:e") ~= "lua" then
    vim.notify("⚠️  Not a Lua file!", vim.log.levels.WARN)
    return
  end

  -- Get the module name if it's in a lua/ directory structure
  -- For example: lua/markdown-present/init.lua -> markdown-present
  local module_path = filepath:match("lua/(.+)%.lua$")

  if module_path then
    -- Convert path to module name (replace / with .)
    local module_name = module_path:gsub("/", ".")

    -- Unload the module
    package.loaded[module_name] = nil

    vim.notify("🔄 Unloaded module: " .. module_name, vim.log.levels.INFO)
  end

  -- Source the current file
  vim.cmd("source " .. filepath)

  vim.notify("🌙 Sourced: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Source Current Lua File" })
