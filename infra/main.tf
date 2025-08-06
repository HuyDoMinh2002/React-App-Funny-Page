terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
# Provider Settings
provider "google" {
  project     = var.project_id
  region      = var.gcp_project_region
  zone        = var.gcp_project_zone           # Choose your zone
  credentials = file(var.gcp_credentials_file) # Path to your service account key file
}

# Compute API (VPC, Subnet, Firewall rules, VMs)
resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

module "network" {
  source             = "./modules/network"
  project_id         = var.project_id
  gcp_project_region = var.gcp_project_region
}

module "compute" {
  source                 = "./modules/compute"
  subnet_id              = module.network.subnet_id
  compute_api_dependency = google_project_service.compute
}