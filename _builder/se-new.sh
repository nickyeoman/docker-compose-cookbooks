#!/bin/bash

BLDR_ENV_FILE+="# $BLDR_APP\n"
BLDR_ENV_FILE+="COOKBOOK=/git/docker-compose-cookbooks #HELP: cookbooks\n"

while IFS= read -r line; do
  # Use a regex to match and extract variable names and defaults
  if [[ $line =~ \$\{([A-Za-z_][A-Za-z0-9_]*)\} ]]; then
    # Matched ${VAR_NAME} (without default)
    var_name="${BASH_REMATCH[1]}"
    BLDR_ENV_FILE+="${var_name}=\n"
  elif [[ $line =~ \$\{([A-Za-z_][A-Za-z0-9_]*)[:-](.*)\} ]]; then
    # Matched ${VAR_DEF:-default} (with default)
    var_name="${BASH_REMATCH[1]}"
    default_value="${BASH_REMATCH[2]:1}"
    BLDR_ENV_FILE+="${var_name}=${default_value}\n"
  fi
done <<< "$BLDR_NEW_DCF"

# Remove duplicates from the output
BLDR_ENV_FILE=$(echo -e "$BLDR_ENV_FILE" | sort -u)

echo "$BLDR_ENV_FILE" > ${BLDR_DIR}/sample.env
