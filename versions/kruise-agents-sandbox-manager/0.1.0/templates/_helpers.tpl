{{/*
Expand the name of the chart.
*/}}
{{- define "sandbox-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sandbox-manager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sandbox-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sandbox-manager.labels" -}}
helm.sh/chart: {{ include "sandbox-manager.chart" . }}
{{ include "sandbox-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sandbox-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sandbox-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
component: {{ include "sandbox-manager.name" . }}
{{- end }}

{{- define "sandbox-manager.peerLabels" -}}
agents.kruise.io/sandbox-manager-peer-finder: {{ .Release.Name }}-{{ .Release.Revision }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sandbox-manager.serviceAccountName" -}}
{{- default (include "sandbox-manager.fullname" .) .Values.serviceAccount.name }}
{{- end }}
