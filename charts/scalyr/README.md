# Scalyr

[Scalyr](https://www.scalyr.com/) is a hosted infrastructure logging platform.

The Scalyr Agent is a daemon that uploads logs and system metrics to the Scalyr servers.

By default, the Scalyr Agent will collect pod logs, container metrics, and Kubernetes Events for all nodes. See the [Kubernetes Events monitor](https://www.scalyr.com/help/monitors/kubernetes-events) documentation for more details on Kubernetes Events, including how to disable the collection (this can be accomplished by overriding the `scalyr.config.agentD` chart values).

This chart follows the [recommended architecture](https://www.scalyr.com/help/install-agent-kubernetes) running the Scalyr Agent as a DaemonSet on your cluster. The DaemonSet runs a Scalyr Agent pod on each node in your cluster that will collect logs and metrics from all other pods running on the same node. Note that by default this will run the agent on the master node; if you do not want to run the agent on the master, see the `tolerations` chart values comment about how to disable.

## Prerequisites

- A scalyr account
- A scalyr Write Logs API key with "write" access

## Installing the Chart

Before the Scalyr agent will run, you must define your Write Logs API key. You can find this under [Logs Access Keys](https://www.scalyr.com/keys). Make sure the key has "write" access. You must create a secret in the cluster, using the "api-key" keypair key:

```console
$ kubectl create secret generic YOUR_SECRET_NAME --from-literal=api-key="YOUR_KEY"
```

Then:

```console
$ helm repo add codecademy https://codecademy-engineering.github.io/helm-charts
$ helm install --name my-release codecademy/scalyr \
    --set scalyr.apiKeyExistingSecret=YOUR_SECRET_NAME
```

## Upgrading the chart

If you upgrade `config` values, this won't automatically recrete the daemonset pods. To do this, you must delete the pods so they can regenerate their containers with the new ENV variables set by the updated ConfigMaps. Example:

```console
$ helm upgrade scalyr codecademy/scalyr --reuse-values --set scalyr.config.k8sCluster=YOUR_CLUSTER_NAME
$ for POD in `kubectl get pods -l app.kubernetes.io/name=scalyr -o name`; do kubectl delete $POD; done
pod "scalyr-abcde" deleted
pod "scalyr-fghij" deleted
pod "scalyr-klmno" deleted
pod "scalyr-pqrst" deleted
pod "scalyr-uvwxy" deleted
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter | Description | Default |
| --- | --- | --- |
| `image.registry` | Container registry | `scalyr/scalyr-k8s-agent` |
| `image.tag` | Container image tag | `2.0.46` |
| `image.pullPolicy` | Container image pull policy | `IfNotPresent` |
| `nameOverride` | Override the chart name | `""` |
| `fullnameOverride` | Override the chart full name | `""` |
| `rbac.create` | If true, create & use RBAC resources | `true` |
| `rbac.serviceAccountName` | If rbac.create is false, a required existing ServiceAccount name to use | `default` |
| `scalyr.apiKeyExistingSecret` | Your Write Logs API key (see "Installing the Chart" above) | `nil` |
| `scalyr.config.agentD.create` | If true, create default FULLNAME-config-agent-d ConfigMap resource | `true` |
| `scalyr.config.agentD.custom` | If scalyr.config.configAgentD.create is false, an optional existing ConfigMap name to use | `nil` |
| `scalyr.config.agentJson.create` | If true, create default FULLNAME-config-agent-json ConfigMap resource | `true` |
| `scalyr.config.agentJson.custom` | If scalyr.config.agentJson.create is false, an optional existing ConfigMap name to use | `nil` |
| `resources` | Pod resource requests and limits | Scalyr recommended `value` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | List of node taints to tolerate | `Scalyr recommended value` |
| `affinity` | Map of node/pod affinities | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release codecademy/scalyr \
    --set scalyr.apiKeyExistingSecret=YOUR_SECRET_NAME \
    --set rbac.create=false \
    --set rbac.serviceAccountName=MY_SERVICE_ACCOUNT_NAME
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
$ helm install --name my-release codecademy/scalyr \
    -f shared-values.yaml \
    -f staging-values.yaml
```

> **Tip**: Refer to the default [values.yaml](values.yaml)
