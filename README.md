# WordPress - Install Profile gabrielmiro.com

This is a starting base to create WordPress websites using an install profile.

## Installation

**Warning:**
You need to setup [WP-CLI](http://wp-cli.org/#install).

Clone the project from [GitHub](https://github.com/gmthegreat/gabimiro.com).

#### Create the config files

Copy the example configuration file to config.sh:

	$ cp default.config.sh config.sh
	$ cp default.config-db.cnf config-db.cnf

Edit each the configuration file, with the relevant data.

#### Run the install script

Run the install script from within the root of the repository:

	$ ./install.sh

#### The install script will perform following steps:

1. Delete the /www folder.
2. Recreate the /www folder.
3. Download and extract all `plugins`, `themes` & `libraries` to the proper
   sub-folders of the profile.
4. Download and extract WordPress core in the ``/www` folder
5. Create an empty `wp-content/uploads` directory
6. Makes a symlink within the `/www/profiles` directory to the `/gabrielmiro`
   directory.
7. Run the WordPress installer (WP-CLI) using the `gabrielmiro` profile.

#### Warning!

* The install script will not preserve the data located in the
  `wp-content/uploads` directory.
* The install script will clear the database during the installation.

**You need to take backups before you run the install script!**
