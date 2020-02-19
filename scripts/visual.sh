#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot
####
# Run the webserver
${HOME}/build/test-dir/bin/drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome.
    sudo apt-get install google-chrome-stable
    npm install -D chromedriver
    ./node_modules/.bin/chromedriver --host: 127.0.0.1 --port 4444 &

elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quatum 68 ESR).
    sudo add-apt-repository ppa:mozillateam/ppa
    sudo apt-get update
    sudo apt-get install firefox-esr xvfb firefox-geckodriver mesa-utils libgl1-mesa-glx
    Xvfb :99 &
    export DISPLAY=:99
    npm install -D geckodriver
    ./node_modules/.bin/geckodriver --host 127.0.0.1 --port 4444 &
fi

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
  echo "Failing due to uncommited changes in repo, check your reference images."
  exit 1
fi

