## LOADING CONFIGURATION
. "${HOME}/resemblance"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET PATCH_FILE
	INTENDED_LINK_TARGET=$1
	LINK=$2

	if [ ! -d "${INTENDED_LINK_TARGET}" ] && [ ! -f "${INTENDED_LINK_TARGET}" ]; then return; fi;

	log "Assuring symlink '${LINK}' to '${INTENDED_LINK_TARGET}'"
	if [ -h "${LINK}" ]; then
		CURRENT_LINK_TARGET=`ls -l ${LINK} | awk '{print $11}'`
		if [ "${CURRENT_LINK_TARGET}" == "${INTENDED_LINK_TARGET}" ]; then 
			log "  The link already is set."
			return 
		fi 
		sudo mv "${LINK}" "${LINK}.old"
		log "  Old symlink ${LINK} renamed."
	elif [ -d "${LINK}" ] || [ -f "${LINK}" ]; then
		if [ -f "${LINK}" ]; then
			PATCH_FILE="${INTENDED_LINK_TARGET}_${PROFILE_NAME(`hostname`)_`date +%F_%T`.patch"
			diff -uNr "${INTENDED_LINK_TARGET}" "${LINK}" > "${PATCH_FILE}"
			log "  File ${LINK} already exists but will be replaced. Rollback patch created: '${PATCH_FILE}'"
		fi
		sudo rm -R "${LINK}"		
	fi
	log "  Creating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"
	sudo ln -s "${INTENDED_LINK_TARGET}" "${LINK}"
}

assureMultiSymlink() {
	local TARGET_ROOT LINK_ROOT
	TARGET_ROOT=$1
	LINK_ROOT=$2

	log "Multi-symlinking '${LINK_ROOT}' to '${TARGET_ROOT}'"
	for file in "find ${TARGET} -type f"; do
		echo "${file}"
	done
}