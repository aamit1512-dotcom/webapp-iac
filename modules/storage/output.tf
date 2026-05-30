output "storage_account_names" {
  value = local.storage_account_names
}
output "storage_account_ids" {
  value = { for k, s in azurerm_storage_account.stg_acc : k => s.id }
}