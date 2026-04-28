# AGENTS.md

This file provides guidance to Qoder (qoder.com) when working with code in this repository.

## Project Overview

This repository contains **Helm charts** for [OpenKruise](https://openkruise.io/) Kubernetes operators and components. It is a packaging/distribution repo — it does not contain Go source code for the controllers themselves (those live in separate repos like `openkruise/kruise`). The work here is authoring and maintaining Helm chart templates, values, CRDs, and RBAC manifests.

The charts are published to `https://openkruise.github.io/charts` via GitHub Pages using `helm/chart-releaser-action`.

## Charts in This Repository

| Chart | Purpose | Upstream Source |
|---|---|---|
| `kruise` | Core OpenKruise manager (CloneSet, SidecarSet, BroadcastJob, etc.) + kruise-daemon DaemonSet | [openkruise/kruise/config](https://github.com/openkruise/kruise/tree/master/config) |
| `kruise-rollout` | Progressive delivery / canary rollout controller | [openkruise/rollouts/config](https://github.com/openkruise/rollouts/tree/master/config) |
| `kruise-game` | Game server orchestration (GameServer, GameServerSet) | [openkruise/kruise-game/config](https://github.com/openkruise/kruise-game/tree/master/config) |
| `kruise-state-metrics` | Prometheus metrics exporter for Kruise workloads | [openkruise/kruise-state-metrics/deploy](https://github.com/openkruise/kruise-state-metrics/tree/master/deploy) |
| `kruise-agents-sandbox-controller` | Sandbox controller for agent workloads | [openkruise/agents/config](https://github.com/openkruise/agents/tree/master/config) |
| `kruise-agents-sandbox-manager` | Sandbox manager with gateway (Envoy-based) for agent workloads | [openkruise/agents/config/sandbox-manager](https://github.com/openkruise/agents/tree/master/config/sandbox-manager) |

Manifest changes from the upstream source repos should be merged into the corresponding `versions/<chart>/next/` directory in this repo.

## Repository Architecture

### Pointer-Based Version Selection

The **critical architectural pattern** to understand: the `charts/` directory does NOT contain chart source directly. Each entry is a **pointer file** — a text file whose content is a relative path to the actual chart under `versions/`:

```
charts/kruise                -> ../versions/kruise/1.8.3
charts/kruise-rollout        -> ../versions/kruise-rollout/0.6.2
charts/kruise-game           -> ../versions/kruise-game/1.0.0
...
```

The CI publish workflow (`chart-releaser-action`) reads from `charts/` as its `charts_dir`. To release a new version, you update the pointer file in `charts/` to reference the new version directory.

### Directory Layout

- **`versions/<chart-name>/<version>/`** — The authoritative source for each chart version. Each contains `Chart.yaml`, `values.yaml`, `templates/`, and optionally `ci/`, `README.md`.
- **`versions/<chart-name>/next/`** — A pseudo-version used to stage in-progress changes for the next major release.
- **`charts/<chart-name>`** — Pointer files whose content is a relative path to the currently-published version in `versions/`.
- **`history-versions/`** — Legacy kruise chart versions (pre-1.0, `v0.x.x` naming). These are historical artifacts.
- **`scripts/`** — `lint.sh` (runs chart-testing via Docker) and `check-kruise.sh` (waits for kruise pods to become ready in a cluster).
- **`test/`** — Kind cluster configurations for CI (`kind-conf.yaml`, `kind-conf-with-vpa.yaml`).
- **`.github/configs/`** — Chart-testing and chart-releaser config files (`ct-lint.yaml`, `ct-install.yaml`, `cr.yaml`, `lintconf.yaml`).

### Chart Internal Structure

Each chart version directory follows the standard Helm layout:
- `Chart.yaml` — Chart metadata, version, appVersion, and `artifacthub.io/changes` annotations
- `values.yaml` — Default configuration values
- `templates/_helpers.tpl` — Shared template helpers (naming, labels, lookup of existing resources)
- `templates/manager.yaml` — Main workload manifests (Deployment, DaemonSet, ServiceAccount, Service, Secret)
- `templates/rbac_role.yaml` — ClusterRole/ClusterRoleBinding definitions
- `templates/webhookconfiguration.yaml` — MutatingWebhookConfiguration / ValidatingWebhookConfiguration
- `templates/*.yaml` (CRD files) — CustomResourceDefinition manifests, named after the API group (e.g., `apps.kruise.io_clonesets.yaml`)
- `ci/` — Values files used by chart-testing for install tests

The kruise chart notably uses Helm `lookup` functions in `_helpers.tpl` to preserve existing immutable fields (ClusterIP, Secret data) during upgrades.

## Commands

### Linting

```bash
# Run chart-testing lint via Docker (no local ct installation needed)
./scripts/lint.sh
```

This uses the `quay.io/helmpack/chart-testing:v3.3.1` Docker image with configs in `.github/configs/ct-lint.yaml` and `.github/configs/lintconf.yaml`.

### Helm Template Validation

```bash
# Render templates locally without installing (useful for checking template output)
helm template my-release charts/kruise

# Lint a single chart with Helm directly
helm lint charts/kruise
```

### Local Installation (requires a Kubernetes cluster)

```bash
# Install kruise from local chart
make install-kruise-from-local

# Install other components
make install-kruise-state-metrics-from-local
make install-kruise-rollout-from-local
make install-kruise-game-from-local
make install-agents-sandbox-controller-from-local
make install-agents-sandbox-manager-from-local

# Install kruise + state-metrics together
make install-from-local
```

Each Makefile target runs `helm install` followed by a readiness check (`kubectl wait --for=condition=Ready`).

### E2E Testing

The E2E workflow (`.github/workflows/e2e-kruise.yaml`) creates Kind clusters across multiple Kubernetes versions (v1.24 through v1.32) and installs all charts. Two Kind configs exist:
- `test/kind-conf.yaml` — Standard 1 control-plane + 3 workers
- `test/kind-conf-with-vpa.yaml` — Same, with `InPlacePodVerticalScaling` feature gate (for K8s >= 1.27)

## Versioning and Release Workflow

### Update Next Chart Content
1. Pull the latest manifests (CRDs, RBAC, Deployments, etc.) from the chart's upstream source repo (see "Upstream Source" column above) into `versions/<chart>/next/templates/`.
2. Add or update Helm template directives and `values.yaml` entries for any newly introduced fields or resources.
3. Submit a PR and get it merged. Do NOT modify `next` and a version-specific directory (e.g., `1.9.0`) in the same PR.

### Creating a New Version

**New major/minor release** — copy from `next`:
```bash
cd versions/kruise/
cp -r next 1.9.0
```

**New patch release** — copy from latest patch:
```bash
cd versions/kruise/
cp -r 1.7.3 1.7.4
```

### Publishing a Release

1. Update the version directory contents (Chart.yaml version/appVersion, values.yaml image tags, templates, CRDs)
2. Update the symlink in `charts/` to point to the new version:
   ```bash
   cd charts
   ln -sf ../versions/kruise/1.9.0 kruise
   ```
3. Merge to `master`. The `publish.yaml` workflow runs `chart-releaser-action` automatically.

### Key Versioning Rules

- Each chart release is **immutable** — even documentation-only changes require a version bump.
- `Chart.yaml` must include `artifacthub.io/changes` annotations documenting what changed.
- `values.yaml` image tags must match `Chart.yaml` `appVersion`.
- PR titles must follow [semantic PR](https://github.com/zeke/semantic-pull-requests) conventions (enforced by `semantic.yml`).
- All commits must be signed off (DCO).

## CI Pipelines

| Workflow | Trigger | What it does |
|---|---|---|
| `lint-and-test.yml` | Pull requests | Runs `ct lint` and `ct install` (only if charts changed) on a Kind cluster |
| `e2e-kruise.yaml` | Push to master/release-*, PRs | Installs all charts on Kind clusters across K8s v1.24–v1.32 |
| `publish.yaml` | Push to master | Packages and publishes charts to GitHub Pages (`gh-pages` branch) |

## YAML Lint Rules

The linting config (`.github/configs/lintconf.yaml`) enforces:
- Consistent indentation (spaces, flexible sequence indent)
- No trailing spaces, unix newlines, newline at end of file
- No duplicate keys
- No line-length limit
- Comments must have a starting space
