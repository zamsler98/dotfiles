# Dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/).

## Installation

1. Install yadm:
   ```bash
   # Arch Linux
   pacman -S yadm

   # Ubuntu/Debian
   sudo apt install yadm

   # macOS
   brew install yadm
   ```

2. Clone your dotfiles and run the bootstrap script:
   ```bash
   yadm clone https://github.com/<username>/dotfiles.git
   yadm bootstrap
   ```

   This bootstrap flow is intended for Arch-based systems and expects `pacman` to be available.

   yadm automatically runs `~/.config/yadm/bootstrap`, which will:
   - Install packages listed in `~/.config/yadm/packages/pacman.txt`
   - Install `nvm`
   - Install the current Node.js LTS release
   - Install global npm packages listed in `~/.config/yadm/packages/npm-globals.txt`

If you already have conflicting dotfiles, use `--force` to overwrite:
```bash
yadm clone --force https://github.com/<username>/dotfiles.git
```

## Package Lists

Bootstrap package lists live in `~/.config/yadm/packages/`:

```text
~/.config/yadm/
  bootstrap
  packages/
    pacman.txt
    npm-globals.txt
```

Both package files support one package per line, plus blank lines and `#` comments.

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
