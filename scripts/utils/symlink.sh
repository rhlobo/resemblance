#!/bin/bash


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


assureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET PATCH_FILE
	INTENDED_LINK_TARGET=$1
	LINK=$2

	if [ ! -d "${INTENDED_LINK_TARGET}" ] && [ ! -f "${INTENDED_LINK_TARGET}" ]; then return; fi;

	log "Assuring symlink '${LINK}' to '${INTENDED_LINK_TARGET}'"
	if [ -h "${LINK}" ]; then
		CURRENT_LINK_TARGET=`ls -l ${LINK} | awk '{print $11}'`
		if [ "${CURRENT_LINK_TARGET}" == "${INTENDED_LINK_TARGET}" ]; then 
			log "\tThe link already is set."
			return 
		fi 
		sudo mv "${LINK}" "${LINK}.old"
		log "\tOld symlink ${LINK} renamed."
	elif [ -d "${LINK}" ] || [ -f "${LINK}" ]; then
		if [ -f "${LINK}" ]; then
			PATCH_FILE="${INTENDED_LINK_TARGET}_`hostname`_`date +%F_%T`.patch"
			diff -uNr "${INTENDED_LINK_TARGET}" "${LINK}" > "${PATCH_FILE}"
			log "\tFile ${LINK} already exists but will be replaced. Rollback patch created: '${PATCH_FILE}'"
		fi
		sudo rm -R "${LINK}"		
	fi
	log "\tCreating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"
	sudo ln -s "${INTENDED_LINK_TARGET}" "${LINK}"
}