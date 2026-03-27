return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- I was having issues formatting .templ files, all the lines were aligned
      -- to the left.
      -- When I ran :ConformInfo I noticed that 2 formatters showed up:
      -- "LSP: html, templ"
      -- But none showed as `ready` This fixed that issue and now templ files
      -- are formatted correctly and :ConformInfo shows:
      -- "LSP: html, templ"
      -- "templ ready (templ) /Users/linkarzu/.local/share/neobean/mason/bin/templ"
      templ = { "templ" },
      -- Not sure why I couldn't make ruff work, so I'll use ruff_format instead
      -- it didn't work even if I added the pyproject.toml in the project or
      -- root of my dots, I was getting the error [LSP][ruff] timeout
      python = { "ruff_format" },
      -- php = { nil },
    },
  },
}
