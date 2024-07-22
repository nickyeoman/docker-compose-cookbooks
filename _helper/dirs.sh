#!/bin/bash

# Function to create directories based on volumes in docker-compose files
create_dirs() {
    local project_path="$1"
    local selected_dirs="$2"
    local cookbook_dir="$3"

    local data_dir="$project_path/data"

    # Loop through selected directories
    for dir in $selected_dirs; do
        local compose_file="$cookbook_dir/$dir/docker-compose.yml"

        # Check if the docker-compose file exists
        if [ -f "$compose_file" ]; then
            # Loop through each line in the file
            while IFS= read -r line; do
                trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                # Check if the line starts with a dash
                if [[ $trimmed_line =~ ^- ]]; then
                    if [[ $trimmed_line =~ VOL_PATH ]]; then
                        extracted=$(echo "$trimmed_line" | sed -n 's/.*\${VOL_PATH:-[^}]*}\([^:]*\):.*/\1/p' | sed 's/^\/\+//')
                        # Echo the line if it starts with a dash
                        mkdir -p $project_path/data/${extracted}
                    fi
                fi
            done < "$compose_file"

        else
            echo "Warning: No docker-compose.yml found in $dir"
        fi
    done
}
