# Recreate homescreen session helper function

function recreate_homescreen -d "Recreate homescreen layout"
    set -l SESSION_NAME ys-straven-homescreen

    # Kill existing session if it exists
    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ Killed existing homescreen"
    end

    # Create new homescreen
    create_homescreen_layout
    echo "✓ Homescreen recreated"

    # Attach if not in tmux
    if not set -q TMUX
        tmux attach-session -t $SESSION_NAME
    else
        tmux switch-client -t $SESSION_NAME
    end
end
