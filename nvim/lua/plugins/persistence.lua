return {
  "folke/persistence.nvim",
  enabled = true,
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
}
