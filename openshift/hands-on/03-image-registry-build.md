# Step 03: Image Registry and Build Strategy

## Introduction
To deploy our services to OpenShift, we need to make the container images accessible to the cluster. We are using **DockerHub** as our external registry. Since we are developing on **macOS (Apple Silicon)** but deploying to a **Linux-based OpenShift (CRC)** environment, we must use multi-platform builds.

## Actions Taken

### 1. Registry Authentication
The user successfully authenticated with DockerHub using a Personal Access Token (PAT).

**Command:**
```bash
docker login -u foriinji
# (Token entered when prompted)
```

### 2. Multi-Platform Build Strategy
We use the `--platform linux/amd64` flag during the build process. This ensures that the generated image is compatible with the x86_64 architecture of the OpenShift nodes.

#### For Mac (M1/M2/M3) Users:
```bash
docker build --platform linux/amd64 -t foriinji/<service-name>:v1 -f src/Services/<Service>/Dockerfile .
```

#### For Linux Users:
```bash
docker build -t foriinji/<service-name>:v1 -f src/Services/<Service>/Dockerfile .
```

### 3. Building and Pushing Services

#### Identity Service
**Build:**
```bash
docker build --platform linux/amd64 -t foriinji/identity.api:v1 -f src/Identity.API/Dockerfile .
```
**Push:**
```bash
docker push foriinji/identity.api:v1
```

#### Catalog Service
**Build:**
```bash
docker build --platform linux/amd64 -t foriinji/catalog.api:v1 -f src/Catalog.API/Dockerfile .
```
**Push:**
```bash
docker push foriinji/catalog.api:v1
```

#### Additional Background Services
For a complete eShop flow, we also built and pushed the following services (Dockerfiles were generated as they were missing in the source):
- **OrderProcessor:** `foriinji/order-processor:v1`
- **PaymentProcessor:** `foriinji/payment-processor:v1`
- **Webhooks.API:** `foriinji/webhooks-api:v1`
- **WebhookClient:** `foriinji/webhooksclient:v1`

**Push Command:**
```bash
docker push foriinji/<service-name>:v1
```

## Rationale
- **Why DockerHub?** It's easy to use and avoids the need to expose the internal OpenShift registry externally during the initial setup.
- **Why `--platform linux/amd64`?** CRC runs on a virtualized Linux environment. Native ARM64 images built on Mac would fail to run on the cluster nodes.
- **Why versioned tags (`:v1`)?** Using `:latest` is a bad practice in production/devops as it makes rollbacks difficult and causes ambiguity.

## Next Sub-steps
- [x] Complete building all 5 core service images.
- [x] Push images to DockerHub (Success).
- [x] Verify images are visible in DockerHub.
