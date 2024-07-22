#!/bin/bash

# Function to list all directories in the same directory as the helper script and allow the user to select multiple directories
select_directories() {
    # Get the directory where this script is located
    local script_dir=$(dirname "$(realpath "$0")")

    # Find all directories in the same directory as the helper script and get their basenames, excluding those starting with an underscore
    local dir_list=$(find "$script_dir" -maxdepth 1 -type d -not -path '*/\.*' -not -path "$script_dir" -not -name '_*' | xargs -I {} basename {})

    # Use fzf to allow the user to select multiple directories with checkboxes
    local selected_dirs=$(echo "$dir_list" | fzf --multi --height 40% --layout=reverse --border --prompt="Select directories (TAB to toggle, ENTER to confirm): " --bind 'tab:toggle+down')

    # Handle the case where no directory was selected
    if [ -z "$selected_dirs" ]; then
        echo "No directories selected. Exiting."
        exit 1
    fi

    HLPR_CONTAINERS="$selected_dirs"
}