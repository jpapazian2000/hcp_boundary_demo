terraform {
  required_providers {
    tfe = {
      version = "~> 0.37.0"
    }
  }
}
provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token
  #version  = "~> 0.37.0"
}