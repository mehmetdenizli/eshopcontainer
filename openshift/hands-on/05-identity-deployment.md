# Step 05: Identity and Core API Deployment

## Introduction
The `Identity.API` is the foundation of our application's security. It handles all authentication and authorization logic. In this step, we learn how to manage configurations using **ConfigMaps** and **Secrets**, and how to expose a service to the outside world using **Routes**.

## Actions Taken

### 1. Refactored Manifest Structure
To maintain scalability, we moved from single files to a directory-per-service structure.
- `openshift/manifests/apps/common/`: Shared configuration.
- `openshift/manifests/apps/identity-api/`: Service-specific manifests.

### 2. Configuration Management (Learning Point)
We implemented best practices by separating configuration from the deployment logic:
- **ConfigMap (`eshop-config`):** Stores environment variables like `ASPNETCORE_ENVIRONMENT`.
- **Secret (`eshop-secrets`):** Stores sensitive data like database connection strings (e.g., `Host=postgres;Database=identitydb...`).

### 3. Exposing the Service (Route)
Unlike standard Kubernetes which uses Ingress, OpenShift uses **Routes** to expose services. We created a Route for `identity-api` to allow external access for login operations.

## Commands to Apply

### Step A: Apply Common Config
```bash
oc apply -f openshift/manifests/apps/common/
```

### Step B: Apply Identity Service
```bash
oc apply -f openshift/manifests/apps/identity-api/
```

## Rationale
- **Why ConfigMap & Secret?** Decoupling configuration from code/manifests allows us to change settings without rebuilding images or modifying the main deployment file.
- **Why Identity first?** Other services like Catalog or Basket will fail to validate tokens if the Identity issuer is not reachable.

## Troubleshooting

### Issue: `ErrImagePull` with "no image found in image index for architecture arm64"
When first applying the manifests, the pod failed to pull the image because CRC on Mac M-series expects an **ARM64** image, but the initial build was targeting **AMD64**.

**Solution:**
Rebuild the images without the `--platform linux/amd64` flag (or explicitly using `linux/arm64`) and push them again.
```bash
docker build -t foriinji/identity.api:v1 -f src/Identity.API/Dockerfile .
docker push foriinji/identity.api:v1
```
OpenShift will automatically retry the pull and start the container once the correct architecture is available in the registry.

## Next Sub-steps
- [x] Fix architecture mismatch (Re-build for ARM64).
- [x] Check Identity API logs: `oc logs deployment/identity-api` (Success)
- [x] Verify the public URL: `oc get route identity-api` (Accessible)

## Verification Results
Testing the OIDC discovery endpoint:
```bash
curl -L http://identity-api-eshop.apps-crc.testing/.well-known/openid-configuration
```
**Result:**
Received full JSON discovery document confirming the service is operational.
