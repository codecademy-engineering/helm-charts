# Rails

This chart helps install a custom [Rails](https://rubyonrails.org/) application.

## Installing

Add codecademy Helm repo:

```console
$ helm repo add codecademy https://codecademy-engineering.github.io/helm-charts
```

See [helm install](https://github.com/helm/helm/blob/master/docs/helm/helm_install.md). Example:

```console
$ helm install --name my-release codecademy/rails
```

This deploys a sample Rails app on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists chart [values](https://github.com/helm/helm/blob/master/docs/chart_best_practices/values.md) that can be configured during installation.

For installing [Sidekiq](https://github.com/mperham/sidekiq/), it's recommended to create an [umbrella chart](https://github.com/helm/helm/blob/master/docs/charts_tips_and_tricks.md#complex-charts-with-many-dependencies) that requries multiple instances of this Rails chart to be configured separately.

For demo purposes the default container is a sample [Rails Hello World](https://github.com/scottrigby/rails-hello) image, but this chart is really only useful with a custom application container image.

## Uninstalling

See [helm delete](https://github.com/helm/helm/blob/master/docs/helm/helm_delete.md). Example:

```console
$ helm delete --purge my-release
```

## Upgrading

Make any required changes, depending on the version you're upgrading to below.

See [helm upgrade](https://github.com/helm/helm/blob/master/docs/helm/helm_upgrade.md). Example:

```console
$ helm upgrade --install my-release codecademy/rails
```

### To 2.0.0

- `envs` was refactored from a list to a map, due to a mistake in overriding, and to help with simplicity. See [this Helm issue](https://github.com/helm/helm/issues/3486). Major version bumped because the new format is not backwards compatible, even though it does fix a bug in overriding.
    - Before:
    ```yaml
    envs:
      - name: EXAMPLE_SIMPLE_STRING
        value: foo
      - name: ANOTHER_KEY
        value: bar
    ```
    - After:
    ```yaml
    envs:
      EXAMPLE_SIMPLE_STRING: foo
      ANOTHER_KEY: bar
    ```
- `envsSecrets` was introduced to similarly allow overriding envs from secrets.
    - Before:
    ```yaml
    envs:
      - name: EXAMPLE_FROM_SECRET
        valueFrom:
          secretKeyRef:
            name: auth
            key: password
    ```
    - After:
    ```yaml
    envsSecrets:
      EXAMPLE_FROM_SECRET:
        name: auth
        key: password
    ```

### To 1.0.0

- `env` was removed in favor of `envs` (for simple environment variables) and `envsTemplate` (for dynamic environment variables using Chart template expressions). This change was made to allow for easier overriding of values, as most do not need dynamic templating. Use the comments and examples in `values.yaml` as a guide for splitting any existing values between the two when upgrade.
- Default `ingress.hosts[0].paths[0]` to `\`
- Uncomment to set default `ingress.tls[0].secretName` and `ingress.tls[0].hosts[0]`
- `image.command` was documented in `values.yaml`
- README added, configuration documented

## Configuration

Parameter | Description | Default
--- | --- | ---
replicaCount | Number Pods to run | `1`
image.repository | Image name | `r6by/rails-hello`
image.tag | Image tag | `0.1.0`
image.pullPolicy | Image pull policy | `IfNotPresent`
nameOverride | String to partially override rails.fullname template with a string (will prepend the release name) | `nil`
fullnameOverride | String to fully override rails.fullname template with a string | `nil`
envs | Map of standard environment variables | `nil`
envsTemplate | YAML block literal string for dynamic environment variables using Chart template expressions | `''`
service.type | Kubernetes Service type | `ClusterIP`
service.port | Service port | `3000`
ingress.enabled | Enable ingress controller resource | `false`
ingress.annotations | Ingress annotations | `{}`
ingress.hosts[0].host | Hostname to your Rails application | `rails.test`
ingress.hosts[0].paths[0] | Path within the url structure | `\`
ingress.tls[0].secretName | TLS Secret (certificates) | `rails-tls`
ingress.tls[0].hosts[0] | TLS hosts | `rails.test`
resources | Pod resource limits/requests | `{}`
nodeSelector | Node labels for pod assignment | `{}`
tolerations | List of node taints to tolerate | `[]`
affinity | Map of node/pod affinities | `{}`
