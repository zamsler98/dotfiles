#!/bin/bash

# Custom installation scripts
#
# For each custom package, define:
#   check_<name>()   - returns 0 if already installed, non-zero otherwise
#   install_<name>() - performs the installation
#
# Names must match the package name in packages.txt with hyphens/spaces
# replaced by underscores (e.g. "oh-my-zsh" -> "oh_my_zsh").

check_yazi() {
    command -v yazi &>/dev/null
}

install_yazi() {
    local tmp_dir
    tmp_dir=$(mktemp -d)
    local latest_url
    latest_url=$(curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest \
        | grep -o '"browser_download_url": *"[^"]*x86_64-unknown-linux-musl.zip"' \
        | grep -o 'https://[^"]*')
    curl -fsSL "$latest_url" -o "$tmp_dir/yazi.zip"
    python3 -c "import zipfile; zipfile.ZipFile('$tmp_dir/yazi.zip').extractall('$tmp_dir')"
    sudo install -m 755 "$tmp_dir"/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi
    rm -rf "$tmp_dir"
}

check_neovim() {
    command -v nvim &>/dev/null
}

install_neovim() {
    if ! command -v curl &>/dev/null; then
        echo "Error: curl is required to install Neovim"
        return 1
    fi

    local tmp_dir
    tmp_dir=$(mktemp -d)
    local latest_url

    # Prefer the linux x86_64 tarball asset
    latest_url=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest \
        | grep -o '"browser_download_url": *"[^"]*nvim-linux64.tar.gz"' \
        | grep -o 'https://[^\"]*' || true)

    if [[ -z "$latest_url" ]]; then
        echo "neovim: failed to find latest linux tarball URL from GitHub releases"
        rm -rf "$tmp_dir"
        return 1
    fi

    echo "neovim: downloading $latest_url"
    curl -fsSL "$latest_url" -o "$tmp_dir/nvim.tar.gz"
    tar -xzf "$tmp_dir/nvim.tar.gz" -C "$tmp_dir"

    # The tarball extracts to a directory named nvim-linux64
    if [[ ! -d "$tmp_dir/nvim-linux64" ]]; then
        echo "neovim: unexpected archive layout"
        rm -rf "$tmp_dir"
        return 1
    fi

    echo "neovim: installing to /usr/local (requires sudo)"
    sudo cp -r "$tmp_dir/nvim-linux64"/* /usr/local/

    # Ensure /usr/local/bin/nvim is executable
    sudo chmod 755 /usr/local/bin/nvim || true

    rm -rf "$tmp_dir"
    echo "neovim: installation complete"
}

check_oh_my_zsh() {
    [[ -d "$HOME/.oh-my-zsh" ]]
}

install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

check_powerlevel10k() {
    [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]
}

install_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
}

check_nvm() {
    local nvm_sh
    nvm_sh="$HOME/.nvm/nvm.sh"

    [[ -s "$nvm_sh" ]] || return 1

    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    . "$nvm_sh"

    [[ "$(nvm version 24)" != "N/A" ]]
}

install_nvm() {
    if ! command -v curl &>/dev/null; then
        echo "Error: curl is required to install nvm"
        return 1
    fi

    export NVM_DIR="$HOME/.nvm"
    mkdir -p "$NVM_DIR"

    if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    fi

    # Load nvm into this non-interactive shell
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"

    nvm install 24
    nvm alias default 24
}

_npm_globals_file() {
    local base_dir
    base_dir="${SCRIPT_DIR:-$HOME/.config/yadm}"
    echo "$base_dir/npm_globals.txt"
}

_ensure_npm_available() {
    if command -v npm &>/dev/null; then
        return 0
    fi

    # If nvm is present, load it so npm/node may become available.
    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        export NVM_DIR="$HOME/.nvm"
        # shellcheck source=/dev/null
        . "$HOME/.nvm/nvm.sh"

        # Prefer default if configured; ignore errors.
        nvm use default &>/dev/null || true
    fi

    command -v npm &>/dev/null
}

_npm_global_installed() {
    local pkg="$1"

    # npm ls exits non-zero when the package isn't installed.
    npm ls -g --depth=0 "$pkg" &>/dev/null
}

check_npm_globals() {
    local globals_file
    globals_file="$(_npm_globals_file)"

    [[ -f "$globals_file" ]] || return 0

    if ! _ensure_npm_available; then
        # Force install step to run so it can emit a warning.
        return 1
    fi

    local line pkg
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^#.*$ || -z "${line// }" ]] && continue
        pkg="$(echo "$line" | xargs)"
        [[ -z "$pkg" ]] && continue

        if ! _npm_global_installed "$pkg"; then
            return 1
        fi
    done < "$globals_file"

    return 0
}

install_npm_globals() {
    local globals_file
    globals_file="$(_npm_globals_file)"

    [[ -f "$globals_file" ]] || {
        echo "npm-globals: no list file found at $globals_file; skipping"
        return 0
    }

    if ! _ensure_npm_available; then
        echo "Warning: npm-globals: 'npm' not found; skipping global npm installs"
        return 0
    fi

    local line pkg
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^#.*$ || -z "${line// }" ]] && continue
        pkg="$(echo "$line" | xargs)"
        [[ -z "$pkg" ]] && continue

        if _npm_global_installed "$pkg"; then
            echo "npm-globals: $pkg already installed, skipping"
        else
            echo "npm-globals: installing $pkg..."
            npm install -g "$pkg"
        fi
    done < "$globals_file"
}
