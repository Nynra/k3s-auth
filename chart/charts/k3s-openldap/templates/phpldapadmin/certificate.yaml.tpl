{{- if .Values.enabled }}{{- if .Values.ldapAdminIngress.enabled }}
{{- if .Values.ldapAdminIngress.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: "phpmyldapadmin-tls"
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "-4"
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
  secretStoreRef:
    kind: {{ .Values.ldapAdminIngress.externalSecret.secretStoreType | quote }}
    name: {{ .Values.ldapAdminIngress.externalSecret.secretStore | quote }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: tls.crt
      remoteRef:
        key: {{ .Values.ldapAdminIngress.externalSecret.secretName | quote }}
        property: tls_crt
    - secretKey: tls.key
      remoteRef:
        key: {{ .Values.ldapAdminIngress.externalSecret.secretName | quote }}
        property: tls_key
{{- end }}
{{- end }}{{- end }}