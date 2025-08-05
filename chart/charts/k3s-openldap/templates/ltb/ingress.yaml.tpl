{{- if .Values.enabled }}{{- if .Values.ltbIngress.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: ltb-ingress
  namespace: {{ .Values.namespace.name | quote }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    # Global annotations
    {{- if .Values.namespace.commonAnnotations }}
    {{- toYaml .Values.namespace.commonAnnotations | nindent 4 }}
    {{- end }}
  {{- if .Values.global.commonLabels }}  
  labels:
    # Global labels
    {{- toYaml .Values.global.commonLabels | nindent 4 }}
  {{- end }}
spec:
  entryPoints:
    - {{ .Values.ltbIngress.entrypoint | quote }}
  routes:
    - match: Host(`{{ .Values.ltbIngress.ingressUrl }}`)
      kind: Rule
      services:
        - name: ltb-passwd
          port: http
  tls:
    secretName: "ltb-tls"
{{- end }}{{- end }}