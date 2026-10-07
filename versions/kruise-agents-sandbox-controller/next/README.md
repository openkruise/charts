# Agents Sandbox Controller v0.6.0-alpha4

## Installation

> **Server-side apply (SSA) is not supported by this chart.** The
> sandbox-controller manages the `template` annotation on the mutating and
> validating webhook configurations at runtime under its own field manager
> (`manager`). Applying the chart with Kubernetes server-side apply competes for
> that same annotation and fails with a field-ownership conflict such as:
>
> ```
> Apply failed with 1 conflict: conflict with "manager" using
> admissionregistration.k8s.io/v1: .metadata.annotations.template
> ```
>
> Disable server-side apply when using Helm. Do **not** pass `--server-side` to
> `helm install` / `helm upgrade` (Helm 3 uses client-side apply by default). If
> you use Helm 4 or another tool that applies with SSA by default, turn SSA off:
>
> ```bash
> helm upgrade --install agents-sandbox-controller next \
>   -n sandbox-system \
>   --set image.registry=<your-registry>
>   # do NOT add --server-side
> ```

## Configuration Parameters

The following tables list the configurable parameters of the agents-sandbox-controller chart and their default values.

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of sandbox-controller replicas | `2` |
| `image.registry` | Registry prepended to every image in this chart | `docker.io` |
| `image.repository` | sandbox-controller image repository | `openkruise/agent-sandbox-controller` |
| `image.tag` | sandbox-controller image tag | `v0.6.0-alpha4` |
| `image.pullPolicy` | Controller image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Image pull secrets list | `[]` |
| `namespace.name` | Namespace name for deployment | `sandbox-system` |
| `resources.limits.cpu` | Controller CPU resource limit | `2` |
| `resources.limits.memory` | Controller memory resource limit | `4Gi` |
| `resources.requests.cpu` | Controller CPU resource request | `2` |
| `resources.requests.memory` | Controller memory resource request | `4Gi` |
| `webhook.port` | Webhook service port | `9443` |
| `metrics.port` | Metrics service port (HTTPS with authn/authz delegation to kube-apiserver) | `8443` |
| `healthProbe.port` | Health probe port | `8081` |
| `controller.featureGates` | Comma-separated `--feature-gates` key=value pairs (e.g. `Foo=true,Bar=false`); empty sets no flag | `""` |

### Advanced Parameters

