resource "google_compute_address" "zookeeper_single_1" {
  project      = var.hackathon_project
  address      = "10.0.101.10"
  address_type = "INTERNAL"
  region       = "europe-west1"
  subnetwork   = module.subnets.subnets["europe-west1/staging-subnet-01"]
  name         = "zookeeper-1"
  description  = "An internal IP address for zookeeper - node 1"
}

resource "google_compute_instance" "single_zookeeper_instance" {
  name = "${var.environment}-single-zookeeper-1"
  # n2-standard-2 as a scale up option
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.zookeeper.self_link
    }
  }

  dynamic "scratch_disk" {

    for_each = local.scratch_disks
    content {
      interface = scratch_disk.value.interface
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    network_ip = google_compute_address.zookeeper_single_1.address
    subnetwork = module.subnets.subnets["europe-west1/staging-subnet-01"]
  }

  #  metadata_startup_script = file("config/vm_startup_script.sh")

  tags = ["kafka"]

  depends_on = [google_project_service.api_service["compute.googleapis.com"], google_compute_network.vpc_network]
  lifecycle {
    create_before_destroy = false
  }
}

resource "google_compute_address" "kafka_single_1" {
  project      = var.hackathon_project
  address      = "10.0.101.20"
  address_type = "INTERNAL"
  region       = "europe-west1"
  subnetwork   = module.subnets.subnets["europe-west1/staging-subnet-01"]
  name         = "kafka-1"
  description  = "An internal IP address for kafka - node 1"
}

resource "google_compute_instance" "single_kafka_instance" {
  name = "${var.environment}-single-kafka-1"
  # n2-standard-2 as a scale up option
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.kafka.self_link
    }
  }

  dynamic "scratch_disk" {

    for_each = local.scratch_disks
    content {
      interface = scratch_disk.value.interface
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    network_ip = google_compute_address.kafka_single_1.address
    subnetwork = module.subnets.subnets["europe-west1/staging-subnet-01"]
  }

  #  metadata_startup_script = file("config/vm_startup_script.sh")

  tags = ["kafka"]

  depends_on = [google_project_service.api_service["compute.googleapis.com"],
    google_compute_network.vpc_network,
  google_compute_instance.single_zookeeper_instance]
}