{{/*
Expand the name of the chart.
*/}}
{{- define "aws-xp-eso.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aws-xp-eso.fullname" -}}
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
{{- define "aws-xp-eso.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aws-xp-eso.labels" -}}
helm.sh/chart: {{ include "aws-xp-eso.chart" . }}
{{ include "aws-xp-eso.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aws-xp-eso.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aws-xp-eso.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "aws-xp-eso.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aws-xp-eso.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create Secret ARN list for the IAM policy
*/}}
{{- define "list.secretArns" -}}
{{- if and .Values.aws.enabled .Values.aws.secretManager }}
items:
{{- range .Values.aws.secretManager.secrets }}
  {{- range .data }}
  - arn:aws:secretsmanager:{{ $.Values.aws.region }}:{{ $.Values.aws.accountId }}:secret:{{ .remoteRef.key }}-*
  {{- end }}
{{- end }}
{{- else }}
items: []
{{- end }}
{{- end }}
