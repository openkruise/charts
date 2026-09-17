# Agent Sandbox Manager v0.3.0

## Configuration Parameters

The following table lists the configurable parameters of the agents-sandbox-manager chart and their default values.

| Parameter                                    | Description                                   | Default                                                                                                                                                       |
|----------------------------------------------|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `replicaCount`                               | Number of sandbox-manager replicas            | `2`                                                                                                                                                           |
| `image.registry`                             | Registry prepended to every image in this chart | `docker.io`                                                                                                                                                 |
| `controller.repository`                      | sandbox-manager controller image repository   | `openkruise/sandbox-manager`                                                                                                                                  |
| `controller.tag`                             | sandbox-manager controller image tag          | `v0.3.0`                                                                                                                                                      |
| `controller.pullPolicy`                      | Controller container image pull policy        | `IfNotPresent`                                                                                                                                                |
| `controller.logLevel`                        | Controller log level                          | `5`                                                                                                                                                           |
| `controller.infra`                           | Sandbox manager infrastructure type           | `sandbox-cr`                                                                                                                                                  |
| `controller.hostNetwork`                     | Whether controller uses host network          | `false`                                                                                                                                                       |
| `controller.maxClaimWorkers`                 | Maximum claim worker threads                  | `100`                                                                                                                                                         |
| `controller.maxCreateQPS`                    | Maximum QPS for creating sandboxes            | `200`                                                                                                                                                         |
| `controller.extProcMaxConcurrency`           | Maximum concurrency for external processors   | `3000`                                                                                                                                                        |
| `controller.createPodInsteadOfSandbox`       | Whether to create Pod instead of Sandbox      | `false`                                                                                                                                                       |
| `controller.resources.cpu`                   | Controller container CPU resource             | `2`                                                                                                                                                           |
| `controller.resources.memory`                | Controller container memory resource          | `4Gi`                                                                                                                                                         |
| `proxy.repository`                           | Envoy proxy image repository                  | `envoyproxy/envoy`                                                                                                                                            |
| `proxy.tag`                                  | Envoy proxy image tag                         | `v1.33-latest`                                                                                                                                                |
| `proxy.pullPolicy`                           | Envoy proxy container image pull policy       | `IfNotPresent`                                                                                                                                                |
| `e2b.domain`                                 | E2B protocol domain                           | `"your.domain.com"`                                                                                                                                           |
| `e2b.enableAuth`                             | Whether to enable E2B authentication          | `true`                                                                                                                                                        |
| `e2b.adminApiKey`                            | E2B admin API key (required)                  | `""`                                                                                                                                                          |
| `e2b.maxTimeout`                             | E2B maximum timeout (seconds)                 | `2592000`                                                                                                                                                     |
| `service.type`                               | sandbox-manager service type                  | `ClusterIP`                                                                                                                                                   |
| `service.port`                               | Envoy proxy service port                      | `7788`                                                                                                                                                        |
| `ingress.className`                          | Ingress class name (required)                 | `""`                                                                                                                                                          |
| `ingress.annotations`                        | Ingress annotations                           | `{}`                                                                                                                                                          |
| `ingress.certSecretName`                     | Ingress TLS certificate Secret name           | `sandbox-manager-tls`                                                                                                                                         |
| `ingress.dataplaneService`                   | Dataplane backend service name for Ingress    | `sandbox-manager`                                                                                                                                             |
| `imagePullSecrets`                           | Image pull secrets list                       | `{}`                                                                                                                                                          |
| `nameOverride`                               | Override Chart name                           | `""`                                                                                                                                                          |
| `fullnameOverride`                           | Override full name                            | `""`                                                                                                                                                          |
| `serviceAccount.automount`                   | Whether to automount ServiceAccount Token     | `true`                                                                                                                                                        |
| `serviceAccount.annotations`                 | ServiceAccount annotations                    | `{}`                                                                                                                                                          |
| `serviceAccount.name`                        | ServiceAccount name to use                    | `""`                                                                                                                                                          |
| `podAnnotations`                             | Pod annotations                               | `{}`                                                                                                                                                          |
| `podLabels`                                  | Pod labels                                    | `{}`                                                                                                                                                          |
| `podSecurityContext`                         | Pod security context                          | `{fsGroup: 2000, seccompProfile: {type: RuntimeDefault}}`                                                                                                     |
| `podSecurityContextAllowPrivilegeEscalation` | Pod security context allowPrivilegeEscalation | `false`                                                                                                                                                       |
| `securityContext`                            | Container security context                    | `{capabilities: {drop: [ALL], add: [NET_BIND_SERVICE]}, readOnlyRootFilesystem: true, allowPrivilegeEscalation: false, runAsNonRoot: true, runAsUser: 65532}` |
| `nodeSelector`                               | Node selector for Pod scheduling              | `{}`                                                                                                                                                          |
| `tolerations`                                | Tolerations for Pod scheduling                | `[]`                                                                                                                                                          |
| `affinity`                                   | Affinity for Pod scheduling                   | Preferred Pod anti-affinity                                                                                                                                   |
| `gateway.replicaCount`                       | Number of sandbox-gateway replicas            | `2`                                                                                                                                                           |
| `gateway.image.repository`                   | sandbox-gateway image repository              | `openkruise/sandbox-gateway`                                                                                                                                  |
| `gateway.image.tag`                          | sandbox-gateway image tag                     | `v0.3.0`                                                                                                                                                      |
| `gateway.image.pullPolicy`                   | sandbox-gateway image pull policy             | `IfNotPresent`                                                                                                                                                |
| `gateway.resources.cpu`                      | sandbox-gateway container CPU resources       | `2`                                                                                                                                                           |
| `gateway.resources.memory`                   | sandbox-gateway container memory resources    | `4Gi`                                                                                                                                                         |
| `gateway.initContainer.enabled`              | Whether to enable gateway initContainer       | `false`                                                                                                                                                       |
| `gateway.initContainer.image.repository`     | initContainer image repository                | `busybox`                                                                                                                                                     |
| `gateway.initContainer.image.tag`            | initContainer image tag                       | `1.36.1`                                                                                                                                                      |
| `gateway.service.type`                       | sandbox-gateway service type                  | `ClusterIP`                                                                                                                                                   |
| `gateway.service.port`                       | sandbox-gateway service port                  | `7788`                                                                                                                                                        |
| `gateway.service.targetPort`                 | sandbox-gateway service target port           | `10000`                                                                                                                                                       |
| `gateway.envoy.admin.address`                | Envoy admin interface address                 | `127.0.0.1`                                                                                                                                                   |
| `gateway.envoy.admin.port`                   | Envoy admin interface port                    | `9901`                                                                                                                                                        |
| `gateway.envoy.listener.address`             | Envoy listener address                        | `0.0.0.0`                                                                                                                                                     |
| `gateway.envoy.listener.port`                | Envoy listener port                           | `10000`                                                                                                                                                       |
| `gateway.envoy.logLevel`                     | Envoy log level                               | `warn`                                                                                                                                                        |
| `gateway.envoy.concurrency`                  | Envoy worker thread concurrency               | `4`                                                                                                                                                           |
| `agentio.enabled` | Deploy the embedded Agentio control plane | `false` |
| `agentio.global.registry` | Registry for Agentio images; empty inherits image.registry | `""` |
| `agentio.global.namespace` | Agentio control-plane namespace | `sandbox-system` |
| `agentio.global.trustDomain` | Workload identity trust domain | `cluster.local` |
| `agentio.global.clusterDomain` | Kubernetes service DNS domain | `cluster.local` |
| `agentio.global.clusterId` | Agentio cluster identifier | `Kubernetes` |
| `agentio.agentiod.ca.trustBundleConfigMapName` | CA trust bundle distributed to traffic proxies | `agentio-ca-root-cert` |
| `agentio.agentiod.replicaCount` | Agentio control-plane replicas | `1` |
| `agentio.agentiod.image.registry` | Control-plane registry; empty inherits agentio.global.registry | `""` |
| `agentio.agentiod.image.repository` | Control-plane repository | `openkruise/agentiod` |
| `agentio.agentiod.image.tag` | Fixed Agentio release image tag | `0.2.0` |
| `agentio.agentiod.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.agentiod.resources` | Control-plane resource requests | `500m CPU, 512Mi` |
| `agentio.epe.mode` | EPE deployment mode: disabled, managed, or external | `managed` |
| `agentio.epe.image.registry` | EPE registry; empty inherits agentio.global.registry | `""` |
| `agentio.epe.image.repository` | EPE repository | `openkruise/agentio-epe` |
| `agentio.epe.image.tag` | Fixed Agentio release image tag | `0.2.0` |
| `agentio.epe.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.egressGateway.mode` | Gateway mode: disabled, static, or gatewayAPI | `static` |
| `agentio.egressGateway.image.registry` | Gateway registry; empty inherits agentio.global.registry | `""` |
| `agentio.egressGateway.image.repository` | Gateway repository | `openkruise/proxyv2` |
| `agentio.egressGateway.image.tag` | Fixed Agentio release image tag | `0.2.0` |
| `agentio.egressGateway.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.agentiod.config.values` | Overrides for the Agentio configuration | `{}` |

