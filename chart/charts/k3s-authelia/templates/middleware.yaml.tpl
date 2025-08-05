{{- if .Values.enabled }}{{- if .Values.authelia.enabled }}
apiVersion: 'traefik.io/v1alpha1'
kind: 'Middleware'
metadata:
  name: authelia-forward-auth
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    {{- if .Values.global.commonAnnotations }}
      {{- toYaml .Values.global.commonAnnotations | nindent 4 }}
    {{- end }}
  {{- if .Values.global.commonLabels }}  
  labels:
    # Global labels
    {{- toYaml .Values.global.commonLabels | nindent 4 }}
  {{- end }}
spec:
  forwardAuth:
    address: 'http://authelia.{{ .Values.namespace.name }}.svc.cluster.local/api/authz/forward-auth'
    authResponseHeaders:
      - 'Remote-User'
      - 'Remote-Groups'
      - 'Remote-Email'
      - 'Remote-Name'
{{- end }}{{- end }}