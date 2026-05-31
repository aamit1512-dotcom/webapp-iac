data "azurerm_client_config" "current" {}

############################################
# Key Vault
############################################

resource "azurerm_key_vault" "kv" {

  for_each = var.key_vaults

  name                = each.value.kv_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  tenant_id = data.azurerm_client_config.current.tenant_id

  enabled_for_disk_encryption = true

  soft_delete_retention_days = 7

  purge_protection_enabled = false

  sku_name = "standard"

  tags = each.value.tags

  access_policy {

    tenant_id = data.azurerm_client_config.current.tenant_id

    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover"
    ]
  }
}

############################################
# Secrets
############################################

resource "azurerm_key_vault_secret" "secret" {

  for_each = {

    for item in flatten([

      for env, kv in var.key_vaults : [

        for secret_name, secret_value in kv.secrets : {

          key = "${env}.${secret_name}"

          name = replace(secret_name, "_", "-")

          value = (
            secret_name == "sql_password" ? var.administrator_password :
            secret_name == "storage_key"  ? var.storage_key :
            secret_name == "app_secret"   ? var.app_secret :
            secret_value
          )

          key_vault_id = azurerm_key_vault.kv[env].id

        }

      ]

    ]) : item.key => item
  }

  name         = each.value.name
  value        = each.value.value
  key_vault_id = each.value.key_vault_id

  depends_on = [
    azurerm_key_vault.kv
  ]
}