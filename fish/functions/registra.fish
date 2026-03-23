# registra session helper function
function registra -d "Attach to registra session"
    set -l SESSION_NAME registra

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        if set -q TMUX
            tmux switch-client -t $SESSION_NAME
        else
            tmux attach-session -t $SESSION_NAME
        end
    else
        create_registra_layout

        if set -q TMUX
            tmux switch-client -t $SESSION_NAME
        else
            tmux attach-session -t $SESSION_NAME
        end
    end
end
