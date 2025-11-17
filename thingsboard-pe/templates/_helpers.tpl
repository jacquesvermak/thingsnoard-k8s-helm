{{/* Returns the namespace from values.yaml */}}
{{- define "thingsboard-pe.namespace" -}}
{{ .Values.global.namespace | default "default" }}
{{- end -}}

{{/* Returns the full name of the release */}}
{{- define "thingsboard-pe.fullname" -}}
{{- printf "%s" .Release.Name -}}
{{- end -}}

{{/* Standard labels for resources */}}
{{- define "thingsboard-pe.labels" -}}
app.kubernetes.io/name: {{ include "thingsboard-pe.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Selector labels for resources */}}
{{- define "thingsboard-pe.selectorLabels" -}}
app.kubernetes.io/name: {{ include "thingsboard-pe.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
