{{- define "agentio.config" }}
{{- if .Values.epe.enabled }}
sandboxExtProc:
  service: {{ .Values.epe.name }}.{{ include "agentio.namespace" . }}.svc.cluster.local
  port: {{ .Values.epe.port }}
  messageTimeout: {{ default "5s" .Values.epe.messageTimeout }}
  request:
    headerMode: SEND
    attributes:
    - filter_state['sandbox.id']
    - filter_state['sandbox.token']
    - filter_state['sandbox.labels']
    - filter_state['downstream_peer'].name
    - filter_state['downstream_peer'].namespace
    - destination.port
    - source.address
  response:
    headerMode: SKIP
{{- end }}
{{- if .Values.egressPolicies }}
egressPolicies:
{{ toYaml .Values.egressPolicies }}
{{- end }}
{{- $defaultServiceEntries := .Values.egressGateway.serviceEntries | default list }}
{{- $configuredGateways := list }}
{{- range $gateway := .Values.egressGateway.gateways }}
{{- $serviceEntries := $defaultServiceEntries }}
{{- if hasKey $gateway "serviceEntries" }}
{{- $serviceEntries = $gateway.serviceEntries }}
{{- end }}
{{- if $serviceEntries }}
{{- $configuredGateways = append $configuredGateways (dict
  "name" $gateway.name
  "namespace" (include "agentio.namespace" $)
  "serviceEntries" $serviceEntries
) }}
{{- end }}
{{- end }}
{{- if $configuredGateways }}
egressGateways:
{{ toYaml $configuredGateways }}
{{- end }}
{{- end }}
