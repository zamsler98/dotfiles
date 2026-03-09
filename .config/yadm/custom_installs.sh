#!/bin/bash

# Custom installation scripts
#
# For each custom package, define:
#   check_<name>()   - returns 0 if already installed, non-zero otherwise
#   install_<name>() - performs the installation
#
# Names must match the package name in packages.txt with hyphens/spaces
# replaced by underscores (e.g. "oh-my-zsh" -> "oh_my_zsh").

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
