resource "google_storage_bucket" "frontend_static_site" {
  name          = "todamiro-frontend-bucket-${local.suffix}"
  location      = "EU"
  force_destroy = false

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
  }

  depends_on = [google_project_service.api_service["storage.googleapis.com"]]
}