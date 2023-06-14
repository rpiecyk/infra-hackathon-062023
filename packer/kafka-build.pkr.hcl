source "googlecompute" "kafka-image" {
  project_id          = var.hackathon_project
  source_image_family = "ubuntu-2204-lts"
  zone                = var.zone
  image_name          = "packer-kafka-${local.timestamp}"
  image_description   = "Created with Packer - Hackathon kafka base image"
  ssh_username        = "root"
  tags                = ["packer"]
}

build {
  name    = "kafka-hackathon-base-image"
  sources = ["sources.googlecompute.kafka-image"]

  provisioner "file" {
    source      = "configs/kafka.service"
    destination = "/etc/systemd/system/kafka.service"
  }

  provisioner "shell" {
    script = "scripts/bootstrap-kafka.sh"
  }

  provisioner "file" {
    source      = "configs/server.properties"
    destination = "/data/kafka/config/server.properties"
  }
}