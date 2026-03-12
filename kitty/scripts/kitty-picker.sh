#!/usr/bin/env bash
# kitty-picker.sh — sesh-style session/window picker for Kitty
# Modes: windows (^t) | zoxide dirs (^x) | session configs (^g) | find (^f) | all (^a)
# Actions: Enter = focus/open | ^d = close window (windows mode only)

KITTEN="/opt/homebrew/bin/kitten"
FZF="/opt/homebrew/bin/fzf"
ZOXIDE="/opt/homebrew/bin/zoxide"
FD="/opt/homebrew/bin/fd"
SESSIONS_DIR="$HOME/.config/kitty/sessions"
SCRIPT="$(realpath "$0")"

# ── Listers ─────────────────────────────────────────────────────────────────
# Format: TYPE\x1fVALUE\tDISPLAY  (fzf shows only DISPLAY via --with-nth 2)

list_windows() {
    $KITTEN @ ls 2>/dev/null | python3 -c "
import sys, json
data = json.load(sys.stdin)
for os_win in data:
    for tab in os_win['tabs']:
        for win in tab['windows']:
            marker = ' *' if win['is_focused'] else ''
            label = f\"🪟  {tab['title']} › {win['title']}{marker}\"
            print(f\"win\x1f{win['id']}\t{label}\")
" 2>/dev/null
}

list_zoxide() {
    $ZOXIDE query -l 2>/dev/null | while read -r dir; do
        printf "dir\x1f%s\t📁  %s\n" "$dir" "$dir"
    done
}

list_sessions() {
    ls "$SESSIONS_DIR"/*.conf 2>/dev/null | while read -r f; do
        name=$(basename "$f" .conf)
        printf "ses\x1f%s\t⚙️   %s\n" "$f" "$name"
    done
}

list_all() {
    list_windows
    list_zoxide
    list_sessions
}

# ── Subcommands (called by fzf reload/execute binds) ─────────────────────────
if [[ "$1" == "--list" ]]; then
    case "$2" in
        windows)  list_windows  ;;
        zoxide)   list_zoxide   ;;
        sessions) list_sessions ;;
        all)      list_all      ;;
    esac
    exit 0
fi

if [[ "$1" == "--kill" ]]; then
    raw="$2"
    type="${raw%%$'\x1f'*}"
    value="${raw#*$'\x1f'}"
    [[ "$type" == "win" ]] && $KITTEN @ close-window "--match=id:$value" 2>/dev/null
    exit 0
fi

if [[ "$1" == "--open" ]]; then
    raw="$2"
    type="${raw%%$'\x1f'*}"
    value="${raw#*$'\x1f'}"
    case "$type" in
        win) $KITTEN @ focus-window "--match=id:$value" 2>/dev/null ;;
        dir) $KITTEN @ new-window "--cwd=$value" 2>/dev/null ;;
        ses) open -na kitty --args --session "$value" ;;
    esac
    exit 0
fi

# ── Main fzf picker ──────────────────────────────────────────────────────────
# Use process substitution so fzf stdin stays on the TTY for keyboard input
selection=$($FZF \
    --prompt '⚡  ' \
    --border rounded \
    --border-label ' kitty ' \
    --header $'  \e[2m^a\e[0m all  \e[2m^t\e[0m windows  \e[2m^x\e[0m zoxide  \e[2m^g\e[0m configs  \e[2m^f\e[0m find  \e[2m^d\e[0m close' \
    --delimiter $'\t' \
    --with-nth 2 \
    --layout reverse \
    --height 100% \
    --no-sort \
    --ansi \
    --bind "tab:down,btab:up" \
    --bind "ctrl-a:change-prompt(⚡  )+reload($SCRIPT --list all)" \
    --bind "ctrl-t:change-prompt(🪟  )+reload($SCRIPT --list windows)" \
    --bind "ctrl-x:change-prompt(📁  )+reload($SCRIPT --list zoxide)" \
    --bind "ctrl-g:change-prompt(⚙️   )+reload($SCRIPT --list sessions)" \
    --bind "ctrl-f:change-prompt(🔎  )+reload($FD -H -d 3 -t d -E .Trash -E .git . \$HOME | while read -r d; do printf 'dir\x1f%s\t📁  %s\n' \"\$d\" \"\$d\"; done)" \
    --bind "ctrl-d:execute-silent($SCRIPT --kill {1})+reload($SCRIPT --list windows)" \
    < <(list_all) \
    2>/dev/tty)

[[ -z "$selection" ]] && exit 0

raw="${selection%%$'\t'*}"
"$SCRIPT" --open "$raw"
