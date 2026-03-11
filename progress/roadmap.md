# DevOps Roadmap: eshopcontainer

This roadmap outlines the planned DevOps improvements and experiments for the `eshopcontainer` project.

## Phase 1: Maintenance & Observability
- [x] Establish environment branching strategy (`dev`, `qa`, `uat`, `prod`).
- [ ] Implement advanced logging and tracing using .NET Aspire dashboards.
- [ ] Set up GitHub Actions for automated build and test validation.
- [ ] Analyze container security scan results.

## Phase 2: Infrastructure as Code (IaC)
- [ ] Refine Azure Bicep / Terraform templates for cloud deployment.
- [ ] Implement GitOps workflows with ArgoCD or Flux.
- [ ] Configure environment-specific variable management.

## Phase 3: Scaling & Performance
- [ ] Implement Horizontal Pod Autoscaling (HPA) in Kubernetes.
- [ ] Optimize container images (multi-stage builds, distroless).
- [ ] Conduct load testing and performance benchmarking.

## Maintenance Policy
All changes will be:
1. Documented in this `progress` folder.
2. Verified via automated or manual testing.
3. Pushed to `origin/main` using Antigravity.
