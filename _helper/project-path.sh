#!/bin/bash

# Function to display directories using fzf with enhanced parameters
select_directory_with_fzf() {
    # Find all directories under the user's home directory, excluding dot directories and suppressing permission errors
    local fzf_input=$(find "$HOME" -type d -not -path '*/\.*' 2>/dev/null | while read -r dir; do [ -r "$dir" ] && echo "$dir"; done)

    # Use fzf with enhanced parameters for better usability
    selected_path=$(echo "$fzf_input" | fzf --height 40% --layout=reverse --border --preview 'echo {} | xargs -I % du -sh % 2>/dev/null' --preview-window=up:30% --prompt="Select a directory: ")

    # Handle the case where no directory was selected
    if [ -z "$selected_path" ]; then
        echo "No directory selected. Exiting."
        exit 1
    fi

    # Output the selected path
    HLPR_PROJECTPATH="$selected_path"
}
