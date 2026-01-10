provider "github" {
  token = data.vault_kv_secret_v2.github.data["token"]
  owner = data.vault_kv_secret_v2.github.data["owner"]
}
