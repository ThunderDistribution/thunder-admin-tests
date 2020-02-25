#!/bin/bash -ex

cd "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin

# Update reference images for visual regression tests.
#
# Copy images and push to branch
if [[ ! -d /tmp/sharpeye/"${JOB_ID}"/diff ]]; then
    exit 0
fi

CHANGES=("$(ls /tmp/sharpeye/"${JOB_ID}"/diff)")

git config user.email "technology@thunder.org"
git config user.name "ThunderTechAccount"

# Reanimate Detached HEAD repo.
git remote set-branches origin "${BRANCH}"
git fetch --depth 1 origin "${BRANCH}"
git checkout "${BRANCH}"
git remote set-url origin https://"${GITHUB_TOKEN}"@github.com/"${REPOSITORY}".git

# Setup lfs for oath token
git config lfs.https://github.com/"${REPOSITORY}".locksverify false
git config lfs.pushurl https://"${GITHUB_TOKEN}":x-oauth-basic@github.com/"${REPOSITORY}".git/info/lfs

for SCREENSHOT in "${CHANGES[@]}"; do
    cp /tmp/sharpeye/"${JOB_ID}"/actual/"${SCREENSHOT}" ./screenshots/reference/
    git add ./screenshots/reference/"${SCREENSHOT}"
done

# Commit and push.
git status
git commit screenshots/reference/ -m "TRAVIS: Updated visual reference images for ${SHARPEYE_BROWSER}"
git pull
git push
