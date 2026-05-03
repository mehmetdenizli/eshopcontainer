# Step 06: Catalog and Business APIs Deployment

## Introduction
With the infrastructure and identity layers ready, we can now deploy the business logic services. This step demonstrates how microservices connect to specific databases, use Redis for state, and utilize RabbitMQ for events.

## Actions Taken

### 1. Catalog Service Deployment
The Catalog API manages the product list. It connects to the `catalogdb` hosted on our central Postgres instance.
- **Manifests:** `openshift/manifests/apps/catalog-api/catalog-api.yaml`
- **Dependency:** Postgres (`catalogdb`).

### 2. Basket Service Deployment
The Basket API handles user carts. It is unique as it uses **Redis** for high-performance state storage.
- **Manifests:** `openshift/manifests/apps/basket-api/basket-api.yaml`
- **Dependency:** Redis.

### 3. Ordering Service Deployment
The Ordering API is the most complex, requiring both a database (`orderingdb`) and a message broker (**RabbitMQ**) to handle order lifecycle events.
- **Manifests:** `openshift/manifests/apps/ordering-api/ordering-api.yaml`
- **Dependency:** Postgres, RabbitMQ.

## Configuration Strategy
All these services leverage the `eshop-config` ConfigMap and `eshop-secrets` Secret created in Step 05. This ensures consistent connection strings and environment settings across the cluster.

## Commands to Apply

### Catalog API
```bash
oc apply -f openshift/manifests/apps/catalog-api/
```

### Basket API
```bash
oc apply -f openshift/manifests/apps/basket-api/
```

### Ordering API
```bash
oc apply -f openshift/manifests/apps/ordering-api/
```

## Rationale
- **Decoupled Deployments:** Deploying each service separately allows us to verify them one by one, making troubleshooting easier.
- **Service Discovery:** Services use internal OpenShift service names (e.g., `http://identity-api:8080`) to communicate, avoiding hardcoded IPs.

## Next Sub-steps
- [x] Prepare all manifests for the 3 services.
- [x] Get approval and apply them sequentially.
- [x] Verify each service's health and logs (Migrations successful).
