output "secrets" {

  value = {

    for k, v in azurerm_key_vault_secret.secret :

    k => v.value

  }

  sensitive = true
}