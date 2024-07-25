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

        # Handle variables with and without default values
        if [[ "$var_value" == *'${'*:*'}'* ]]; then
            # For variables with default values
            modified_var="${var_name}=\${${APP_NAME}_${var_value#\$\{}"
        else
            # For variables without default values
            modified_var="${var_name}=\${${APP_NAME}_${var_name}:-${var_value}}"
        fi

        # Append the modified variable to results
        results+=("$modified_var")
    done <<< "$env_vars"

    # Output the results joined with new lines
    printf "%s\n" "${results[@]}" | sort
}