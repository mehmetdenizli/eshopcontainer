# Step 04: Infrastructure Setup and Deployment

## Introduction
Before deploying our microservices, we must establish a stable infrastructure layer. This includes databases and message brokers that the services rely on for state management and communication.

## Actions Taken

### 1. Directory Organization
We created a structured manifest directory to separate infrastructure from application services.
```bash
mkdir -p openshift/manifests/infra openshift/manifests/apps
```

### 2. Infrastructure Manifests
We prepared three core manifests in `openshift/manifests/infra/`:
- **01-postgres.yaml:** Deploys Postgres with the `pgvector` image and a 5Gi PVC.
- **02-redis.yaml:** Deploys Redis 8.2 with a 2Gi PVC.
- **03-rabbitmq.yaml:** Deploys RabbitMQ 4.2-management with a 2Gi PVC.

### 3. Storage Strategy
In OpenShift (CRC), we use `PersistentVolumeClaims` (PVC). The default storage class (`crc-standard`) automatically provisions the underlying `PersistentVolumes` (PV), simplifying the setup while ensuring data survives pod restarts.

## Applying Manifests
To apply these manifests, we use the following command:
```bash
oc apply -f openshift/manifests/infra/
```

### 4. Troubleshooting & Security (SCC) - IMPORTANT
During the initial deployment of Postgres, the pod failed with a `chmod: operation not permitted` error. 

**Reason:** OpenShift runs containers using a randomly assigned high UID for security. Official Postgres images often attempt to change ownership or permissions of the data directory as root, which is restricted by OpenShift's default Security Context Constraints (SCC).

**Solution:** We granted the `anyuid` SCC to the `default` service account in the `eshop` namespace to allow the container to run as the user defined in its image.

**Command:**
```bash
oc adm policy add-scc-to-user anyuid -z default -n eshop
```
After applying this policy, the Postgres pod was restarted and initialized successfully.

## Rationale
- **Why RabbitMQ Management?** The `-management` tag allows us to access a web UI to monitor message queues and exchanges, which is invaluable for debugging microservice communication.
- **Why separated manifests?** This allows for modular updates and easier troubleshooting of specific infrastructure components.

## Next Sub-steps
- [x] Apply the infra manifests.
- [x] Check pod status: `oc get pods` (All Running)
- [x] Verify PVC binding: `oc get pvc` (All Bound)
- [x] Fix Postgres permission issues via `anyuid` SCC.
