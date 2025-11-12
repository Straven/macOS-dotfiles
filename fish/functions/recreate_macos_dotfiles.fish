# Recreate macos-dotfiles session helper function

function recreate_macos_dotfiles -d "Recreate macos-dotfiles layout"
    set -l SESSION_NAME macos-dotfiles

    # Kill existing session if it exists
    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ Killed existing macos-dotfiles session"
    end

    # Create new session
    create_macos_dotfiles_layout
    echo "✓ macos-dotfiles session recreated"

    # Attach if not in tmux
    if not set -q TMUX
        tmux attach-session -t $SESSION_NAME
    else
        tmux switch-client -t $SESSION_NAME
    end
end
