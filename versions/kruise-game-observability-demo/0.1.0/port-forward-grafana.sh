#!/usr/bin/env bash

# Helper: Port-forward Grafana from the okg-demo chart in kind/local clusters.
# Usage:
#   NAMESPACE=okg-demo RELEASE=okg-demo LOCAL_PORT=3000 ./port-forward-grafana.sh
# Defaults match the demo chart (`okg-demo` release/namespace, service ${RELEASE}-grafana).

set -euo pipefail

NAMESPACE="${NAMESPACE:-okg-demo}"
RELEASE="${RELEASE:-okg-demo}"
SERVICE="${SERVICE:-${RELEASE}-grafana}"
LOCAL_PORT="${LOCAL_PORT:-3000}"
REMOTE_PORT="${REMOTE_PORT:-80}"

command -v kubectl >/dev/null || { echo "kubectl not found" >&2; exit 1; }

if ! kubectl -n "${NAMESPACE}" get svc "${SERVICE}" >/dev/null 2>&1; then
  echo "Service ${SERVICE} not found in namespace ${NAMESPACE}. Is the demo chart installed?" >&2
  exit 1
fi

echo "Port-forwarding svc/${SERVICE} ${LOCAL_PORT}->${REMOTE_PORT} in namespace ${NAMESPACE}..."
echo "Press Ctrl+C to stop."

kubectl port-forward -n "${NAMESPACE}" "svc/${SERVICE}" "${LOCAL_PORT}:${REMOTE_PORT}"
