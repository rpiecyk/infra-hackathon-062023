resource "google_compute_firewall" "rules" {
  for_each                = { for x in var.rules : x.name => x }
  name                    = each.value.name
  description             = each.value.description
  network                 = var.network_name
  direction               = each.value.direction
  source_ranges           = each.value.direction == "INGRESS" ? each.value.source_ranges : null
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.destination_ranges : null
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}