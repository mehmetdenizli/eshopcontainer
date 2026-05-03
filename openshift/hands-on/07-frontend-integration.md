# Step 07: Frontend (WebApp) and Final Integration

## Introduction
The final step brings everything together. The `WebApp` provides the user interface, while the background workers handle the asynchronous business processes (Order processing and Payment simulation) via RabbitMQ.

## Actions Taken

### 1. Background Workers Deployment
We deploy `OrderProcessor` and `PaymentProcessor`. These services don't need a public Route as they only listen to RabbitMQ events and connect to the database.
- **Manifests:** `openshift/manifests/apps/order-processor/` & `payment-processor/`
- **Dependencies:** RabbitMQ, Ordering DB.

### 2. Webhooks Ecosystem Deployment
We also deploy the Webhooks infrastructure to allow external systems to subscribe to eShop events.
- **Webhooks.API:** Manages subscriptions and dispatches events.
- **WebhookClient:** A dedicated UI to visualize incoming webhooks.
- **Manifests:** `openshift/manifests/apps/webhooks-api/` & `webhooksclient/`
- **Dependencies:** Postgres (webhooksdb), RabbitMQ, Identity.API.

### 3. Centralized Configuration (Best Practice)
Instead of hardcoding environment variables in each deployment, we moved all service URLs and secrets to a single source of truth:
- **ConfigMap:** `eshop-config` contains all internal and external URLs.
- **Secrets:** `eshop-secrets` contains connection strings and RabbitMQ credentials.
- **OIDC Fixes:** Added `WebAppClient` and `IdentityUrl` (flat) to the ConfigMap to ensure IdentityServer redirects and WebApp service starts correctly.

### 4. Final Integration Test
We will verify:
- Browser redirection to Identity API for login.
- Successful authentication and return to WebApp.
- Placing an order and seeing it processed by the `OrderProcessor`.

## Commands to Apply

### Order & Payment Processors
```bash
oc apply -f openshift/manifests/apps/order-processor/
oc apply -f openshift/manifests/apps/payment-processor/
```

### Webhooks
```bash
oc apply -f openshift/manifests/apps/webhooks-api/
oc apply -f openshift/manifests/apps/webhooksclient/
```

### WebApp
```bash
oc apply -f openshift/manifests/apps/webapp/
```

## Rationale
- **Asynchronous Decoupling:** By using `OrderProcessor`, we ensure that the user doesn't have to wait for the entire order fulfillment process to finish before getting a confirmation.
- **External vs Internal URLs:** Understanding the difference between how services talk to each other (Internal) vs how the user's browser talks to them (External) is key to a successful OpenShift deployment.

## Next Sub-steps
- [x] Prepare manifests for all services (including Webhooks).
- [x] Get approval and apply.
- [x] Conduct final smoke test (System fully operational with 9 services).
