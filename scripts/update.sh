#!/bin/bash


## LOADING CONFIGURATION
. "${HOME}/resemblance"


## LOADING HELPER FUNCTIONS
. "${SCRIPTS_BASE_PATH}/utils/directory.sh"
. "${SCRIPTS_BASE_PATH}/utils/symlink.sh"
. "${SCRIPTS_BASE_PATH}/utils/config.sh"
. "${SCRIPTS_BASE_PATH}/utils/log.sh"


## SETTING UP CONFIGURATION AND SCRIPTS DIRECTORY
log "Assuring scripts directory link existence."
assureSymlink ${SCRIPTS_BASE_PATH} ${SCRIPTS_LINK_PATH}

log "Assuring host configuration directory existence."
assureDirectory "${CONFIG_HOST_PATH}"

log "Assuring host configuration files directory existence."
assureDirectory "${CONFIG_HOST_FILES_PATH}"

### TODO VARRER PASTA DE ARQUIVOS DE CONFIGURAÇÃO VERIFICANDO LINK SIMBOLICO DE CADA UM
### TODO	VARREDURA DEVE IGNORAR PRE E POS PROCESSAMENTO
### TODO	NO LINK SIMBOLICO, AO SER CRIADO, TENTAR EXECUTAR PRE E POS PROCESSAMENTO

### TODO Se o arquivo de dependencias nao existir, cria-lo, se existir, perguntar se é pra atuializa-lo de acordo com o sistema ou atualizar o sistema com ele
### Update machine dependency (package) list
updateHostDependenciesDescription "${CONFIG_HOST_DEPENDENCIES_FILE}"


### TODO Perguntar se quer varrer o home adicionando alguns arquivos/folders no repo


### 

#createDependencyInstallationScript "${INITIAL_CONFIG_DEPENDENCIES_FILE}" "${CONFIG_HOST_DEPENDENCIES_FILE}" "${CONFIG_HOST_DEPENDENCIES_SCRIPT}"
#rm -R "${HOME}/resemblance"


# names memoir, silhouette
#	change config file
#	change repo folder name
#	change script folder name

# COMMAND TO CREATE/UPDATE A FILE(S) THAT DETAILS A PROFILE DEPENDENCY LIST
# 	ppas
# 	oter repos
# COMMAND THAT APPLYES ANOTHER PROFILE DEPENDENCY LIST INTO THIS
# COMMAND TO MOVE A CONFIGURATION INTO REPO USING SYMLINK UTILS
# COMMAND THAT APPLIES CURRENT PROFILE FILES INTO CURR SYSTEM USING SYMLINK UTILS 
# COMMAND TO APPLY A HOST CONFIGURATION INTO THE CURRENT HOST > CHANGE PROFILE

# COMMAND THAT SYNCS OTHER FILES IN DATA

# COMMAND TO MAKE SNAPSHOT
# COMMAND TO REVERT SNAPSHOT
# COMMAND TO DESTROY SNAPSHOT
# COMMAND TO LIST SNAPSHOTS

# COMMAND TO TURN OFF MONITOR

# GIT_REPOSITORY_URL should be setg by param, keeping the curr as a default
# GIT_REPOSITORY_URL should be divided into two repositories, one for the configuration files and one for the script files.


# COMMAND TO SAVE INSTALLED PACKAGES INTO A FILE
# COMMAND TO APPLY PACKAGES FROM A FILE

# USE SPARKLESHARE OR UNISON OR RSYNC TO SYNC DATA FILES BETWEEN HOSTS > The more automatic the better
# CONFIGURE SHELL (bash or zsh)
#	Configure shell path
# 	Configure shell aliases, functions and other configurations

# Configure dropbox, google drive (insync), ...


