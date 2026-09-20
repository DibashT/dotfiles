# My Fedora Sway Dotfiles

My personal configuration for Fedora running Sway on Wayland.

This repo contains the configs I use for my daily desktop setup:

- Sway
- Waybar
- Ghostty
- Neovim
- Tmux
- Rofi
- Swaylock
- Wlogout
- MPD and rmpc
- Fastfetch
- Lazygit
- Zsh

## Structure

```text
.
├── fastfetch/    # System information
├── ghostty/      # Terminal configuration and shaders
├── lazygit/      # Lazygit configuration
├── mpd/          # MPD configuration
├── nvim/         # Neovim configuration
├── rmpc/         # MPD client configuration
├── rofi/         # Application launcher
├── sway/         # Sway configuration and scripts
├── swaylock/     # Screen locker
├── tmux/         # Tmux configuration
├── waybar/       # Status bar
├── wlogout/      # Logout menu
└── .zshrc        # Zsh configuration
```

## Setup

Clone the repository:

```bash
git clone https://github.com/DibashT/dotfiles.git ~/dotfiles
```

I use symlinks so changes made in the repository are immediately used by the applications.

Example:

```bash
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/sway ~/.config/sway
ln -s ~/dotfiles/ghostty ~/.config/ghostty
ln -s ~/dotfiles/tmux ~/.config/tmux
ln -s ~/dotfiles/waybar ~/.config/waybar
ln -s ~/dotfiles/rofi ~/.config/rofi
ln -s ~/dotfiles/.zshrc ~/.zshrc
```

Back up any existing configuration before creating the links.

## Neovim

The Neovim configuration is written from scratch in Lua.

It does not use LazyVim or `lazy.nvim`. Plugins are installed with Neovim's native package manager using `vim.pack.add()`.

The main configuration is in:

```text
nvim/init.lua
```

It currently includes:

- LSP
- Treesitter
- FZF-Lua
- Blink completion
- Mason
- DAP
- Oil
- Lazygit
- CodeDiff
- Lualine
- Mini.nvim
- Alpha
- Markdown rendering

Neovim 0.12 or newer is required.

## Reloading

```bash
# Reload Sway
swaymsg reload

# Reload Waybar
killall -SIGUSR2 waybar

# Reload tmux
tmux source-file ~/.config/tmux/tmux.conf

# Restart MPD
systemctl --user restart mpd
```

## Notes

This is a personal configuration, so some paths and commands may need to be changed before using it on another machine.

I mainly use this setup with Fedora, Sway, Wayland, Ghostty, and Neovim.
