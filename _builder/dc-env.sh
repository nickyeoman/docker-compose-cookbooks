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

        # Check if the variable value contains a reference to another variable with the format ${VAR_NAME:-default}
        if [[ "$var_value" == *'${'*':'*'}'* ]]; then
            # Extract the variable inside the ${} braces
            ref_var="${var_value#\$\{}"
            ref_var="${ref_var%%[:-]*}"

            # Extract the default value part
            default_value="${var_value##*:-}"
            default_value="${default_value%\}}"

            # Check if the reference variable already contains APP_NAME_ prefix
            if [[ "$ref_var" == ${APP_NAME}_* ]]; then
                # If it already contains the prefix, use it as is
                modified_var="${var_name}=\${${ref_var}:-${default_value}}"
            else
                # If not, add the APP_NAME_ prefix
                modified_var="${var_name}=\${${APP_NAME}_${ref_var}:-${default_value}}"
            fi
        else
            # For variables without ${VAR_NAME} references
            if [[ "$var_name" == ${APP_NAME}_* ]]; then
                # If the variable name already starts with APP_NAME_, do not prefix again
                modified_var="${var_name}=${var_value}"
            else
                # Add APP_NAME_ prefix for consistency
                modified_var="${var_name}=\${${APP_NAME}_${var_name}:-${var_value}}"
            fi
        fi

        # Append the modified variable to results
        results+=("$modified_var")
    done <<< "$env_vars"

    # Output the results joined with new lines
    printf "%s\n" "${results[@]}" | sort
}