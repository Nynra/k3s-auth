{{- if .Values.enabled }}{{- if .Values.externalCert.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: "authelia-tls"
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
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
    kind: {{ .Values.externalCert.secretStoreType | quote }}
    name: {{ .Values.externalCert.secretStore | quote }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: tls.crt
      remoteRef:
        key: {{ .Values.externalCert.secretName | quote }}
        property: tls_crt
    - secretKey: tls.key
      remoteRef:
        key: {{ .Values.externalCert.secretName | quote }}
        property: tls_key
{{- end }}{{- end }}