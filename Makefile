IMG ?= openkruise/kruise-manager:test


.PHONY: install-kruise-from-local
install-kruise-from-local:
	helm install kruise charts/kruise
	./scripts/check-kruise.sh

.PHONY: install-kruise-from-helm
install-kruise-from-helm:
	helm install kruise openkruise/kruise
	./scripts/check-kruise.sh

.PHONY: install-kruise-state-metrics-from-local
install-kruise-state-metrics-from-local:
	helm install kruise-sm charts/kruise-state-metrics --set installation.installServiceMonitor=false
	sleep 1
	kubectl -n kruise-system wait --for=condition=Ready pods -l control-plane=kruise-state-metrics --timeout=60s || exit 1

.PHONY: install-kruise-rollout-from-local
install-kruise-rollout-from-local:
	helm install kruise-rollout charts/kruise-rollout
	sleep 1
	kubectl -n kruise-rollout wait --for=condition=Ready pods -l control-plane=kruise-rollout-controller-manager --timeout=60s || exit 1


.PHONY: install-kruise-game-from-local
install-kruise-game-from-local:
	helm install kruise-game charts/kruise-game
	sleep 1
	kubectl -n kruise-game-system wait --for=condition=Ready pods -l control-plane=kruise-game-controller-manager --timeout=60s || exit 1

.PHONY: install-agents-sandbox-controller-from-local
install-agents-sandbox-controller-from-local:
	kubectl get namespace sandbox-system > /dev/null 2>&1 || kubectl create namespace sandbox-system
	helm install agents-sandbox-controller charts/kruise-agents-sandbox-controller -n sandbox-system \
		--set replicaCount=1 \
        --set-json 'resources={"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"500m","memory":"512Mi"}}'
	sleep 1
	kubectl -n sandbox-system wait --for=condition=Ready pods -l control-plane=agents-sandbox-controller --timeout=60s || exit 1

.PHONY: install-agents-sandbox-manager-from-local
install-agents-sandbox-manager-from-local:
	helm install agents-sandbox-manager charts/kruise-agents-sandbox-manager -n sandbox-system \
		--set replicaCount=1 \
        --set-json 'controller.resources={"cpu":"500m","memory":"512Mi"}' \
        --set-json 'proxy.resources={"cpu":"500m","memory":"512Mi"}' \
        --set e2b.adminApiKey=test-key \
        --set ingress.className=nginx
	sleep 1
	kubectl -n sandbox-system wait --for=condition=Ready pods -l component=agents-sandbox-manager --timeout=60s || exit 1

install-from-local: install-kruise-from-local install-kruise-state-metrics-from-local