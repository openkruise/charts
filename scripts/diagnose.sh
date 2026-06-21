#!/usr/bin/env bash
# Copyright (c) 2023 Alibaba Group Holding Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# diagnose.sh prints diagnostic information about why pods in a namespace
# may not be created or ready. Useful for debugging e2e test failures.
#
# Usage: diagnose.sh <namespace> [label-selector]

set +e

NAMESPACE="${1:-default}"
SELECTOR="${2:-}"

echo "==================== DIAGNOSTICS for namespace: ${NAMESPACE} ===================="
echo ""

echo "--- Nodes ---"
kubectl get nodes -o wide
echo ""

echo "--- All pods in ${NAMESPACE} ---"
kubectl get pods -n "${NAMESPACE}" -o wide
echo ""

if [ -n "${SELECTOR}" ]; then
  echo "--- Pods matching selector '${SELECTOR}' in ${NAMESPACE} ---"
  kubectl get pods -n "${NAMESPACE}" -l "${SELECTOR}" -o wide
  echo ""
fi

echo "--- Deployments in ${NAMESPACE} ---"
kubectl get deployments -n "${NAMESPACE}" -o wide
echo ""

echo "--- Deployment details in ${NAMESPACE} ---"
kubectl describe deployments -n "${NAMESPACE}"
echo ""

echo "--- ReplicaSets in ${NAMESPACE} ---"
kubectl get replicasets -n "${NAMESPACE}" -o wide
echo ""

echo "--- ReplicaSet details (shows FailedCreate events) ---"
kubectl describe replicasets -n "${NAMESPACE}"
echo ""

echo "--- Events in ${NAMESPACE} (last 20, sorted by time) ---"
kubectl get events -n "${NAMESPACE}" --sort-by=.lastTimestamp | tail -20
echo ""

echo "--- All resources in ${NAMESPACE} ---"
kubectl get all -n "${NAMESPACE}"
echo ""

echo "--- Kruise system pods ---"
kubectl get pods -n kruise-system -o wide
echo ""

echo "--- Kruise manager logs (last 100 lines) ---"
kubectl logs -n kruise-system -l control-plane=controller-manager --tail=100 --max-log-requests=5
echo ""

echo "--- Kruise manager logs (previous, last 100 lines) ---"
kubectl logs -n kruise-system -l control-plane=controller-manager --tail=100 --previous=true --max-log-requests=5
echo ""

echo "--- Mutating webhook configurations ---"
kubectl get mutatingwebhookconfigurations
echo ""

echo "--- Validating webhook configurations ---"
kubectl get validatingwebhookconfigurations
echo ""

echo "--- Kruise mutating webhook details ---"
kubectl describe mutatingwebhookconfiguration kruise-mutating-webhook-configuration
echo ""

echo "--- Kruise webhook service endpoints ---"
kubectl get endpoints -n kruise-system kruise-webhook-service
echo ""

echo "==================== END DIAGNOSTICS ===================="
