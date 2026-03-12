#!/usr/bin/env nu

# Kitty session picker — Ctrl+a > s
# Queries all OS windows / tabs / panes via kitten @ ls,
# presents them in fzf, then focuses the selected window.

let kitten = "/opt/homebrew/bin/kitten"
let fzf    = "/opt/homebrew/bin/fzf"

let raw = (^$kitten @ ls | from json)

# Flatten structure: os_window > tabs > windows
let entries = ($raw | each { |os_win|
    $os_win.tabs | each { |tab|
        $tab.windows | each { |win|
            let marker = if $win.is_focused { " *" } else { "" }
            {
                id:      $win.id
                display: $"($tab.title) › ($win.title)($marker)"
            }
        }
    } | flatten
} | flatten)

if ($entries | is-empty) {
    print "No windows found."
    exit 0
}

# fzf picker
let selection = (
    $entries
    | get display
    | str join "\n"
    | ^$fzf
        --prompt "  window › "
        --border rounded
        --height 40%
        --layout reverse
        --no-sort
        --ansi
    | str trim
)

if ($selection | is-empty) { exit 0 }

# Resolve id and focus
let win_id = ($entries | where display == $selection | get id | first)
^$kitten @ focus-window $"--match=id:($win_id)"
