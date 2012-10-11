#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/directory.sh"
. "${SCRIPTS_BASE_PATH}/utils/symlink.sh"
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


echo "$(dirname /home/shared/resemblance/profiles/oncast-rhlobo/config)"