# eShop Architecture Overview (OpenShift/CRC Deployment)

This document provides a detailed overview of the microservices architecture for the eShop application, specifically tailored for its deployment on OpenShift using CodeReady Containers (CRC).

## 1. Architecture Style
The application follows a **microservices architecture** managed via **.NET Aspire** orchestration logic. It emphasizes service isolation, asynchronous communication, and scalable infrastructure.

## 2. Component Inventory

### A. Core Application Services (9 Services)
These services form the business logic of the eShop. All are built as container images tagged with `:v1`.

| Service Name | Technology | Responsibility |
| :--- | :--- | :--- |
| **Identity.API** | .NET 10 (Auth) | Handles OAuth2/OIDC, user registration, and token issuance. |
| **Catalog.API** | .NET 10 | Manages product inventory, categories, and brands. |
| **Basket.API** | .NET 10 | Manages user shopping carts (State stored in Redis). |
| **Ordering.API** | .NET 10 | Processes orders, manages order status and history. |
| **WebApp** | Blazor Server | The primary customer-facing web interface. |
| **OrderProcessor** | .NET 10 Worker | Background worker that processes orders from the message bus. |
| **PaymentProcessor**| .NET 10 Worker | Simulates payment gateway interactions. |
| **Webhooks.API** | .NET 10 | Manages registration and dispatching of webhooks. |
| **WebhookClient** | .NET 10 UI | A sample client to visualize received webhooks. |

### B. Infrastructure Services (3 Services)
Common infrastructure components used across the microservices.

| Service Name | Image | Role |
| :--- | :--- | :--- |
| **Postgres** | `ankane/pgvector:latest` | Relational database with vector support. Hosts `catalogdb`, `identitydb`, `orderingdb`, and `webhooksdb`. |
| **Redis** | `redis:8.2` | High-performance key-value store for `Basket.API` state. |
| **RabbitMQ** | `rabbitmq:4.2` | Message broker for asynchronous event-driven communication. |

## 3. Communication Patterns

### Senchronous (HTTP/gRPC)
- **WebApp** communicates with `Catalog`, `Basket`, and `Ordering` APIs via REST/HTTP.
- Services validate tokens against the **Identity.API** during request processing.

### Asynchronous (Event-Driven)
- All services interact via **RabbitMQ** (the Event Bus).
- **Example Flow:** When an order is placed, `Ordering.API` publishes an event. `OrderProcessor` and `PaymentProcessor` listen to this event to fulfill the order lifecycle.

## 4. Data Management Strategy
- **Shared Cluster, Isolated DBs:** A single Postgres instance is used for efficiency in the CRC environment, but each microservice has its own dedicated database schema to maintain autonomy.
- **Persistence:** On OpenShift, these databases will be backed by **PersistentVolumeClaims (PVC)** to ensure data survives pod restarts.

## 5. Deployment Roadmap on OpenShift
1. **Infra Layer:** Deploy Postgres, Redis, and RabbitMQ with Persistent Storage.
2. **Identity Layer:** Deploy `Identity.API` (the gateway for auth).
3. **Business Layer:** Deploy `Catalog`, `Basket`, and `Ordering` services.
4. **Integration Layer:** Deploy Workers (`OrderProcessor`, `PaymentProcessor`).
5. **UI Layer:** Deploy `WebApp` and `WebhookClient` and expose them via **OpenShift Routes**.

---
*This architecture ensures high availability and scalability while remaining manageable within a local CRC environment.*
