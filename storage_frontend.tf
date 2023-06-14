data "google_iam_policy" "frontend_viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

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

resource "google_storage_bucket_iam_policy" "frontend_policy_binding" {
  bucket      = google_storage_bucket.frontend_static_site.name
  policy_data = data.google_iam_policy.frontend_viewer.policy_data
}
