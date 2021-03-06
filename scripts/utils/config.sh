## LOADING CONFIGURATION
. "${HOME}/.resemblancerc"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


updateHostDependenciesDescription() {
	local DEPENDENCIES_FILE
	DEPENDENCIES_FILE="$1"

	log "Updating host's installed package list '${DEPENDENCIES_FILE}'."
	sudo dpkg --get-selections | sed "s/\s*deinstall//" | sed "s/\s*install$//g" > "${DEPENDENCIES_FILE}"
}

updateMachineDependenciesFromDescription() {
	local DEPENDENCIES_FILE
	DEPENDENCIES_FILE="$1"

	log "Updating host's installed package list '${DEPENDENCIES_FILE}'."
	sudo dpkg --get-selections | sed "s/\s*deinstall//" | sed "s/\s*install$//g" > "${DEPENDENCIES_FILE}"
	sudo apt-get update && cat "${DEPENDENCIES_FILE}" | xargs sudo apt-get install -y
}

_echoPackageToFile() {
	local OUTPUT_FILE PACKAGE PREFIX_SYMBOL aux
	OUTPUT_FILE=$1
	PACKAGE=$2
	PREFIX_SYMBOL=$3

	aux=$(apt-cache search ${PACKAGE} | grep "^${PACKAGE}\s.*$" | sed "s/^\S*\s-\s//g")
	_echoToOutAndFile "${OUTPUT_FILE}" "###### ${aux}"
	_echoToOutAndFile "${OUTPUT_FILE}" "${PREFIX_SYMBOL}${PACKAGE}"
	_echoToOutAndFile "${OUTPUT_FILE}" ""
}

_echoToOutAndFile() {
	local MESSAGE OUTPUT_FILE
	OUTPUT_FILE=$1
	MESSAGE=$2

	log "${MESSAGE}"
	echo "${MESSAGE}" >> "${OUTPUT_FILE}"
}

createDependencyInstallationScript() {
	local FILE1 FILE2 OUTPUT_FILE PACKAGES_TO_INSTALL PACKAGES_TO_UNINSTALL i
	FILE1=$1
	FILE2=$2
	OUTPUT_FILE=$3

	log "Creating dependency installation script from '${FILE1}' to '${FILE2}'."
	if [ ! -f "${FILE1}" ]; then log "- '${FILE1}' does not exist."; fi
	if [ ! -f "${FILE2}" ]; then log "- '${FILE2}' does not exist."; fi

	echo "" > "${OUTPUT_FILE}"
	_echoToOutAndFile "${OUTPUT_FILE}" "## DEPENDENCY SYNC DESCRIPTION FILE"

	_echoToOutAndFile "${OUTPUT_FILE}" ""
	_echoToOutAndFile "${OUTPUT_FILE}" ""
	_echoToOutAndFile "${OUTPUT_FILE}" "#### PACKAGES TO UNINSTALL"
	PACKAGES_TO_UNINSTALL=$(diff -adNrw --unified=1 --suppress-common-lines "${FILE1}" "${FILE2}" | grep "^[-][^-+]\S*" | sed "s/^[-+]//g")
	for i in $(echo ${PACKAGES_TO_UNINSTALL}); do
		_echoPackageToFile "${OUTPUT_FILE}" "${i}" "-"
	done

	_echoToOutAndFile "${OUTPUT_FILE}" ""
	_echoToOutAndFile "${OUTPUT_FILE}" ""
	_echoToOutAndFile "${OUTPUT_FILE}" "#### PACKAGES TO INSTALL"
	PACKAGES_TO_INSTALL=$(diff -adNrw --unified=1 --suppress-common-lines "${FILE1}" "${FILE2}" | grep "^[+][^-+]\S*" | sed "s/^[-+]//g")
	for i in $(echo ${PACKAGES_TO_INSTALL}); do
		_echoPackageToFile "${OUTPUT_FILE}" "${i}" "+"
	done
}