All remaining parameters are optional. Sensible defaults apply and most installs do not need to change them.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `controller.workers.sandboxWorkers` | Concurrent workers for the Sandbox reconciler | `200` |
| `controller.workers.sandboxsetWorkers` | Concurrent workers for the SandboxSet reconciler | `10` |
| `controller.workers.sandboxclaimWorkers` | Concurrent workers for the SandboxClaim reconciler | `200` |
| `controller.workers.sandboxupdateopsWorkers` | Concurrent workers for the SandboxUpdateOps reconciler | `5` |
| `controller.workers.poolautoscalerWorkers` | Concurrent workers for the PoolAutoscaler reconciler | `3` |
| `controller.workers.commitWorkers` | Concurrent workers for the Commit reconciler | `5` |
| `controller.clientQPS` | Kubernetes API client QPS rate limit | `30000` |
| `controller.clientBurst` | Kubernetes API client burst limit | `60000` |
| `metrics.rbac.create` | Create a ClusterRole granting `get` on the `/metrics` nonResourceURL; bind it to your Prometheus / ARMS scraper ServiceAccount | `true` |
| `nameOverride` | Override Chart name | `""` |
| `fullnameOverride` | Override full name | `""` |
| `serviceAccount.create` | Whether to create ServiceAccount | `true` |
| `serviceAccount.automount` | Whether to automount ServiceAccount Token | `true` |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}` |
| `serviceAccount.name` | ServiceAccount name to use | `""` |
| `rbac.create` | Whether to create RBAC resources | `true` |
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Pod labels | `{}` |
| `podSecurityContext` | Pod security context | `{runAsNonRoot: true, seccompProfile: {type: RuntimeDefault}}` |
| `securityContext` | Container security context | `{allowPrivilegeEscalation: false, capabilities: {drop: [ALL], add: [NET_BIND_SERVICE]}, readOnlyRootFilesystem: true}` |
| `nodeSelector` | Node selector for Pod scheduling | `{}` |
| `tolerations` | Tolerations for Pod scheduling | `[]` |
| `affinity` | Affinity for Pod scheduling | `{}` |
| `agentRuntime.image.repository` | Injected agent-runtime sidecar image repository | `openkruise/agent-runtime` |
| `agentRuntime.image.tag` | Injected agent-runtime sidecar image tag | `v0.3.0` |
| `agentRuntime.image.pullPolicy` | Injected agent-runtime sidecar image pull policy | `IfNotPresent` |
| `commitJob.image.repository` | Image repository of the Commit job pods | `openkruise/commit-job` |
| `commitJob.image.tag` | Image tag of the Commit job pods | `v0.3.0` |
| `enableTLS` | Master switch for cert-manager / trust-manager based TLS provisioning; when `false` nothing under `templates/tls/` renders and the controller keeps plaintext runtime behavior | `false` |
| `tls.createCA` | Create the shared root CA (selfSigned Issuer → CA Certificate → CA Issuer). The controller chart owns the CA; the sandbox-manager chart sets this to `false` and references the Issuer by name | `true` |
| `tls.selfSignedIssuerName` | Self-signed bootstrap Issuer name | `sandbox-selfsigned-issuer` |
| `tls.caCertificateName` | CA Certificate resource name | `sandbox-ca` |
| `tls.caSecretName` | Secret holding the CA key pair (`tls.crt`/`tls.key`); also the trust-manager Bundle source and the CA Issuer's signing material | `sandbox-ca-key-pair` |
| `tls.signingIssuerName` | CA Issuer name used to sign leaf certificates | `sandbox-signing-issuer` |
| `tls.caCommonName` | CA certificate common name | `sandbox-ca` |
| `tls.caOrganization` | CA certificate organization | `openkruise` |
| `tls.caDuration` | CA certificate lifetime | `87600h` (10 years) |
| `tls.certDuration` | Leaf certificate lifetime | `2160h` (90 days) |
| `tls.certRenewBefore` | Leaf certificate renewal window | `360h` (15 days) |
| `tls.runtime.enabled` | Issue the runtime client/server certificates and activate the client-side TLS paths (`--runtime-client-cert-dir` plus the agent-runtime sidecar TLS env). Fails against an agent-runtime that does not serve TLS; requires `enableTLS` | `false` |
| `tls.runtimeClientCertName` | Controller → agent-runtime client Certificate resource name | `sandbox-controller-runtime-client` |
| `tls.runtimeClientCertSecretName` | Controller client certificate Secret name | `sandbox-controller-runtime-client-cert` |
| `tls.runtimeClientCommonName` | Controller client certificate common name | `system:sandbox-controller-manager` |
| `tls.runtimeClientCertDir` | Mount point for `--runtime-client-cert-dir`; the volume remaps `tls.crt`/`tls.key`/`ca.crt` to `client.crt`/`client.key`/`ca.crt` | `/etc/agent-runtime-client/certs` |
| `tls.agentRuntimeServerCertName` | agent-runtime server Certificate resource name | `sandbox-agent-runtime-server` |
| `tls.agentRuntimeServerCertSecretName` | agent-runtime server certificate Secret name | `sandbox-agent-runtime-server-certs` |
| `tls.agentRuntimeServerSAN` | SAN the gateway/controller/manager use to reach the runtime | `agentruntime.sandbox.agents.kruise.io` |
| `tls.bundle.enabled` | Create the trust-manager Bundle distributing the CA as a `ca.crt` ConfigMap | `true` |
| `tls.bundle.name` | trust-manager Bundle name | `sandbox-ca-bundle` |
| `tls.bundle.configMapKey` | Key holding the CA in the distributed ConfigMap | `ca.crt` |
| `tls.bundle.namespaceSelector` | Namespace selector limiting where the CA ConfigMap is written; empty selects every namespace | `{}` |
| `agentio.trafficProxy.controlPlaneNamespace` | Namespace containing the Agentio control plane | `sandbox-system` |
| `agentio.trafficProxy.controlPlaneService` | Agentio control-plane Service name | `agentiod` |
| `agentio.trafficProxy.xdsAddress` | Explicit XDS address; generated from service and namespace when empty | `""` |
| `agentio.trafficProxy.caAddress` | Explicit CA address; generated from service and namespace when empty | `""` |
| `agentio.trafficProxy.caCertConfigMap` | CA ConfigMap mounted in injected workload namespaces | `agentio-ca-root-cert` |
| `agentio.trafficProxy.clusterId` | Cluster identifier reported to the control plane | `Kubernetes` |
| `agentio.trafficProxy.clusterDomain` | Kubernetes service DNS domain | `cluster.local` |
| `agentio.trafficProxy.tokenAudience` | Projected workload token audience | `agentio-ca` |
| `agentio.trafficProxy.includeInboundPorts` | Inbound ports captured by the traffic proxy | `*` |
| `agentio.trafficProxy.includeOutboundIPRanges` | Outbound IP ranges captured by the traffic proxy | `*` |
| `agentio.trafficProxy.includeOutboundPorts` | Outbound ports captured by the traffic proxy | `""` |
| `agentio.trafficProxy.excludeInboundPorts` | Inbound ports excluded from capture | `""` |
| `agentio.trafficProxy.excludeOutboundIPRanges` | Outbound IP ranges excluded from capture | `""` |
| `agentio.trafficProxy.excludeOutboundPorts` | Outbound ports excluded from capture | `""` |
| `agentio.trafficProxy.enableFirewallRules` | Enable traffic-proxy firewall rules | `true` |
| `agentio.trafficProxy.firewallBackend` | Firewall backend selection | `auto` |
| `agentio.trafficProxy.imagePullPolicy` | Traffic-proxy image pull policy | `IfNotPresent` |
| `agentio.trafficProxy.healthProbeRewrite` | Rewrite health probes for injected traffic proxies | `true` |
| `agentio.trafficProxy.dnsCapture` | Enable DNS capture | `true` |
| `agentio.trafficProxy.image.registry` | Injected ztunnel image registry; empty inherits `image.registry` | `""` |
| `agentio.trafficProxy.image.repository` | Injected ztunnel image repository | `openkruise/ztunnel` |
| `agentio.trafficProxy.image.tag` | Injected ztunnel image tag | `0.2.0` |
| `agentio.trafficProxy.image.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.trafficProxy.initImage.registry` | Injected iptables init image registry; empty inherits `image.registry` | `""` |
| `agentio.trafficProxy.initImage.repository` | Injected iptables init image repository | `openkruise/proxy-init` |
| `agentio.trafficProxy.initImage.tag` | Injected iptables init image tag | `0.2.0` |
| `agentio.trafficProxy.initImage.digest` | Optional digest override; takes precedence over tag | `""` |
| `agentio.trafficProxy.resources` | Injected ztunnel resources | `requests: 100m/64Mi, limits: 200m/128Mi` |
| `agentio.trafficProxy.initResources` | Injected iptables init resources | `requests: 100m/128Mi, limits: 1/1Gi` |

## Image Registry

Images render as `<registry>/<repository>:<tag>` or, with a digest override, `<registry>/<repository>@<digest>`. The `registry` defaults to the chart-wide `image.registry`. The agentio images carry their own `registry` key, which overrides `image.registry` when non-empty.

The registry prefix is dropped when the first path segment of a repository already names a host (it contains a `.` or a `:`), so setting `image.repository` to `myreg.io/openkruise/agent-sandbox-controller` keeps working without also clearing `image.registry`.

The `sandbox-injection-config` ConfigMap is installed in the sandbox-controller release namespace. `controlPlaneNamespace` is independent, so the injected traffic proxy can connect to Agentio running in another namespace.

Agentio images use the fixed `0.2.0` tag by default; an optional `digest` overrides the tag.

Upgrade the traffic-proxy configuration together with the Agentio control plane and recreate workload Pods for the `agentio-ca-root-cert` trust bundle and `agentio-ca` token audience.

## TLS Provisioning (cert-manager / trust-manager)

All TLS resources live under `templates/tls/` and are gated by `enableTLS` (default `false`), which requires cert-manager and, for the CA Bundle, trust-manager to be installed in the cluster.

- **`enableTLS=true`** provisions the shared root CA (`tls.createCA`), the trust-manager Bundle (`tls.bundle.*`) that distributes the CA as a `ca.crt` ConfigMap, and — in the sandbox-manager chart — the ingress certificate. These resources are inert against a plaintext runtime.
- **The root CA is owned by this chart.** The sandbox-manager chart must be installed in the same namespace (one-Issuer topology) and references the `tls.signingIssuerName` Issuer created here with its own `tls.createCA=false`.
- **`tls.runtime.enabled=true`** additionally issues the controller's runtime client certificate (`--runtime-client-cert-dir`) and the agent-runtime server certificate, and activates the agent-runtime sidecar TLS environment. Those paths fail against an agent-runtime that does not yet serve TLS, so enable this only once the agent-runtime image supports runtime TLS. Requires `enableTLS`, and must be set together with `tls.runtime.enabled` in the sandbox-manager chart for the full runtime path.

## Agent Runtime Injection

The `sandbox-injection-config` ConfigMap also ships an `agent-runtime` entry.
It is applied only to sandboxes that explicitly opt in by declaring the runtime
in `Sandbox.spec.runtimes`:

```yaml
apiVersion: agents.kruise.io/v1alpha1
kind: Sandbox
metadata:
  name: demo
