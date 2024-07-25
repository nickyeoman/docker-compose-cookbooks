#!/bin/bash

# Check if BLDR_DIR is set
if [[ -z "$BLDR_DIR" ]]; then
  echo "Error: BLDR_DIR is not set. Please ensure it points to a valid directory."
  exit 1
fi

# Define the path to the docker-compose.yml file
compose_file="$BLDR_DIR/docker-compose.yml"

# Check if the docker-compose.yml file exists
if [[ ! -f "$compose_file" ]]; then
  echo "Error: No docker-compose.yml file found in $BLDR_DIR"
  exit 1
fi

# Read the contents of the docker-compose.yml file into BLDR_OLD_DCF variable
BLDR_OLD_DCF=$(<"$compose_file")
