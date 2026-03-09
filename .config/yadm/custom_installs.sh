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
