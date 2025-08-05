{{ $dn := .Values.authelia.configMap.servers.identity_validation.authentication_backend.ldap.base_dn }}
{{ $rootDomain := .Values.global.ldapDomain }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-customldif
data:
  00-root.ldif: |-
    dn: {{ $dn }}
    objectClass: top
    objectClass: dcObject
    objectClass: organization
    o: MY-DOMAIN
    dc: {{ $rootDomain }}
  01-admin-read-user.ldif: |-
    dn: cn=admin-read,{{ $dn }}
    cn: admin-read
    mail: admin-read@{{ $rootDomain }}
    objectClass: inetOrgPerson
    objectClass: top
    userPassword:: {SSHA}xxxxxxxxxxxx
    sn: Admin read only
  02-users-group.ldif: |-
    dn: ou=users,{{ $dn }}
    ou: users
    objectClass: organizationalUnit
    objectClass: top