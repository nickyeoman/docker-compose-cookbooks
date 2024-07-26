#!/bin/bash

process_env_vars() {
    local env_vars="$1"  # Accept the environment variables as the first parameter
    local APP_NAME="$(echo "$2" | tr '[:lower:]' '[:upper:]')"  # Convert app name to uppercase
    local results=()     # Array to collect results

    # Loop through each environment variable
    while IFS= read -r env_var; do
        # Split into name and value parts based on '='
        var_name="${env_var%%=*}"  # Variable name
        var_value="${env_var#*=}"  # Variable value

        # Handle variables without existing braces (not previously processed)
        if [[ "$var_value" != *'${'* ]]; then
            modified_var="${var_name}: \${${APP_NAME}_${var_name}:-${var_value}}"
        else
            # Handle variables already having ${} and possible default
            ref_var="${var_value#\$\{}"
            ref_var="${ref_var%%[:-]*}"

            # Extract the default value part
            default_value="${var_value##*:-}"
            default_value="${default_value%\}}"

            # Check if the reference variable already contains APP_NAME_ prefix
            if [[ "$ref_var" == ${APP_NAME}_* ]]; then
                # Use the reference variable as is if it already contains the prefix
                modified_var="${var_name}: \${${ref_var}:-${default_value}}"
            else
                # Add APP_NAME_ prefix to reference variable
                modified_var="${var_name}: \${${APP_NAME}_${ref_var}:-${default_value}}"
            fi
        fi

        # Append the modified variable to results
        results+=("$modified_var")
    done <<< "$env_vars"

    # Output the results joined with new lines
    printf "%s\n" "${results[@]}" | sort
}