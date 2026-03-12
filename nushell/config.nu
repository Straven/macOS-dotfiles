hide-env --ignore-errors __zoxide_hooked

source ~/.config/nushell/themes/tokyo_night_flash_goddess_storm.nu

$env.config = {
    show_banner: false
    edit_mode: vi

    color_config: $env.tokyo_night_flash_goddess_storm

    history: {
        max_size: 1000000
        sync_on_enter: true
        file_format: "sqlite"
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }

    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }

    keybindings: [
        {
            name: fzf_history
            modifier: control
            keycode: char_r
            mode: [vi_normal, vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit (
                    history | get command | reverse | uniq
                    | str join (char newline)
                    | fzf --reverse --no-sort
                )"
            }
        }
    ]
}

# ─── Aliases ──────────────────────────────────────────────────────────────────
# EZA
alias ls  = eza --color=always --long --git --icons=always --no-user --no-permissions
alias ll  = eza -al --icons --git --color --no-user --no-permissions
alias lll = eza -alh --long --icons --git --color --no-user --no-permissions
alias lst = eza -alh -T --icons --git --color --no-user --no-permissions

# Core
alias v  = nvim
alias g  = git
alias yz = yazi
alias gs = git status
alias gc = git commit
alias gp = git push

# Brew
alias bi  = brew install
alias bic = brew install --cask
alias bin = brew info
alias bs  = brew search
alias bl  = brew list
alias bu  = brew uninstall

# Rust
alias cb  = cargo build
alias cr  = cargo run
alias ct  = cargo test
alias cc  = cargo check
alias cbr = cargo build --release
alias crr = cargo run --release
alias ctr = cargo test --release
alias ccl = cargo clean
alias ccp = cargo clippy
alias cf  = cargo fmt
alias rup = rustup update

# Hugo
alias hserv = hugo server -D

# Zellij session shortcuts
alias t  = zellij
alias ta = zellij attach
alias tl = zellij list-sessions
alias tk = zellij kill-session

# ─── Custom Commands ──────────────────────────────────────────────────────────
def cwr [] { cargo watch -x run }
def cwt [] { cargo watch -x test }

def homescreen [] {
    let session = "homescreen"
    let sessions = (zellij list-sessions | lines | str trim)
    if $session in $sessions {
        zellij attach $session
    } else {
        zellij --layout homescreen --session $session
    }
}

def macos_dotfiles [] {
    let session = "macos-dotfiles"
    let sessions = (zellij list-sessions | lines | str trim)
    if $session in $sessions {
        zellij attach $session
    } else {
        zellij --layout macos-dotfiles --session $session
    }
}

def kill_homescreen [] {
    zellij kill-session "homescreen"
    print "✓ Homescreen session killed"
}

def kill_macos_dotfiles [] {
    zellij kill-session "macos-dotfiles"
    print "✓ macos-dotfiles session killed"
}

def "ys brew" [] { ~/.config/bin/ys-brew }
