{{- if .Values.enabled }}{{- if .Values.authelia.enabled }}{{- if .Values.ingress.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: authelia-ingress
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "2"
    kubernetes.io/ingress.class: traefik-external
    {{- if .Values.global.commonAnnotations }}
      {{- toYaml .Values.global.commonAnnotations | nindent 4 }}
    {{- end }}
  {{- if .Values.global.commonLabels }}  
  labels:
    # Global labels
    {{- toYaml .Values.global.commonLabels | nindent 4 }}
  {{- end }}
spec:
  entryPoints:
    {{- range .Values.authelia.ingress.traefikCRD.entryPoints }}
    - {{ . | quote }}
    {{- end }}
  routes:
    - match: Host(`{{ .Values.ingress.url | quote }}`)
      kind: Rule
      services:
        - name: "{{ .Values.authelia.appNameOverride }}"
          port: http
  tls:
    secretName: "authelia-tls"
{{- end }}{{- end }}{{- end }}