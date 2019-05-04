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

# Because `helm repo index` always updates the "generated" timestamp, we only
# want to push the merged index YAML if there are any other changes.
# Therefore we store the existing index YAML to a variable, minus "generated".
git checkout gh-pages
git pull origin gh-pages
OLD_INDEX=`sed -e '/generated:/d' index.yaml`

# Remove chart packages from TEMP_DIR that match existing chart packages.
# Ref: https://github.com/helm/helm/issues/4482
for CHART in `ls $TEMP_DIR`; do
    [ -f $CHART ] && rm $TEMP_DIR/$CHART
done
# Build a new index YAML file with only new charts.
helm repo index $TEMP_DIR --merge index.yaml --url https://${CIRCLE_PROJECT_USERNAME}.github.io/${CIRCLE_PROJECT_REPONAME}

# Store newly generated index YAML to another variable for comparison.
NEW_INDEX=`sed -e '/generated:/d' $TEMP_DIR/index.yaml`

if [ "$NEW_INDEX" != "$OLD_INDEX" ]; then
    # Add new chart packages and index YAML from TEMP_DIR.
    cp -f $TEMP_DIR/* .

    # Commit and push changes to gh-pages branch.
    git add *.tgz index.yaml
    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_USERNAME"
    git commit --message "Update Helm repo index and packages [skip ci]" --signoff
    git push origin gh-pages
else
    echo Nothing to do. No chart changes detected.
fi
