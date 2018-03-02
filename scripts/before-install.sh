#!/usr/bin/env bash -ex

# Remove xdebug to make php execute faster
phpenv config-rm xdebug.ini
find sausage

# Show php modules
php -m

# Prepare MySQL user and database
mysql -e "CREATE DATABASE drupal;"
mysql -e "CREATE USER 'thunder'@'localhost' IDENTIFIED BY 'thunder';"
mysql -e "GRANT ALL ON drupal.* TO 'thunder'@'localhost';"
