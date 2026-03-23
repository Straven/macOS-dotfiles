# Recreate registra session helper function

function recreate_registra -d "Recreate registra layout"
    set -l SESSION_NAME registra

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ Killed existing registra session"
    end

    create_registra_layout
    echo "✓ registra session recreated"

    if not set -q TMUX
        tmux attach-session -t $SESSION_NAME
    else
        tmux switch-client -t $SESSION_NAME
    end
end
