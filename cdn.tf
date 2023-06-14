# Reserve an external IP
resource "google_compute_global_address" "website" {
  name = "frontend-external-ip"
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website" {
  name        = "frontend-website-backend"
  description = "Frontend for the patodamiro app."
  bucket_name = google_storage_bucket.frontend_static_site.name
  enable_cdn  = true
}

# GCP URL MAP
resource "google_compute_url_map" "website" {
  name            = "frontend-website-url-map"
  default_service = google_compute_backend_bucket.website.self_link
}

# GCP target proxy
resource "google_compute_target_https_proxy" "website" {
  name             = "frontend-website-target-proxy"
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website.self_link
}