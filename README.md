# codecademy Helm Charts

[![CircleCI](https://circleci.com/gh/codecademy-engineering/helm-charts/tree/master.svg?style=svg)](https://circleci.com/gh/codecademy-engineering/helm-charts/tree/master)

This repo collects a set of [Helm](https://helm.sh) charts curated by [Codecademy](https://www.codecademy.com).

## Usage

[Helm](https://helm.sh) must be installed and initialized to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
$ helm repo add codecademy https://codecademy-engineering.github.io/helm-charts
```

You can then run `helm search codecademy` to see the charts.
