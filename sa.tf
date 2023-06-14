module "sa" {
  source      = "./modules/service_account"
  for_each    = local.service_accounts
  project_id  = var.hackathon_project
  account_id  = each.value.account_id
  description = each.value.description
  roles       = each.value.roles
}