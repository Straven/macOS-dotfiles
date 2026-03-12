# Kill macos-dotfiles session helper function

function kill_macos_dotfiles -d "Kill macos-dotfiles session"
    set -l SESSION_NAME macos-dotfiles

    if tmux has-session -t $SESSION_NAME 2>/dev/null
        tmux kill-session -t $SESSION_NAME
        echo "✓ macos-dotfiles session killed"
    else
        echo "✗ macos-dotfiles session not found"
        return 1
    end
end
