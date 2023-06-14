locals {
  # For project-wide uniqual names
  suffix = substr(sha256(var.hackathon_project), 0, 5)

  # VM scratch_disks
  scratch_disks = []

  # All SA used externally
  service_accounts = {
    packer_sa = {
      account_id  = "sa-packer-${local.suffix}"
      description = "SA for running packer to build VM images"
      roles = [
        "roles/compute.instanceAdmin.v1",
        "roles/iam.serviceAccountUser",
        "roles/iap.tunnelResourceAccessor"
      ]
    },
    gh_backend_sa = {
      account_id  = "sa-gh-backend-${local.suffix}"
      description = "SA for pushing backend images to AR"
      roles = [
        "roles/iam.serviceAccountTokenCreator",
        "roles/artifactregistry.writer"
      ]
    },
    gh_frontend_sa = {
      account_id  = "sa-gh-frontend-${local.suffix}"
      description = "SA for publishing frontend artifacts to GCS"
      roles = [
        "roles/storage.admin"
      ]
    }
  }

  # Needed by Serverless VPC Access Connector
  serverless_subnet_name = split("/", module.subnets.subnets["europe-west1/serverless-subnet"])[10]
}