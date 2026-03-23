# Homescreen helper function

function homescreen -d "Attach to homescreen session"
    set -l SESSION_NAME ys-straven-homescreen

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
        create_homescreen_layout

        # Attach to the newly created session
        if set -q TMUX
            tmux switch-client -t $SESSION_NAME
        else
            tmux attach-session -t $SESSION_NAME
        end
    end
end
