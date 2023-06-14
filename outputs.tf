# TBD

output "packer_sa_key" {
  sensitive = true
  value     = module.sa["packer_sa"].decoded_private_key
}

#output "gh_backend_sa_key" {
#  sensitive = true
#  value     = module.sa["gh_backend_sa"].decoded_private_key
#}