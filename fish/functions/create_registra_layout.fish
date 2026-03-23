# Create layout for registra session
function create_registra_layout -d "Create registra tmux layout"
    set -l SESSION_NAME registra
    set -l PROJECT_PATH ~/Projects/registra

    # Create new session at exact terminal dimensions so percentages are accurate
    tmux new-session -d -s $SESSION_NAME -n main -c $PROJECT_PATH -x 184 -y 49

    # Split right ~16% (30 of 184 cols) - pane 3: right column (pnpm tauri dev)
    tmux split-window -h -t "$SESSION_NAME:main.1" -c $PROJECT_PATH -p 27

    # Split pane 1 vertically, bottom ~10% (5 of 49 rows) - pane 2: shell
    tmux split-window -v -t "$SESSION_NAME:main.1" -c $PROJECT_PATH -p 20

    # Pane layout (actual tmux numbering after splits)
    # main.1 - top-left     (neovim)
    # main.2 - bottom-left  (shell)
    # main.3 - right        (pnpm tauri dev)

    tmux send-keys -t "$SESSION_NAME:main.1" "nvim ." C-m
    tmux send-keys -t "$SESSION_NAME:main.3" "pnpm tauri dev" C-m

    # Leave focus on nvim pane
    tmux select-pane -t "$SESSION_NAME:main.1"
end
