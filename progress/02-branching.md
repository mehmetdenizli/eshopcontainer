# Stage 02: Branching Strategy Implementation

In this stage, we established the environment-based branching strategy to support a full DevOps lifecycle.

## Environment Branches

We created four primary branches based on the `main` branch:

1. **`dev`**: For continuous integration and development testing.
2. **`qa`**: For quality assurance and automated testing.
3. **`uat`**: For User Acceptance Testing and staging.
4. **`prod`**: For production-ready stable code.

## Commands Used

```bash
# Create local branches
git branch dev
git branch qa
git branch uat
git branch prod

# Push all new branches to the remote repository
git push origin dev qa uat prod
```

## Branching Logic
This structure allows us to implement promotion-based CI/CD pipelines where code moves from `dev` -> `qa` -> `uat` -> `prod` after passing respective quality gates.
