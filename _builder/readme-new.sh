#!/bin/bash

# Variables for README content
DESCRIPTION="${DESCRIPTION:-This is a sample project.}"
AUTHOR="${AUTHOR:-Nick Yeoman}"
UPDATED=$(date +"%a %B %d, %Y %H:%M:%S %Z")

# Function to generate a README file
generate_readme() {
  local readme_content=""

  # Header
  readme_content+="# $BLDR_APP\n\n"
  readme_content+="Last Updated: $UPDATED\n\n"

  # Description
  readme_content+="## Description\n"
  readme_content+="$DESCRIPTION\n\n"

  # Usage
  readme_content+="## Usage\n"
  readme_content+="Provide examples of how to use the project:\n\n"
  readme_content+="\`\`\`bash\n"
  readme_content+="# Example command\n"
  readme_content+="\`\`\`\n\n"

  # Environment Variables
  readme_content+="## Environment Variables\n"
  readme_content+="List of environment variables used in the project:\n\n"

  # Extract environment variables from BLDR_NEW_SE
  while IFS= read -r line; do
    # Use regex to match and extract variable names and defaults
    if [[ $line =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      var_name="${BASH_REMATCH[1]}"
      var_value="${BASH_REMATCH[2]}"
      readme_content+="* \`$var_name\`: $var_value\n"
    fi
  done <<< "$BLDR_NEW_SE"

  readme_content+="\n"

  # Author
  readme_content+="## Author\n"
  readme_content+="Developed by $AUTHOR.\n"

  # Output the README content to a file
  echo -e "$readme_content"
}

