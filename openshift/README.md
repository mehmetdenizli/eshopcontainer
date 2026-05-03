# Project Setup and Documentation Strategy for OpenShift (CRC)

This project aims to deploy and manage the eShop application on OpenShift using a local CodeReady Containers (CRC) environment. The approach emphasizes structured progress tracking, clear documentation, and step-by-step execution discipline.

## Directory Structure

This `openshift` directory serves as the main workspace for all activities related to the OpenShift deployment.

- **[progress/](./progress/):** Tracks the progress of the project step by step. Each completed step is documented as a separate file.
- **[hands-on/](./hands-on/):** Contains detailed, practical documentation of each step, including commands, explanations, and rationale.
- **README.md:** This file, providing an overview and roadmap.

## Workflow Principles

1. **Step-by-Step Execution:** The project proceeds strictly one step at a time.
2. **Mandatory Documentation:** A new step will not begin until the current step is fully executed, documented in `hands-on/`, and logged in `progress/`.
3. **Traceability:** File naming reflects the specific step names for easy navigation.

## Roadmap & Progress Summary

| Step | Task Name | Status | Progress Log | Hands-on Doc |
| :--- | :--- | :--- | :--- | :--- |
| 01 | Environment Preparation (CRC) | ✅ Completed | [Link](./progress/01-env-prep.md) | [Link](./hands-on/01-env-prep.md) |
| 02 | Login and Cluster Verification | ✅ Completed | [Link](./progress/02-login-verification.md) | [Link](./hands-on/02-login-verification.md) |
| 03 | Image Registry and Build Strategy | ✅ Completed | [Link](./progress/03-image-registry-build.md) | [Link](./hands-on/03-image-registry-build.md) |
| 04 | Infrastructure Setup and Deployment | ✅ Completed | [Link](./progress/04-infra-setup.md) | [Link](./hands-on/04-infra-setup.md) |
| 05 | Identity and Core API Deployment | 🕒 Next Step | - | - |

---
**Goal:** To build a well-documented, reproducible, and professional-grade workflow for OpenShift deployment.
