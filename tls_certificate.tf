resource "google_compute_managed_ssl_certificate" "website" {
  provider = google-beta
  project  = var.hackathon_project
  name     = "frontend-website-website-cert"
  managed {
    domains = [google_dns_record_set.patodamiro_website.name]
  }
}