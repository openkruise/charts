#!/usr/bin/env bash
# Copyright (c) 2023 Alibaba Group Holding Ltd.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

NODES=$(kubectl get node | wc -l)
NODES=$(($NODES-1))
EXCEPT_PODS=$(($NODES+2))
for ((i=1;i<20;i++));
do
  set +e
  PODS=$(kubectl get pod -n kruise-system | grep -c '1/1')
  set -e
  if [ "$PODS" -eq "$EXCEPT_PODS" ]; then
    break
  fi
  sleep 3
done
set +e
PODS=$(kubectl get pod -n kruise-system | grep -c '1/1')
kubectl get node
kubectl get all -n kruise-system
kubectl get pod -n kruise-system --no-headers | grep daemon | awk '{print $1}' | xargs kubectl logs -n kruise-system --tail 100
kubectl get pod -n kruise-system --no-headers | grep daemon | awk '{print $1}' | xargs kubectl logs -n kruise-system --previous=true --tail 100
set -e
if [ "$PODS" -eq "$EXCEPT_PODS" ]; then
  echo "Wait for kruise-manager and kruise-daemon ready successfully"
else
  echo "Timeout to wait for kruise-manager and kruise-daemon ready"
  exit 1
fi
