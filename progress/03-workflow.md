# Stage 03: Feature Branching Workflow

We have established a standard "Feature Branching" workflow to ensure `dev`, `qa`, and `prod` branches remain stable.

## Workflow Steps

1. **Branch Creation**: Always start from the latest `dev` branch.
    ```bash
    git checkout dev
    git pull origin dev
    git checkout -b feature/your-feature-name
    ```
2. **Development**: Perform all coding, testing, and documentation on the feature branch.
3. **Merge to Dev**: Once the feature is ready and verified, merge it into `dev`.
    ```bash
    git checkout dev
    git merge feature/your-feature-name
    ```
4. **Remote Sync**: Push both the feature branch (for backup/review) and the updated `dev` branch.
    ```bash
    git push origin feature/your-feature-name
    git push origin dev
    ```

## Current Activity
We are using `feature/devops-setup-docs` to finalize the initial setup documentation before promoting it to the `dev` environment.
