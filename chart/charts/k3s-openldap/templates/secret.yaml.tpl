{{- if .Values.enableExternalSecrets }}{{- if .Values.enabled }}{{- if .Values.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .Values.global.existingSecret | quote }}
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "-10"
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
    kind: {{ .Values.externalSecret.secretStoreType | quote }}
    name: {{ .Values.externalSecret.secretStore | quote }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: LDAP_ADMIN_PASSWORD
      remoteRef:
        key: {{ .Values.externalSecret.secretName | quote }}
        property: {{ .Values.externalSecret.properties.ldapAdmin | quote }}
    - secretKey: LDAP_CONFIG_ADMIN_PASSWORD
      remoteRef:
        key: {{ .Values.externalSecret.secretName | quote }}
        property: {{ .Values.externalSecret.properties.ldapConfig | quote }}
    - secretKey: LDAP_ADMIN_READ_PASSWORD
      remoteRef:
        key: {{ .Values.externalSecret.secretName | quote }}
        property: {{ .Values.externalSecret.properties.ldapClient | quote }}
{{- end }}{{- end }}{{- end }}
