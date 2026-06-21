IMG ?= openkruise/kruise-manager:test


.PHONY: install-kruise-from-local
install-kruise-from-local:
	helm install kruise charts/kruise
	./scripts/check-kruise.sh

.PHONY: install-kruise-from-helm
install-kruise-from-helm:
	helm install kruise openkruise/kruise
	./scripts/check-kruise.sh

# wait-for-pods first polls until pods matching the label selector exist, then
# waits for them to become Ready. On failure, runs diagnose.sh to dump cluster
# state for debugging (deployment status, events, webhook configs, manager logs).
wait-for-pods = \
	for i in $$(seq 1 30); do \
	  kubectl -n $(1) get pods -l $(2) --no-headers 2>/dev/null | grep -q . && break; \
	  sleep 2; \
	done; \
	kubectl -n $(1) wait --for=condition=Ready pods -l $(2) --timeout=120s || { echo "\nERROR: pods not ready in namespace $(1) with selector $(2)\n"; ./scripts/diagnose.sh $(1) $(2); exit 1; }

.PHONY: install-kruise-state-metrics-from-local
install-kruise-state-metrics-from-local:
	helm install kruise-sm charts/kruise-state-metrics --set installation.installServiceMonitor=false
	$(call wait-for-pods,kruise-system,control-plane=kruise-state-metrics)

.PHONY: install-kruise-rollout-from-local
install-kruise-rollout-from-local:
	helm install kruise-rollout charts/kruise-rollout
	$(call wait-for-pods,kruise-rollout,control-plane=kruise-rollout-controller-manager)


.PHONY: install-kruise-game-from-local
install-kruise-game-from-local:
	helm install kruise-game charts/kruise-game
	$(call wait-for-pods,kruise-game-system,control-plane=kruise-game-controller-manager)

.PHONY: install-agents-sandbox-controller-from-local
install-agents-sandbox-controller-from-local:
	kubectl get namespace sandbox-system > /dev/null 2>&1 || kubectl create namespace sandbox-system
	helm install agents-sandbox-controller charts/kruise-agents-sandbox-controller -n sandbox-system \
		--set replicaCount=1 \
        --set-json 'resources={"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"500m","memory":"512Mi"}}'
	$(call wait-for-pods,sandbox-system,control-plane=agents-sandbox-controller)

.PHONY: install-agents-sandbox-manager-from-local
install-agents-sandbox-manager-from-local:
	helm install agents-sandbox-manager charts/kruise-agents-sandbox-manager -n sandbox-system \
		--set replicaCount=1 \
        --set-json 'controller.resources={"cpu":"500m","memory":"512Mi"}' \
        --set-json 'gateway.resources={"cpu":"500m","memory":"512Mi"}' \
		--set gateway.envoy.concurrency=1 \
		--set e2b.adminApiKey='adminApiKey' \
		--set ingress.className='alb' \
		--set gateway.replicaCount=1
	$(call wait-for-pods,sandbox-system,component=agents-sandbox-manager)
	$(call wait-for-pods,sandbox-system,app.kubernetes.io/name=sandbox-gateway)

install-from-local: install-kruise-from-local install-kruise-state-metrics-from-local