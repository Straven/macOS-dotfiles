# Refresh fastfetch helper function

function refresh_fastfetch -d "Refresh fastfetch in homescreen"
    set -l SESSION_NAME ys-straven-homescreen

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux send-keys -t "$SESSION_NAME:main.0" C-c
        tmux send-keys -t "$SESSION_NAME:main.0" "clear && fastfetch" C-m
        echo "✓ Fastfetch refreshed!"
    else
        echo "✗ Homescreen session not found"
        return 1
    end
end
