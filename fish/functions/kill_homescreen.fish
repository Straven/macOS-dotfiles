# Kill homescreen session helper function

function kill_homescreen -d "Kill homescreen session"
    set -l SESSION_NAME ys-straven-homescreen

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ Homescreen session killed"
    else
        echo "✗ Homescreen session not found"
        return 1
    end
end
