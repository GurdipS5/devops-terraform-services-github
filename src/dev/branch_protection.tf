resource "github_organization_ruleset" "protect_main" {
  name        = "org-protect-main"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
    }
  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = true
    required_signatures     = true

    pull_request {
      required_approving_review_count = 1
      require_code_owner_review       = true
      dismiss_stale_reviews           = true
    }

    required_status_checks {
      strict = true
    }
  }
}
