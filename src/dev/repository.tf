module "repository" {
  source  = "git@github.com:your-org/terraform-github-modules.git//repository?ref=v1.2.0"
  # or using HTTPS:
  # source = "github.com/your-org/terraform-github-modules//repository?ref=v1.2.0"

  for_each = var.repositories

  name               = each.key
  description        = each.value.description
  visibility         = each.value.visibility
  required_approvers = each.value.required_approvers
  teams              = each.value.teams
}
