#!/usr/bin/env sh

set -o errexit
set -o nounset
set -o pipefail

: "${GIT_USERNAME:?Environment variable GIT_USERNAME must be set}"
: "${GIT_EMAIL:?Environment variable GIT_EMAIL must be set}"

CHANGED_CHARTS="$(git diff --find-renames --name-only origin/master -- charts | cut -d '/' -f 2 | uniq)"

if [ -n "$CHANGED_CHARTS" ]; then
    rm -rf .deploy
    mkdir -p .deploy

    for CHART in $CHANGED_CHARTS; do
        helm dependency build charts/$CHART
        helm package charts/${CHART} --destination .deploy
    done

    helm repo index .deploy --url https://${CIRCLE_PROJECT_USERNAME}.github.io/${CIRCLE_PROJECT_REPONAME}

    git checkout gh-pages
    cp --force .deploy/* .
    rm -r .deploy
    git add .

    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_USERNAME"
    git commit --message "Update Helm repo index and packages" --signoff
    git push origin gh-pages
else
    echo Nothing to do. No chart changes detected.
fi
