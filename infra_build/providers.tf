terraform {
    required_version = ">=1.0.0"

    required_providers {
        hcp = {
            source  = "hashicorp/hcp"
            version = "0.43.0"
            }
        aws = {
            source  = "hashicorp/aws"
            version = ">=3.51.0"
            }
        google = {
            source = "hashicorp/google"
            version = "4.33.0"
        }
        }
    }
    
provider "hcp" {
}
provider "aws" {
    region = var.region
}
provider "google" {
  project = var.google_project
  region = var.google_region
}