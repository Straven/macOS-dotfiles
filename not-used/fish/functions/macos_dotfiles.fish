# macos-dotfiles session helper function

function macos_dotfiles -d "Attach to macos-dotfiles session"
    set -l SESSION_NAME macos-dotfiles

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        # Session exists, attach to it
        if set -q TMUX
            # Already in tmux, switch to the session
            tmux switch-client -t $SESSION_NAME
        else
            # Not in tmux, attach to the session
            tmux attach-session -t $SESSION_NAME
        end
    else
        # Session doesn't exist, create it
        create_macos_dotfiles_layout

        # Attach to the newly created session
        if set -q TMUX
            tmux switch-client -t $SESSION_NAME
        else
            tmux attach-session -t $SESSION_NAME
        end
    end
end
