# Create layout for yazi file explorer session
function create_yazi_layout -d "Create the yazi tmux layout"
    set -l SESSION_NAME ys-straven-yazi

    # Create new session starting at root
    tmux new-session -d -s $SESSION_NAME -n main -c /

    # Launch yazi at root
    tmux send-keys -t "$SESSION_NAME:main.1" "yazi /" C-m
end
