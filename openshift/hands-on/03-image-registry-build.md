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
Depending on where you are deploying (Local CRC on Mac vs. Cloud/Standard Linux), you must choose the correct architecture.

> [!IMPORTANT]
> **For Mac (M-Series) Users:** CRC runs on an **ARM64** VM. Build natively on your Mac.
> **For Standard Linux/Cloud Users:** Most environments use **AMD64**. You must specify the platform explicitly if building from a different architecture.

#### Case A: Development on Mac (M1/M2/M3) for Local CRC
```bash
# Native build (defaults to ARM64)
docker build -t foriinji/<service-name>:v1 -f src/<Path>/Dockerfile .
```

#### Case B: Deployment to Standard x86_64 Cloud Clusters
```bash
# Explicit AMD64 build
docker build --platform linux/amd64 -t foriinji/<service-name>:v1 -f src/<Path>/Dockerfile .
```

### 3. Building and Pushing Services

#### 1. Identity Service
- **Image:** `foriinji/identity.api:v1`

#### 2. Catalog Service
- **Image:** `foriinji/catalog.api:v1`

#### 3. Basket Service
- **Image:** `foriinji/basket.api:v1`

#### 4. Ordering Service
- **Image:** `foriinji/ordering.api:v1`

#### 5. WebApp (UI)
- **Image:** `foriinji/webapp:v1`

#### 6. OrderProcessor
- **Image:** `foriinji/order-processor:v1`

#### 7. PaymentProcessor
- **Image:** `foriinji/payment-processor:v1`

#### 8. Webhooks.API
- **Image:** `foriinji/webhooks-api:v1`

#### 9. WebhookClient
- **Image:** `foriinji/webhooksclient:v1`

**Standard Build & Push Command:**
```bash
docker build -t foriinji/<service-name>:v1 -f <Dockerfile-Path> .
docker push foriinji/<service-name>:v1
```

## Rationale
- **Why DockerHub?** It's easy to use and avoids the need to expose the internal OpenShift registry externally during the initial setup.
- **Why Architecture matters?** Initially, we targeted `amd64`. However, CRC on Apple Silicon (Mac M-series) runs an **ARM64** VM. We pivot to ARM64 builds to ensure compatibility with the local cluster nodes.
- **Why versioned tags (`:v1`)?** Using `:latest` is a bad practice in production/devops as it makes rollbacks difficult and causes ambiguity.

## Next Sub-steps
- [x] Complete building all 5 core service images.
- [x] Push images to DockerHub (Success).
- [x] Verify images are visible in DockerHub.
