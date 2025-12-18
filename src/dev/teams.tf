# Add a team to the organization
resource "github_team" "devops_team" {
  name        = "DevOps"
  description = "DevOps"
  privacy     = "closed"
}

# Add a team to the organization
resource "github_team" "secops_team" {
  name        = "SecOps"
  description = "SecOps"
  privacy     = "closed"
}
