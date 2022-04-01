{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "velero.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "velero.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "velero.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use for creating or deleting the velero server
*/}}
{{- define "velero.serverServiceAccount" -}}
{{- if .Values.serviceAccount.server.create -}}
    {{ default (printf "%s-%s" (include "velero.fullname" .) "server") .Values.serviceAccount.server.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.server.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name for the credentials secret.
*/}}
{{- define "velero.secretName" -}}
{{- if .Values.credentials.existingSecret -}}
  {{- .Values.credentials.existingSecret -}}
{{- else -}}
  {{- include "velero.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Create the Velero priority class name.
*/}}
{{- define "velero.priorityClassName" -}}
{{- if .Values.priorityClassName -}}
  {{- .Values.priorityClassName -}}
{{- else -}}
  {{- include "velero.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Create the Restic priority class name.
*/}}
{{- define "velero.restic.priorityClassName" -}}
{{- if .Values.restic.priorityClassName -}}
  {{- .Values.restic.priorityClassName -}}
{{- else -}}
  {{- include "velero.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Create the backup storage location name
*/}}
{{- define "velero.backupStorageLocation.name" -}}
{{- with .Values.configuration.backupStorageLocation -}}
{{ default "default" .name }}
{{- end -}}
{{- end -}}

{{/*
Create the backup storage location provider
*/}}
{{- define "velero.backupStorageLocation.provider" -}}
{{- with .Values.configuration -}}
{{ default .provider .backupStorageLocation.provider }}
{{- end -}}
{{- end -}}

{{/*
Create the volume snapshot location name
*/}}
{{- define "velero.volumeSnapshotLocation.name" -}}
{{- with .Values.configuration.volumeSnapshotLocation -}}
{{ default "default" .name }}
{{- end -}}
{{- end -}}

{{/*
Create the volume snapshot location provider
*/}}
{{- define "velero.volumeSnapshotLocation.provider" -}}
{{- with .Values.configuration -}}
{{ default .provider .volumeSnapshotLocation.provider }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
{{ include "labels.selector" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "velero.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
name: velero
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "velero.name" . }}
{{- end -}}
