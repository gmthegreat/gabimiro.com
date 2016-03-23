#!/bin/bash

#########################################################################################
#
# Connect to remote server via an ssh connection.
# Password is not required. The Remote server authentication validate the user
# ssh public key accordingly.
#
# In case you get an error "access forbidden" then check your "user name" and
# that your "ssh public key" was properly added to the server.
# Adding your ssh public key to the server .ssh/authorized_keys:
# http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)
#
# Do not change this file, Config should be defiend on the "config.sh".
#
#########################################################################################

# Load the colors.
source helper-colors.sh

# Load the helpers.
source helper-functions.sh

# Load the configuration.
load_config_file

# Connect to remote server "root" directory.
if [[ -z "$SERVER_DIR_PATH" ]]
then
  echo -e "${LBLUE}> Conencting to remote server... ${RESTORE}"
  ssh $SERVER_USER_NAME@$SERVER_NAME -p $SERVER_PORT
# Connect to a specific directory on the remote server.
else
  echo -e "${LBLUE}> Conencting to remote server at directory: ${WHITE}$SERVER_DIR_PATH ${RESTORE}"
  ssh $SERVER_USER_NAME@$SERVER_NAME /
  -p $SERVER_PORT /
  -t "cd $SERVER_DIR_PATH; bash --login"
fi
