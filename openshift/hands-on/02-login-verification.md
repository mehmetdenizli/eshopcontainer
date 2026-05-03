# Step 02: Login and Cluster Verification

## Introduction
Before deploying any applications, we must ensure that we are correctly authenticated and that the cluster is in a healthy state. This step also involves setting up a dedicated workspace (Project) in OpenShift.

## Actions Taken

### 1. Identity Verification
We checked who is currently logged in to the cluster.

**Command:**
```bash
oc whoami
```
**Result:** `kubeadmin`

### 2. Cluster Health Check
We verified that the nodes are ready and that the core cluster operators are functioning correctly.

**Commands:**
```bash
oc get nodes
oc get co (Cluster Operators)
```
**Observation:** All essential operators are in an `Available=True` and `Progressing=False` state, indicating a stable environment.

### 3. Project Creation
We created a new OpenShift Project named `eshop`. Projects in OpenShift are essentially Kubernetes namespaces with additional metadata and security features.

**Command:**
```bash
oc new-project eshop
```
**Result:** The project was created, and the context was automatically switched to it.

## Rationale
- **Why `kubeadmin`?** Using the cluster administrator account ensures we have all necessary permissions to create projects and manage resources during the initial setup.
- **Why a separate Project?** Isolation is key in OpenShift. A dedicated project prevents resource conflicts and allows for granular access control and resource management.

## Next Sub-steps
- [ ] Explore the eShop source code to identify the first service to deploy.
- [ ] Prepare Docker images or BuildConfigs for OpenShift.
