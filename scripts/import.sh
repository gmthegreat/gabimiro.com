#!/bin/bash

# Load the colors.
source helper-colors.sh

# Load the helpers.
source helper-functions.sh

# Load the configuration.
load_config_file

# Connect to a specific directory on the remote server.
if [[ -z "$SERVER_DIR_PATH" ]]
then
  echo -e "${LBLUE}> Conencting to remote server... ${RESTORE}"
  ssh $SERVER_USER_NAME@$SERVER_NAME -p $PORT
# Connect to remote server "root" directory.
else
  echo -e "${LBLUE}> Conencting to remote server at directory: ${WHITE}$SERVER_DIR_PATH ${RESTORE}"
  ssh $SERVER_USER_NAME@$SERVER_NAME -p $PORT -t "cd $SERVER_DIR_PATH; bash --login"
fi
