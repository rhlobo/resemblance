## LOADING CONFIGURATION
. "${HOME}/resemblance"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


assureDirectory() {
	local PATH
	PATH="$1"

	if [ ! -d "${PATH}" ]; then
		log "> Creating directory '${PATH}'"
		sudo mkdir -p "${PATH}"
	else
		log "> Directory already exists in '${PATH}'."
	fi
}