data "template_file" "startup_zookeeper" {
  template = file("${path.module}/scripts/startup_zookeeper.sh")
  vars = {
    project_id = var.hackathon_project
    region     = var.main_region
  }
}

data "template_file" "startup_kafka" {
  template = file("${path.module}/scripts/startup_kafka.sh")
  vars = {
    zookeeper_nodes = "10.0.101.30:2181,10.0.101.31:2181,10.0.101.32:2181"
  }
}