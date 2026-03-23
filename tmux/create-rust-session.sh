#!/usr/bin/env bash

SESSION_NAME="ys-straven-rust"
PROJECT_PATH="${1:-$HOME}"

# Create session with nvim on the left (75%)
tmux new-session -d -s "$SESSION_NAME" -n rust -c "$PROJECT_PATH"

# Split right side (25%)
tmux split-window -h -t "$SESSION_NAME:rust.1" -c "$PROJECT_PATH" -p 25

# Split right pane into 3 vertical panes
tmux split-window -v -t "$SESSION_NAME:rust.2" -c "$PROJECT_PATH"
tmux split-window -v -t "$SESSION_NAME:rust.3" -c "$PROJECT_PATH"

# Send commands to right panes
tmux send-keys -t "$SESSION_NAME:rust.2" "cargo test" Enter
tmux send-keys -t "$SESSION_NAME:rust.3" "cargo run" Enter
# rust.4 stays as plain shell

# Launch nvim in left pane and focus it
tmux send-keys -t "$SESSION_NAME:rust.1" "nvim ." Enter
tmux select-pane -t "$SESSION_NAME:rust.1"
