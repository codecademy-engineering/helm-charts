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

## Contribution Guidelines

We'd love to have you contribute!
Check the [issue tracker](https://github.com/Codecademy/helm-charts/issues) for issues labeled [Accepting PRs](https://github.com/Codecademy/package-name/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+label%3A%22Accepting+PRs%22) to find bug fixes and feature requests the community can work on.
If this is your first time working with this code, the [Good First issue](https://github.com/Codecademy/guidelines/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+label%3A%22Good+First+Issue%22+) label indicates good introductory issues.

Please note that this project is released with a [Contributor Covenant](https://www.contributor-covenant.org).
By participating in this project you agree to abide by its terms.
See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).
