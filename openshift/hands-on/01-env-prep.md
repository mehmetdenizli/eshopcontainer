# Step 01: Environment Preparation (CRC)

## Introduction
The first step in deploying eShop to OpenShift is ensuring our local environment is correctly configured. We use **CodeReady Containers (CRC)** to run a minimal OpenShift 4 cluster locally on macOS.

## Actions Taken

### 1. Directory Structure Setup
We established a dedicated workspace for OpenShift-related tasks to keep the repository organized and ensure a clear separation from other deployment methods (like k3s or Docker Compose).

```bash
mkdir -p openshift/progress openshift/hands-on
```

### 2. Tool Verification
We verified that the necessary CLI tools (`crc` and `oc`) are installed and accessible.

**Commands:**
```bash
crc version
oc version
```

**Results:**
- **CRC version:** 2.57.0
- **OpenShift version:** 4.20.5
- **Status:** Running (VM and OpenShift are active).

### 3. Documentation Strategy
Initialized the main `README.md` and progress tracking files to adhere to the "Step-by-Step" documentation discipline.

## Rationale
- **Why `openshift/` directory?** To provide a clean, isolated environment for OpenShift manifests, scripts, and logs.
- **Why step-by-step?** Deployment to OpenShift can be complex. Documenting each success and failure ensures reproducibility and easier troubleshooting.

## Next Sub-steps
- [x] Check CRC setup status: `crc status` (Confirmed: Running)
- [x] Ensure system requirements are met.
- [x] Start the cluster: `crc start` (Already active)
