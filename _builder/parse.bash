#!/bin/bash

get_vols() {
    local compose_content="$1"
    local volumes=""

    # Use yq to extract volumes from services
    volumes=$(echo "$compose_content" | yq eval '.services.*.volumes[]' - 2>/dev/null)

    # Print the volumes, preserving line breaks
    printf "%s\n" "$volumes"
}

get_env_vars() {
    local compose_content="$1"
    local env_vars=""

    # Use yq to extract environment variables from services
    env_vars=$(echo "$compose_content" | yq eval '.services.*.environment[]' - 2>/dev/null)

    echo "$env_vars"
}

get_image() {
    local compose_content="$1"
    local images=""

    # Use yq to extract image names from services
    images=$(echo "$compose_content" | yq eval '.services.*.image' - 2>/dev/null)

    echo "$images"
}