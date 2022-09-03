locals {
  project = "hg-test-361420"
  region  = "us-west2"
}

provider "google" {
  credentials = "${file("hg-test-361420-7e6410369e2e.json")}"
  project     = local.project
  region      = local.region
}

module "vpc" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "5.2.0"

  project_id   = local.project
  network_name = "hugo-vpc"
  routing_mode = "REGIONAL"

  delete_default_internet_gateway_routes = "true"

  subnets = [
    {
      subnet_name           = "subnet-gke"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
      description           = "This subnet is for GKE Kubernates"
    },
    {
      subnet_name           = "subnet-services"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet is for Services"
    }
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  name    = "hugo-router"
  project = local.project
  region  = local.region
  network = module.vpc.network_name

  nats = [{
    name                               = "nat"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                    = "subnet-services"
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
      }
    ]
  }]
}
