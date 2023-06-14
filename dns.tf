resource "google_dns_managed_zone" "patodamiro_zone" {
  name        = "todamiro-com"
  dns_name    = "todamiro.com."
  description = "Hackathon - ToDoMiRo site DNS zone"

  dnssec_config {
    kind = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state = "on"

    default_key_specs {
      algorithm = "rsasha256"
      key_length = 2048
      key_type = "keySigning"
      kind = "dns#dnsKeySpec"
    }

    default_key_specs {
      algorithm = "rsasha256"
      key_length = 1024
      key_type = "zoneSigning"
      kind = "dns#dnsKeySpec"
    }
  }
}