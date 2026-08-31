# Agents Sandbox Controller v0.3.0

## Configuration Parameters

The following table lists the configurable parameters of the agents-sandbox-controller chart and their default values.

| Parameter                    | Description                               | Default                                                                                                                 |
|------------------------------|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `replicaCount`               | Number of sandbox-controller replicas     | `2`                                                                                                                     |
| `image.repository`           | sandbox-controller image repository       | `openkruise/agent-sandbox-controller`                                                                                   |
| `image.tag`                  | sandbox-controller image tag              | `v0.3.0`                                                                                                                |
| `image.pullPolicy`           | Controller image pull policy              | `IfNotPresent`                                                                                                          |
| `webhook.port`               | Webhook service port                      | `9443`                                                                                                                  |
| `metrics.port`               | Metrics service port                      | `8443`                                                                                                                  |
| `healthProbe.port`           | Health probe port                         | `8081`                                                                                                                  |
| `resources.limits.cpu`       | Controller CPU resource limit             | `2`                                                                                                                     |
| `resources.limits.memory`    | Controller memory resource limit          | `4Gi`                                                                                                                   |
| `resources.requests.cpu`     | Controller CPU resource request           | `2`                                                                                                                     |
| `resources.requests.memory`  | Controller memory resource request        | `4Gi`                                                                                                                   |
| `namespace.name`             | Namespace name for deployment             | `sandbox-system`                                                                                                        |
| `serviceAccount.create`      | Whether to create ServiceAccount          | `true`                                                                                                                  |
| `serviceAccount.automount`   | Whether to automount ServiceAccount Token | `true`                                                                                                                  |
| `serviceAccount.annotations` | ServiceAccount annotations                | `{}`                                                                                                                    |
| `serviceAccount.name`        | ServiceAccount name to use                | `""`                                                                                                                    |
| `rbac.create`                | Whether to create RBAC resources          | `true`                                                                                                                  |
| `imagePullSecrets`           | Image pull secrets list                   | `[]`                                                                                                                    |
| `nameOverride`               | Override Chart name                       | `""`                                                                                                                    |
| `fullnameOverride`           | Override full name                        | `""`                                                                                                                    |
| `podAnnotations`             | Pod annotations                           | `{}`                                                                                                                    |
| `podLabels`                  | Pod labels                                | `{}`                                                                                                                    |
| `podSecurityContext`         | Pod security context                      | `{runAsNonRoot: true, seccompProfile: {type: RuntimeDefault}}`                                                          |
| `securityContext`            | Container security context                | `{allowPrivilegeEscalation: false, capabilities: {drop: [ALL], add: [NET_BIND_SERVICE]}, readOnlyRootFilesystem: true}` |
| `nodeSelector`               | Node selector for Pod scheduling          | `{}`                                                                                                                    |
| `tolerations`                | Tolerations for Pod scheduling            | `[]`                                                                                                                    |
| `affinity`                   | Affinity for Pod scheduling               | `{}`                                                                                                                    |
| `agentio.trafficProxy.controlPlaneNamespace` | Namespace containing the Agentio control plane | `agentio-system` |
| `agentio.trafficProxy.controlPlaneService` | Agentio control-plane Service name | `agentiod` |
| `agentio.trafficProxy.xdsAddress` | Explicit XDS address; generated from service and namespace when empty | `""` |
| `agentio.trafficProxy.caAddress` | Explicit CA address; generated from service and namespace when empty | `""` |
| `agentio.trafficProxy.caCertConfigMap` | CA ConfigMap mounted in injected workload namespaces | `agentio-ca-certs` |
| `agentio.trafficProxy.image` | Injected ztunnel image | `docker.io/openkruise/ztunnel:0.1.0` |
| `agentio.trafficProxy.initImage` | Injected iptables init image | `docker.io/openkruise/proxy-init:0.1.0` |
| `agentio.trafficProxy.imagePullPolicy` | Traffic-proxy image pull policy | `IfNotPresent` |
| `agentio.trafficProxy.healthProbeRewrite` | Rewrite health probes for injected traffic proxies | `true` |
| `agentio.trafficProxy.dnsCapture` | Enable DNS capture | `true` |
| `agentio.trafficProxy.resources` | Injected ztunnel resources | `requests: 100m/64Mi, limits: 200m/128Mi` |
| `agentio.trafficProxy.initResources` | Injected iptables init resources | `requests: 100m/128Mi, limits: 1/1Gi` |

The `sandbox-injection-config` ConfigMap is installed in the sandbox-controller
release namespace. `controlPlaneNamespace` is independent, so the injected
traffic proxy can connect to Agentio running in another namespace.

Specify each parameter using the `--set key=value[,key=value]` argument. For example:

```bash
helm install agents-sandbox-controller . -n <namespace> openkruise/kruise-agents-sandbox-controller \
  --set key=value...
```
