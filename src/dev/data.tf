data "vault_kv_secret_v2" "github" {
  mount = "terraform"
  name  = "providers/github"
}
