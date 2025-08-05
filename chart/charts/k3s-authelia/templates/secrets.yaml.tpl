{{- if .Values.enabled }}{{- if .Values.externalSecrets.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: "my-authelia-secrets"
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
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
  secretStoreRef:
    kind: {{ .Values.externalSecrets.secretStoreType | quote }}
    name: {{ .Values.externalSecrets.secretStore | quote }}
  target:
    creationPolicy: Owner
  data:
    # Secrets for Authelia
    - secretKey: 'identity_validation.reset_password.jwt.hmac.key'
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        property: {{ .Values.externalSecrets.authelia.properties.jwt | quote }}
    - secretKey: 'authentication.ldap.password.txt'
      remoteRef:
        key: {{ .Values.externalSecrets.ldap.secretName | quote }}
        property: {{ .Values.externalSecrets.ldap.properties.ldapPassword | quote }}
    - secretKey: 'identity_providers.oidc.hmac.key'
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        property: {{ .Values.externalSecrets.authelia.properties.oidcHmac | quote }}
    - secretKey: OIDC_ISSUER_PRIVATE_KEY
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        property: {{ .Values.externalSecrets.authelia.properties.oidcIssuer | quote }}
    {{- if .Values.authelia.configMap.session.redis.enabled }}
    - secretKey: redis.password
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        {{- if .Values.externalSecrets.authelia.properties.redis }}
        property: {{ .Values.externalSecrets.authelia.properties.redis | quote }}
        {{- else }}
        {{- fail "redis.password is not set" }}
        {{- end }}
    {{- end }}
    - secretKey: 'session.encryption.key'
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        property: {{ .Values.externalSecrets.authelia.properties.session | quote }}
    {{- if .Values.externalSecrets.smtp }}
    - secretKey: 'notifier.smtp.password.txt'
      remoteRef:
        key: {{ .Values.externalSecrets.smtp.secretName | quote }}
        property: {{ .Values.externalSecrets.smtp.properties.smtpPassword | quote }}
    {{- end }}
    - secretKey: 'storage.encryption.key'
      remoteRef:
        key: {{ .Values.externalSecrets.authelia.secretName | quote }}
        property: {{ .Values.externalSecrets.authelia.properties.storageEncryption | quote }}
{{- end }}{{- end }}
