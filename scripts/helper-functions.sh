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
function load_config_files {
  # Check if the site config file exist.
  if [ ! -f $ROOT/config/config.sh ]; then
    echo
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo -e  "${BGLRED}  ERROR: No configuration file found!                            ${RESTORE}"
    echo -e  "${BGRED}  > Check if the ${BGLRED}config.sh${BGRED} file exists in the ${BGLRED}scripts directory${BGRED}. ${RESTORE}"
    echo -e  "${BGRED}  > If not create one by creating a copy of ${BGLRED}default.config.sh${BGRED}.   ${RESTORE}"
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo
  fi

  # Check if the site config file exist.
  if [ ! -f $ROOT/config/config-db.cnf ]; then
    echo
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo -e  "${BGLRED}  ERROR: No DB configuration file found!                            ${RESTORE}"
    echo -e  "${BGRED}  > Check if the ${BGLRED}config-db.cnf${BGRED} file exists in the ${BGLRED}scripts directory${BGRED}. ${RESTORE}"
    echo -e  "${BGRED}  > If not create one by creating a copy of ${BGLRED}default.config-db.cnf${BGRED}.   ${RESTORE}"
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo
    exit 1
  fi

  # Include the configuration file.
  source config/config.sh
}


##
# Delete the site database.
##
function delete_the_site_db {
    echo -e "${LBLUE}Creating the website database ${RESTORE}"
    # Deleting the database if exists and re-creating a fresh Database instead.

    mysql \
    --defaults-extra-file=$ROOT/config/config-db.cnf \
    --execute="DROP SCHEMA IF EXISTS $MYSQL_DB_NAME; CREATE SCHEMA $MYSQL_DB_NAME"
    echo -e "${LGREEN}Success:${LGREEN}" \
      "${WHITE}Database:${WHITE}" \
      "${LGREEN}$MYSQL_DB_NAME${LGREEN}" \
      "${WHITE}created successfully.${WHITE}"
    echo
}


##
# Delete all the content within the /www dircetory.S
##
function delete_site_www_directory {
  # Delete the www directory if it exists.
  if [ -d $ROOT/www/ ]; then
    rm -rf $ROOT/www/
  fi

  # Create a clean www directory.
  if [ ! -d $ROOT/www ]; then
    mkdir $ROOT/www
  fi

  echo -e "${LBLUE}Creating the www directory ${RESTORE}"
  echo -e "${LGREEN}Success: ${LGREEN}${WHITE}Directory created successfully.${WHITE}"
  echo
}


##
# Generate Wordpress.
##
function generate_word_press_core {
  # Downloading Wordpress latest version.
  echo -e "${LBLUE}Downloading Wordpress ${RESTORE}"
  # Set a speific version
  INSTALL_VERSION=""
  if [[ -n "$WP_VERSION" ]]; then
    INSTALL_VERSION="--version=$WP_VERSION"
  fi
  # Set a speific local (language)
  INSTALL_LOCAL=""
  if [[ -n "$WP_LOCALE" ]]; then
    INSTALL_LOCALE="--locale=$WP_LOCALE"
  fi
  echo
  wp core download --path=www $INSTALL_VERSION $INSTALL_LOCALE
  echo
}

##
# Generating Wordpress config file.
##
function generate_word_press_config {
  echo -e "${LBLUE}Generating Wordpress config file ${RESTORE}"
  cd $ROOT/www
  wp core config \
  --dbhost=$MYSQL_HOSTNAME \
  --dbname=$MYSQL_DB_NAME \
  --dbuser=$MYSQL_USERNAME \
  --dbpass=$MYSQL_PASSWORD
  echo
}

##
# Install Wordpress.
##
function install_word_press {
  echo -e "${LBLUE}Install Wordpress ${RESTORE}"
  cd $ROOT/www
  wp core install \
  --url=$SERVER_BASE_URL \
  --admin_name=$ADMIN_USERNAME \
  --admin_password=$ADMIN_PASSWORD \
  --admin_email=$ADMIN_EMAIL \
  --title=$SERVER_TITLE
  echo
}
