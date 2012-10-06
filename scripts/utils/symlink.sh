#!/bin/bash


## SECONDARY VARIABLES (SHOULD NOT CONFIGURE)
SCRIPT_CURRENT_PATH="$(dirname $(readlink -f $0))"


## LOADING HELPER FUNCTIONS
. ${SCRIPT_CURRENT_PATH}/log_utils.sh


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