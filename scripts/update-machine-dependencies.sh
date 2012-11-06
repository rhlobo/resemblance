#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


log "- Updating machine description based on dependency file '${CONFIG_HOST_DEPENDENCIES_FILE}'."
#updateMachineDependenciesFromDescription "${CONFIG_HOST_DEPENDENCIES_FILE}"

#log "- Creating dependency synchorization script based on the current profile's dependency file."
#createDependencyInstallationScript "${INITIAL_CONFIG_DEPENDENCIES_FILE}" "${CONFIG_HOST_DEPENDENCIES_FILE}" "${CONFIG_HOST_DEPENDENCIES_SCRIPT}"

mkdir -p "${CONFIG_HOST_APTREPOS_PATH}/sources.list.d/"
sudo cp /etc/apt/sources.list.d/* "${CONFIG_HOST_APTREPOS_PATH}/sources.list.d/"
sudo cp /etc/apt/sources.list "${CONFIG_HOST_APTREPOS_PATH}/"

# There's a directory, /etc/apt/sources.list.d/ that contains individual entries for each PPA you've added with add-apt-repository. Those are the files you need to back up.
# cat /etc/apt/sources.list /etc/apt/sources.list.d/*.list > ~/sources.list
# You could then move this file to /etc/apt/sources.list and do sudo apt-get update to re-add the repositories. If you are planning to use this backup on another computer, make sure that the version of Ubuntu on the machine matches the versions in the sources.list file, otherwise, you might have some problems.