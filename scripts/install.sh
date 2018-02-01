#!/usr/bin/env bash

# create thunder project
composer create-project burdamagazinorg/thunder-project:2.x ${THUNDER} --stability dev --no-interaction --no-install

cd ${THUNDER}
# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# This actually does a 'composer install'
composer require drush/drush:~8.1

# setup theme
cd ~/builds
git clone --depth=50 https://github.com/BurdaMagazinOrg/theme-thunder-admin.git -b 8.x-2.x

# link theme
rm -rf ${THEME}
mv ~/builds/theme-thunder-admin ${THEME}

#drush site-install standard install_configure_form.enable_update_status_module=NULL
# /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`"
cd ${THUNDER}/docroot
${THUNDER}/bin/drush site-install thunder --account-pass=admin --db-url=mysql://thunder:thunder@127.0.0.1/drupal install_configure_form.enable_update_status_module=NULL -y
