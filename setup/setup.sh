#!/bin/bash

## COMMUNICATING SETUP
sudo echo "Initializing setup"


## DEFINING HELPER FUNCTIONS
writeVariableFile() {
	local FILE
	FILE=$1

	echo '#!/bin/bash' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '## CONFIGURATION VARIABLES' >> "${FILE}"
	echo 'BASE_PATH="/home/shared"' >> "${FILE}"
	echo "PROFILE_NAME=\"$(hostname)\"" >> "${FILE}"
	echo 'GIT_REPOSITORY_URL="https://github.com/rhlobo/homeConfig.git"' >> "${FILE}"
	echo '# GIT_REPOSITORY_URL="git@github.com:rhlobo/homeConfig.git"' >> "${FILE}"
	echo 'GIT_READONLY_REPOSITORY_URL="git://github.com/rhlobo/homeConfig.git"' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '' >> "${FILE}"
	echo '## SECONDARY VARIABLES (SHOULD NOT CONFIGURE)' >> "${FILE}"
	echo 'GIT_LOCAL_BRANCH="work"' >> "${FILE}"
	echo 'GIT_LOCAL_REPOSITORY_PATH="${BASE_PATH}/repo"' >> "${FILE}"
	echo 'SCRIPT_CURRENT_PATH="$(dirname $(readlink -f $0))"' >> "${FILE}"
	echo 'SCRIPTS_ORIGIN_PATH="${GIT_LOCAL_REPOSITORY_PATH}/scripts"' >> "${FILE}"
	echo 'SCRIPTS_LINK_PATH="${HOME}/scripts"' >> "${FILE}"
	echo 'CONFIG_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/config"' >> "${FILE}"
	echo 'HOST_CONFIG_BASE_PATH="${CONFIG_BASE_PATH}/profiles"' >> "${FILE}"
	echo 'HOST_CONFIG_PATH="${HOST_CONFIG_BASE_PATH}/${PROFILE_NAME}"' >> "${FILE}"
	echo 'HOST_CONFIG_DEPENDENCIES_FILE="${HOST_CONFIG_PATH}/dependency.list"' >> "${FILE}"
	echo 'HOST_CONFIG_DEPENDENCIES_SCRIPT="${HOST_CONFIG_PATH}/dependency[common-current].sh"' >> "${FILE}"
	echo 'INITIAL_CONFIG_DEPENDENCIES_FILE="${CONFIG_BASE_PATH}/common.dependency.list"' >> "${FILE}"
	echo 'SETUP_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/setup"' >> "${FILE}"
	echo 'SETUP_EXECUTABLE="${SETUP_BASE_PATH}/setup.sh"' >> "${FILE}"
	echo 'UPDATE_EXECUTABLE="${SETUP_BASE_PATH}/update.sh"' >> "${FILE}"
	echo 'EXECUTION_PATH="$(pwd)"	' >> "${FILE}"
}
log() {
	echo "$@" >&2
    return 0
}


## CREATING CONFIGURATION FILE
CONFIG_FILE="${HOME}/homeConfig"
if [ ! -f "${CONFIG_FILE}" ]; then
	writeVariableFile "${CONFIG_FILE}"
	sudo chmod +x "${CONFIG_FILE}"
	vim "${CONFIG_FILE}"
fi
. "${CONFIG_FILE}"


## INSTALLING DEPENDENCIES
#### Installing git
log "Assuring that git is installed and updated..." 
sudo apt-get -y install git


## SETUP BASE PATH
#### Creating base path [if needed]
if [ ! -d ${BASE_PATH} ]; then
	log "Creating the base directory: '${BASE_PATH}'" 
	sudo mkdir -p ${BASE_PATH}
	sudo chown ${USER}:${USER} ${BASE_PATH}
fi


## LOADING USER HOME CONFIGURATION AND SCRIPTS DIRECTORY
#### Creating repository path [if needed]
if [ ! -d ${GIT_LOCAL_REPOSITORY_PATH} ]; then
	log "Creating the repository directory: '${GIT_LOCAL_REPOSITORY_PATH}'" 
	sudo mkdir -p ${GIT_LOCAL_REPOSITORY_PATH}
	sudo chown ${USER}:${USER} ${GIT_LOCAL_REPOSITORY_PATH}
fi

#### Clone script and configuration into local git repository
###### Clone git repository [if needed]
cd ${GIT_LOCAL_REPOSITORY_PATH}
log "Checking if the local git repository is configured." 
if [ "`git rev-parse --is-inside-work-tree`" ]; then 
	log "The local repository is already set." 
else
	log "Creating local repository in ${GIT_LOCAL_REPOSITORY_PATH}" 
	git clone ${GIT_REPOSITORY_URL} ${GIT_LOCAL_REPOSITORY_PATH}
	if [ "`git rev-parse --is-inside-work-tree`" ]; then 
		log "The local repository was set." 
	else
		log "Could not clone the repository as authenticated user. Going to use read-only mode."
		git clone ${GIT_READONLY_REPOSITORY_URL} ${GIT_LOCAL_REPOSITORY_PATH}
	fi
fi
###### Create a branch [if needed]
log "Checking if local branch '${GIT_LOCAL_BRANCH}' exists." 
git show-ref --verify --quiet refs/heads/${GIT_LOCAL_BRANCH} || {
	log "Creating local branch '${GIT_LOCAL_BRANCH}'" 
	git branch "${GIT_LOCAL_BRANCH}"
}
git checkout "${GIT_LOCAL_BRANCH}"
log "Returning to the execution directory:" 
cd -


## CONFIGURATING HOST
if [ -f "${UPDATE_EXECUTABLE}" ]; then
	log "Loading setup configuration script '${UPDATE_EXECUTABLE}'."
	. ${UPDATE_EXECUTABLE}
else
	log "NOT POSSIBLE TO FIND '${UPDATE_EXECUTABLE}'. ABORTING..."
	exit 1
fi


## FINALIZING SETUP
#### Returning to the execution directory
log "Returning to the execution directory" 
cd "${EXECUTION_PATH}"

#### Displaying success message
log "Setup complete."