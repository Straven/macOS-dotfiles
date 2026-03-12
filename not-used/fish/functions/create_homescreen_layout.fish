# Creating layout for homescreen session and send commands to them

function create_homescreen_layout -d "Create the homescreen tmux layout"
    set -l SESSION_NAME ys-straven-homescreen

    # Create new session with first pane (this becomes pane 0)
    tmux new-session -d -s $SESSION_NAME -n main -c $HOME

    # Split vertically to create right pane (this becomes pane 1)
    tmux split-window -h -t "$SESSION_NAME:main.1" -c $HOME -p 75

    # Split the LEFT pane horizontally to create bottom-left (this becomes pane 2)
    tmux split-window -v -t "$SESSION_NAME:main.1" -c $HOME -p 30

    # Now we have:
    # Pane 0: top-left
    # Pane 2: bottom-left
    # Pane 1: right (full height)

    # Run fastfetch in pane 0 (top-left)
    tmux send-keys -t "$SESSION_NAME:main.1" fastfetch C-m

    # Run btop in pane 1 (right)
    tmux select-pane -t "$SESSION_NAME:main.2"

    # Select pane 2 (bottom-left) for commands - this is where user will type
    tmux send-keys -t "$SESSION_NAME:main.3" btop C-m
end
