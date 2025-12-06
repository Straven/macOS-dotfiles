# macOS Dotfiles

> My personal macOS configuration files for a keyboard-driven, terminal-centric
> development environment.

## Overview

This repository contains configuration files for a highly optimized macOS
development setup focused on productivity, efficiency, and keyboard-driven
workflows. Built around the philosophy of minimal mouse usage and maximum
terminal power.

## Philosophy

- **Keyboard-first**: Extensive use of hotkeys and keyboard navigation
- **Terminal-centric**: Heavy reliance on CLI tools and TUI applications
- **Minimal but powerful**: Clean configurations that don't sacrifice
  functionality
- **Fish shell**: Modern shell with sensible defaults and excellent
  autocompletion
- **Neovim**: Extensible editor with IDE-like capabilities

## Core Components

### Window Management

- **[yabai](https://github.com/koekeishiya/yabai)** - Tiling window manager for
  macOS
- **[skhd](https://github.com/koekeishiya/skhd)** - Simple hotkey daemon for
  macOS
- **[sketchybar](https://github.com/FelixKratz/SketchyBar)** - Custom menu bar
  replacement
- **[borders](https://github.com/FelixKratz/borders)** - Window border system

### Terminal & Shell

- **[Ghostty](https://ghostty.org/)** - Fast, feature-rich terminal emulator
- **[Fish](https://fishshell.com/)** - Smart and user-friendly command line
  shell
- **[tmux](https://github.com/tmux/tmux)** - Terminal multiplexer
- **[Starship](https://starship.rs/)** - Fast, customizable shell prompt

### Editor & Development

- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor
- **[Sesh](https://github.com/joshmedeski/sesh)** - Smart session manager for
  tmux

### File Management & Navigation

- **[lf](https://github.com/gokcehan/lf)** - Terminal file manager
- **[yazi](https://github.com/sxyazi/yazi)** - Blazing fast terminal file
  manager
- **[eza](https://github.com/eza-community/eza)** - Modern replacement for ls

### Utilities

- **[bat](https://github.com/sharkdp/bat)** - Cat clone with syntax highlighting
- **[btop](https://github.com/aristocratos/btop)** - Resource monitor
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** - System
  information tool

## Repository Structure

```
.
├── bat/              # Syntax highlighting and theming
├── bin/              # Custom scripts and utilities
├── borders/          # Window border configuration
├── btop/             # System monitor configuration
├── eza/              # File listing configuration
├── fastfetch/        # System info display configuration
├── fish/             # Fish shell configuration
├── ghostty/          # Terminal emulator settings
├── lf/               # File manager configuration
├── nvim/             # Neovim configuration
├── sesh/             # Session manager configuration
├── sketchybar/       # Menu bar configuration
├── skhd/             # Hotkey daemon configuration
├── starship/         # Shell prompt configuration
├── tmux/             # Terminal multiplexer configuration
├── yabai/            # Window manager configuration
└── yazi/             # File manager configuration
```

## Features

### 🎨 Visual Experience

- Custom menu bar with system information
- Window borders for better focus indication
- Consistent color scheme across all applications
- Beautiful terminal UI with modern fonts

### ⌨️ Keyboard-Driven Workflow

- Extensive hotkey bindings for window management
- Vim-style navigation everywhere possible
- Custom keybindings for common tasks
- Quick app launching with keyboard shortcuts

### 🚀 Performance

- Optimized shell startup time
- Lazy-loading for heavy plugins
- Efficient window management
- Fast file navigation

### 🔧 Developer Tools

- Full IDE-like experience in Neovim
- Integrated terminal multiplexing
- Smart session management
- Git integration throughout

## Quick Start

### Prerequisites

- macOS (tested on recent versions)
- [Homebrew](https://brew.sh/)
- Git

### Installation

> **Warning**: Review the code before running any installation scripts. These
> dotfiles are highly personalized and may not suit your workflow without
> modification.

1. Clone the repository:

```bash
git clone https://github.com/Straven/macOS-dotfiles.git ~/.config
```

2. Install core dependencies via Homebrew:

```bash
brew install \
  yabai skhd sketchybar borders \
  fish tmux neovim \
  ghostty \
  lf yazi eza bat btop fastfetch \
  starship
```

3. Symlink configurations (example):

```bash
# Fish shell
ln -sf ~/.config/fish ~/.config/fish

# Neovim
ln -sf ~/.config/nvim ~/.config/nvim

# Continue for other configs as needed...
```

4. Start services:

```bash
# Start yabai and skhd
brew services start yabai
brew services start skhd
brew services start sketchybar
brew services start borders
```

5. Change your default shell to Fish:

```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

## Key Bindings Highlights

### Window Management (skhd + yabai)

| Binding                | Action                          |
| ---------------------- | ------------------------------- |
| `alt + j/k`            | Cycle through stacked windows   |
| `alt + 1-6`            | Switch to specific space        |
| `alt + t`              | Toggle float for current window |
| `alt + f`              | Toggle fullscreen               |
| `shift + alt + arrows` | Stack windows                   |
| `ctrl + alt + cmd + y` | Restart yabai                   |

### Application Launchers

| Binding         | Application        |
| --------------- | ------------------ |
| `cmd + alt + t` | Ghostty (Terminal) |
| `cmd + alt + o` | Obsidian           |
| `cmd + alt + b` | Safari             |
| `cmd + alt + z` | Zed                |
| `cmd + alt + c` | Claude             |

See [skhd/skhdrc](skhd/skhdrc) for complete keybinding documentation.

## Customization

### Personalizing These Dotfiles

If you want to use these dotfiles as a base:

1. **Fork this repository**
2. **Review each configuration file** - understand what each setting does
3. **Modify to your preferences**:
   - Update color schemes
   - Adjust keybindings
   - Remove unwanted tools
   - Add your own scripts to `bin/`
4. **Test incrementally** - don't apply everything at once

### Configuration Files to Customize First

- `skhd/skhdrc` - Keyboard shortcuts
- `yabai/yabairc` - Window management behavior
- `fish/config.fish` - Shell aliases and functions
- `ghostty/config` - Terminal appearance
- `nvim/` - Editor configuration

## Notes

- This setup assumes a keyboard-centric workflow
- Some configurations may require macOS accessibility permissions
- yabai requires System Integrity Protection (SIP) partial disable for advanced
  features
- Regular updates to dependencies recommended

## Inspiration

This configuration draws inspiration from the broader dotfiles community,
particularly:

- [dotfiles.github.io](https://dotfiles.github.io/) community
- Various macOS power users and their setups
- The philosophy of keyboard-driven computing

## License

These dotfiles are personal configurations. Feel free to use, modify, and learn
from them, but use at your own risk.

## Support

If you find issues or have questions:

- Open an issue in this repository
- Review the official documentation for each tool
- Check the dotfiles community resources

---

**Note**: These are living configurations that evolve with my workflow. Not all
changes may be documented immediately.
