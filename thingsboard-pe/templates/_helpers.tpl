{{/* Returns the namespace from values.yaml */}}
{{- define "thingsboard-pe.namespace" -}}
{{ .Values.global.namespace | default "default" }}
{{- end -}}
