# Step 05: Identity and Core API Deployment

## Status
- **Date:** 2026-05-03
- **Status:** ✅ Completed

## Summary
In this step, we focus on deploying the `Identity.API` service. This is the central authentication service that all other microservices depend on for token validation and user identity. We are also introducing a more organized manifest structure.

## Tasks
- [x] Organize `openshift/manifests/apps/` into service-specific subdirectories.
- [x] Create shared `common/config-secrets.yaml` (ConfigMap and Secrets).
- [x] Create `identity-api/identity-api.yaml` (Deployment, Service, Route).
- [x] Apply `common` manifests to OpenShift.
- [x] Apply `identity-api` manifests to OpenShift.
- [x] Verify `Identity.API` pod health and Route accessibility.
