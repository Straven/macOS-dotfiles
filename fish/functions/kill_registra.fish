# Kill registra session helper function

function kill_registra -d "Kill registra session"
    set -l SESSION_NAME registra

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ registra session killed"
    else
        echo "✗ registra session not found"
        return 1
    end
end
