terraform {
  required_version = ">= 1.14"
  
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = data.vault_kv_secret_v2.github.data["token"]
  owner = data.vault_kv_secret_v2.github.data["owner"]
}

provider "vault" {
  address = "https://vault.example.com"
  # Auth via VAULT_TOKEN env var
}
