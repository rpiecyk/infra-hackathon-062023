source "googlecompute" "zookeeper-image" {
  project_id          = var.hackathon_project
  source_image_family = "ubuntu-2204-lts"
  zone                = var.zone
  image_name          = "packer-zookeeper-${local.timestamp}"
  image_description   = "Created with Packer - Hackathon zookeeper base image"
  ssh_username        = "root"
  tags                = ["packer"]
}

build {
  name    = "zookeeper-hackathon-base-image"
  sources = ["sources.googlecompute.zookeeper-image"]

  provisioner "shell" {
    inline = ["mkdir -p /opt/zookeeper"]
  }

  provisioner "file" {
    source      = "configs/zoo.cfg"
    destination = "/tmp/zoo.cfg"
  }

  provisioner "file" {
    source      = "configs/zookeeper.service"
    destination = "/etc/systemd/system/zookeeper.service"
  }

  provisioner "shell" {
    script = "scripts/bootstrap-zookeeper.sh"
  }
}