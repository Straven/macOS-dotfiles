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
- **Minimal but powerful**: Clean configurations that don't sacrifice functionality
- **Nushell**: Structured, modern shell with powerful data manipulation
- **Neovim**: Extensible editor with IDE-like capabilities

## Core Components

### Window Management

- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** - Tiling window manager for macOS
- **[skhd](https://github.com/koekeishiya/skhd)** - Simple hotkey daemon for macOS
- **[sketchybar](https://github.com/FelixKratz/SketchyBar)** - Custom menu bar replacement
- **[borders](https://github.com/FelixKratz/borders)** - Window border system

### Terminal & Shell

- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-accelerated terminal emulator with native session management
- **[Ghostty](https://ghostty.org/)** - Fast, feature-rich terminal emulator (kept as backup)
- **[Nushell](https://www.nushell.sh/)** - Structured, modern shell
- **[Starship](https://starship.rs/)** - Fast, customizable shell prompt

### Editor & Development

- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor
- **[Zed](https://zed.dev/)** - High-performance, multiplayer code editor

### File Management & Navigation

- **[yazi](https://github.com/sxyazi/yazi)** - Blazing fast terminal file manager
- **[lf](https://github.com/gokcehan/lf)** - Terminal file manager
- **[eza](https://github.com/eza-community/eza)** - Modern replacement for ls

### Utilities

- **[bat](https://github.com/sharkdp/bat)** - Cat clone with syntax highlighting
- **[btop](https://github.com/aristocratos/btop)** - Resource monitor
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** - System information tool

## Repository Structure

```
.
├── aerospace/        # Tiling window manager configuration
├── bat/              # Syntax highlighting and theming
├── bin/              # Custom scripts and utilities
├── borders/          # Window border configuration
├── btop/             # System monitor configuration
├── eza/              # File listing configuration
├── fastfetch/        # System info display configuration
├── ghostty/          # Terminal emulator settings (backup)
├── kitty/            # Primary terminal emulator configuration
├── lf/               # File manager configuration
├── nushell/          # Shell configuration
├── nvim/             # Neovim configuration
├── sketchybar/       # Menu bar configuration
├── skhd/             # Hotkey daemon configuration
├── starship/         # Shell prompt configuration
├── yazi/             # File manager configuration
└── zed/              # Code editor configuration
```

## Features

### 🎨 Visual Experience

- Custom menu bar with system information
- Window borders for better focus indication
- Consistent color scheme (Tokyo Night Flash Goddess Storm) across all applications
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
- Native Kitty session management with startup layouts
- Smart window picker via fzf overlay (`Ctrl+a > s`)
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
git clone https://github.com/Straven/macOS-dotfiles.git
```

2. Install core dependencies via Homebrew:

```bash
brew install \
  aerospace skhd sketchybar borders \
  nushell neovim \
  kitty ghostty \
  yazi lf eza bat btop fastfetch \
  starship zed
```

3. Symlink configurations:

```bash
ln -s /path/to/macos-dotfiles/kitty ~/.config/kitty
ln -s /path/to/macos-dotfiles/nvim ~/.config/nvim
ln -s /path/to/macos-dotfiles/nushell ~/.config/nushell
# Continue for other configs as needed...
```

4. Start services:

```bash
brew services start skhd
brew services start sketchybar
brew services start borders
# AeroSpace starts automatically on login
```

5. Change your default shell to Nushell:

```bash
echo /opt/homebrew/bin/nu | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/nu
```

## Key Bindings Highlights

### Window Management (skhd + AeroSpace)

| Binding                 | Action                          |
| ----------------------- | ------------------------------- |
| `alt + h/j/k/l`         | Focus window                    |
| `alt + 1-6`             | Switch to specific workspace    |
| `alt + t`               | Toggle float for current window |
| `alt + f`               | Toggle fullscreen               |
| `shift + alt + h/j/k/l` | Move window                     |

### Terminal (Kitty — Ctrl+a prefix)

| Binding            | Action                      |
| ------------------ | --------------------------- |
| `Ctrl+a > \|`      | Vertical split              |
| `Ctrl+a > -`       | Horizontal split            |
| `Ctrl+a > h/j/k/l` | Focus pane                  |
| `Ctrl+a > c`       | New tab                     |
| `Ctrl+a > 1-5`     | Go to tab                   |
| `Ctrl+a > s`       | Window/session picker (fzf) |

### Application Launchers

| Binding         | Application      |
| --------------- | ---------------- |
| `cmd + alt + t` | Kitty (Terminal) |
| `cmd + alt + o` | Obsidian         |
| `cmd + alt + b` | Safari           |
| `cmd + alt + z` | Zed              |
| `cmd + alt + c` | Claude           |

See [skhd/skhdrc](skhd/skhdrc) for complete keybinding documentation.

## Customization

If you want to use these dotfiles as a base:

1. **Fork this repository**
2. **Review each configuration file** - understand what each setting does
3. **Modify to your preferences** - update color schemes, keybindings, tools
4. **Test incrementally** - don't apply everything at once

### Configuration Files to Customize First

- `skhd/skhdrc` - Keyboard shortcuts
- `aerospace/aerospace.toml` - Window management behavior
- `nushell/config.nu` - Shell aliases and functions
- `kitty/kitty.conf` - Terminal appearance and keybindings
- `nvim/` - Editor configuration

## Notes

- This setup assumes a keyboard-centric workflow
- Some configurations may require macOS accessibility permissions
- AeroSpace does not require SIP to be disabled
- Regular updates to dependencies recommended

## ⚠️ Not Used

The `not-used/` directory contains configs that were used in the past or simply
tried out and left behind. There is **no guarantee** these configs are functional
or up to date. Kept for reference only.

| Directory      | Description                                     |
| -------------- | ----------------------------------------------- |
| `alacritty/`   | Terminal emulator — replaced by Kitty/Ghostty   |
| `fish/`        | Shell — replaced by Nushell                     |
| `hammerspoon/` | macOS automation — replaced by AeroSpace + skhd |
| `kanata/`      | Keyboard remapper — replaced by Karabiner       |
| `rift/`        | Window manager — evaluated, not adopted         |
| `sesh/`        | tmux session manager — no longer using tmux     |
| `tmux/`        | Terminal multiplexer — replaced by Kitty native |
| `yabai/`       | Window manager — replaced by AeroSpace          |
| `zellij/`      | Terminal workspace — replaced by Kitty native   |

## License

These dotfiles are personal configurations. Feel free to use, modify, and learn
from them, but use at your own risk.

---

**Note**: These are living configurations that evolve with my workflow.
