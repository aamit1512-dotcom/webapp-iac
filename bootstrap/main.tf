module "resource_group" {

  source = "../modules/resource_group"

  rgs = var.resource_groups

}

module "storage" {

  source = "../modules/storage"

  storage_accounts = var.storage_accounts

  containers = var.containers
 depends_on = [
    module.resource_group
  ]
}