locals {
  env              = "dev"
  project          = "citizix"
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

  project = "citizix-prj"
  region  = local.region
}
