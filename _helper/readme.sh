#!/bin/bash

# Function to create a README.md file
create_readme() {
    local project_path="$1"
    local project_name="$2"
    local selected_dirs="$3"
    local readme_path="$project_path/README.md"
    local current_date=$(date +"%Y-%m-%d")

    # Retrieve the full name from the global Git config
    local git_name=$(git config --global user.name)
    if [ -z "$git_name" ]; then
        echo 'WARNING: Set your git username: git config --global user.name "Your Name"'
        git_name="$USER"
    fi

    # Create the README.md file
    cat <<EOL > "$readme_path"
# $project_name

Project created on $current_date by $git_name

## Description

A brief description of your project goes here.

## Project Structure

This project includes the following containers:

EOL

    # Add the selected directories to the README
    if [ -n "$selected_dirs" ]; then
        echo "$selected_dirs" | while read -r dir; do
            echo "- $(basename "$dir")" >> "$readme_path"
        done
    else
        echo "No containers selected." >> "$readme_path"
    fi

    cat <<EOL >> "$readme_path"

## Usage

podman-compose up -d

EOL
}
