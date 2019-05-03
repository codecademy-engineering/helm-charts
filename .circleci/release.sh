#!/usr/bin/env sh

set -o errexit
set -o nounset
set -o pipefail

: "${GIT_USERNAME:?Environment variable GIT_USERNAME must be set}"
: "${GIT_EMAIL:?Environment variable GIT_EMAIL must be set}"

# Always generate new index.yaml file from charts in master, for comparison
# with existing file in gh-pages branch.

# Ensure local copy is not out of date because of circle jobs overrunning one
# another out of order.
git fetch origin
git pull origin master

# Clean directory to add packaged charts, and index.yaml.
rm -rf .deploy
mkdir -p .deploy
helm init --client-only
for CHART in charts/*; do
    helm dependency build $CHART
    helm package $CHART --destination .deploy
done
helm repo index .deploy --url https://${CIRCLE_PROJECT_USERNAME}.github.io/${CIRCLE_PROJECT_REPONAME}

# Get newly generaged index.yaml values for comparison. Note timestamps will
# never match, so remove them for comparison.
NEW_INDEX=`sed -e '/created:/d' -e '/generated:/d' .deploy/index.yaml`

# Check out helm repo gh-pages branch, to compare existing index.yaml.
git checkout gh-pages
git pull origin gh-pages
OLD_INDEX=`sed -e '/created:/d' -e '/generated:/d' .deploy/index.yaml index.yaml`

if [ "$NEW_INDEX" != "$OLD_INDEX" ]; then
    # If the index files (without dates) are not identical, remove any existing
    # artifacts, and copy the new one in place.
    rm *.yaml *.tgz
    cp --force .deploy/* .
    rm -r .deploy
    git add -A

    # Commit and push changes to gh-pages branch.
    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_USERNAME"
    git commit --message "Update Helm repo index and packages" --signoff
    git push origin gh-pages
else
    echo Nothing to do. No chart changes detected.
fi
