#!/bin/bash

## CONFIGURATION VARIABLES
DEPENDENCIES_FILE_NAME="dependency.list"
DEPENDENCIES_SCRIPT_FILE_NAME="dependency.installation.script"
DEFAULT_DEPENDENCIES_FILE_NAME="../../common.dependency.list"


## LOADING HELPER FUNCTIONS
loadScript() {
	#v0.1
	local UTIL_SCRIPT_FILE UTIL_SCRIPT_FILENAME
	UTIL_SCRIPT_FILENAME=$1

	if [ -f "$(dirname $(readlink -f $0))/UTIL_SCRIPT_FILENAME" ]; then 
		UTIL_SCRIPT_FILE="$(dirname $(readlink -f $0))/UTIL_SCRIPT_FILENAME"
	elif [ -d "${SCRIPTS_ORIGIN_PATH}" ]; then 
		UTIL_SCRIPT_FILE="${SCRIPTS_ORIGIN_PATH}/${UTIL_SCRIPT_FILENAME}"
	else 
		UTIL_SCRIPT_FILE="${HOME}/scripts/${UTIL_SCRIPT_FILENAME}"
	fi

	. "${UTIL_SCRIPT_FILE}"
}
loadScript "/utils/log.sh"


_assureHostConfigDirectory() {
	local BASE_CONFIG_PATH ENV_NAME ENV_CONFIG_PATH
	BASE_CONFIG_PATH=$1 
	ENV_NAME=$2
	ENV_CONFIG_PATH="${BASE_CONFIG_PATH}/${ENV_NAME}"

	log "Assuring host configuration directory existence."
	if [ ! -d "${ENV_CONFIG_PATH}" ]; then
		log "Creating host configuration directory '${ENV_CONFIG_PATH}'"
		mkdir -p "${ENV_CONFIG_PATH}"
	else
		log "Host configuration directory already exists in '${ENV_CONFIG_PATH}'."
	fi
}

updateHostDependenciesDescription() {
	local BASE_CONFIG_PATH ENV_NAME ENV_CONFIG_PATH DEPENDENCIES_FILE PACKAGES i aux
	BASE_CONFIG_PATH=$1
	ENV_NAME=$2
	ENV_CONFIG_PATH="${BASE_CONFIG_PATH}/${ENV_NAME}"
	DEPENDENCIES_FILE="${ENV_CONFIG_PATH}/${DEPENDENCIES_FILE_NAME}"
	OLD_DEPENDENCIES_FILE="${ENV_CONFIG_PATH}/${DEFAULT_DEPENDENCIES_FILE_NAME}"

	_assureHostConfigDirectory "${BASE_CONFIG_PATH}" "${ENV_NAME}"

	log "Updating host's installed package list '${DEPENDENCIES_FILE}'."
	sudo dpkg --get-selections | sed "s/.*deinstall//" | sed "s/install$//g" > "${DEPENDENCIES_FILE}"

	log "---------------------------------------------------------------------"
	createDependencyInstallationScript "${OLD_DEPENDENCIES_FILE}" "${DEPENDENCIES_FILE}"
}

createDependencyInstallationScript() {
	local FILE1 FILE2 PACKAGES PACKAGES_TO_INSTALL i aux
	FILE1=$1
	FILE2=$2

	log "Creating dependency installation script from '${FILE1}' to '${FILE2}'."
	if [ ! -f "${FILE1}" ]; then log "- '${FILE1}' does not exist."; fi
	if [ ! -f "${FILE2}" ]; then log "- '${FILE2}' does not exist."; fi

	PACKAGES=$(diff -uNr ${FILE1} ${FILE2} | grep "^[-+][^-+]\S*")
	PACKAGES_TO_INSTALL=$(diff -uNr ${FILE1} ${FILE2} | grep "^[+][^-+]\S*" | sed "s/^[-+]//g")
	PACKAGES_TO_UNINSTALL=$(diff -uNr ${FILE1} ${FILE2} | grep "^[-][^-+]\S*" | sed "s/^[-+]//g")
	for i in $(echo ${PACKAGES_TO_INSTALL}); do
		aux=$(apt-cache search ${i} | grep "^${i}\s.*$" | sed "s/^\S*\s-\s//g")
		echo "#*** ${aux}"
		echo "+${i}"
		echo ""
	done
}