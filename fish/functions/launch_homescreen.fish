# Main function for the my homescreen session setup.
# It's launched and attached tmux homescreen session.

function launch_homescreen -d "Launch or attach to tmux homescreen session"
    set -l SESSION_NAME ys-straven-homescreen

    # Check if sesh and gum are available
    if command -v sesh &>/dev/null; and command -v gum &>/dev/null
        # Use sesh for session management
        sesh connect $SESSION_NAME 2>/dev/null
        or begin
            create_homescreen_layout
            sesh connect $SESSION_NAME
        end
    else
        # Fallback to standard tmux
        homescreen
    end
end
