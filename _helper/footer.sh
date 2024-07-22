#!/bin/bash

function display_footer() {
    echo "======================================"
    echo "All Done"
    echo "Created Project: $HLPR_PROJECTNAME in $HLPR_PROJECTDIR"
    echo "With the following containers:"
    echo $HLPR_CONTAINERS   
}