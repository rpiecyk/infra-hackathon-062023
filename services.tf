locals {
  services = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "replicapool.googleapis.com",
    "dns.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

resource "google_project_service" "api_service" {
  for_each                   = toset(local.services)
  service                    = each.value
  project                    = var.hackathon_project
  disable_dependent_services = true
  disable_on_destroy         = false
}