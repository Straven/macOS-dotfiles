#!/usr/bin/env nu

# Kitty session/window picker — Ctrl+a > s
# Lists open windows AND launchable session configs.
# Open window → focus it. Session config → launch as new tab(s).

let kitten = "/opt/homebrew/bin/kitten"
let fzf    = "/opt/homebrew/bin/fzf"
let sessions_dir = ($env.HOME | path join ".config/kitty/sessions")

# ── Open windows ────────────────────────────────────────────────────────────
let raw = (^$kitten @ ls | from json)

let window_entries = ($raw | each { |os_win|
    $os_win.tabs | each { |tab|
        $tab.windows | each { |win|
            let marker = if $win.is_focused { " *" } else { "" }
            {
                kind:    "window"
                id:      $win.id
                display: $"($tab.title) › ($win.title)($marker)"
            }
        }
    } | flatten
} | flatten)

# ── Launchable sessions ─────────────────────────────────────────────────────
let session_entries = (
    ls $sessions_dir
    | where name ends-with ".conf"
    | where { |f| ($f.name | path basename) != "startup.conf" }
    | each { |f|
        let name = ($f.name | path basename | str replace ".conf" "")
        {
            kind:    "session"
            id:      $f.name
            display: $"⚡ ($name)"
        }
    }
)

let all_entries = ($window_entries | append $session_entries)

if ($all_entries | is-empty) {
    print "Nothing to show."
    exit 0
}

# ── fzf with section headers ────────────────────────────────────────────────
let fzf_lines = (
    ["── open ──"]
    | append ($window_entries | get display)
    | append ["── sessions ──"]
    | append ($session_entries | get display)
    | str join "\n"
)

let selection = (
    $fzf_lines
    | ^$fzf
        --prompt "  pick › "
        --border rounded
        --height 50%
        --layout reverse
        --no-sort
        --ansi
    | str trim
)

if ($selection | is-empty) or ($selection | str starts-with "──") { exit 0 }

# ── Dispatch ────────────────────────────────────────────────────────────────
let matched = ($all_entries | where display == $selection | first)

if $matched.kind == "window" {
    ^$kitten @ focus-window $"--match=id:($matched.id)"
} else {
    ^$kitten @ action goto_session ($matched.id)
}
