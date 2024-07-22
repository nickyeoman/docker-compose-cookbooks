#!/bin/bash

# Function to check if fzf is installed and provide installation instructions if not
check_fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "fzf is not installed."
        echo "To install fzf:"
        echo "  - Fedora: sudo dnf install fzf"
        echo "  - Arch: sudo pacman -S fzf"
        echo "  - Debian: sudo apt install fzf"
        exit 1
    fi
}

# Function to check if pwgen is installed and provide installation instructions if not
check_pwgen() {
    if ! command -v pwgen &> /dev/null; then
        echo "pwgen is not installed."
        echo "To install pwgen:"
        echo "  - Fedora: sudo dnf install pwgen"
        echo "  - Arch: sudo pacman -S pwgen"
        echo "  - Debian: sudo apt install pwgen"
        exit 1
    fi
}