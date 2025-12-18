resource "github_branch_protection" "example" {
  repository_id = github_repository.example.node_id
  # also accepts repository name
  # repository_id  = github_repository.example.name

  pattern          = "main"
  enforce_admins   = true
  allows_deletions = true

  required_status_checks {
    strict   = false
    contexts = ["ci/travis"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews  = true
    restrict_dismissals    = true
    dismissal_restrictions = [
      data.github_user.example.node_id,
      github_team.example.node_id,
      "/exampleuser",
      "exampleorganization/exampleteam",
    ]
  }

  restrict_pushes {
    push_allowances = [
      data.github_user.example.node_id,
      "/exampleuser",
      "exampleorganization/exampleteam",
      # you can have more than one type of restriction (teams + users). If you use
      # more than one type, you must use node_ids of each user and each team.
      # github_team.example.node_id
      # github_user.example-2.node_id
    ]
  }

  force_push_bypassers = [
    data.github_user.example.node_id,
    "/exampleuser",
    "exampleorganization/exampleteam",
    # you can have more than one type of restriction (teams + users)
    # github_team.example.node_id
    # github_team.example-2.node_id
  ]

}
