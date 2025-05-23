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

install-from-local: install-kruise-from-local install-kruise-state-metrics-from-local