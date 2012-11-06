#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/directory.sh"
. "${SCRIPTS_BASE_PATH}/utils/symlink.sh"
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


## SETTING UP CONFIGURATION AND SCRIPTS DIRECTORY
log "-\033[1m Assuring scripts directory link existence.\033[0m"
assureSymlink ${SCRIPTS_BASE_PATH} ${SCRIPTS_LINK_PATH}

log "-\033[1m Assuring host configuration directory existence.\033[0m"
assureDirectory "${CONFIG_HOST_PATH}"

log "-\033[1m Assuring host configuration files directory existence.\033[0m"
assureDirectory "${CONFIG_HOST_FILES_PATH}"


## ASSURING ALL PROFILE FILES ARE SYMLINKED
log "-\033[1m Scanning profile file hierarchy assuring everything is symlinked correctly.\033[0m"
assureMultiSymlink "${CONFIG_HOST_FILES_PATH}" "${LINKING_ROOT_PATH}"


## HANDLING DEPENDECIES
log "-\033[1m Verifying if profile's dependency file exists at '${CONFIG_HOST_DEPENDENCIES_FILE}'.\033[0m"
if [ ! -d "${CONFIG_HOST_DEPENDENCIES_FILE}" ]; then
	log "-- Creating profile's dependency file '${CONFIG_HOST_DEPENDENCIES_FILE}'."
	. "${UPDATE_DEPENDENCY_EXECUTABLE}"
fi

log "\033[0;35m---------------------------------------------------------------------------------------------------\033[0m"
log "\033[0;34m All profile files are contained withing a git repository. \033[0m"
log "\033[0;34m You should manage your profiles manually. Use git to do it. \033[0m"
log ""
log "\033[0;34m The current profile's configuration files can be found within '\033[1;34m${CONFIG_HOST_FILES_PATH}\033[0;34m'. \033[0m"
log "\033[0;34m - Running this script, you can assure there are symbolic links on the desired locations for each of the configuration files. \033[0m"
log ""
log "\033[0;34m The current profile's dependency file can be found in '\033[1;34m${CONFIG_HOST_DEPENDENCIES_FILE}\033[0;34m'. \033[0m"
log "\033[0;34m - Dependencies are to be handled manually: The update and setup scripts will not change it after the initial creation. \033[0m"
log ""
log "\033[0;34m To update the dependency file from the machine current state, use: \033[0m"
log "\033[1;33m  $ . ${UPDATE_DEPENDENCY_EXECUTABLE} \033[0m"
log "\033[0;34m To update the machine current state from the dependency file, applying it, use: \033[0m"
log "\033[1;33m  $ . ${UPDATE_MACHINE_EXECUTABLE} \033[0m"
log ""
log "\033[0;34m Scripts can also be executed from '\033[1;34m${SCRIPTS_LINK_PATH}\033[0;34m'. \033[0m"
log "\033[0;34m Read the documentation for more information. \033[0m"
log "\033[0;35m---------------------------------------------------------------------------------------------------\033[0m"
