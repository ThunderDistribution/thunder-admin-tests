#!/bin/bash -ex

####
if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome.
    docker run -d --shm-size 2g --net=host selenium/standalone-chrome:3.141.59-zinc
elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quatum 68 ESR).
    docker run -d --shm-size 2g --net=host selenium/standalone-firefox:3.141.59-titanium
fi

# Show dockers
docker ps -a
####

until nc -z 127.0.0.1 4444; do
    sleep 1
    if [[ ${count} -gt 10 ]]; then
        printf "Selenium docker timed out." 1>&2
        exit 1
    fi
    count=$((count + 1))
done

cd "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin

# Run the webserver
"${HOME}"/build/test-dir/vendor/bin/drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

# Run visual regression tests
if [[ ${UPDATE_SCREENSHOTS} == true ]]; then
  ./node_modules/.bin/sharpeye --single-browser "${SHARPEYE_BROWSER}" --num-retries 0
else
  ./node_modules/.bin/sharpeye --single-browser "${SHARPEYE_BROWSER}"
fi

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
    echo "Failing due to uncommited changes in repo, check your reference images."
    exit 1
fi
