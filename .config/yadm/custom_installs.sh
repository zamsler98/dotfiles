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
