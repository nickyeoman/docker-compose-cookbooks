#!/bin/bash

debug_print_helper_variables() {
    for var in $(compgen -v | grep '^HLPR_'); do
        echo "$var=${!var}"
    done
}