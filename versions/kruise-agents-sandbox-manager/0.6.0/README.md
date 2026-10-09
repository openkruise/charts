# Agent Sandbox Manager v0.6.0

## Configuration Parameters

The following tables list the configurable parameters of the agents-sandbox-manager chart and their default values.

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of sandbox-manager replicas | `2` |
| `image.registry` | Registry prepended to every image in this chart | `docker.io` |
| `imagePullSecrets` | Image pull secrets list | `{}` |
| `controller.repository` | sandbox-manager controller image repository | `openkruise/sandbox-manager` |
| `controller.tag` | sandbox-manager controller image tag | `v0.6.0` |
| `controller.pullPolicy` | Controller container image pull policy | `IfNotPresent` |
| `controller.resources.cpu` | Controller container CPU resource | `2` |
| `controller.resources.memory` | Controller container memory resource | `4Gi` |
| `e2b.domain` | E2B protocol domain (required) | `"your.domain.com"` |
| `e2b.enableAuth` | Whether to enable E2B authentication | `true` |
| `e2b.adminApiKey` | E2B admin API key (required) | `""` |
| `service.port` | Envoy proxy service port | `7788` |
| `ingress.className` | Ingress class name (required) | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `prometheus.enabled` | Create a ServiceMonitor for manager and gateway metrics | `false` |
| `gateway.replicaCount` | Number of sandbox-gateway replicas | `2` |
| `gateway.image.repository` | sandbox-gateway image repository | `openkruise/sandbox-gateway` |
| `gateway.image.tag` | sandbox-gateway image tag | `v0.6.0` |
| `gateway.image.pullPolicy` | sandbox-gateway image pull policy | `IfNotPresent` |
| `gateway.resources.cpu` | sandbox-gateway container CPU resources | `2` |
| `gateway.resources.memory` | sandbox-gateway container memory resources | `4Gi` |

### Advanced Parameters

