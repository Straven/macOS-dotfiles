# Fish restart
abbr fish-restart "source ~/.config/fish/config.fish"

# yazi
abbr yz yazi

# Brew
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bin "brew info"
abbr binc "brew info --cask"
abbr bs "brew search"
abbr bl "brew list"
abbr bu "brew uninstall"

# Hugo
abbr hserv "hugo server -D"
abbr hnc "hugo new content$argv[1]"

# EZA
abbr ls "eza --color=always --long --git --icons=always --no-user --no-permissions"
abbr ll "eza -al --icons --git --color --no-user --no-permissions"
abbr lll "eza -alh --long --icons --git --color --no-user --no-permissions"
abbr lst "eza -alh -T --icons --git --color --no-user --no-permissions"
abbr lstl "eza -alh -T --icons --color --git --no-user --no-permissions --level=$argv[1]"

# tmux
abbr -a t tmux
abbr -a ta 'tmux attach'
abbr -a tl 'tmux list-sessions'
abbr -a tn 'tmux new-session -s'
abbr -a tk 'tmux kill-session -t'

# homescreen
abbr -a home homescreen
abbr -a ff refresh_fastfetch

#macos-dotfiles
abbr -a c-mdots macos_dotfiles
abbr -a r-mdots recreate_macos_dotfiles
abbr -a k-mdots kill_macos_dotfiles

# sesh
abbr -a s sesh
abbr -a sc 'sesh connect'
abbr -a sl 'sesh list'

# common
abbr -a v nvim
abbr -a g git
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a gp 'git push'
