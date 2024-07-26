#!/bin/bash

# List all directories in the current directory that don't start with an underscore
directories=$(find . -maxdepth 1 -type d -not -name '_*' -exec basename {} \; | grep -v '[_\.]' | sort -r)

# Use fzf to allow the user to select a directory
selected_dir=$(echo "$directories" | fzf --prompt="Select a directory: ")

# Check if a directory was selected
if [[ -z "$selected_dir" ]]; then
  echo "No directory selected."
  return 1
fi

# Set the BLDR_DIR variable to the selected directory
BLDR_DIR="${BLDR_PARENT_PATH}/${selected_dir}"
BLDR_APP=${selected_dir}
