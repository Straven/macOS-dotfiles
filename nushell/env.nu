$env.EDITOR = "nvim"
$env.HOMEBREW_NO_ENV_HINTS = "1"
$env.CARGO_TARGET_DIR = "target"
$env.EZA_CONFIG_DIR = $"($env.HOME)/.config/eza"
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"

# PATH
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        $"($env.HOME)/.bun/bin"
        $"($env.HOME)/.cargo/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.config/bin"
        "/opt/homebrew/bin"
        $"($env.HOME)/develop/flutter/bin"
    ]
    | uniq
)

# Homebrew
if ("/opt/homebrew" | path exists) {
    load-env (
        /opt/homebrew/bin/brew shellenv
        | lines
        | where { |l| $l starts-with "export " }
        | each { |l| $l | str replace "export " "" | split column "=" | first }
        | reduce -f {} { |row, acc| $acc | insert $row.column0 $row.column1 }
    )
}

# FZF — Tokyo Night Flash Goddess Storm palette
$env.FZF_DEFAULT_OPTS = '--color=fg:#DED09F,bg:#24283b,hl:#9D7CD8 --color=fg+:#DED09F,bg+:#202825,hl+:#9D7CD8 --color=info:#A88E71,prompt:#D56920,pointer:#9D7CD8 --color=marker:#9D7CD8,spinner:#A88E71,header:#4B233E'

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
