module "firewall" {
  source       = "./modules/firewall"
  network_name = google_compute_network.vpc_network.self_link
  rules = [
    {
      name                    = "allow-ssh-through-iap-to-bastion"
      description             = "allow ssh connections through IAP"
      direction               = "INGRESS"
      source_ranges           = ["35.235.240.0/20"]
      source_tags             = null
      source_service_accounts = null
      destination_ranges      = null
      target_tags             = ["bastion", "kafka"]
      target_service_accounts = null
      priority                = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
        },
        {
          protocol = "icmp"
          ports    = []
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "allow-ssh-from-bastion-to-private-instances"
      description             = "allow ssh connections from bastion host to private instances"
      direction               = "INGRESS"
      source_ranges           = null
      source_tags             = ["bastion"]
      source_service_accounts = null
      destination_ranges      = null
      target_tags             = ["private-host"]
      target_service_accounts = null
      priority                = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "allow-internal-traffic"
      description             = "allow in-VPC traffic"
      direction               = "INGRESS"
      source_ranges           = ["10.0.100.0/23", "10.0.200.0/23"]
      source_tags             = null
      source_service_accounts = null
      destination_ranges      = null
      target_tags             = []
      target_service_accounts = null
      priority                = 65534
      allow = [{
        protocol = "tcp"
        ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
          ports    = []
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "kafka-cluster-vpc-allow-kafka-zookeeper"
      description             = "Allow traffic between Kafka brokers and Zookeeper nodes"
      direction               = "INGRESS"
      source_ranges           = []
      source_tags             = ["kafka"]
      source_service_accounts = null
      destination_ranges      = null
      target_tags             = ["kafka"]
      target_service_accounts = null
      priority                = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}