output "unique_id" {
  value       = google_service_account.service_account.unique_id
  description = "The unique id of the service account."
}

output "decoded_private_key" {
  value     = base64decode(google_service_account_key.sa_key.private_key)
  sensitive = true
}