spec:
  runtimes:
    - name: agent-runtime
  # ... pod template
```

When the runtime is declared, the controller injects:

- A native sidecar container named `agent-runtime`, built from
  `agentRuntime.image.repository`, `agentRuntime.image.tag` and
  `agentRuntime.image.pullPolicy`. The default is the public image
  `openkruise/agent-runtime:v0.3.0`. The sidecar carries its own `ENVD_DIR`
  environment variable and mounts `envd-volume` at `/mnt/envd`.
- `ENVD_DIR`, `GODEBUG` and `POD_UID` environment variables, the `envd-volume`
  (`/mnt/envd`) mount, and a `postStart` hook into the first business container.
- One `emptyDir` volume named `envd-volume`, shared by the sidecar and the first
  business container.

### Requirements

- **Kubernetes >= 1.29.** The `agent-runtime` container is injected as a native
  sidecar (an init container with `restartPolicy: Always`), which requires the
  `SidecarContainers` feature to be enabled by default. On older clusters the
  injected pod will be rejected or the sidecar will not restart as expected.
- **The first business container image must contain `bash`.** The injected
  `postStart` hook runs `bash /mnt/envd/envd-run.sh` inside that container, so
  images without a `bash` binary (for example plain `distroless` or `busybox`
  based images) will fail to start.

### Not included

This chart intentionally ships only the `traffic-proxy` and `agent-runtime`
injection entries. The **TLS / helper runtime** and the **CSI runtime** are
**not** included: no CSI driver, no `AGENT_IDENTITY` settings or certificates,
and no additional RBAC, Deployment, Service or CRD resources are created for
them. Deploy those components separately if your environment needs them.

Specify each parameter using the `--set key=value[,key=value]` argument. For example:

```bash
helm install agents-sandbox-controller openkruise/kruise-agents-sandbox-controller -n <namespace> \
  --set key=value...
```
