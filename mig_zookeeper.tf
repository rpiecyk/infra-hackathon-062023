#resource "google_compute_health_check" "hc_zookeeper" {
#  name                = "autohealing-health-check"
#  check_interval_sec  = 5
#  timeout_sec         = 5
#  healthy_threshold   = 2
#  unhealthy_threshold = 10 # 50 seconds
#
#  tcp_health_check {
#    port = "2181"
#  }
#}
#
#resource "google_compute_instance_template" "zookeeper_cluster" {
#  name           = "zookeeper-cluster-template"
#  machine_type   = "e2-medium"
#  can_ip_forward = false
#  tags           = ["kafka"]
#
#  disk {
#    source_image = data.google_compute_image.zookeeper.self_link
#    auto_delete  = true #? STATEFUL??
#    boot         = true #? STATEFUL??
#  }
#
#  network_interface {
#    network = google_compute_network.vpc_network.self_link
#  }
#
#  service_account {
#    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
#
#  }
#
#  metadata = {
#    startup-script = data.template_file.startup_zookeeper.rendered
#  }
#}
#
#resource "google_compute_region_instance_group_manager" "zookeeper" {
#  name = "zookeeper-cluster-igm"
#
#  base_instance_name        = "zookeeper"
#  region                    = "europe-west1"
#  distribution_policy_zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
#
#  version {
#    instance_template = google_compute_instance_template.zookeeper_cluster.self_link_unique
#  }
#
#  #  target_pools = [google_compute_target_pool.appserver.id]
#  target_size = 3
#
#  auto_healing_policies {
#    health_check      = google_compute_health_check.hc_zookeeper.id
#    initial_delay_sec = 300
#  }
#
#  update_policy {
#    minimal_action               = "REPLACE"
#    type                         = "PROACTIVE"
#    instance_redistribution_type = "NONE"
#    replacement_method           = "RECREATE"
#  }
#}
#
## ---------------------------------------------------------------------------------- #
#
#resource "google_compute_address" "zookeeper_1" {
#  project      = var.hackathon_project
#  address      = "10.0.101.30"
#  address_type = "INTERNAL"
#  region       = "europe-west1"
#  subnetwork   = module.subnets.subnets["europe-west1/staging-subnet-01"]
#  name         = "zookeeper-node-1"
#  description  = "An internal IP address for zookeeper cluster - node 1"
#}
#
#resource "google_compute_disk" "zookeeper_1" {
#  name                      = "disk-zookeeper-1"
#  type                      = "pd-ssd"
#  zone                      = "europe-west1-b"
#  physical_block_size_bytes = 4096
#}
#
#resource "google_compute_per_instance_config" "zookeeper_1" {
#  zone                   = "europe-west1-b"
#  instance_group_manager = google_compute_region_instance_group_manager.zookeeper.name
#  name                   = "zookeeper-1"
#  preserved_state {
#    internal_ip {
#      interface_name = "nic0"
#      ip_address {
#        address = google_compute_address.zookeeper_1.address
#      }
#    }
#    metadata = {
#      // Adding a reference to the instance template used causes the stateful instance to update
#      // if the instance template changes. Otherwise there is no explicit dependency and template
#      // changes may not occur on the stateful instance
#      instance_template = google_compute_instance_template.zookeeper_cluster.self_link
#    }
#
#    disk {
#      device_name = "stateful-disk"
#      source      = google_compute_disk.zookeeper_1.id
#      mode        = "READ_WRITE"
#    }
#  }
#}
#
## ---------------------------------------------------------------------------------- #
#
#resource "google_compute_address" "zookeeper_2" {
#  project      = var.hackathon_project
#  address      = "10.0.101.31"
#  address_type = "INTERNAL"
#  region       = "europe-west1"
#  subnetwork   = module.subnets.subnets["europe-west1/staging-subnet-01"]
#  name         = "zookeeper-node-2"
#  description  = "An internal IP address for zookeeper cluster - node 2"
#}
#
#resource "google_compute_disk" "zookeeper_2" {
#  name                      = "disk-zookeeper-2"
#  type                      = "pd-ssd"
#  zone                      = "europe-west1-c"
#  physical_block_size_bytes = 4096
#}
#
#resource "google_compute_per_instance_config" "zookeeper_2" {
#  zone                   = "europe-west1-c"
#  instance_group_manager = google_compute_region_instance_group_manager.zookeeper.name
#  name                   = "zookeeper-2"
#  preserved_state {
#    internal_ip {
#      interface_name = "nic0"
#      ip_address {
#        address = google_compute_address.zookeeper_2.address
#      }
#    }
#    metadata = {
#      // Adding a reference to the instance template used causes the stateful instance to update
#      // if the instance template changes. Otherwise there is no explicit dependency and template
#      // changes may not occur on the stateful instance
#      instance_template = google_compute_instance_template.zookeeper_cluster.self_link
#    }
#
#    disk {
#      device_name = "stateful-disk"
#      source      = google_compute_disk.zookeeper_2.id
#      mode        = "READ_WRITE"
#    }
#  }
#}
#
## ---------------------------------------------------------------------------------- #
#
#resource "google_compute_address" "zookeeper_3" {
#  project      = var.hackathon_project
#  address      = "10.0.101.32"
#  address_type = "INTERNAL"
#  region       = "europe-west1"
#  subnetwork   = module.subnets.subnets["europe-west1/staging-subnet-01"]
#  name         = "zookeeper-node-3"
#  description  = "An internal IP address for zookeeper cluster - node 3"
#}
#
#resource "google_compute_disk" "zookeeper_3" {
#  name                      = "disk-zookeeper-3"
#  type                      = "pd-ssd"
#  zone                      = "europe-west1-d"
#  physical_block_size_bytes = 4096
#}
#
#resource "google_compute_per_instance_config" "zookeeper_3" {
#  zone                   = "europe-west1-d"
#  instance_group_manager = google_compute_region_instance_group_manager.zookeeper.name
#  name                   = "zookeeper-3"
#  preserved_state {
#    internal_ip {
#      interface_name = "nic0"
#      ip_address {
#        address = google_compute_address.zookeeper_3.address
#      }
#    }
#    metadata = {
#      // Adding a reference to the instance template used causes the stateful instance to update
#      // if the instance template changes. Otherwise there is no explicit dependency and template
#      // changes may not occur on the stateful instance
#      instance_template = google_compute_instance_template.zookeeper_cluster.self_link
#    }
#
#    disk {
#      device_name = "stateful-disk"
#      source      = google_compute_disk.zookeeper_3.id
#      mode        = "READ_WRITE"
#    }
#  }
#}