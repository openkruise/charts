# KruiseGame Observability Demo Chart

This chart deploys a complete observability stack for KruiseGame, including:
- **OpenKruise** (to provide PodProbeMarker / Advanced StatefulSet CRDs)
- **KruiseGame Controller Manager** (configured to emit telemetry)
- **OpenTelemetry Collector** (receives, processes, and exports telemetry)
- **Prometheus** (Metrics)
- **Loki** (Logs)
- **Tempo** (Traces)
- **Grafana** (Visualization with pre-loaded dashboards)
- **Minecraft demo GameServer** (HostPort network) to generate telemetry (logs/metrics/traces)

It is designed for **demonstration and testing purposes** to showcase the observability capabilities of KruiseGame out-of-the-box.

## Prerequisites

- Kubernetes 1.18+
- Helm >=3.12 (validated with Helm 4.x)

## Installation

### 1. Create Kind Cluster

For local testing, use the provided kind configuration:

```bash
kind create cluster --name okg-demo \
  --config charts/versions/kruise-game-observability-demo/0.1.0/kind-conf.yaml
```

### 2. Install Chart

We recommend installing with the release name `okg-demo` in namespace `okg-demo` to ensure all service links work correctly by default.

```bash
cd charts/versions/kruise-game-observability-demo/0.1.0
helm upgrade --install okg-demo . \
  --namespace okg-demo --create-namespace \
  --wait --timeout 10m --dependency-update
```

> **Note**: The `--dependency-update` flag automatically resolves all chart dependencies. If you choose a different release name, you MUST override the endpoint URLs in `values.yaml` (e.g., `kruise-game.manager.otel.endpoint`, Grafana datasources) to match your release name.

## Images and tags

- Default KruiseGame image: `ghcr.io/ballista01/kruise-game-manager:dev` (tracks the latest dev build).
- To pin a specific build, override via Helm:
  ```bash
  # Use a specific tag (e.g., dev-<sha>)
  helm upgrade --install okg-demo charts/kruise-game-observability-demo \
    --namespace okg-demo --create-namespace \
    --set kruise-game.image.tag=dev-<sha>

  # Or pin by digest (if available)
  helm upgrade --install okg-demo charts/kruise-game-observability-demo \
    --namespace okg-demo --create-namespace \
    --set kruise-game.image.digest=sha256:<digest>
  ```

## Verification

1. **Wait for Pods**: Ensure all pods in `okg-demo` namespace are running.
   ```bash
   kubectl get pods -n okg-demo -w
   ```

2. **Access Grafana**:
   ```bash
   # Use the provided port-forward script
   ./port-forward-grafana.sh
   # Or manually:
   # kubectl port-forward --namespace okg-demo svc/okg-demo-grafana 3000:80
   ```
   Open http://localhost:3000 in your browser (default credentials: admin/admin).

3. **View Dashboards**:
   Go to **Dashboards** -> **Browse**. You will see the "KruiseGame Overview" dashboard.

4. **Generate Traffic**:
   Deploy a GameServerSet to see metrics, logs, and traces populate the dashboard.

## Exploring Telemetry

Once the demo is running, here's how to navigate the observability stack:

### Dashboards (Metrics)
1. Open Grafana at http://localhost:3000
2. Go to **Dashboards** → **KruiseGame Overview**
3. Key panels:
   - **GameServer State Distribution** - Current state of all GameServers
   - **Network Ready Duration** - Time for network to become ready
   - **Error Rate by Plugin** - Network plugin error rates (look for exemplar dots)

### Traces (Drilldown/Traces)
1. In Grafana, open **Drilldown** → **Traces** (Tempo).
2. Filter by attributes (e.g., `service.name="okg-controller-manager"`, `game.kruise.io.network.plugin.name="kubernetes_nodeport"`, `status.code=ERROR`).
3. Use the RED view (Rate/Errors/Duration) to spot spikes, then open a trace to inspect the span tree.

### Logs (Drilldown/Logs)
1. In Grafana, open **Drilldown** → **Logs** (Loki).
2. Filter by labels (e.g., `{namespace="okg-demo"}` or add `|= "error"`).
3. Expand an entry to see `trace_id` and click it to jump back to the corresponding trace.

### Trace-Log Correlation
The real power is connecting signals:
1. Find an error span in Tempo
2. Note the `trace_id`
3. In Loki, search for that trace ID to see all related logs
4. Or use Grafana's built-in "Logs for this span" feature

For detailed diagnosis workflows and examples, see the [Observability Usage Guide](https://github.com/openkruise/kruise-game/blob/main/docs/en/observability/observability-usage.md#7-diagnosis-scenarios-cookbook).

## Configuration

This chart is a wrapper around several upstream charts. Key configurations are exposed in `values.yaml`, but you can override any sub-chart value. `kruise-game.manager.logFormat` only changes the human-readable Pod stdout; OTLP output stays structured either way. Use `--set kruise-game.manager.logFormat=json` if you prefer JSON logs in stdout.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kruise-game.manager.logFormat` | Log output format for KruiseGame manager (`console` or `json`) | `console` |
| `kruise-game.manager.otel.enabled` | Enable OTel in KruiseGame | `true` |
| `opentelemetry-collector.mode` | Deployment mode for collector | `deployment` |
| `loki.enabled` | Enable Loki | `true` |
| `tempo.enabled` | Enable Tempo | `true` |
| `prometheus.enabled` | Enable Prometheus | `true` |
| `grafana.enabled` | Enable Grafana | `true` |
| `demoGameServer.enabled` | Deploy demo GameServerSet (Minecraft, HostPort) | `true` |

OpenKruise is bundled to install required CRDs (PodProbeMarker, Advanced StatefulSet). Defaults: `kruise.installCRDs=true`, `kruise.installation.namespace=kruise-system`, `kruise.manager.replicaCount=1`.

For full configuration, refer to the `values.yaml` file and the documentation of the dependency charts.
