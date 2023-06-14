resource "google_artifact_registry_repository" "todamiro_backend" {
  location      = "europe-west1"
  repository_id = "todamiro-backend"
  description   = "Backend for todamiro app"
  format        = "DOCKER"

  depends_on = [google_project_service.api_service["artifactregistry.googleapis.com"]]
}