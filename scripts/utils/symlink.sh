## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET PATCH_FILE aux
	INTENDED_LINK_TARGET=$1
	LINK=$2

	if [ ! -d "${INTENDED_LINK_TARGET}" ] && [ ! -f "${INTENDED_LINK_TARGET}" ]; then return; fi;

	log "-- Assuring symlink '${LINK}' to '${INTENDED_LINK_TARGET}'"
	if [ -h "${LINK}" ]; then
		CURRENT_LINK_TARGET=`ls -l ${LINK} | awk '{print $11}'`
		if [ "${CURRENT_LINK_TARGET}" == "${INTENDED_LINK_TARGET}" ]; then 
			log "--- The link already is set."
			return 
		fi 
		sudo mv "${LINK}" "${LINK}.old"
		log "--- Old symlink ${LINK} renamed."
	elif [ -d "${LINK}" ] || [ -f "${LINK}" ]; then
		if [ -f "${LINK}" ]; then
			PATCH_FILE="${INTENDED_LINK_TARGET}_${PROFILE_NAME}_(`hostname`)_`date +%F_%T`.patch"
			diff -uNr "${INTENDED_LINK_TARGET}" "${LINK}" > "${PATCH_FILE}"
			log "--- File ${LINK} already exists but will be replaced. Rollback patch created: '${PATCH_FILE}'"
		fi
		sudo rm -R "${LINK}"		
	fi

	log "--- Verifying needed directory for link creation."
	aux="$(dirname ${LINK})"
	if [ ! -d "${aux}" ]; then
		log "---- Creating needed directory structure '${aux}'..."
		mkdir -p "${aux}"
	else
		log "---- Directory structure is okay."
	fi

	log "--- Creating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"
	sudo ln -s "${INTENDED_LINK_TARGET}" "${LINK}"
}


assureMultiSymlink() {
	local TARGET_ROOT LINK_ROOT TARGET_LIST
	TARGET_ROOT=$1
	LINK_ROOT=$2

	log "Multi-symlinking '${LINK_ROOT}' to '${TARGET_ROOT}'"
	TARGET_LIST=$(find "${TARGET_ROOT}" -type f | grep -v "${DIRECTORY_SYMLINK_FILE_REGEX}")
	for file in $(find "${TARGET_ROOT}" -type f | grep "${DIRECTORY_SYMLINK_FILE_REGEX}" | sed "s/${DIRECTORY_SYMLINK_FILE_REGEX}//g"); do
		TARGET_LIST=$(echo "${TARGET_LIST}" | grep -v "^${file}\/")
		if [ -d "${file}" ]; then
			_shouldAssureSymlink "${file}" "${LINK_ROOT}"
		fi
	done

	for file in $(echo "${TARGET_LIST}" | grep "^\S*"); do
		_shouldAssureSymlink "${file}" "${LINK_ROOT}"
	done
}

_shouldAssureSymlink() {
	local TARGET_FILE LINK_ROOT LINK REGEX
	LINK=$1
	LINK_ROOT=$2
	REGEX="s/^.*\/${PROFILES_FOLDER_NAME-"profiles"}\/${PROFILE_NAME-$(hostname)}\/config\//\//g"
	TARGET_FILE=$(echo "${file}" | sed "${REGEX}")

	_fakeAssureSymlink "${TARGET_FILE}" "${LINK_ROOT}${LINK}"
}

_fakeAssureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET PATCH_FILE aux
	INTENDED_LINK_TARGET=$1
	LINK=$2

	if [ ! -d "${INTENDED_LINK_TARGET}" ] && [ ! -f "${INTENDED_LINK_TARGET}" ]; then return; fi;

	log "-- Assuring symlink '${LINK}' to '${INTENDED_LINK_TARGET}'"
	if [ -h "${LINK}" ]; then
		CURRENT_LINK_TARGET=`ls -l ${LINK} | awk '{print $11}'`
		if [ "${CURRENT_LINK_TARGET}" == "${INTENDED_LINK_TARGET}" ]; then 
			log "--- The link already is set."
			return 
		fi 
		log "--- Old symlink ${LINK} renamed."
	elif [ -d "${LINK}" ] || [ -f "${LINK}" ]; then
		if [ -f "${LINK}" ]; then
			PATCH_FILE="${INTENDED_LINK_TARGET}_${PROFILE_NAME}_(`hostname`)_`date +%F_%T`.patch"
			log "--- File ${LINK} already exists but will be replaced. Rollback patch created: '${PATCH_FILE}'"
		fi
	fi

	log "--- Verifying needed directory for link creation."
	aux="$(dirname ${LINK})"
	if [ ! -d "${aux}" ]; then
		log "---- Creating needed directory structure '${aux}'..."
	else
		log "---- Directory structure is okay."
	fi
	
	log "--- Creating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"
}
