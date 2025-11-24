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
- Helm 4.x

## Installation

### 1. Add Repository (Optional)

If you are installing from a Helm repository:

```bash
helm repo add openkruise https://openkruise.github.io/charts/
helm repo update
```

### 2. Install Chart

We recommend installing with the release name `okg-demo` in namespace `okg-demo` to ensure all service links work correctly by default.

```bash
helm dependency build charts/charts/kruise-game-observability-demo
helm install okg-demo charts/charts/kruise-game-observability-demo --namespace okg-demo --create-namespace
```

> **Note**: If you choose a different release name, you MUST override the endpoint URLs in `values.yaml` (e.g., `kruise-game.manager.otel.endpoint`, Grafana datasources) to match your release name.

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
   # Get admin password (default: admin)
   kubectl get secret --namespace okg-demo okg-demo-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

   # Port-forward Grafana
   kubectl port-forward --namespace okg-demo svc/okg-demo-grafana 3000:80
   ```
   Open http://localhost:3000 in your browser.

3. **View Dashboards**:
   Go to **Dashboards** -> **Browse**. You will see the "KruiseGame Overview" dashboard.

4. **Generate Traffic**:
   Deploy a GameServerSet to see metrics, logs, and traces populate the dashboard.

## Configuration

This chart is a wrapper around several upstream charts. Key configurations are exposed in `values.yaml`, but you can override any sub-chart value.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kruise-game.manager.otel.enabled` | Enable OTel in KruiseGame | `true` |
| `opentelemetry-collector.mode` | Deployment mode for collector | `deployment` |
| `loki.enabled` | Enable Loki | `true` |
| `tempo.enabled` | Enable Tempo | `true` |
| `prometheus.enabled` | Enable Prometheus | `true` |
| `grafana.enabled` | Enable Grafana | `true` |
| `demoGameServer.enabled` | Deploy demo GameServerSet (Minecraft, HostPort) | `true` |

OpenKruise is bundled to install required CRDs (PodProbeMarker, Advanced StatefulSet). Defaults: `kruise.installCRDs=true`, `kruise.installation.namespace=kruise-system`, `kruise.manager.replicaCount=1`.

For full configuration, refer to the `values.yaml` file and the documentation of the dependency charts.