The sandbox-manager integration intentionally excludes Agentio ambient mode and
the Agentio sidecar injector. Kruise Agents injects the per-sandbox
`traffic-proxy` from the `sandbox-injection-config` ConfigMap installed by the
sandbox-controller chart.

Specify each parameter using the `--set key=value[,key=value]` argument. For example:

```bash
helm install agents-sandbox-manager . -n <namespace> openkruise/kruise-agents-sandbox-manager \
  --set e2b.adminApiKey=<your-admin-api-key> \
  --set ingress.className=<alb|nginx> \
  --set key=value...
```

## Image Registry

Images render as `<registry>/<repository>:<tag>` or, with a digest override,
`<registry>/<repository>@<digest>`. The
`registry` defaults to the chart-wide `image.registry`. The Agentio images
resolve their registry through a longer chain: their own `image.registry`, then
`agentio.global.registry`, then `image.registry`.

The registry prefix is dropped when the first path segment of a repository
already names a host (it contains a `.` or a `:`), so setting
`controller.repository` to `myreg.io/openkruise/sandbox-manager` keeps working
without also clearing `image.registry`.

Agentio images default to the fixed `0.2.0` release tag and an empty `digest`.
Registry mirrors must provide that tag. Set an image's `tag` to override its
version, or supply `digest` to pin a specific manifest instead. Future Agentio
synchronizations set these defaults to the synchronized release version.

