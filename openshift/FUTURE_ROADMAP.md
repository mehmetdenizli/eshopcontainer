# Project Roadmap: Helm & GitOps Transformation

After successfully deploying the static manifests, our next goal is to modernize the eShop deployment using **Helm** for templating and **ArgoCD** for GitOps synchronization.

## 🎯 Objectives
- Replace static Kubernetes manifests with reusable Helm Charts.
- Implement Environment-based configuration (Dev/Prod).
- Automate deployments via GitOps (Single Source of Truth).
- Enhance security using Secret Management tools.

## 🚀 Phases

### Phase 1: Helmification
- [ ] **Common Service Chart:** Create a reusable chart for all eShop APIs (Deployment, Service, Route, HPA).
- [ ] **Infrastructure Integration:** Migrate Postgres, Redis, and RabbitMQ to Helm dependencies.
- [ ] **Global Values:** Define a global `values.yaml` for shared settings like `IdentityUrl` and `EventBusConnection`.

### Phase 2: GitOps Infrastructure
- [ ] **ArgoCD Deployment:** Install ArgoCD Operator on OpenShift.
- [ ] **Project Setup:** Define ArgoCD Projects and RBAC for the `eshop` namespace.
- [ ] **Repository Linking:** Connect this GitHub repository to ArgoCD.

### Phase 3: Environment Strategy
- [ ] **Namespace Isolation:** Separate `eshop-dev` and `eshop-prod` environments.
- [ ] **SealedSecrets:** Implement Bitnami SealedSecrets to safely store secrets in Git.
- [ ] **Kustomize + Helm:** Use Kustomize for environment-specific patches if needed.

### Phase 4: Automation & Observability
- [ ] **ArgoCD Image Updater:** Automatically sync new image tags from the registry to Git.
- [ ] **Sync Notifications:** Set up Slack/Teams alerts for deployment status.

## 🛠️ Next Steps for Tomorrow
1. Initialize the `openshift/charts/` directory.
2. Start with the `Identity.API` Helm conversion as a template.
3. Install ArgoCD on the CRC cluster.

---
**Vision:** "Commit code, push to Git, and watch OpenShift sync the state automatically."
