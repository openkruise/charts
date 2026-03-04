# Agents Sandbox Controller v0.1.0

## Configuration Parameters

The following table lists the configurable parameters of the agents-sandbox-controller chart and their default values.

| Parameter                                             | Description                                                      | Default                                                                                                                 |
|-------------------------------------------------------|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `sandboxController.replicaCount`                      | Number of sandbox-controller replicas                            | `2`                                                                                                                     |
| `sandboxController.image.repository`                  | sandbox-controller image repository                              | `openkruise/agent-sandbox-controller`                                                                                   |
| `sandboxController.image.tag`                         | sandbox-controller image tag                                     | `v0.1.0`                                                                                                                |
| `sandboxController.image.pullPolicy`                  | Controller image pull policy                                     | `IfNotPresent`                                                                                                          |
| `sandboxController.webhook.port`                      | Webhook service port                                             | `9443`                                                                                                                  |
| `sandboxController.metrics.port`                      | Metrics service port                                             | `8443`                                                                                                                  |
| `sandboxController.healthProbe.port`                  | Health probe port                                                | `8081`                                                                                                                  |
| `sandboxController.resources.limits.cpu`              | Controller CPU resource limit                                    | `2`                                                                                                                     |
| `sandboxController.resources.limits.memory`           | Controller memory resource limit                                 | `4Gi`                                                                                                                   |
| `sandboxController.resources.requests.cpu`            | Controller CPU resource request                                  | `2`                                                                                                                     |
| `sandboxController.resources.requests.memory`         | Controller memory resource request                               | `4Gi`                                                                                                                   |
| `namespace.name`                                      | Namespace name for deployment                                    | `sandbox-system`                                                                                                        |
| `serviceAccount.create`                               | Whether to create ServiceAccount                                 | `true`                                                                                                                  |
| `serviceAccount.automount`                            | Whether to automount ServiceAccount Token                        | `true`                                                                                                                  |
| `serviceAccount.annotations`                          | ServiceAccount annotations                                       | `{}`                                                                                                                    |
| `serviceAccount.name`                                 | ServiceAccount name to use                                       | `""`                                                                                                                    |
| `rbac.create`                                         | Whether to create RBAC resources                                 | `true`                                                                                                                  |
| `imagePullSecrets`                                    | Image pull secrets list                                          | `[]`                                                                                                                    |
| `nameOverride`                                        | Override Chart name                                              | `""`                                                                                                                    |
| `fullnameOverride`                                    | Override full name                                               | `""`                                                                                                                    |
| `podAnnotations`                                      | Pod annotations                                                  | `{}`                                                                                                                    |
| `podLabels`                                           | Pod labels                                                       | `{}`                                                                                                                    |
| `podSecurityContext`                                  | Pod security context                                             | `{runAsNonRoot: true, seccompProfile: {type: RuntimeDefault}}`                                                          |
| `securityContext`                                     | Container security context                                       | `{allowPrivilegeEscalation: false, capabilities: {drop: [ALL], add: [NET_BIND_SERVICE]}, readOnlyRootFilesystem: true}` |
| `nodeSelector`                                        | Node selector for Pod scheduling                                 | `{}`                                                                                                                    |
| `tolerations`                                         | Tolerations for Pod scheduling                                   | `[]`                                                                                                                    |
| `affinity`                                            | Affinity for Pod scheduling                                      | `{}`                                                                                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument. For example:

```bash
helm install agents-sandbox-controller . -n <namespace> openkruise/kruise-agents-sandbox-controller --set key=value...
```
