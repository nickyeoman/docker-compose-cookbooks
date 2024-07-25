#!/bin/bash

# Function to parse and handle the variable
extract_image_name() {
    local dirty_img="$1"

    if [[ "$dirty_img" == *\$* ]]; then
        extracted_value=$(echo "$dirty_img" | sed -n 's/.*:-\([^}]*\)}.*/\1/p')
    else
        extracted_value=$dirty_img
    fi

    echo "$extracted_value"
}

