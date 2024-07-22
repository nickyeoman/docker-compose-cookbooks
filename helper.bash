#!/bin/bash

HLPR_COOKBOOKDIR="$(dirname "$(realpath "$BASH_SOURCE")")"
HLPR_PROJECTNAME='NEW_PROJECT'
HLPR_PROJECTPATH=$HOME
HLPR_PROJECTDIR="$HLPR_PROJECTPATH/$HLPR_PROJECTNAME"
HLPR_CONTAINERS=''

#source ./_helper/debug.sh
# debug_print_helper_variables

################################################
# Pre Check
################################################
source ./_helper/precheck.sh
check_fzf
check_pwgen

################################################
# Display Header
################################################
source ./_helper/header.sh
display_header

################################################
# Get Project Name
################################################
source ./_helper/project-name.sh
get_project_name

################################################
# Get Project Path
################################################
source ./_helper/project-path.sh
select_directory_with_fzf
HLPR_PROJECTDIR="$HLPR_PROJECTPATH/$HLPR_PROJECTNAME"

################################################
# Select containers
################################################
source ./_helper/select-containers.sh
select_directories

################################################
# Create Project Directory
################################################
source ./_helper/project-create.sh
handle_project_creation "$HLPR_PROJECTPATH" "$HLPR_PROJECTNAME"

################################################
# Create a .gitignore
################################################
source ./_helper/gitignore.sh
create_gitignore "$HLPR_PROJECTDIR"

################################################
# Create a README.md
################################################
source ./_helper/readme.sh
create_readme "$HLPR_PROJECTDIR" "$HLPR_PROJECTNAME" "$HLPR_CONTAINERS"

################################################
# Create docker-compose
################################################
source ./_helper/dockercompose.sh
create_dockercompose "$HLPR_PROJECTDIR" "$HLPR_CONTAINERS" "$HLPR_COOKBOOKDIR"

################################################
# Create env
################################################
source ./_helper/env.sh
create_env "$HLPR_PROJECTDIR" "$HLPR_CONTAINERS" "$HLPR_COOKBOOKDIR"

################################################
# Create directories
################################################
source ./_helper/dirs.sh
create_dirs "$HLPR_PROJECTDIR" "$HLPR_CONTAINERS" "$HLPR_COOKBOOKDIR"

################################################
# Display Footer
################################################
source ./_helper/footer.sh
display_footer