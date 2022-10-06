terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.43.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.33.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.8.2"
    }
    #boundary = {
      #source = "hashicorp/boundary"
      #version = "1.0.12"
    #}
    tls = {
      source = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}

data "terraform_remote_state" "infra" {
  backend = "remote"
  config = {
    organization = "jpapazian-org"
    workspaces = {
      name = "hcp-vault-boundary-infra"
    }
   }
}


provider "hcp" {
}

#provider "aws" {
#  region = var.region
#}

provider "google" {
  project = var.google_project
  region = var.google_region
}

provider "vault" {
  address = data.terraform_remote_state.infra.outputs.vault_public_endpoint_url
  token = data.terraform_remote_state.infra.outputs.vault_token
  #namespace = "admin"
  #skip_child_token = true
}

provider "boundary" {
  addr = data.terraform_remote_state.infra.outputs.boundary_cluster
  auth_method_id = var.boundary_auth_method
  password_auth_method_login_name = data.terraform_remote_state.infra.outputs.boundary_user
  password_auth_method_password = data.terraform_remote_state.infra.outputs.boundary_pwd
}