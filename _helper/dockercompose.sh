#!/bin/bash

# Function to create a new docker-compose file using extends
create_dockercompose() {
    local project_path="$1"
    local selected_dirs="$2"
    local script_dir="$3"  # Directory where helper.bash is located

    # Initialize the new docker-compose file
    local new_compose_file="$project_path/docker-compose.yml"

    # Write the initial part of the docker-compose file
    echo "version: '3.4'" > "$new_compose_file"
    echo "" >> "$new_compose_file"
    echo "services:" >> "$new_compose_file"

    # Loop through selected directories
    for dir in $selected_dirs; do
        local sample_file="$script_dir/$dir/sample-extends.yml"

        if [ -f "$sample_file" ]; then
            # Extract services section from the sample file and append it
            awk '/^services:/{flag=1; next}/^$/{flag=0}flag' "$sample_file" >> "$new_compose_file"
            echo "" >> "$new_compose_file"  # Add a newline after each file's content
        else
            echo "Warning: Create an issue: No sample-extends.yml found in $dir"
            cp $script_dir/$dir/docker-compose.yml $new_compose_file
        fi
    done
}
