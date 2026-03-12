# New session helper function

function new_session -d "Create a new tmux session with sesh"
    if command -v sesh &>/dev/null; and command -v gum &>/dev/null
        set -l session_name (gum input --placeholder "Session name")

        if test -n "$session_name"
            tmux new-session -d -s $session_name -c $HOME
            sesh connect $session_name
        else
            echo "✗ Session name required"
            return 1
        end
    else
        echo "✗ sesh or gum not installed"
        echo "Install with: brew install sesh gum"
        return 1
    end
end
