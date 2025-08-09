{{ $rootDomain := .Values.global.ldapDomain }}
{{ $rootNameOnly := .Values.global.ldapDomainNameOnly }}
{{ $rootExtensionOnly := .Values.global.ldapDomainExtension }}
# Tree structure for the OpenLDAP server
# rootDomain
# |-- groups  # These are user groups (admin, user, etc.) for authelia rbac
# |   |-- cluster-admin
# |   |-- cluster-moderator
# |   |-- service-admin
# |   |-- service-moderator
# |   |-- iot-access
# |-- users  # These are user accounts
# |-- services  # These are service accounts that need resticted ldap access
# |   |-- authenticator  # (authelia)
# |   |-- ltb
apiVersion: v1
kind: ConfigMap
metadata:
  name: custom-ldif-cm
data:
  00-root.ldif: |-
    dn: dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: dcObject
    objectClass: organization
    o: {{ $rootNameOnly }}
    dc: {{ $rootDomain }}
  # Admin user exists by default so we only have to create the read only user
  01-admin-read-user.ldif: |-
    dn: cn=admin-read,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    cn: admin-read
    mail: admin-read@{{ $rootDomain }}
    objectClass: inetOrgPerson
    objectClass: top
    userPassword:: {SSHA}xxxxxxxxxxxx
    sn: Admin read only
  02-groups-group.ldif: |-
    dn: ou=groups,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: organizationalUnit
    ou: groups
    description: Organizational unit for the groups of the OpenLDAP server
  03-users-group.ldif: |-
    dn: ou=users,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: organizationalUnit
    ou: users
    description: Organizational unit for the users info
  # 04-services-group.ldif: |-
  #   dn: ou=services,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
  #   objectClass: top
  #   objectClass: organizationalUnit
  #   ou: services
  #   description: Organizational unit for the services accounts
  06-cluster-admin-group.ldif: |-
    dn: cn=cluster-admin,ou=groups,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfMembers
    cn: cluster-admin
    gidNumber: 10003
    description: Group for the cluster admin users
  07-cluster-moderator-group.ldif: |-
    dn: cn=cluster-moderator,ou=groups,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfMembers
    cn: cluster-moderator
    gidNumber: 10004
    description: Group for the cluster moderator users
  08-service-admin-group.ldif: |-
    dn: cn=service-admin,ou=groups,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfMembers
    cn: service-admin
    gidNumber: 10005
    description: Group for the service admin users
  09-service-moderator-group.ldif: |-
    dn: cn=service-moderator,ou=groups,dc={{ $rootNameOnly }},dc={{ $rootExtensionOnly }}
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfMembers
    cn: service-moderator
    gidNumber: 10006
    description: Group for the service moderator users
    # Some general service accounts
  # 10-authenticator-service.ldif: |-
  #   dn: cn=authenticator,ou=services,dc={{ $rootNameOnly }}},dc={{ $rootExtensionOnly }}
  #   objectClass: top
  #   objectClass: person
  #   objectClass: posixAccount
  #   uid: authenticator
  #   cn: authenticator
  #   sn: Authenticator