All remaining parameters are optional. Sensible defaults apply and most installs do not need to change them.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `controller.logLevel` | Controller log level | `5` |
| `controller.infra` | Sandbox manager infrastructure type | `sandbox-cr` |
| `controller.hostNetwork` | Whether controller uses host network | `false` |
| `controller.maxClaimWorkers` | Maximum claim worker threads | `100` |
| `controller.maxCreateQPS` | Maximum QPS for creating sandboxes | `200` |
| `controller.extProcMaxConcurrency` | Maximum concurrency for external processors | `10000` |
| `controller.enableShortSandboxId` | Enable short, human-friendly sandbox identifiers | `true` |
| `controller.shortSandboxIdPrefix` | Optional prefix for short sandbox ids; only applied when non-empty | `""` |
| `e2b.extraDomains` | Extra domains added to the Ingress host list alongside `e2b.domain` | `[]` |
| `e2b.maxTimeout` | E2B maximum timeout (seconds) | `2592000` |
| `e2b.keyStorage.mode` | Where E2B API keys are stored: `secret` (the `e2b-key-store` Secret) or `mysql` | `secret` |
| `e2b.keyStorage.mysql.dsn` | MySQL DSN; required (non-empty) when `keyStorage.mode=mysql`, validated at startup | `""` |
| `e2b.keyStorage.mysql.hashPepper` | MySQL key-hash pepper; required (non-empty) when `keyStorage.mode=mysql`, validated at startup | `""` |
| `quota.enabled` | Enable Redis-backed quota accounting | `false` |
| `quota.redis.addr` | Redis address for quota; only passed to the manager when enabled | `""` |
| `quota.redis.db` | Redis database number for quota | `0` |
| `quota.redis.username` | Redis username (rendered into the manager Secret) | `""` |
| `quota.redis.password` | Redis password (rendered into the manager Secret) | `""` |
| `service.type` | sandbox-manager service type | `ClusterIP` |
| `ingress.dataplaneService` | Dataplane backend service name for Ingress | `sandbox-gateway` |
| `ingress.certSecretName` | Ingress TLS certificate Secret name | `sandbox-manager-tls` |
| `nameOverride` | Override Chart name | `""` |
| `fullnameOverride` | Override full name | `""` |
| `serviceAccount.automount` | Whether to automount ServiceAccount Token | `true` |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}` |
| `serviceAccount.name` | ServiceAccount name to use | `""` |
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Pod labels | `{}` |
| `podSecurityContext` | Pod security context | `{fsGroup: 2000, seccompProfile: {type: RuntimeDefault}}` |
| `securityContext` | Container security context | `{capabilities: {drop: [ALL], add: [NET_BIND_SERVICE]}, readOnlyRootFilesystem: true, allowPrivilegeEscalation: false, runAsNonRoot: true, runAsUser: 65532}` |
| `nodeSelector` | Node selector for Pod scheduling | `{}` |
| `tolerations` | Tolerations for Pod scheduling | `[]` |
| `affinity` | Affinity for Pod scheduling | Preferred Pod anti-affinity |
| `gracefulShutdown.preStopSleepSeconds` | Sleep in the preStop hook before termination; also raises `terminationGracePeriodSeconds` when > 0 | `0` |
| `gateway.imagePullSecrets` | Gateway image pull secrets list | `[]` |
| `gateway.nameOverride` | Override gateway name | `""` |
| `gateway.serviceAccount.annotations` | Gateway ServiceAccount annotations | `{}` |
| `gateway.serviceAccount.name` | Gateway ServiceAccount name to use | `""` |
| `gateway.podAnnotations` | Gateway pod annotations | `{}` |
| `gateway.podSecurityContext` | Gateway pod security context | `{}` |
| `gateway.securityContext` | Gateway container security context | `{}` |
| `gateway.initContainer.enabled` | Whether to enable gateway initContainer | `false` |
| `gateway.initContainer.image.repository` | initContainer image repository | `busybox` |
| `gateway.initContainer.image.tag` | initContainer image tag | `1.36.1` |
| `gateway.initContainer.image.pullPolicy` | initContainer image pull policy | `IfNotPresent` |
| `gateway.initContainer.securityContext` | initContainer security context | `{capabilities: {drop: [ALL], add: [SYS_ADMIN]}}` |
| `gateway.service.type` | sandbox-gateway service type | `ClusterIP` |
| `gateway.service.port` | sandbox-gateway service port | `7788` |
| `gateway.service.targetPort` | sandbox-gateway service target port | `7788` |
| `gateway.service.annotations` | Gateway service annotations | `{}` |
| `gateway.service.labels` | Gateway service labels | `{}` |
| `gateway.nodeSelector` | Node selector for gateway pod scheduling | `{}` |
| `gateway.tolerations` | Tolerations for gateway pod scheduling | `[]` |
| `gateway.affinity` | Affinity for gateway pod scheduling | `{}` |
| `gateway.livenessProbe` | Gateway liveness probe (TCP on port 7788) | `initialDelay: 10s, period: 10s, timeout: 5s, failureThreshold: 3` |
| `gateway.readinessProbe` | Gateway readiness probe (TCP on port 7788) | `initialDelay: 5s, period: 5s, timeout: 3s, failureThreshold: 3` |
| `gateway.podAntiAffinity` | Gateway pod anti-affinity | `soft, weight: 100, topologyKey: kubernetes.io/hostname` |
| `gateway.envoy.admin.address` | Envoy admin interface address | `127.0.0.1` |
| `gateway.envoy.admin.port` | Envoy admin interface port | `9901` |
| `gateway.envoy.prometheus.enabled` | Expose Envoy Prometheus metrics externally (proxies admin `/stats/prometheus`) | `false` |
| `gateway.envoy.prometheus.address` | Envoy Prometheus listener address | `0.0.0.0` |
| `gateway.envoy.prometheus.port` | Envoy Prometheus listener port | `9902` |
| `gateway.envoy.prometheus.path` | Envoy Prometheus metrics path | `/metrics` |
| `gateway.envoy.listener.address` | Envoy listener address | `0.0.0.0` |
| `gateway.envoy.listener.port` | Envoy listener port | `7788` |
| `gateway.envoy.logLevel` | Envoy log level | `warn` |
| `gateway.envoy.concurrency` | Envoy worker thread concurrency; empty falls back to `gateway.resources.cpu` | `""` |
| `gateway.envoy.drainTimeSeconds` | Envoy drain time on shutdown | `30` |
| `gateway.envoy.streamIdleTimeout` | Envoy stream idle timeout | `600s` |
| `gateway.envoy.connectTimeout` | Envoy upstream connect timeout | `5s` |
| `gateway.envoy.useDownstreamProtocolConfig` | Apply the downstream protocol config to upstream connections | `false` |
| `gateway.envoy.perConnectionBufferLimitBytes` | Per-connection buffer limit | `1048576` |
| `gateway.envoy.circuitBreakers` | Envoy circuit-breaker thresholds | `enabled: true, maxConnections: 80000, maxPendingRequests: 32768, maxRequests: 80000, maxRetries: 5` |
| `gateway.envoy.tcpKeepalive` | Envoy upstream TCP keepalive | `enabled: false, keepaliveProbes: 3, keepaliveTime: 60, keepaliveInterval: 10` |
| `gateway.envoy.golangFilter` | Gateway golang filter library | `libraryId/pluginName: sandbox-gateway, libraryPath: /etc/envoy/sandbox-gateway.so` |
| `gateway.envoy.pluginConfig.hostHeaderName` | Header carrying the upstream host | `Host` |
| `gateway.envoy.pluginConfig.sandboxHeaderName` | Header carrying the sandbox id | `e2b-sandbox-id` |
| `gateway.envoy.pluginConfig.sandboxPortHeader` | Header carrying the sandbox port | `e2b-sandbox-port` |
| `gateway.envoy.pluginConfig.defaultPort` | Port used when no sandbox port header is present | `"49983"` |
| `gateway.envoy.pluginConfig.enableAuth` | Enforce traffic access-token auth in the gateway plugin | `true` |
| `gateway.envoy.pluginConfig.trafficAccessTokenHeader` | Header carrying the traffic access token | `e2b-traffic-access-token` |
| `gateway.envoy.pluginConfig.enableJwtAuth` | Enable OIDC/JWT verification; requires `tls.oidc.discoveryUrl` to be set | `false` |
| `gateway.envoy.pluginConfig.wakeTimeoutSeconds` | Timeout waiting for a sleeping sandbox to wake | `60` |
| `enableTLS` | Master switch for cert-manager/trust-manager TLS. Issues the ingress server certificate, the manager/gateway runtime client certificates, the peer certificates, and turns on runtime mTLS in the gateway envoy config. The shared root CA is owned by the sandbox-controller chart, which must be installed in the same namespace | `false` |
| `tls.signingIssuerName` | CA Issuer created by the sandbox-controller chart (same namespace); not created here | `sandbox-signing-issuer` |
| `tls.signingIssuerKind` | Kind of the referenced issuer | `Issuer` |
| `tls.caCommonName` | Ingress certificate common name; also the subject organization on issued certificates | `sandbox-ca` |
| `tls.caOrganization` | Subject organization on issued certificates | `openkruise` |
| `tls.certDuration` | Leaf certificate lifetime | `2160h` |
| `tls.certRenewBefore` | Leaf certificate renewal window | `360h` |
| `tls.ingressCertName` | Ingress server Certificate resource; its Secret name must match `ingress.certSecretName`. Provisioned by `enableTLS` alone and safe against a plaintext runtime | `sandbox-manager-ingress-cert` |
| `tls.runtime.enabled` | Issue the manager/gateway runtime client certificates and activate `--runtime-client-cert-secret` plus the gateway enable-runtime-mtls/transport_socket. Fails against an agent-runtime that does not serve TLS; requires `enableTLS`; set together with the controller chart's `tls.runtime.enabled` | `false` |
| `tls.managerRuntimeClientCertName` | Manager runtime client Certificate name | `sandbox-manager-runtime-client` |
| `tls.managerRuntimeClientCertSecretName` | Manager runtime client certificate Secret name | `sandbox-manager-runtime-client-cert` |
| `tls.managerRuntimeClientCommonName` | Manager runtime client certificate common name | `system:sandbox-manager` |
| `tls.gatewayRuntimeClientCertName` | Gateway runtime client Certificate name | `sandbox-gateway-runtime-client` |
| `tls.gatewayRuntimeClientCertSecretName` | Gateway runtime client certificate Secret name | `sandbox-gateway-runtime-client-cert` |
| `tls.gatewayRuntimeClientCommonName` | Gateway runtime client certificate common name | `system:sandbox-gateway` |
| `tls.gatewayRuntimeMtlsDir` | Directory where the gateway runtime mTLS Secret is mounted; referenced by the envoy transport_socket | `/var/run/sandbox-gateway/runtime-mtls` |
| `tls.agentRuntimeServerSAN` | SAN the agent-runtime server certificate carries; used as envoy SNI and validated via auto_sni_san_validation. Must match the controller chart | `agentruntime.sandbox.agents.kruise.io` |
| `tls.peer.enabled` | Peer mTLS + memberlist gossip encryption for the manager↔gateway control-plane cluster. Independent of the agent-runtime data path; requires `enableTLS` and images including openkruise/agents#967 (older sandbox-manager images crash on the unknown `--peer-*` flags) | `false` |
| `tls.peer.serverCertName` / `serverCertSecretName` | Peer TLS server certificate shared by manager and gateway (server auth only; SAN fixed to `tls.agentRuntimeServerSAN`) | `sandbox-peer-server` / `sandbox-peer-server-cert` |
| `tls.peer.managerClientCertName` / `managerClientCertSecretName` / `managerClientCommonName` | Manager peer client certificate (client auth only) | `sandbox-peer-manager-client` / `sandbox-peer-manager-client-cert` / `system:sandbox-manager` |
| `tls.peer.gatewayClientCertName` / `gatewayClientCertSecretName` / `gatewayClientCommonName` | Gateway peer client certificate (client auth only) | `sandbox-peer-gateway-client` / `sandbox-peer-gateway-client-cert` / `system:sandbox-gateway` |
| `tls.peer.keySecretName` | Existing Secret (data key `key`, exactly 32 bytes) for memberlist gossip encryption; empty disables. cert-manager cannot create it; provide it out-of-band, referenced by both manager and gateway | `""` |
| `tls.peer.allowedClientCNs` | Optional comma-separated inbound allow-list matched against the client certificate CN or DNS SANs; empty accepts any client trusted by the peer server CA | `""` |
| `tls.oidc.discoveryUrl` | Absolute HTTPS discovery URL of the token issuer; required when JWT auth is enabled, the verifier fails to initialize while empty | `""` |
| `tls.oidc.caConfigMapName` / `caConfigMapKey` | ConfigMap holding the CA verifying the issuer's TLS certificate; defaults point at the trust-manager Bundle created by the controller chart | `sandbox-ca-bundle` / `ca.crt` |
| `tls.oidc.clockSkew` | Optional token clock-skew override (e.g. `1m`); empty uses the default | `""` |
| `tls.epe.enabled` | Issue the traffic-extension (EPE) credential-provider client certificate; requires `agentio.epe.mode=managed` and `agentio.epe.credentialProvider.mtls.source=files` | `false` |
| `tls.epe.certificateName` / `commonName` | Certificate resource / common name; empty defaults to `<epe-fullname>-mtls-client-cert` / `system:<epe-fullname>` | `""` |
| `tls.epe.issuerName` / `issuerKind` / `issuerGroup` | Issuer signing the EPE client certificate; the namespaced default Issuer only works when the agentio namespace also holds the CA Issuer | `sandbox-signing-issuer` / `Issuer` / `cert-manager.io` |
| `tls.epe.duration` / `renewBefore` | EPE certificate lifetime / renewal window | `2160h` / `360h` |
| `agentio.enabled` | Deploy the embedded Agentio control plane | `false` |
| `agentio.global.registry` | Default registry for Agentio images; empty inherits `image.registry` | `""` |
| `agentio.global.tag` | Default tag for Agentio images, overridable per component | `0.2.0` |
| `agentio.global.imagePullPolicy` | Default pull policy for Agentio images | `IfNotPresent` |
| `agentio.global.imagePullSecrets` | Default pull secrets for Agentio images | `[]` |
| `agentio.global.namespace` | Agentio control-plane namespace | `sandbox-system` |
| `agentio.global.createNamespace` | Create the Agentio control-plane namespace | `true` |
| `agentio.global.trustDomain` | Agentio workload identity trust domain | `cluster.local` |
| `agentio.global.clusterDomain` | Kubernetes service DNS domain | `cluster.local` |
| `agentio.global.clusterId` | Agentio cluster identifier | `Kubernetes` |
| `agentio.global.caCertConfigMap` | ConfigMap distributing the Agentio mesh root CA | `agentio-ca-certs` |
| `agentio.agentiod.ca.trustBundleConfigMapName` | CA trust bundle distributed to traffic proxies | `agentio-ca-root-cert` |
| `agentio.agentiod.replicaCount` | Agentio control-plane replicas | `1` |
| `agentio.agentiod.image.registry` | Agentio control-plane image registry; empty inherits `agentio.global.registry` | `""` |
| `agentio.agentiod.image.repository` | Agentio control-plane image repository | `openkruise/agentiod` |
| `agentio.agentiod.image.tag` | Agentio control-plane image tag | `0.2.0` |
| `agentio.agentiod.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.agentiod.resources` | Control-plane resource requests | `500m CPU, 512Mi` |
| `agentio.epe.mode` | EPE deployment mode: disabled, managed, or external | `managed` |
| `agentio.epe.image.registry` | EPE image registry; empty inherits `agentio.global.registry` | `""` |
| `agentio.epe.image.repository` | EPE image repository | `openkruise/agentio-epe` |
| `agentio.epe.image.tag` | EPE image tag | `0.2.0` |
| `agentio.epe.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.egressGateway.mode` | Gateway mode: disabled, static, or gatewayAPI | `static` |
| `agentio.egressGateway.image.registry` | Egress gateway proxy image registry; empty inherits `agentio.global.registry` | `""` |
| `agentio.egressGateway.image.repository` | Egress gateway proxy image repository | `openkruise/proxyv2` |
| `agentio.egressGateway.image.tag` | Egress gateway proxy image tag | `0.2.0` |
| `agentio.egressGateway.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.agentiod.config.values` | Raw overrides for the Agentio configuration | `{}` |

The sandbox-manager integration intentionally excludes Agentio ambient mode and the Agentio sidecar injector. Kruise Agents injects the per-sandbox `traffic-proxy` from the `sandbox-injection-config` ConfigMap installed by the sandbox-controller chart.

With `agentio.enabled=true`, a static egress gateway and managed EPE are enabled by default, and the default egress policy routes all external traffic through that gateway. Override `agentio.agentiod.config.values.egressPolicies` to change the route, or set it to `[]` to remove it. Set `agentio.egressGateway.mode=disabled` and `agentio.epe.mode=disabled` to disable these components. Existing `agentio-config-primary` overrides still take precedence.

Specify each parameter using the `--set key=value[,key=value]` argument. For example:

```bash
helm install agents-sandbox-manager openkruise/kruise-agents-sandbox-manager -n <namespace> \
  --set e2b.adminApiKey=<your-admin-api-key> \
  --set ingress.className=<alb|nginx> \
  --set key=value...
