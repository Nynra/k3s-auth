{{- if .Values.enabled }}{{- if .Values.ldapAdminIngress.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: ldap-admin-ingress
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    # Global annotations
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
    - {{ .Values.ldapAdminIngress.entrypoint | quote }}
  routes:
    - match: Host(`{{ .Values.ldapAdminIngress.ingressUrl }}`)
      kind: Rule
      services:
        - name: phpldapadmin
          port: http
  tls:
    secretName: "phpmyldapadmin-tls"
{{- end }}{{- end }}