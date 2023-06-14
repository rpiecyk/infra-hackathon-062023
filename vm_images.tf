data "google_compute_image" "kafka" {
  name = var.kafka_image_name
}

data "google_compute_image" "zookeeper" {
  name = var.zookeeper_image_name
}