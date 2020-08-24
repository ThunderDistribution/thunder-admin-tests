#!/bin/bash -ex

cd "${HOME}"/build/test-dir/docroot

# Install thunder
"${HOME}"/build/test-dir/vendor/bin/drush site-install thunder \
    --account-pass=admin --db-url="sqlite://sites/default/files/.testbasesqlite" \
    install_configure_form.enable_update_status_module=NULL thunder_module_configure_form.install_modules_thunder_demo -y

# Install styleguide and disable transitions
chmod u+w sites/default/settings.php
cp sites/default/settings.php /tmp/settings.php
echo "\$settings['extension_discovery_scan_tests'] = TRUE;" >> sites/default/settings.php
"${HOME}"/build/test-dir/vendor/bin/drush -y en thunder_styleguide css_disable_transitions_test
mv /tmp/settings.php sites/default/settings.php

# Final cache rebuild, to make sure every code change is respected
"${HOME}"/build/test-dir/vendor/bin/drush cr

# Pre-create all image styles for entity browser.´
"${HOME}"/build/test-dir/vendor/bin/drush image-derive-all
