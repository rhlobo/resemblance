#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/resemblance"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/directory.sh"
. "${SCRIPTS_BASE_PATH}/utils/symlink.sh"
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureMultiSymlink /home/shared/repo/profiles/oncast-rhlobo/config /