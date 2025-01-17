## Public Kratos
# pattern: http://<proxy>/.ory/kratos/public
# these are the entrypoint of kratos, it handles initialization of forms
# redirections(configured in user_auth.tf from infrastructure)
apiVersion: oathkeeper.ory.sh/v1alpha1
kind: Rule
metadata:
  name: kratos-${name}-public
  namespace: ${auth_namespace}
spec:
  upstream:
    url: http://kratos-${name}-public.${auth_namespace}
    stripPath: ${public_selfserve_endpoint}
    preserveHost: true
  match:
    url: http://${backend_service_domain}${public_selfserve_endpoint}/<.*>
    methods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
  authenticators:
    - handler: noop
  authorizer:
    handler: allow
  mutators:
    - handler: noop
---
## Kratos Admin
# pattern: http://<proxy>/.ory/kratos
# Note this only allows :GET requests
# Once self-service flow is initiated, a flow_id is generated
# The endpoint is used to exchange for form format / fields given a flow_id
apiVersion: oathkeeper.ory.sh/v1alpha1
kind: Rule
metadata:
  name: kratos-${name}-form-data
  namespace: ${auth_namespace}
spec:
  upstream:
    url: http://kratos-${name}-admin.${auth_namespace}
    stripPath: ${admin_selfserve_endpoint}
    preserveHost: true
  match:
    url: http://${backend_service_domain}${admin_selfserve_endpoint}/self-service/<(login|registration|recovery|settings)>/flows<.*>
    methods:
      - GET
  authenticators:
    - handler: noop
  authorizer:
    handler: allow
  mutators:
    - handler: noop
