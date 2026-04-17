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
        # ─ Ctrl+R history search (sponge-style: only successful commands) ─────────
        {
            name: fzf_history
            modifier: control
            keycode: char_r
            mode: [vi_normal, vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit (
                    history | where exit_status == 0 | get command | reverse | uniq
                    | str join (char newline)
                    | fzf --reverse --no-sort
                )"
            }
        }

        # ─ Pisces-style auto-close brackets (vi_insert only) ─────────────────────
        {
            name: auto_pair_paren
            modifier: none
            keycode: "char_("
            mode: vi_insert
            event: [
                { edit: insertchar, value: "(" }
                { edit: insertchar, value: ")" }
                { edit: moveleft }
            ]
        }
        {
            name: auto_pair_bracket
            modifier: none
            keycode: "char_["
            mode: vi_insert
            event: [
                { edit: insertchar, value: "[" }
                { edit: insertchar, value: "]" }
                { edit: moveleft }
            ]
        }
        {
            name: auto_pair_brace
            modifier: none
            keycode: "char_{"
            mode: vi_insert
            event: [
                { edit: insertchar, value: "{" }
                { edit: insertchar, value: "}" }
                { edit: moveleft }
            ]
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
alias bi   = brew install
alias bic  = brew install --cask
alias bin  = brew info
alias binc = brew info --cask
alias bs   = brew search
alias bl   = brew list
alias bu   = brew uninstall

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

# Tmux session shortcuts
alias t  = tmux
alias ta = tmux attach
alias tl = tmux list-sessions
alias tk = tmux kill-session

# ─── Custom Commands ──────────────────────────────────────────────────────────
def cwr [] { cargo watch -x run }
def cwt [] { cargo watch -x test }

# eza tree with a --level override, e.g. `lstl 3`
def lstl [level: int] {
    eza -alh -T --icons --git --color --no-user --no-permissions --level=$level
}

def homescreen [] {
    let session = "ys-straven-homescreen"
    let exists = (bash -c $"tmux has-session -t ($session) 2>/dev/null; echo $?" | str trim)
    if $exists == "0" {
        if ($env | get -o TMUX | is-not-empty) {
            bash -c $"tmux switch-client -t ($session)"
        } else {
            bash -c $"tmux attach-session -t ($session)"
        }
    } else {
        bash -c "~/.config/tmux/create-homescreen.sh"
        if ($env | get -o TMUX | is-not-empty) {
            bash -c $"tmux switch-client -t ($session)"
        } else {
            bash -c $"tmux attach-session -t ($session)"
        }
    }
}

def rust-session [project?: string] {
    let session = "ys-straven-rust"
    let path = ($project | default (pwd | str trim))
    let exists = (bash -c $"tmux has-session -t ($session) 2>/dev/null; echo $?" | str trim)
    if $exists == "0" {
        if ($env | get -o TMUX | is-not-empty) {
            bash -c $"tmux switch-client -t ($session)"
        } else {
            bash -c $"tmux attach-session -t ($session)"
        }
    } else {
        bash -c $"~/.config/tmux/create-rust-session.sh ($path)"
        if ($env | get -o TMUX | is-not-empty) {
            bash -c $"tmux switch-client -t ($session)"
        } else {
            bash -c $"tmux attach-session -t ($session)"
        }
    }
}

def kill_homescreen [] {
    bash -c "tmux kill-session -t ys-straven-homescreen"
    print "✓ Homescreen session killed"
}

def kill-rust-session [] {
    bash -c "tmux kill-session -t ys-straven-rust"
    print "✓ Rust session killed"
}

# ─── Auto-launch tmux in Ghostty (skip inside cmux) ──────────────────────────
# cmux sets TERM_PROGRAM=ghostty too, so we additionally check CMUX_WORKSPACE_ID
# to distinguish real Ghostty from a cmux pane.
if (
    ($env | get -o TMUX | is-empty)
    and (($env | get -o TERM_PROGRAM | default "") == "ghostty")
    and (($env | get -o CMUX_WORKSPACE_ID | default "") == "")
) {
    homescreen
}

def "ys-brew" [] { ~/.config/bin/ys-brew }
