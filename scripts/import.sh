#!/bin/bash

# Load the colors.
source helper-colors.sh

# Load the helpers.
source helper-functions.sh

# Load the configuration.
load_config_file

ssh $USER_NAME@$SERVER_NAME -p $PORT