## Migrating Agentio 0.1 overrides

The embedded integration now follows Agentio 0.2.0. Migrate existing values before
upgrading; see the [Agentio integration guide](https://github.com/openkruise/agentio/blob/0.2.0/manifests/charts/OPENKRUISE.md#migrate-release-01-values)
for the complete configuration changes.

| Previous key | Agentio 0.2.0 key |
| --- | --- |
| `agentio.agentiod.replicas` | `agentio.agentiod.replicaCount` |
| `agentio.epe.enabled: true` | `agentio.epe.mode: managed` |
| `agentio.epe.replicas` | `agentio.epe.replicaCount` |
| `agentio.egressGateway.gateways` | `agentio.egressGateway.mode: static` and `fullnameOverride` for one gateway |
| `agentio.agentioConfig` | `agentio.agentiod.config.values` |
| `agentio.global.meshInternalTrafficPolicy` | `agentio.agentiod.meshInternalTrafficPolicy` |

The mesh-internal policy now defaults to `PEER_AWARE`. Set it to `PASSTHROUGH`
explicitly if required. Workload proxies use the `agentio-ca-root-cert` trust
bundle and `agentio-ca` token audience; upgrade the controller's traffic-proxy
configuration with the manager and recreate workload Pods to receive it.

### Default egress routing

With `agentio.enabled=true`, the integration deploys a static egress gateway and
managed EPE by default. A catch-all `GATEWAY` egress policy points to
`agentio-egress.sandbox-system.svc.cluster.local`; the generated address follows
gateway name, namespace, and cluster-domain overrides.

Set `agentio.agentiod.config.values.egressPolicies` to replace the default route,
including an empty list to remove it. Setting `agentio.egressGateway.mode=disabled`
suppresses the default gateway route; set `agentio.epe.mode=disabled` to disable
EPE as well. Existing `agentio-config-primary` overrides still take precedence.
