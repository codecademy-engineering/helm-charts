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

# Stash packaged charts and index YAML file from master charts source into a
# temporary directory.
TEMP_DIR=`mktemp -d`
helm init --client-only
for CHART in charts/*; do
    helm dependency build $CHART
    helm package $CHART --destination $TEMP_DIR
done

# Store old index YAML as a variable for comparison. Note that timestamps
# between generated helm repo index files will never match, so we remove them
# when setting variables for comparison.
# Newly packaged charts will also always have a different digest:
# Ref: https://github.com/helm/helm/issues/4482
git checkout gh-pages
git pull origin gh-pages
OLD_INDEX=`sed -e '/created:/d' -e '/generated:/d' -e '/digest:/d' index.yaml`

# Generate new index YAML from stashed master charts source, and store as a
# new variable for comparison.
# Merge into existing index.yaml, so that we keep any previous chart versions.
helm repo index $TEMP_DIR --merge index.yaml --url https://${CIRCLE_PROJECT_USERNAME}.github.io/${CIRCLE_PROJECT_REPONAME}
NEW_INDEX=`sed -e '/created:/d' -e '/generated:/d' -e '/digest:/d' $TEMP_DIR/index.yaml`

if [ "$NEW_INDEX" != "$OLD_INDEX" ]; then
    # If the index files (without dates) are not identical, copy only new
    # artifacts in place, and the newly merged index file over the old one.
    cp -u $TEMP_DIR/* .
    git add -A

    # Commit and push changes to gh-pages branch.
    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_USERNAME"
    git commit --message "Update Helm repo index and packages" --signoff
    git push origin gh-pages
else
    echo Nothing to do. No chart changes detected.
fi
