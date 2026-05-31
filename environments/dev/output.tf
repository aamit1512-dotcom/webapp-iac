output "all_secrets" {

  value = module.secrets.secrets

  sensitive = true

}