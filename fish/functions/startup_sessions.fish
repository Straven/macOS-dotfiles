# Single entry point for tmux startup sequence
# Pre-warms all project sessions and attaches to homescreen

function startup_sessions -d "Create all required sessions and launch
homescreen"

    if not tmux has-session -t macos-dotfiles 2>/dev/null
        create_macos_dotfiles_layout
    end

    if not tmux has-session -t registra 2>/dev/null
        create_registra_layout
    end

    launch_homescreen
end
