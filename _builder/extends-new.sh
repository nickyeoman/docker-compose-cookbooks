#!/bin/bash

# Define the content to write to the file
file_content=$(cat <<EOF
version: '3.4'

services:
  $BLDR_APP:
    extends:
      file: \${COOKBOOK}/$BLDR_APP/docker-compose.yml
      service: $BLDR_APP
EOF
)

# Output the content to a file
BLDR_NEW_SE="$file_content" 

echo "***** Sample Extends *****"
echo "$BLDR_NEW_SE"