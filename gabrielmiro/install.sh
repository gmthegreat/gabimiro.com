#!/bin/bash
################################################################################
#
# This script will setup a local copy of WordPress
# based on the Installation Profile.
#
# Do not change the content of this file,
# all configuration variables are in the config.sh file.
#
################################################################################

# Define the root of the GIT repository.
cd ${0%/*}
ROOT=$(pwd)
cd $ROOT

# Load the colors.
source $ROOT/helper-colors.sh

# Load the helpers.
source $ROOT/helper-functions.sh

# Load the configuration.
load_config_file

# Download Wordpress.
load_config_file

# Cleanup the www directory.
delete_www_content

# Create Wordpress core files.
create_word_press_core
