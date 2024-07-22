#!/bin/bash

process_help_comments() {
    local input_file="$1"
    local output_file="$2"
    local project_path="$3"
    local cookbook_dir="$4"
    
    local temp_file=$(mktemp)

    while IFS= read -r line; do
        # Handle headings (keep headings and process below lines)
        if [[ "$line" =~ ^# ]]; then
            echo "$line" >> "$temp_file"
        elif [[ "$line" =~ ^([^=]+)= ]]; then
            local var_name="${BASH_REMATCH[1]}"
            local var_value="${line#*=}"
            var_value=$(echo "$var_value" | sed 's/\s*#HELP:.*$//')
            
            # Process #HELP comments
            if [[ "$line" =~ \#HELP:\ project_path ]]; then
                var_value="$HLPR_PROJECTPATH"
            elif [[ "$line" =~ \#HELP:\ volpath ]]; then
                var_value="$HLPR_PROJECTPATH/data"
			elif [[ "$line" =~ \#HELP:\ configpath ]]; then
                var_value="$HLPR_PROJECTPATH/config"
            elif [[ "$line" =~ \#HELP:\ cookbooks ]]; then
                var_value="$HLPR_COOKBOOKDIR"
            elif [[ "$line" =~ \#HELP:\ gen32 ]]; then
                var_value=$(pwgen -cnsB1v 32)
            fi

            # Add the processed variable to the temp file
            echo "${var_name}=${var_value}" >> "$temp_file"
        else
            # If the line doesn't match a variable, just echo it
            echo "$line" >> "$temp_file"
        fi
    done < "$input_file"

    # Call remove_duplicate_variables to process temp_file and write to output_file
    cat "$temp_file" >> $output_file
    rm "$temp_file"
}

remove_duplicate_variables() {
	local input_file="$1"
	local temp_file=$(mktemp)
	declare -A seen_keys

	while IFS= read -r line; do
		
		# Skip lines that start with # or are blank
		if [[ ! $line =~ ^# ]] && [[ -n $line ]]; then
			# Extract the part before the equals sign
			key=$(echo "$line" | awk -F '=' '{print $1}')
			
			# Check if the key has already been seen
			if [[ -z "${seen_keys[$key]}" ]]; then
				# Mark the key as seen
				seen_keys[$key]=1
				# Output the key
				echo "$line" >> "$temp_file"
			fi
		else
			echo "$line" >> "$temp_file"
		fi
	done < "$input_file"

	# Replace the original file with the deduplicated version
	mv "$temp_file" "$input_file"
}

# Function to create .env file
create_env() {
	local project_path="$1"
	local selected_dirs="$2"
	local cookbook_dir="$3"
	local new_env_file="$project_path/.env"
	local current_date=$(date)
	local git_user=$(git config --get user.name)
	if [[ -z "$git_user" ]]; then
		local git_user=$USER
	fi

	# Create the file
	touch $new_env_file
	echo "# Auto Generated env file on $current_date by $git_user" >> "$new_env_file"

	# Loop through selected directories and process sample.env files
	for dir in $selected_dirs; do
		local sample_file="$cookbook_dir/$dir/sample.env"

		if [ -f "$sample_file" ]; then
			process_help_comments "$sample_file" "$new_env_file" "$project_path" "$cookbook_dir"
		else
			echo "Warning: Create an issue: No sample.env found in $dir" >&2
			echo "#No Sample File found, raise a bug" >> "$new_env_file"
		fi
	done

	remove_duplicate_variables "$new_env_file"

}
