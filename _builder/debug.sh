#!/bin/bash

debug_print_helper_variables() {
    echo "DEBUGGING $(date +%s): "
    for var in $(compgen -v | grep '^BLDR_'); do
        echo "$var=${!var}"
    done
}