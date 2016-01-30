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
source $ROOT/scripts/helper-colors.sh

# Load the helpers.
source $ROOT/scripts/helper-functions.sh

# Load the configuration.
load_config_file

# Delete the site database
delete_the_site_db

# Cleanup the www directory.
delete_site_www_directory

# Create Wordpress core files.
generate_word_press_core

# Generate Wordpress config file.
generate_word_press_config

# Install Wordpress.
install_word_press
