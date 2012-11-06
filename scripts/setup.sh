#!/bin/bash


## COMMUNICATING SETUP
sudo echo -e "-\033[1m Initializing setup\033[0m"


## DEFINING HELPER FUNCTIONS
writeVariableFile() {
	local FILE
	FILE=$1

	echo '#!/bin/bash' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '## CONFIGURATION VARIABLES' >> "${FILE}"
	echo 'BASE_PATH="/home/shared"' >> "${FILE}"
	echo "PROFILE_NAME=\"$(hostname)\"" >> "${FILE}"
	echo "LINKING_ROOT_PATH=\"${HOME}\"" >> "${FILE}"
	echo 'GIT_REPOSITORY_URL="https://github.com/rhlobo/homeConfig.git"' >> "${FILE}"
	echo '# GIT_REPOSITORY_URL="git@github.com:rhlobo/homeConfig.git"' >> "${FILE}"
	echo 'GIT_READONLY_REPOSITORY_URL="git://github.com/rhlobo/homeConfig.git"' >> "${FILE}"
	echo 'SYMLINK_DIRECTORY_SUFFIX=".resemble_dir"' >> "${FILE}"
	echo 'SYMLINK_PRESCRIPT_SUFFIX=".resemble_prescript"' >> "${FILE}"
	echo 'SYMLINK_POSSCRIPT_SUFFIX=".resemble_posscript"' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '## SECONDARY VARIABLES (SHOULD NOT CONFIGURE)' >> "${FILE}"
	echo 'GIT_LOCAL_BRANCH="work"' >> "${FILE}"
	echo 'PROFILES_FOLDER_NAME="profiles"' >> "${FILE}"
	echo 'GIT_LOCAL_REPOSITORY_PATH="${BASE_PATH}/resemblance"' >> "${FILE}"
	echo 'SCRIPT_CURRENT_PATH="$(dirname $(readlink -f $0))"' >> "${FILE}"
	echo 'SCRIPTS_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/scripts"' >> "${FILE}"
	echo 'SCRIPTS_LINK_PATH="${HOME}/.resemblance"' >> "${FILE}"
	echo 'CONFIG_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/${PROFILES_FOLDER_NAME}"' >> "${FILE}"
	echo 'CONFIG_HOST_PATH="${CONFIG_BASE_PATH}/${PROFILE_NAME}"' >> "${FILE}"
	echo 'CONFIG_HOST_FILES_PATH="${CONFIG_HOST_PATH}/config"' >> "${FILE}"
	echo 'CONFIG_HOST_APTREPOS_PATH="${CONFIG_HOST_PATH}/apt"' >> "${FILE}"
	echo 'CONFIG_HOST_DEPENDENCIES_FILE="${CONFIG_HOST_PATH}/dependency.list"' >> "${FILE}"
	echo 'SETUP_EXECUTABLE="${SCRIPTS_BASE_PATH}/setup.sh"' >> "${FILE}"
	echo 'UPDATE_EXECUTABLE="${SCRIPTS_BASE_PATH}/update.sh"' >> "${FILE}"
	echo 'UPDATE_DEPENDENCY_EXECUTABLE="${SCRIPTS_BASE_PATH}/update-dependency-file.sh"' >> "${FILE}"
	echo 'UPDATE_MACHINE_EXECUTABLE="${SCRIPTS_BASE_PATH}/update-machine-dependencies"' >> "${FILE}"
	echo 'EXECUTION_PATH="$(pwd)"	' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '## TEMPORARY CONFIGURATIONS (SHOULD BE REMOVED SOMETIME)' >> "${FILE}"	
	echo 'CONFIG_HOST_DEPENDENCIES_SCRIPT="${CONFIG_HOST_PATH}/dependency[common-current].cfg"' >> "${FILE}"
	echo 'INITIAL_CONFIG_DEPENDENCIES_FILE="${CONFIG_BASE_PATH}/clean-ubuntu-12.04/dependency.list"' >> "${FILE}"
}
log() {
	echo "$@" >&2
    return 0
}


