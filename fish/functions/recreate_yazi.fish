# Recreate yazi session helper function

function recreate_yazi -d "Recreate yazi layout"
    set -l SESSION_NAME ys-straven-yazi

    # Kill existing session if it exists
    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ Killed existing yazi session"
    end

    # Create new session
    create_yazi_layout
    echo "✓ yazi session recreated"

    # Attach if not in tmux
    if not set -q TMUX
        tmux attach-session -t $SESSION_NAME
    else
        tmux switch-client =t $SESSION_NAME
    end
end
