# Step 03: Image Registry and Build Strategy

## Status
- **Date:** 2026-05-03
- **Status:** ✅ Completed

## Summary
In this step, we configure the image registry (DockerHub) and execute the build process for our microservices. We ensure cross-platform compatibility by targeting `linux/amd64` for OpenShift (CRC) deployment.

## Tasks
- [x] DockerHub Login (performed by user via Token).
- [x] Build and Tag all 9 Services (v1).
    - Identity.API, Catalog.API, Basket.API, Ordering.API, WebApp
    - OrderProcessor, PaymentProcessor, Webhooks.API, WebhookClient
- [x] Push all images to DockerHub (`foriinji` repository).
