#!/bin/bash

# Function to process volumes
process_volumes() {
    local volumes="$1"  # Accept volumes as the first parameter
    local results=()    # Array to collect results

    # Loop through each volume
    while IFS= read -r volume; do
        # Perform actions with each volume
        if [[ "$volume" == *\$* ]]; then
            if [[ "$volume" == *'VOL'* && "$volume" == *'PATH'* ]]; then
                results+=("$volume")
            else
                part="${volume#*\}}/"  # Note the \} to handle the literal }
                part="${part#./}"
                part="${part#/}"
                results+=('${VOL_PATH:-./data}/'"$part")
            fi
        else
            if [[ "${volume:0:1}" == '/' ]]; then
                results+=("$volume")
            else
                if [[ "$volume" == './data'* ]]; then
                    part="${volume#./data}"
                    part="${part#/}"
                    results+=('${VOL_PATH:-./data}/'"$part")
                elif [[ "$volume" == './config'* ]]; then
                    part="${volume#./config}"
                    part="${part#/}"
                    results+=('${VOL_CONFIG_PATH:-./config}/'"$part")
                else
                    part="${volume#./}"
                    results+=("./$part")
                fi
            fi
        fi
        # Add your commands here to handle each volume
    done <<< "$volumes"

    # Output the results joined with new lines
    printf "%s\n" "${results[@]}" | sort
}

