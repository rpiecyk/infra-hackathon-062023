resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment}-${local.suffix}"
  auto_create_subnetworks = false
  mtu                     = 1460

  depends_on = [google_project_service.api_service["compute.googleapis.com"]]
}

module "subnets" {
  source = "./modules/subnets"

  project_id   = var.hackathon_project
  network_name = google_compute_network.vpc_network.self_link
  subnets      = var.subnets

  depends_on = [google_compute_network.vpc_network]
}


resource "google_compute_router" "router" {
  name        = "${var.environment}-router-${local.suffix}"
  network     = google_compute_network.vpc_network.self_link
  region      = var.main_region
  description = "Created with Terraform - ${var.environment}-router-${local.suffix}"
  bgp {
    asn            = 64514
    advertise_mode = "DEFAULT"
  }

  depends_on = [google_compute_network.vpc_network]
}


resource "google_compute_router_nat" "nat" {
  name                               = "${var.environment}-router-nat-${local.suffix}"
  router                             = google_compute_router.router.name
  region                             = var.main_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [google_compute_router.router]
}