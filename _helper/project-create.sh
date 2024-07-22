#!/bin/bash

# Function to check if the project directory already exists
check_project() {
    local path="$1"
    if [ -d "$path" ]; then
        echo "Error: Directory '$path' already exists."
        return 1
    fi
    return 0
}

# Function to create the project directory
create_project() {
    local path="$1"
    mkdir -p "$path"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory '$path'. Exiting."
        exit 1
    fi
}

# Function to handle the project directory creation process
handle_project_creation() {
    local project_path="$1"
    local project_name="$2"

    while true; do
        check_project "$HLPR_PROJECTDIR"
        if [ $? -eq 0 ]; then
            create_project "$HLPR_PROJECTDIR"
            break
        else
            read -p "Please enter a new directory path (must not exist): " new_project_path
            if [ -z "$new_project_path" ]; then
                echo "Error: Path cannot be empty. Exiting."
                exit 1
            fi
            project_path="$new_project_path"
            HLPR_PROJECTDIR="$project_path/$project_name"
        fi
    done
}
