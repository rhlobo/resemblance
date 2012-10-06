#!/bin/bash

## CONFIGURATION VARIABLES
DEPENDENCIES_FILE_NAME="dependency.list"
DEPENDENCIES_SCRIPT_FILE_NAME="dependency.installation.script"
DEFAULT_DEPENDENCIES_FILE_NAME="../common.dependency.list"


## LOADING HELPER FUNCTIONS
. "$(dirname $(readlink -f $0))/log.sh"


_assureHostConfigDirectory() {
	local BASE_CONFIG_PATH ENV_NAME ENV_CONFIG_PATH
	BASE_CONFIG_PATH=$1
	ENV_NAME=$2
	ENV_CONFIG_PATH="${BASE_CONFIG_PATH}/${ENV_NAME}"

	log "Assuring host configuration directory existence."
	if [ ! -d "${ENV_CONFIG_PATH}" ]; then
		log "\t Creating host configuration directory '${ENV_CONFIG_PATH}'"
		mkdir -p "${ENV_CONFIG_PATH}"
	else
		log "\t Host configuration directory already exists in '${ENV_CONFIG_PATH}'."
	fi
}

updateHostDependenciesDescription() {
	local BASE_CONFIG_PATH ENV_NAME ENV_CONFIG_PATH DEPENDENCIES_FILE PACKAGES i aux
	BASE_CONFIG_PATH=$1
	ENV_NAME=$2
	ENV_CONFIG_PATH="${BASE_CONFIG_PATH}/${ENV_NAME}"
	DEPENDENCIES_FILE="${ENV_CONFIG_PATH}/DEPENDENCIES_FILE_NAME"

	_assureHostConfigDirectory "${BASE_CONFIG_PATH}" "${ENV_NAME}"

	log "Updating host's installed package list '${DEPENDENCIES_FILE}'."
	sudo dpkg --get-selections | sed "s/.*deinstall//" | sed "s/install$//g" > "${DEPENDENCIES_FILE}"

	log "Creating installation script that reproduces this host in "
	PACKAGES=$(cat "${DEPENDENCIES_FILE}")
	echo "" > "${DEPENDENCIES_SCRIPT_FILE_NAME}"
	for i in $(echo ${PACKAGES}); do
		aux=$(apt-cache search ${i} | grep "^${i}\s.*$" | sed "s/^\S*\s-\s//g")
		echo -e "#*** ${aux}" >> "${DEPENDENCIES_SCRIPT_FILE_NAME}"
		echo -e "${i}" >> "${DEPENDENCIES_SCRIPT_FILE_NAME}"
		echo -e "" >> "${DEPENDENCIES_SCRIPT_FILE_NAME}"
	done
}