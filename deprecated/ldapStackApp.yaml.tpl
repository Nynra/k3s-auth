{{- if .Values.enabled }}{{- if .Values.enableLdapStack }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ldap-stack-app
  namespace: {{ .Values.argocd.namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    # Global annotations
    {{- if .Values.global.commonAnnotations }}
      {{- toYaml .Values.global.commonAnnotations | nindent 4 }}
    {{- end }}
  labels:
    # Global labels
    {{- if .Values.global.commonLabels }}
      {{- toYaml .Values.global.commonLabels | nindent 4 }}
    {{- end }}
spec:
  destination:
    namespace: {{ .Values.namespace.name | quote }}
    server: {{ .Values.argocd.server | quote }}
  project: {{ .Values.project.name | quote }}
  sources:
    - repoURL: https://jp-gouin.github.io/helm-openldap/
      targetRevision: {{ .Values.helmOpenLdapTargetRevision | quote }}
      chart: helm-openldap

  syncPolicy:
    syncOptions:
      - CreateNamespace=false
    automated:
      prune: true
      selfHeal: true
{{- end }}{{- end }}