## CREATING CONFIGURATION FILE
CONFIG_FILE="${HOME}/.resemblancerc"
if [ ! -f "${CONFIG_FILE}" ]; then
	writeVariableFile "${CONFIG_FILE}"
	sudo chmod +x "${CONFIG_FILE}"
	"${EDITOR-vi}" "${CONFIG_FILE}"
fi
. "${CONFIG_FILE}"


## LOADING HELPER FUNCTIONS
if [ -f "${SCRIPTS_BASE_PATH}/utils/log.sh" ]; then 
	. "${SCRIPTS_BASE_PATH}/utils/log.sh"
fi


## INSTALLING DEPENDENCIES
#### Installing git
log "-\033[1m Assuring that git is installed and updated...\033[0m" 
sudo apt-get -y install git


## SETUP BASE PATH
#### Creating base path [if needed]
if [ ! -d ${BASE_PATH} ]; then
	log "-\033[1m Creating the base directory: '${BASE_PATH}'\033[0m" 
	sudo mkdir -p ${BASE_PATH}
	sudo chown ${USER}:${USER} ${BASE_PATH}
fi


## LOADING USER HOME CONFIGURATION AND SCRIPTS DIRECTORY
#### Creating repository path [if needed]
if [ ! -d ${GIT_LOCAL_REPOSITORY_PATH} ]; then
	log "-\033[1m Creating the repository directory: '${GIT_LOCAL_REPOSITORY_PATH}'\033[0m" 
	sudo mkdir -p ${GIT_LOCAL_REPOSITORY_PATH}
	sudo chown ${USER}:${USER} ${GIT_LOCAL_REPOSITORY_PATH}
fi

#### Clone script and configuration into local git repository
###### Clone git repository [if needed]
cd "${GIT_LOCAL_REPOSITORY_PATH}"
log "-\033[1m Checking if the local git repository is configured.\033[0m" 
if [ "`git rev-parse --is-inside-work-tree`" ]; then 
	log "-- The local repository is already set." 
else
	log "-- Creating local repository in ${GIT_LOCAL_REPOSITORY_PATH}" 
	git clone ${GIT_REPOSITORY_URL} ${GIT_LOCAL_REPOSITORY_PATH}
	if [ "`git rev-parse --is-inside-work-tree`" ]; then 
		log "--- The local repository is now set." 
	else
		log "--- Could not clone the repository as authenticated user. Going to use read-only mode."
		git clone ${GIT_READONLY_REPOSITORY_URL} ${GIT_LOCAL_REPOSITORY_PATH}
	fi
fi
###### Create a branch [if needed]
log "-\033[1m Checking if local branch '${GIT_LOCAL_BRANCH}' exists.\033[0m" 
git show-ref --verify --quiet refs/heads/${GIT_LOCAL_BRANCH} || {
	log "-- Creating local branch '${GIT_LOCAL_BRANCH}'" 
	git branch "${GIT_LOCAL_BRANCH}"
}
git checkout "${GIT_LOCAL_BRANCH}"
log "-\033[1m Returning to the execution directory:\033[0m" 
cd "${EXECUTION_PATH}"


## CONFIGURATING HOST
if [ -f "${UPDATE_EXECUTABLE}" ]; then
	log "-\033[1m Loading setup configuration script '${UPDATE_EXECUTABLE}'.\033[0m"
	. ${UPDATE_EXECUTABLE}
else
	log "[ERROR] NOT POSSIBLE TO FIND '${UPDATE_EXECUTABLE}'. ABORTING..."
	exit 1
fi


## FINALIZING SETUP
#### Returning to the execution directory
log "-\033[1m Returning to the execution directory\033[0m" 
cd "${EXECUTION_PATH}"

#### Displaying success message
log "\033[1mSetup is complete.\033[0m"