## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET patch_file aux link_dir
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
			patch_file="${INTENDED_LINK_TARGET}_${PROFILE_NAME}_(`hostname`)_`date +%F_%T`.patch"
			diff -uNr "${INTENDED_LINK_TARGET}" "${LINK}" > "${patch_file}"
			log "--- File ${LINK} already exists but will be replaced. Rollback patch created: '${patch_file}'"
		fi
		sudo rm -R "${LINK}"		
	fi

	link_dir="$(dirname ${LINK})"
	log "--- Verifying needed directory for link creation (${link_dir})."
	if [ ! -d "${link_dir}" ]; then
		log "---- Creating needed directory structure '${link_dir}'..."
		mkdir -p "${link_dir}"
	else
		log "---- Directory structure is okay."
	fi

	aux="${INTENDED_LINK_TARGET}${SYMLINK_PRESCRIPT_SUFFIX}"
	log "--- Verifying the existance of a symlink pre script '${aux}'."
	if [ -f "${aux}" ]; then
		chmod +x "${aux}"
		log "---- Symlink pre script '${aux}' found: executing."
		cd "${link_dir}"
		. "${aux}"
		cd "${EXECUTION_PATH}"
	fi

	log "--- Creating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"
	sudo ln -s "${INTENDED_LINK_TARGET}" "${LINK}"

	aux="${INTENDED_LINK_TARGET}${SYMLINK_POSSCRIPT_SUFFIX}"
	log "--- Verifying the existance of a symlink pos script '${aux}'."
	if [ -f "${aux}" ]; then
		chmod +x "${aux}"
		log "---- Symlink pos script '${aux}' found: executing."
		cd "${link_dir}"
		. "${aux}"
		cd "${EXECUTION_PATH}"
	fi
}


assureMultiSymlink() {
	local TARGET_ROOT LINK_ROOT TARGET_LIST
	TARGET_ROOT=$1
	LINK_ROOT=$2

	log "-- Multi-symlinking '${LINK_ROOT}' to '${TARGET_ROOT}'"
	TARGET_LIST=$(find "${TARGET_ROOT}" -type f | grep -v "${SYMLINK_IGNORE_SUFFIX}$" | grep -v "${SYMLINK_DIRECTORY_SUFFIX}$" | grep -v "${SYMLINK_PRESCRIPT_SUFFIX}$" | grep -v "${SYMLINK_POSSCRIPT_SUFFIX}$" | grep -v "~$")
	for file in $(find "${TARGET_ROOT}" -type f | grep "${SYMLINK_DIRECTORY_SUFFIX}$" | sed "s/${SYMLINK_DIRECTORY_SUFFIX}//g"); do
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
	TARGET_FILE=$1
	LINK_ROOT=$2
	REGEX="s/^.*\/${PROFILES_FOLDER_NAME-"profiles"}\/${PROFILE_NAME-$(hostname)}\/config\//\//g"
	LINK=$(echo "${file}" | sed "${REGEX}")

	assureSymlink "${TARGET_FILE}" "${LINK_ROOT}${LINK}"
}

_fakeAssureSymlink() {
	local INTENDED_LINK_TARGET LINK CURRENT_TARGET patch_file aux link_dir
	INTENDED_LINK_TARGET=$1
	LINK=$2

	if [ ! -d "${INTENDED_LINK_TARGET}" ] && [ ! -f "${INTENDED_LINK_TARGET}" ]; then 
		log "!!! File not found: '${INTENDED_LINK_TARGET}'."
		return; 
	fi

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
			patch_file="${INTENDED_LINK_TARGET}_${PROFILE_NAME}_(`hostname`)_`date +%F_%T`.patch"
			log "--- File ${LINK} already exists but will be replaced. Rollback patch created: '${patch_file}'"
		fi
	fi

	log "--- Verifying needed directory for link creation."
	aux="$(dirname ${LINK})"
	if [ ! -d "${aux}" ]; then
		log "---- Creating needed directory structure '${aux}'..."
	else
		log "---- Directory structure is okay."
	fi
	
	link_dir="$(dirname ${LINK})"
	log "--- Verifying needed directory for link creation (${link_dir})."
	if [ ! -d "${link_dir}" ]; then
		log "---- Creating needed directory structure '${link_dir}'..."
	else
		log "---- Directory structure is okay."
	fi

	aux="${INTENDED_LINK_TARGET}${SYMLINK_PRESCRIPT_SUFFIX}"
	log "--- Verifying the existance of a symlink pre script '${aux}'."
	if [ -f "${aux}" ]; then
		log "---- Symlink pre script '${aux}' found: executing."
		cd "${link_dir}"
		cd "${EXECUTION_PATH}"
	fi

	log "--- Creating new symlink '${LINK}' from '${INTENDED_LINK_TARGET}'"

	aux="${INTENDED_LINK_TARGET}${SYMLINK_POSSCRIPT_SUFFIX}"
	log "--- Verifying the existance of a symlink pos script '${aux}'."
	if [ -f "${aux}" ]; then
		log "---- Symlink pos script '${aux}' found: executing."
		cd "${link_dir}"
		cd "${EXECUTION_PATH}"
	fi
}
