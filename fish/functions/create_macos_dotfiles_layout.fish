# Creating layout for macos-dotfiles session

function create_macos_dotfiles_layout -d "Create the macos-dotfiles tmux layout"
    set -l SESSION_NAME macos-dotfiles
    set -l PROJECT_PATH ~/OneDrive/StravenConfigs/dotfiles/macos-dotfiles

    # Create new session with first pane (top pane - this becomes pane 0)
    tmux new-session -d -s $SESSION_NAME -n main -c $PROJECT_PATH

    # Split horizontally to create bottom pane (this becomes pane 1)
    # Using -p 10 to make it 10 rows (not columns) in height
    tmux split-window -v -t "$SESSION_NAME" -c $PROJECT_PATH -l 10

    # Now we have:
    # Pane 0: top (neovim)
    # Pane 1: bottom (command line - 10 rows height)

    # Start neovim in pane 0 (top)
    tmux send-keys -t "$SESSION_NAME:main.1" "nvim ." C-m

    # Select pane 1 (bottom) - this is where user will type commands
    tmux select-pane -t "$SESSION_NAME:main.1"
end
