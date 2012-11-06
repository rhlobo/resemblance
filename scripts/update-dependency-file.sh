#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"

log "- Updating dependency file '${CONFIG_HOST_DEPENDENCIES_FILE}' based on the current machine setup."
updateHostDependenciesDescription "${CONFIG_HOST_DEPENDENCIES_FILE}"
