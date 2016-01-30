#!/bin/bash

################################################################################
#
# Helper functions so we can reuse code indifferent scripts!
#
################################################################################


##
# Load the configuration file.
# Will exit with an error message if the configuration file does not exists!
##
function load_config_file {
  # Check if the config file exists.
  if [ ! -f $ROOT/config.sh ]; then
    echo
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo -e  "${BGLRED}  ERROR: No configuration file found!                            ${RESTORE}"
    echo -e  "${BGRED}  > Check if the ${BGLRED}config.sh${BGRED} file exists in the ${BGLRED}scripts directory${BGRED}. ${RESTORE}"
    echo -e  "${BGRED}  > If not create one by creating a copy of ${BGLRED}default.config.sh${BGRED}.   ${RESTORE}"
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo
    exit 1
  fi

  # Include the configuration file.
  source config.sh
}


##
# Delete all the content within the /www folder.
##
function delete_site_content_and_db {
  if [ -d $ROOT/www/ ]; then
    echo -e "${LBLUE}> Cleaning up the www directory${RESTORE}"
    rm -rf $ROOT/www/
    echo
  fi

  # Create the www directory if necessary.
  if [ ! -d $ROOT/www ]; then
    echo -e "${LBLUE}> Creating an empty www directory${RESTORE}"
    mkdir $ROOT/www
    echo
  fi
}

##
# Generate Wordpress.
##
function generate_word_press_core {
  # Downloading Wordpress latest version.
  if [[ -z "$WP_VERSION" ]]
  then
    echo -e "${LBLUE}> Downloading Wordpress latest version... ${RESTORE}"
    wp core download --path=www
    # Downloading Wordpress latest version.
  else
    echo -e "${LBLUE}> Downloading Wordpress version $WP_VERSION  ${RESTORE}"
    wp core download --path=www --version=$WP_VERSION
  fi
}

##
# Create Wordpress config file.
##
function generate_word_press_config {
  cd $ROOT/www
  wp core config \
  --dbhost=$MYSQL_HOSTNAME \
  --dbname=$MYSQL_DB_NAME \
  --dbuser=$MYSQL_USERNAME \
  --dbpass=$MYSQL_PASSWORD
}

##
# Install Wordpress.
##
function install_word_press {
  cd $ROOT/www
  wp core install \
  --url=$SERVER_BASE_PATH \
  --admin_name=$admin_name \
  --admin_password=$ADMIN_PASSWORD \
  --admin_email=$ADMIN_EMAIL \
  --title=$SERVER_TITLE
}
