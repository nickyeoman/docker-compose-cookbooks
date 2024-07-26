#!/bin/bash

BLDR_DIR=""
BLDR_APP=""
BLDR_PARENT_PATH=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
BLDR_OLD_DCF="" # Content of Old Docker Compose File
BLDR_NEW_DCF="" # Content of New Docker Compose File
BLDR_NEW_SE="" # sample-extends
BLDR_NEW_README=""
BLDR_DC_VOLS=""
BLDR_DC_IMAGE=""
BLDR_DC_ENV=""
BLDR_ENV_FILE=""

source ./_builder/debug.sh
#debug_print_helper_variables

################################################
# Pre Check
################################################
source ./_builder/precheck.sh
check_command "fzf"
check_command "yq"

################################################
# Get Directory we are working with
################################################
source ./_builder/getdir.bash
get_directory

################################################
# Save file to work with
################################################
source ./_builder/olddcf.bash

################################################
# Take out the stuff we need
################################################
source ./_builder/parse.bash
BLDR_DC_VOLS=$(get_vols "$BLDR_OLD_DCF")
BLDR_DC_ENV=$(get_env_vars "$BLDR_OLD_DCF")
BLDR_DC_IMAGE=$(get_image "$BLDR_OLD_DCF")
unset BLDR_OLD_DCF # Done, got the stuff we need

################################################
# Clean up the IMAGE
################################################
source ./_builder/dc-image.sh
BLDR_DC_IMAGE=$(extract_image_name "$BLDR_DC_IMAGE")

################################################
# Clean up VOLS
################################################
source ./_builder/dc-vols.sh
BLDR_DC_VOLS=$(process_volumes "$BLDR_DC_VOLS")

################################################
# Clean up ENV
################################################
source ./_builder/dc-env.sh
BLDR_DC_ENV=$(process_env_vars "$BLDR_DC_ENV" "$BLDR_APP")

################################################
# Compile New Docker Var BLDR_NEW_DCF
################################################
source ./_builder/dc-new.sh

################################################
# Create sample-env
################################################
source ./_builder/se-new.sh

################################################
# Create sample-extends
################################################
source ./_builder/extends-new.sh

################################################
# Create Readme.md
################################################
source ./_builder/readme-new.sh
BLDR_NEW_README=$(generate_readme)
echo "$BLDR_NEW_README" > ${BLDR_DIR}/README.md

# TODO: for readme file do mkdir -p data/vols for vols
# Do a git diff on the directory
# fuzzy find latest image using skopeo
# skopeo list-tags docker://docker.io/solidnerd/book