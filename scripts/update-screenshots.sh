#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Update reference images for visual regression tests.
#
# Copy images and push to branch
if [ ${UPDATE_SCREENSHOTS} == "true" ] && [ ${TRAVIS_PULL_REQUEST}  != 'false' ]; then
    CHANGES=( $(ls /tmp/sharpeye/${TRAVIS_JOB_ID}/diff ) )

    if [ "${#CHANGES}" > 0 ]; then
        for SCREENSHOT in "${CHANGES[@]}"
        do
            cp /tmp/sharpeye/${TRAVIS_JOB_ID}/screen/${SCREENSHOT} ./screenshots/reference/
        done
    fi

    git status
    # Set configuration.
    git config --global user.email "technology@thunder.org"
    git config --global user.name "ThunderTechAccount"
    # Checkout branch.
    git remote set-branches origin ${TRAVIS_PULL_REQUEST_BRANCH}
    git fetch --depth 1 origin ${TRAVIS_PULL_REQUEST_BRANCH}
    git checkout ${TRAVIS_PULL_REQUEST_BRANCH}
    # Commit changes.
    git commit screenshots/reference/* -m 'TRAVIS: Updated visual reference images'
    git status

#git config --global credential.helper store
#echo "https://${GITHUB_TOKEN}:x-oauth-basic@github.com" >> ~/.git-credentials

    git remote set-url origin https://${GITHUB_TOKEN}c@github.com/${TRAVIS_PULL_REQUEST_SLUG}.git
    #git remote set-url origin https://github.com/${TRAVIS_PULL_REQUEST_SLUG}.git
    git push
fi

