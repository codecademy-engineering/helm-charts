# codecademy Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Actions](https://github.com/codecademy-engineering/helm-charts/workflows/Release%20Charts/badge.svg?branch=main)](https://github.com/codecademy-engineering/helm-charts/actions)

This repo collects a set of [Helm](https://helm.sh) charts curated by [Codecademy](https://www.codecademy.com).

## Requirements
* KEDA CRDs
  ```
  helm repo add kedacore https://kedacore.github.io/charts
  helm repo update
  helm install keda kedacore/keda
  ```
 
## Usage

[Helm](https://helm.sh) must be installed and initialized to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
$ helm repo add codecademy https://codecademy-engineering.github.io/helm-charts
```

You can then run `helm search repo codecademy` to see the charts.

## Contribution Guidelines

We'd love to have you contribute! Please refer to our [contribution guidelines](CONTRIBUTING.md) for details.
