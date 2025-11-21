return {
  "folke/which-key.nvim",
  optional = true,
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>ml", group = "Lua", icon = "🌙" },
        { "<leader>mls", desc = "Source Current File", icon = "⚡" },
      },
    },
  },
}
