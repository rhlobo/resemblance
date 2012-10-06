#!/bin/bash

## COMMUNICATING SETUP
sudo echo "Initializing setup"


## CONFIGURATION VARIABLES
### Base setup path
BASE_PATH="/home/shared"
GIT_REPOSITORY_URL="https://github.com/rhlobo/homeConfig.git"
# GIT_REPOSITORY_URL="git@github.com:rhlobo/homeConfig.git"
GIT_READONLY_REPOSITORY_URL="git://github.com/rhlobo/homeConfig.git"


## SECONDARY VARIABLES (SHOULD NOT CONFIGURE)
### User configurations, scripts and other files
GIT_LOCAL_REPOSITORY_PATH="${BASE_PATH}/repo"
SCRIPT_CURRENT_PATH="$(dirname $(readlink -f $0))"
SCRIPTS_ORIGIN_PATH="${GIT_LOCAL_REPOSITORY_PATH}/scripts"
SCRIPTS_LINK_PATH="${HOME}/scripts"
CONFIG_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/config"
HOST_CONFIG_BASE_PATH="${CONFIG_BASE_PATH}/hosts"
SETUP_BASE_PATH="${GIT_LOCAL_REPOSITORY_PATH}/setup"
SETUP_SETUP_FILE="${SETUP_BASE_PATH}/setup.sh"
SETUP_CONFIG_FILE="${SETUP_BASE_PATH}/config.sh"
EXECUTION_PATH="$(pwd)"
HOST_NAME="${hostname}"
GIT_LOCAL_BRANCH="work"


## DEFINING HELPER FUNCTIONS
log() {
	echo "$@" >&2
    return 0
}


## INSTALLING DEPENDENCIES
### Installing git
log "Assuring that git is installed and updated..." 
sudo apt-get -y install git


## SETUP BASE PATH
### Creating base path [if needed]
if [ ! -d ${BASE_PATH} ]; then
	log "Creating the base directory: '${BASE_PATH}'" 
	sudo mkdir -p ${BASE_PATH}
	sudo chown ${USER}:${USER} ${BASE_PATH}
fi


## LOADING USER HOME CONFIGURATION AND SCRIPTS DIRECTORY
### Creating repository path [if needed]
if [ ! -d ${GIT_LOCAL_REPOSITORY_PATH} ]; then
	log "Creating the repository directory: '${GIT_LOCAL_REPOSITORY_PATH}'" 
	sudo mkdir -p ${GIT_LOCAL_REPOSITORY_PATH}
	sudo chown ${USER}:${USER} ${GIT_LOCAL_REPOSITORY_PATH}
fi

### Clone script and configuration into local git repository
#### Clone git repository [if needed]
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
#### Create a branch [if needed]
log "Checking if local branch '${GIT_LOCAL_BRANCH}' exists." 
git show-ref --verify --quiet refs/heads/${GIT_LOCAL_BRANCH} || {
	log "Creating local branch '${GIT_LOCAL_BRANCH}'" 
	git branch "${GIT_LOCAL_BRANCH}"
}
git checkout "${GIT_LOCAL_BRANCH}"
log "Returning to the execution directory:" 
cd -


## CONFIGURATING HOST
if [ -f "${SETUP_CONFIG_FILE}" ]; then
	log "Loading setup configuration script '${SETUP_CONFIG_FILE}'."
	. ${SETUP_CONFIG_FILE}
else
	log "NOT POSSIBLE TO FIND '${SETUP_CONFIG_FILE}'. ABORTING..."
	exit 1
fi


## FINALIZING SETUP
### Returning to the execution directory
log "Returning to the execution directory:" 
cd "${EXECUTION_PATH}"

### Displaying success message
log "Setup complete."