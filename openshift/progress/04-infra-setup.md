# Step 04: Infrastructure Setup and Deployment

## Status
- **Date:** 2026-05-03
- **Status:** ✅ Completed

## Summary
In this step, we focus on deploying the shared infrastructure components (Postgres, Redis, RabbitMQ) that our microservices depend on. We ensure data persistence using PVCs.

## Tasks
- [x] Create `openshift/manifests/infra` and `apps` directories.
- [x] Create Postgres manifest (PVC, Deployment, Service).
- [x] Create Redis manifest (PVC, Deployment, Service).
- [x] Create RabbitMQ manifest (PVC, Deployment, Service).
- [x] Apply Infrastructure manifests to OpenShift.
- [x] Verify Infrastructure services are running and healthy.
- [x] Resolved Postgres permission issues (SCC `anyuid`).
