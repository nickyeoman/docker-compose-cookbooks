#!/bin/bash

# Function to get user input for project name
get_project_name() {
    while true; do
        read -p "Enter project name (usually the domain name, like www-example-com): " HLPR_PROJECTNAME
        if [[ "$HLPR_PROJECTNAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
            break
        else
            echo "Invalid project name. Please use only letters, numbers, and dashes. No spaces allowed."
        fi
    done
}
