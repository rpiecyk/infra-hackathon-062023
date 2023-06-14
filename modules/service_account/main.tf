resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.description
}

resource "google_project_iam_member" "service_account_iam" {
  for_each   = toset(var.roles)
  project    = var.project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [google_service_account.service_account]
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.service_account.name
}