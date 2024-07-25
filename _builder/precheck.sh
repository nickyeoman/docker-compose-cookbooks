#!/bin/bash

# Function to check if a command is installed and provide installation instructions if not
check_command() {
    local command_name="$1"

    if ! command -v "$command_name" &> /dev/null; then
        echo "$command_name is not installed."
        echo "To install $command_name:"
        
        case "$(uname -s)" in
            Linux*)
                if [ -f /etc/os-release ]; then
                    . /etc/os-release
                    case "$ID" in
                        fedora)
                            echo "  - Fedora: sudo dnf install $command_name"
                            ;;
                        arch)
                            echo "  - Arch: sudo pacman -S $command_name"
                            ;;
                        debian | ubuntu)
                            echo "  - Debian/Ubuntu: sudo apt install $command_name"
                            ;;
                        *)
                            echo "  - On other Linux distros, refer to your package manager's documentation."
                            ;;
                    esac
                else
                    echo "  - Linux: refer to your package manager's documentation for installation."
                fi
                ;;
            Darwin*)
                echo "  - macOS: brew install $command_name (Homebrew)"
                ;;
            *)
                echo "  - Unsupported OS. Please install $command_name manually."
                ;;
        esac

        exit 1
    fi
}
