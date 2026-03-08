#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/packages.txt"

detect_package_manager() {
    if command -v brew &>/dev/null; then
        echo "brew"
    elif command -v apt &>/dev/null; then
        echo "apt"
    else
        echo "unknown"
    fi
}

install_or_update_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo "Updating $pkg..."
        sudo apt install --only-upgrade -y "$pkg"
    else
        echo "Installing $pkg..."
        sudo apt install -y "$pkg"
    fi
}

install_or_update_brew() {
    local pkg="$1"
    if brew list "$pkg" &>/dev/null; then
        echo "Updating $pkg..."
        brew upgrade "$pkg" 2>/dev/null || echo "$pkg is already up to date"
    else
        echo "Installing $pkg..."
        brew install "$pkg"
    fi
}

sync_packages() {
    local pm
    pm=$(detect_package_manager)

    echo ""
    echo "=== Package Sync ==="
    echo "Detected package manager: $pm"
    echo ""

    if [[ "$pm" == "unknown" ]]; then
        echo "Error: No supported package manager found (brew or apt)"
        exit 1
    fi

    if [[ "$pm" == "apt" ]]; then
        echo "Updating apt cache..."
        sudo apt update
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ || -z "${line// }" ]] && continue

        # Parse the line: name | apt_name | brew_name
        IFS='|' read -ra parts <<< "$line"

        local default_name apt_name brew_name pkg_name
        default_name=$(echo "${parts[0]}" | xargs)
        apt_name=$(echo "${parts[1]:-$default_name}" | xargs)
        brew_name=$(echo "${parts[2]:-$default_name}" | xargs)

        if [[ "$pm" == "apt" ]]; then
            pkg_name="$apt_name"
        else
            pkg_name="$brew_name"
        fi

        # Skip if marked with "-"
        if [[ "$pkg_name" == "-" ]]; then
            echo "Skipping $default_name (not available for $pm)"
            continue
        fi

        if [[ "$pm" == "apt" ]]; then
            install_or_update_apt "$pkg_name"
        else
            install_or_update_brew "$pkg_name"
        fi

    done < "$PACKAGES_FILE"

    echo ""
    echo "Package sync complete!"
}

sync_packages
