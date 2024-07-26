#!/bin/bash

BLDR_IMAGE_VAR="\${${BLDR_APP^^}_IMAGE:-$BLDR_DC_IMAGE}"

# Generate Docker Compose content and save it to a variable
BLDR_NEW_DCF=$(cat <<EOF
version: '3.4'

services:
  stash:
    image: $BLDR_IMAGE_VAR
    restart: unless-stopped
    environment:
$(echo "$BLDR_DC_ENV" | sed 's/^/      - /')
    volumes:
$(echo "$BLDR_DC_VOLS" | sed 's/^/      - /')
EOF
)

# Print the variable to verify the content
echo "$BLDR_NEW_DCF" > ${BLDR_DIR}/docker-compose.yml
