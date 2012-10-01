#!/bin/bash


## LOADING HELPER FUNCTIONS
. ./symlink_utils.sh
. ./log_utils.sh


## CONFIGURATION VARIABLES
### Base setup path
BASE_PATH="/home/shared"
GIT_LOCAL_BRANCH="work"


## SECONDARY VARIABLES (DO NOT CONFIGURE)
### User configurations, scripts and other files
GIT_REPOSITORY_PATH="${BASE_PATH}/repo"
SCRIPTS_ORIGIN_PATH="${GIT_REPOSITORY_PATH}/scripts"
SCRIPTS_LINK_PATH="${HOME}/scripts"


## INSTALLING DEPENDENCIES
### Installing git
log "Assuring git is installed and updated..." 
sudo apt-get install git


## SETUP BASE PATH
### Creating base path [if needed]
if [ ! -d ${BASE_PATH} ]; then
	log "Creating the base directory: '${BASE_PATH}'" 
	sudo mkdir -p ${BASE_PATH}
	sudo chown ${USER}:${USER} ${BASE_PATH}
fi


## SETUP USER HOME CONFIGURATION AND SCRIPTS FOLDER
### Creating repository path [if needed]
if [ ! -d ${GIT_REPOSITORY_PATH} ]; then
	log "Creating the repository directory: '${GIT_REPOSITORY_PATH}'" 
	sudo mkdir -p ${GIT_REPOSITORY_PATH}
	sudo chown ${USER}:${USER} ${GIT_REPOSITORY_PATH}
fi

### Clone script and configuration into local git repository
cd ${GIT_REPOSITORY_PATH}
log "Checking if the local git repository is configured." 
if [ "`git rev-parse --is-inside-work-tree`" ]; then 
	log "The local repository is already set." 
else
	log "Creating local repository in ${GIT_REPOSITORY_PATH}" 
	git clone git@github.com:rhlobo/homeConfig.git ${GIT_REPOSITORY_PATH}
fi

### Go create a branch [if needed]
log "Checking if local branch '${GIT_LOCAL_BRANCH}' exists." 
git show-ref --verify --quiet refs/heads/${GIT_LOCAL_BRANCH} || {
	log "Creating local branch '${GIT_LOCAL_BRANCH}'" 
	git branch "${GIT_LOCAL_BRANCH}"
}
git checkout "${GIT_LOCAL_BRANCH}"

### Returning to execution directory
log "Returning to the current directory:" 
cd -

### Setup script folder into computer
assureSymlink ${SCRIPTS_ORIGIN_PATH} ${SCRIPTS_LINK_PATH}


## COMMUNICATING SETUP STATUS
### Displaying success message
log "Setup complete."



# SEPARATE INTO MULTIPLE files
# EDIT TO MAKE IT PRETTY INTO HTML WITH MARKUT