#!/usr/bin/env bash

SESSION_NAME="ys-straven-homescreen"

tmux new-session -d -s "$SESSION_NAME" -n main -c "$HOME"
tmux split-window -h -t "$SESSION_NAME:main.1" -c "$HOME" -p 75
tmux split-window -v -t "$SESSION_NAME:main.1" -c "$HOME" -p 30
tmux send-keys -t "$SESSION_NAME:main.1" "fastfetch" Enter
tmux send-keys -t "$SESSION_NAME:main.3" "btop" Enter
tmux select-pane -t "$SESSION_NAME:main.2"
