# GitHub Repository Management with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](LICENSE)
[![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen?style=for-the-badge)](https://github.com/yourusername/your-repo)

Manage GitHub repositories, teams, and settings as code using Terraform. Automate repository creation, branch protection, team permissions, and organizational settings.

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Repository Structure](#-repository-structure)
- [Usage](#-usage)
- [Examples](#-examples)
- [Modules](#-modules)
- [Best Practices](#-best-practices)
- [Contributing](#-contributing)

## 🌟 Overview

This repository uses the [GitHub Terraform Provider](https://registry.terraform.io/providers/integrations/github/latest/docs) to manage GitHub resources declaratively. Perfect for organizations that want to:

- Standardize repository configurations
- Enforce security policies across all repos
- Automate repository creation and setup
- Manage team access and permissions at scale
- Version control your GitHub organization settings

## ✨ Features

- **Repository Management**: Create, configure, and manage GitHub repositories
- **Branch Protection**: Enforce branch protection rules and required reviews
- **Team Management**: Manage teams and repository access levels
- **Secret Management**: Provision repository and organization secrets
- **Webhook Configuration**: Automate webhook setup for CI/CD
- **Issue Labels**: Standardize labels across repositories
- **Actions Settings**: Configure GitHub Actions permissions and runners
- **Organization Settings**: Manage organization-wide policies

## 🔧 Prerequisites

### Required

- [Terraform](https://www.terraform.io/downloads) >= 1.5.0
- GitHub account with appropriate permissions:
  - **Organization Owner** (for org-level resources)
  - **Admin** access (for repository management)
- [GitHub Personal Access Token (PAT)](https://github.com/settings/tokens) or GitHub App

### Required Token Scopes

For Classic PAT, enable these scopes:
- `repo` (Full control of private repositories)
- `admin:org` (Full control of orgs and teams)
- `delete_repo` (Delete repositories)
- `admin:repo_hook` (Full control of repository hooks)
- `workflow` (Update GitHub Action workflows)

For Fine-grained PAT, grant:
- Repository permissions: Administration (Read/Write)
- Organization permissions: Administration (Read/Write), Members (Read/Write)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/terraform-github-management.git
cd terraform-github-management
```

### 2. Set GitHub Token

```bash
# Export token as environment variable
export GITHUB_TOKEN="ghp_your_personal_access_token"

# Or use GitHub App authentication
export GITHUB_APP_ID="your_app_id"
export GITHUB_APP_INSTALLATION_ID="your_installation_id"
export GITHUB_APP_PEM_FILE="path/to/app-private-key.pem"
```

### 3. Configure Variables

Create `terraform.tfvars`:

```hcl
github_organization = "your-org-name"
github_owner        = "your-username"

default_branch_protection = {
  require_code_owner_reviews       = true
  required_approving_review_count  = 2
  dismiss_stale_reviews            = true
  require_conversation_resolution  = true
}
```

### 4. Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

## 📁 Repository Structure

```
.
├── modules/
│   ├── repository/
│   │   ├── main.tf              # Repository resource
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── team/
│   │   ├── main.tf              # Team management
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── branch-protection/
│   │   └── ...
│   └── webhooks/
│       └── ...
├── environments/
│   ├── organization/
│   │   ├── main.tf              # Org-wide settings
│   │   ├── repositories.tf      # All repositories
│   │   ├── teams.tf             # Team definitions
│   │   └── terraform.tfvars
│   └── personal/
│       └── ...
├── templates/
│   ├── repository/
│   │   ├── standard-repo.tf    # Template for new repos
│   │   └── microservice.tf     # Microservice template
│   └── policies/
│       └── branch-protection.tf
├── scripts/
│   ├── generate-repo.sh         # Helper script
│   └── bulk-import.sh           # Import existing repos
├── .gitignore
├── backend.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## 💻 Usage

### Create a New Repository

```hcl
module "new_repository" {
  source = "./modules/repository"

  name        = "my-new-repo"
  description = "Repository description"
  visibility  = "private"
  
  has_issues      = true
  has_projects    = true
  has_wiki        = false
  has_downloads   = true
  
  auto_init          = true
  gitignore_template = "Python"
  license_template   = "mit"
  
  topics = ["python", "api", "microservice"]
  
  # Team access
  teams = {
    "developers" = "push"
    "admins"     = "admin"
  }
}
```

### Configure Branch Protection

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  repository = "my-repo"
  branch     = "main"
  
  require_code_owner_reviews      = true
  required_approving_review_count = 2
  dismiss_stale_reviews           = true
  require_conversation_resolution = true
  
  require_signed_commits = true
  
  required_status_checks = {
    strict = true
    contexts = [
      "ci/test",
      "ci/lint",
      "security/scan"
    ]
  }
  
  restrictions = {
    users = ["admin-user"]
    teams = ["platform-team"]
  }
}
```

### Manage Teams

```hcl
module "engineering_team" {
  source = "./modules/team"

  name        = "engineering"
  description = "Engineering team"
  privacy     = "closed"
  
  members = {
    "user1" = "maintainer"
    "user2" = "member"
    "user3" = "member"
  }
  
  repositories = {
    "backend-api"     = "push"
    "frontend-app"    = "push"
    "infrastructure"  = "pull"
  }
}
```

### Add Repository Secrets

```hcl
resource "github_actions_secret" "api_key" {
  repository      = "my-repo"
  secret_name     = "API_KEY"
  plaintext_value = var.api_key
}

resource "github_actions_organization_secret" "shared_token" {
  secret_name     = "SHARED_TOKEN"
  visibility      = "all"
  plaintext_value = var.shared_token
}
```

## 📦 Examples

### Standard Application Repository

```hcl
module "api_service" {
  source = "./modules/repository"

  name        = "payment-api"
  description = "Payment processing API service"
  visibility  = "private"
  
  # Repository settings
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  auto_init     = true
  
  # Templates
  gitignore_template = "Node"
  license_template   = "apache-2.0"
  
  # Topics for discoverability
  topics = ["nodejs", "api", "payments", "microservice"]
  
  # Default branch
  default_branch = "main"
  
  # Enable vulnerability alerts
  vulnerability_alerts = true
  
  # Team permissions
  teams = {
    "backend-team"    = "push"
    "platform-team"   = "admin"
    "security-team"   = "pull"
  }
}

# Branch protection for main
resource "github_branch_protection" "api_main" {
  repository_id = module.api_service.repository_id
  pattern       = "main"
  
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
    require_last_push_approval      = true
  }
  
  required_status_checks {
    strict = true
    contexts = [
      "ci/build",
      "ci/test", 
      "ci/lint",
      "security/sast"
    ]
  }
  
  enforce_admins = true
  require_signed_commits = true
  
  require_conversation_resolution = true
  
  push_restrictions = [
    "/platform-team"
  ]
}
```

### Organization-Wide Settings

```hcl
# Default labels for all repositories
resource "github_issue_label" "bug" {
  repository  = each.value
  for_each    = toset(var.all_repositories)
  
  name        = "bug"
  color       = "d73a4a"
  description = "Something isn't working"
}

# Organization settings
resource "github_organization_settings" "main" {
  billing_email = "billing@company.com"
  company       = "Your Company"
  blog          = "https://blog.company.com"
  email         = "github@company.com"
  
  has_organization_projects = true
  has_repository_projects   = true
  
  default_repository_permission = "read"
  members_can_create_repositories = false
  
  members_can_create_public_repositories  = false
  members_can_create_private_repositories = false
  
  web_commit_signoff_required = true
}

# Organization security settings
resource "github_organization_security_manager" "security_team" {
  team_slug = "security"
}
```

### Webhook Configuration

```hcl
resource "github_repository_webhook" "ci_webhook" {
  repository = "my-repo"

  configuration {
    url          = "https://ci.company.com/webhook"
    content_type = "json"
    insecure_ssl = false
    secret       = var.webhook_secret
  }

  active = true

  events = [
    "push",
    "pull_request",
    "release"
  ]
}
```

## 🎯 Modules

### Repository Module

Creates and configures a GitHub repository with all settings.

**Inputs:**
- `name` - Repository name
- `description` - Repository description
- `visibility` - public/private/internal
- `has_issues` - Enable issues
- `has_wiki` - Enable wiki
- `teams` - Team access map

**Outputs:**
- `repository_id` - Repository ID
- `full_name` - Full repository name
- `html_url` - Repository URL
- `ssh_clone_url` - SSH clone URL

### Team Module

Manages GitHub teams and their repository permissions.

**Inputs:**
- `name` - Team name
- `description` - Team description
- `privacy` - secret/closed
- `members` - Map of members and roles
- `repositories` - Map of repos and permissions

**Outputs:**
- `team_id` - Team ID
- `team_slug` - Team slug
- `members_count` - Number of members

### Branch Protection Module

Configures branch protection rules.

**Inputs:**
- `repository` - Repository name
- `branch` - Branch pattern
- `require_code_owner_reviews` - Require CODEOWNERS review
- `required_approving_review_count` - Number of required reviews
- `required_status_checks` - Status checks that must pass

**Outputs:**
- `protection_id` - Protection rule ID

## 🛡️ Best Practices

### Repository Naming

Use consistent naming conventions:
```
<team>-<project>-<type>
backend-api-service
frontend-web-app
infrastructure-terraform
```

### Branch Protection

Always protect your main branch:
- ✅ Require pull request reviews (minimum 2)
- ✅ Require status checks to pass
- ✅ Require conversation resolution
- ✅ Require signed commits
- ✅ Include administrators in restrictions

### Team Management

Organize teams by function:
- `platform-team` - Infrastructure and platform
- `backend-team` - Backend services
- `frontend-team` - Frontend applications
- `security-team` - Security reviews
- `data-team` - Data engineering

### Secret Management

- ✅ Use organization secrets for shared values
- ✅ Use repository secrets for service-specific values
- ✅ Never commit secrets to Terraform files
- ✅ Use Terraform variables marked as sensitive
- ✅ Store secrets in secure vault (HashiCorp Vault, AWS Secrets Manager)

### State Management

```hcl
terraform {
  backend "s3" {
    bucket         = "company-terraform-state"
    key            = "github/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### Security Scanning

Enable security features for all repositories:
```hcl
vulnerability_alerts             = true
security_and_analysis {
  secret_scanning {
    status = "enabled"
  }
  secret_scanning_push_protection {
    status = "enabled"
  }
}
```

## 🔄 Import Existing Repositories

To import existing GitHub repositories into Terraform:

```bash
# Import repository
terraform import module.existing_repo.github_repository.main your-org/repo-name

# Import team
terraform import github_team.developers 1234567

# Import branch protection
terraform import github_branch_protection.main repo-name:main
```

Or use the bulk import script:
```bash
./scripts/bulk-import.sh your-org
```

## 🚀 Automation Examples

### Bulk Repository Creation

```hcl
locals {
  microservices = [
    "user-service",
    "payment-service",
    "notification-service",
    "analytics-service"
  ]
}

module "microservice_repos" {
  source   = "./modules/repository"
  for_each = toset(local.microservices)
  
  name        = each.value
  description = "${each.value} microservice"
  visibility  = "private"
  
  topics = ["microservice", "api", "nodejs"]
  
  # Standard configuration
  has_issues     = true
  has_wiki       = false
  auto_init      = true
  license_template = "mit"
  
  teams = {
    "backend-team" = "push"
    "platform-team" = "admin"
  }
}
```

### Standard Labels Across All Repos

```hcl
locals {
  standard_labels = {
    bug = {
      color       = "d73a4a"
      description = "Something isn't working"
    }
    enhancement = {
      color       = "a2eeef"
      description = "New feature or request"
    }
    documentation = {
      color       = "0075ca"
      description = "Improvements or additions to documentation"
    }
    security = {
      color       = "ee0701"
      description = "Security vulnerability or issue"
    }
  }
}

resource "github_issue_label" "standard" {
  for_each = {
    for pair in setproduct(var.all_repositories, keys(local.standard_labels)) :
    "${pair[0]}-${pair[1]}" => {
      repo  = pair[0]
      label = pair[1]
    }
  }
  
  repository  = each.value.repo
  name        = each.value.label
  color       = local.standard_labels[each.value.label].color
  description = local.standard_labels[each.value.label].description
}
```

## 📊 Outputs

After applying Terraform, you can view outputs:

```bash
# List all repositories
terraform output repositories

# Get specific repository URL
terraform output -json | jq '.repositories.value["my-repo"].html_url'

# List all teams
terraform output teams
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-template`)
3. Make your changes
4. Test with `terraform plan`
5. Commit your changes (`git commit -am 'feat: add new repository template'`)
6. Push to the branch (`git push origin feature/new-template`)
7. Open a Pull Request

## 🔒 Security

- **Never commit tokens** to version control
- Use **environment variables** for authentication
- Enable **branch protection** on this repository
- Use **encrypted remote state** backend
- Enable **secret scanning** on all repositories
- Implement **CODEOWNERS** file for review requirements
- Regular **audit of team permissions**

## 📚 Resources

- [GitHub Terraform Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Maintainers

- **Platform Team** - [@platform-team](https://github.com/orgs/your-org/teams/platform-team)
- **Contact** - platform@company.com

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

**Manage GitHub at scale with Infrastructure as Code**

**Made with ❤️ by the Platform Team**
