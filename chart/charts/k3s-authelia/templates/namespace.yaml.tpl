apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
    # Global annotations
    {{- if .Values.namespace.commonAnnotations }}
    {{- toYaml .Values.namespace.commonAnnotations | nindent 4 }}
    {{- end }}
  {{- if .Values.global.commonLabels }}  
  labels:
    # Global labels
    {{- toYaml .Values.global.commonLabels | nindent 4 }}
  {{- end }}
    