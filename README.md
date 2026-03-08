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
