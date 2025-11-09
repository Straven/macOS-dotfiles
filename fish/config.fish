set -Ux EDITOR nvim

set -U fish_greeting # disable fish greeting
set -U fish_key_bindings fish_vi_key_bindings

set -U FZF_CTRL_R_OPTS --reverse
set -U FZF_TMUX_OPTS -p
set -U FZF_DEFAULT_OPTS_FILE '$HOME/.config/fzf/.fzfrc'

function fish_title
#    echo 🐈‍⬛ $argv[1] (pwd)
end

# Homebrew
if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Add local bin to PATH
fish_add_path ~/.local/bin

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.config/bin

export HOMEBREW_NO_ENV_HINTS=1

export CARGO_TARGET_DIR="/tmp/.cargo-target"

# FZF Plugin
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'

# EZA theme
export EZA_CONFIG_DIR='$HOME/.config/eza'

# Auto launch tmux homescreen only in Ghostty
# Prevents nested tmux sessions and only runs in interactive mode
if status is-interactive
    and not set -q TMUX
    and test "$TERM_PROGRAM" = ghostty
    launch_homescreen
end

starship init fish | source
zoxide init fish | source
