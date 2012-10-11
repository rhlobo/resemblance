## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureDirectory() {
	local DIR_PATH
	DIR_PATH="$1"

	if [ ! -d "${DIR_PATH}" ]; then
		log "-- Creating directory '${DIR_PATH}'"
		mkdir -p "${DIR_PATH}"
	else
		log "-- Directory already exists in '${DIR_PATH}'."
	fi
}