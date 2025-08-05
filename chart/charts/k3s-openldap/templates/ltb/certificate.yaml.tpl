{{- if .Values.enabled }}{{- if .Values.ltbIngress.enabled }}
{{- if .Values.ltbIngress.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: "ltb-tls"
  namespace: {{ .Values.namespace.name | quote }}
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
    kind: {{ .Values.ltbIngress.externalSecret.secretStoreType | quote }}
    name: {{ .Values.ltbIngress.externalSecret.secretStore | quote }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: tls.crt
      remoteRef:
        key: {{ .Values.ltbIngress.externalSecret.secretName | quote }}
        property: tls_crt
    - secretKey: tls.key
      remoteRef:
        key: {{ .Values.ltbIngress.externalSecret.secretName | quote }}
        property: tls_key
{{- end }}
{{- end }}{{- end }}