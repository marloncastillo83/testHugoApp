locals {
  env              = "dev"
  project          = "hg-test-361420"
  credentials_path = "service-account.json"
  region           = "us-west1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.20.0, < 5.0.0"
    }
  }
}

provider "google" {
  credentials = file(local.credentials_path)

  project = local.project
  region  = local.region
}
