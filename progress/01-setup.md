# Stage 01: Environment Setup & Repository Initialization

This document outlines the initial steps taken to set up the eShop development environment and connect it to a personalized GitHub repository.

## Commands Used

### 1. Local Workspace Initialization
We started by cloning the official Microsoft eShop repository into a local directory.
```bash
# Workspace: /Users/denizli/Desktop/eshopcontainer
git clone https://github.com/dotnet/eShop.git .
```

### 2. GitHub CLI Installation
To automate repository creation and management, we installed the GitHub CLI (`gh`) via Homebrew.
```bash
brew install gh
```

### 3. Authentication
We authenticated the GitHub CLI using the browser-based flow.
```bash
gh auth login
# Followed interactive prompts:
# - Account: GitHub.com
# - Protocol: HTTPS
# - Authenticate Git: Yes
# - Method: Web browser
```

### 4. Repository Mirroring
We created a new repository on the user's GitHub account and reconfigured the remotes to allow push/pull while staying synced with the original source.
```bash
# Create the repository on GitHub
gh repo create eshopcontainer --public

# Reconfigure remotes
git remote rename origin upstream
git remote add origin https://github.com/mehmetdenizli/eshopcontainer.git

# Initial push
git push -u origin main
```

## Final Configuration Status
- **Local Directory**: `/Users/denizli/Desktop/eshopcontainer`
- **Primary Remote (origin)**: `https://github.com/mehmetdenizli/eshopcontainer.git`
- **Upstream Remote (upstream)**: `https://github.com/dotnet/eShop.git`
