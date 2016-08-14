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
    echo -e  "${BGRED}  > Check if the ${BGLRED}config.sh${BGRED} file exists in the ${BGLRED}config directory${BGRED}. ${RESTORE}"
    echo -e  "${BGRED}  > If not create one by creating a copy of ${BGLRED}default.config.sh${BGRED}.   ${RESTORE}"
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo
  fi

  # Check if the site config file exist.
  if [ ! -f $ROOT/config/database/config-db.cnf ]; then
    echo
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo -e  "${BGLRED}  ERROR: No Database configuration file found!                            ${RESTORE}"
    echo -e  "${BGRED}  > Check if the ${BGLRED}config-db.cnf${BGRED} file exists in the ${BGLRED}config/database/ directory${BGRED}. ${RESTORE}"
    echo -e  "${BGRED}  > If not create one by creating a copy of ${BGLRED}default.config-db.cnf${BGRED}.   ${RESTORE}"
    echo -e  "${BGRED}                                                                 ${RESTORE}"
    echo
    exit 1
  fi

  # Include the configuration file.
  source $ROOT/config/config.sh
}

##
# init install message.
##
function init_install_message {
  echo
  echo -e  "${BGBLUE}                                                                 ${RESTORE}"
  echo -e  "${BGLBLUE}  Website: $SERVER_TITLE                                              ${RESTORE}"
  echo -e  "${BGLBLUE}                                                                 ${RESTORE}"
  echo -e  "${BGBLUE}  This will install the platform as defined in the config file.  ${RESTORE}"
  echo -e  "${BGBLUE}  If the platform is already installed, it will be removed and   ${RESTORE}"
  echo -e  "${BGBLUE}  reinstalled.                                                   ${RESTORE}"
  echo -e  "${BGBLUE}                                                                 ${RESTORE}"
  echo -e  "${BGBLUE}  OPTIONS:                                                       ${RESTORE}"
  echo -e  "${BGBLUE}    -d   Load demo content after the installation.               ${RESTORE}"
  echo -e  "${BGBLUE}    -l   Open a new tab in your default browser and login to     ${RESTORE}"
  echo -e  "${BGBLUE}         your project as the Administrator.                      ${RESTORE}"
  echo -e  "${BGBLUE}                                                                 ${RESTORE}"
  echo
}

##
# Delete the site database.
##
function delete_the_site_db {
    echo -e "${LBLUE}Creating the website database ${RESTORE}"
    # Deleting the database if exists and re-creating a fresh Database instead.

    mysql \
    --defaults-extra-file=$ROOT/config/database/config-db.cnf \
    --execute="DROP SCHEMA IF EXISTS $MYSQL_DB_NAME; CREATE SCHEMA $MYSQL_DB_NAME"
    echo -e "${LGREEN}Success:${LGREEN}" \
      "${WHITE}Database:${WHITE}" \
      "${LWHITE}$MYSQL_DB_NAME${LWHITE}" \
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

##
# Install Wordpress.
##
function symlink_plugins {
  echo -e "${LBLUE}Custom plugins ${RESTORE}"
  # Symlink the plugins.
  ln -s $ROOT/profile/plugins/* $ROOT/www/wp-content/plugins
  echo -e "${LGREEN}Success:${LGREEN}" \
          "${WHITE}Symlinked to${WHITE}" \
          "${LWHITE}wp-content/plugins${LWHITE}" \
          "${WHITE}directory.${WHITE}"
  echo
}

function symlink_themes {
  echo -e "${LBLUE}Custom Themes ${RESTORE}"
  # Symlink the themes.
  ln -s $ROOT/profile/themes/* $ROOT/www/wp-content/themes
  echo -e "${LGREEN}Success:${LGREEN}" \
          "${WHITE}Symlinked to${WHITE}" \
          "${LWHITE}wp-content/themes${LWHITE}" \
          "${WHITE}directory.${WHITE}"
  echo
}


##
# Manage themes (Install/Activate/Delete).
##
function manage_themes {

  # Symink Themes.
  symlink_themes

#  declare -A array
#  array[theme1]=bar
#  array[theme2]=foo
#
#  for i in "${!array[@]}"
#    do
#    echo "$i => ${array[$i]}"
#  done

  activate_theme
}

##
# Manage Plugins (Install/Activate/uninstall).
##
function manage_plugins {

  # Symink Plugins.
  symlink_plugins

#  declare -A array
#  array[plugin1]=bar
#  array[plugin2]=foo
#
#  for i in "${!array[@]}"
#    do
#    echo "$i => ${array[$i]}"
#  done
}
