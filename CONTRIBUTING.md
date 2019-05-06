# Contributing Guidelines

Contributions are welcome via GitHub pull requests. This document outlines the process to help get your contribution accepted.

## Sign off Your Work

The Developer Certificate of Origin (DCO) is a lightweight way for contributors to certify that they wrote or otherwise have the right to submit the code they are contributing to the project. Here is the full text of the [DCO](http://developercertificate.org/). Contributors must sign-off that they adhere to these requirements by adding a `Signed-off-by` line to commit messages.

```
This is my commit message

Signed-off-by: Random J Developer <random@developer.example.org>
```

See `git help commit`:

```
-s, --signoff
    Add Signed-off-by line by the committer at the end of the commit log
    message. The meaning of a signoff depends on the project, but it typically
    certifies that committer has the rights to submit this work under the same
    license and agrees to a Developer Certificate of Origin (see
    http://developercertificate.org/ for more information).
```

## How to Contribute

1. Fork this repository, develop, and test your changes.
1. Remember to sign off your commits as described above.
1. Submit a pull request.

***NOTE***: In order to make testing and merging of PRs easier, please submit changes to multiple charts in separate PRs.

### Technical Requirements

* Must pass linting and installing with the [chart-testing](https://github.com/helm/chart-testing) tool
* Must follow [best practices](https://github.com/helm/helm/tree/master/docs/chart_best_practices) and [review guidelines](https://github.com/helm/charts/blob/master/REVIEW_GUIDELINES.md)

### Documentation Requirements

* A chart's `README.md` must include configuration options
* A chart's `NOTES.txt` must include relevant post-installation information

### Merge Approval and Release Process

* Must pass DCO check
* Must pass CI jobs for linting changed charts
* Any change to a chart requires a version bump following [semver](https://semver.org/) principles

Once changes have been merged, the release job will automatically run to package and release changed charts.

### Community Requirements

Please note that this project is released with a [Contributor Covenant](https://www.contributor-covenant.org).
By participating in this project you agree to abide by its terms.
See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).
