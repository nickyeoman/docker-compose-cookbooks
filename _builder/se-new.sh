#!/bin/bash

BLDR_NEW_SE+="# $BLDR_APP\n"

while IFS= read -r line; do
  # Use a regex to match and extract variable names and defaults
  if [[ $line =~ \$\{([A-Za-z_][A-Za-z0-9_]*)\} ]]; then
    # Matched ${VAR_NAME} (without default)
    var_name="${BASH_REMATCH[1]}"
    BLDR_NEW_SE+="${var_name}=\n"
  elif [[ $line =~ \$\{([A-Za-z_][A-Za-z0-9_]*)[:-](.*)\} ]]; then
    # Matched ${VAR_DEF:-default} (with default)
    var_name="${BASH_REMATCH[1]}"
    default_value="${BASH_REMATCH[2]:1}"
    BLDR_NEW_SE+="${var_name}=${default_value}\n"
  fi
done <<< "$BLDR_NEW_DCF"

# Remove duplicates from the output
BLDR_NEW_SE=$(echo -e "$BLDR_NEW_SE" | sort -u)

echo "***** NEW sample.env *****"
echo "$BLDR_NEW_SE"