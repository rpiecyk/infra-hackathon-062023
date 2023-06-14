output "subnets" {
  value       = { for k, v in google_compute_subnetwork.subnetwork : k => v.self_link }
  description = ""
}