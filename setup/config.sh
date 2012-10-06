#!/bin/bash


## LOADING HELPER FUNCTIONS
loadScript() {
	#v0.1
	local UTIL_SCRIPT_FILE UTIL_SCRIPT_FILENAME
	UTIL_SCRIPT_FILENAME=$1

	UTIL_SCRIPT_FILE="$(dirname $(readlink -f $0))/UTIL_SCRIPT_FILENAME"
	if [ -f "${UTIL_SCRIPT_FILE}" ]; then ."${UTIL_SCRIPT_FILE}"; return;
	elif [ -d "${SCRIPTS_ORIGIN_PATH}" ]; then 
		UTIL_SCRIPT_FILE="${SCRIPTS_ORIGIN_PATH}/${UTIL_SCRIPT_FILENAME}"
	else 
		UTIL_SCRIPT_FILE="${HOME}/scripts/${UTIL_SCRIPT_FILENAME}"
	fi

	if [ ! -f "${UTIL_SCRIPT_FILE}" ] then exit 1; fi

	. "${UTIL_SCRIPT_FILE}"
}
loadScript "/utils/symlink.sh"
loadScript "/utils/config.sh"


## SETTING UP CONFIGURATION AND SCRIPTS DIRECTORY
### Setup script folder into computer
assureSymlink ${SCRIPTS_ORIGIN_PATH} ${SCRIPTS_LINK_PATH}

### Update machine dependency (package) list
updateHostDependenciesDescription "${CONFIG_BASE_PATH}" "${HOST_NAME}"


#!!!!!!!!!!!!!! SHOULD CALL ANOTHER SCRIPT
# Creates a folder for host configuration


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## LOADING HELPER FUNCTIONS
#		MAKE UTIL THAT HAS THIS FUNCTION
#			IF NEEDED UTIL FILES DONT EXIST, TRY IN THE INSTALLATION DIRECTORY, IF NOT, USE THE DIRECTORY INFO TO FETCH THEM FROM THE GITHUB REPO
# EDIT TO MAKE IT PRETTY INTO HTML WITH MARKUT

# COMMAND TO MAKE SNAPSHOT
# COMMAND TO REVERT SNAPSHOT
# COMMAND TO DESTROY SNAPSHOT
# COMMAND TO LIST SNAPSHOTS

# COMMAND TO TURN OFF MONITOR

# GIT_REPOSITORY_URL should be setg by param, keeping the curr as a default
# GIT_REPOSITORY_URL should be divided into two repositories, one for the configuration files and one for the script files.

# COMMAND TO CREATE A FILE(S) THAT DETAILS A HOST CONFIGURATION
# COMMAND TO APPLY A HOST CONFIGURATION INTO THE CURRENT HOST

# COMMAND TO SAVE INSTALLED PACKAGES INTO A FILE
# COMMAND TO APPLY PACKAGES FROM A FILE

# USE SPARKLESHARE OR UNISON OR RSYNC TO SYNC DATA FILES BETWEEN HOSTS > The more automatic the better
# CONFIGURE SHELL (bash or zsh)
#	Configure shell path
# 	Configure shell aliases, functions and other configurations


# Configure dropbox, google drive (insync), ...