```

## Image Registry

Images render as `<registry>/<repository>:<tag>` or, with a digest override, `<registry>/<repository>@<digest>`. The `registry` defaults to the chart-wide `image.registry`. The Agentio images resolve their registry through a longer chain: their own `image.registry`, then `agentio.global.registry`, then `image.registry`.

The registry prefix is dropped when the first path segment of a repository already names a host (it contains a `.` or a `:`), so setting `controller.repository` to `myreg.io/openkruise/sandbox-manager` keeps working without also clearing `image.registry`.

Agentio images use the fixed `0.2.0` tag by default; an optional `digest` overrides the tag.

## TLS (cert-manager / trust-manager)

All certificate issuance is gated by `enableTLS` (default `false`), which requires cert-manager (and trust-manager, for the CA Bundle) in the cluster. The shared root CA (Issuer and CA Certificate) is owned by the sandbox-controller chart and must be installed in the same namespace; this chart only references the `tls.signingIssuerName` Issuer by name.

The switches are independent and can be adopted incrementally:

- **`enableTLS=true`** provisions the ingress server certificate (`tls.ingressCertName`, wired into `ingress.certSecretName`). External client → ingress HTTPS is independent of the agent-runtime, so this is safe and effective today, even with a plaintext runtime.
- **`tls.runtime.enabled=true`** additionally issues the manager and gateway runtime client certificates and activates `--runtime-client-cert-secret` plus the gateway enable-runtime-mtls/transport_socket. Those client paths fail against an agent-runtime that does not yet serve TLS — enable only once the agent-runtime image supports runtime TLS, and set it together with `tls.runtime.enabled` in the controller chart for the full runtime path.
- **`tls.peer.enabled=true`** secures the manager↔gateway route-sync/gossip channel (peer mTLS plus optional memberlist gossip encryption via `tls.peer.keySecretName`). It is independent of the agent-runtime data path and safe to enable on its own, but requires manager/gateway images that include openkruise/agents#967: an older sandbox-manager crashes on the unknown `--peer-*` flags (the gateway merely ignores unknown `PEER_*` env). Verify the image before enabling.
- **`tls.epe.enabled=true`** issues the EPE credential-provider client certificate. Requires `agentio.epe.mode=managed` with `agentio.epe.credentialProvider.mtls.source=files`; the certificate is written into the same files Secret EPE mounts with keys remapped to `client.crt`/`client.key`/`ca.crt`. Mesh workload certificates (egress gateway, traffic-proxy/ztunnel mTLS) are NOT issued here — agentiod/pilot issues them on demand as SPIFFE SVIDs.
- **`gateway.envoy.pluginConfig.enableJwtAuth=true`** (with `enableTLS`) turns on OIDC/JWT verification at the gateway. Requires `tls.oidc.discoveryUrl`; the verifier reads its CA from the `tls.oidc.caConfigMapName` ConfigMap through the API server, so that ConfigMap must exist in this namespace (the defaults point at the trust-manager Bundle created by the controller chart).

## Upgrading Agentio

For upgrades from Agentio 0.1, migrate renamed values using the [Agentio integration guide](https://github.com/openkruise/agentio/blob/0.2.0/manifests/charts/OPENKRUISE.md#migrate-release-01-values). Upgrade the controller's traffic-proxy configuration together with the control plane and recreate workload Pods for the `agentio-ca-root-cert` trust bundle and `agentio-ca` token audience. The mesh-internal policy now defaults to `PEER_AWARE`.
