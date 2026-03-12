return {
  "folke/which-key.nvim",
  optional = true,
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>r", group = "Rust", icon = " " },
        { "<leader>rc", desc = "Open Cargo.toml", icon = "📦" },
        { "<leader>rd", desc = "Debug", icon = "🐛" },
        { "<leader>re", desc = "Expand Macro", icon = "🔍" },
        { "<leader>rh", desc = "Hover Actions", icon = "💡" },
        { "<leader>rj", desc = "Join Lines", icon = "🔗" },
        { "<leader>rk", desc = "Move Item Up", icon = "⬆️" },
        { "<leader>rp", desc = "Parent Module", icon = "📁" },
        { "<leader>rr", desc = "Run", icon = "▶️" },
        { "<leader>rt", desc = "Test", icon = "🧪" },
        { "<leader>rex", desc = "Explain Error", icon = "❓" },
        { "<leader>rrd", desc = "Render Diagnostic", icon = "📋" },
        { "<leader>rsr", desc = "Structural Search Replace", icon = "🔄" },
      },
    },
  },
}
