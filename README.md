# Dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/).

## Installation

1. Install yadm:
   ```bash
   # Arch Linux
   sudo pacman -S yadm

   # Ubuntu/Debian
   sudo apt install yadm

   # macOS
   brew install yadm
   ```

2. Clone via HTTPS and bootstrap:
   ```bash
   yadm clone https://github.com/<username>/dotfiles.git
   yadm bootstrap
   ```

   The bootstrap script will:
   - Generate an SSH key if one doesn't exist
   - Display the public key for you to add to GitHub
   - Switch the remote to SSH after setup

If you already have conflicting dotfiles, use `--force` to overwrite:
```bash
yadm clone --force https://github.com/<username>/dotfiles.git
```

## Font

This setup requires **Iosevka Nerd Font** for proper rendering of icons and glyphs (used by Neovim, lualine, etc.).

Install it from [Nerd Fonts](https://www.nerdfonts.com/font-downloads) or via a package manager:

```bash
# Arch Linux
sudo pacman -S ttf-iosevka-nerd

# macOS
brew install --cask font-iosevka-nerd-font
```

Then set `IosevkaNerdFont` (or `IosevkaNFM` for mono) as your terminal font.
