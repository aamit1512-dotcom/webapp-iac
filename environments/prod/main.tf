# =========================
# RESOURCE GROUP
# =========================
module "resource_group" {
  source = "../../modules/resource_group"
  rgs    = var.rgs
}

# =========================
# KEY VAULT
# =========================
module "secrets" {
  source     = "../../modules/secrets"
  key_vaults = var.key_vaults
  depends_on = [module.resource_group]
}

# =========================
# NSG
# =========================
module "networking" {
  source   = "../../modules/networking"
  rg_name  = module.resource_group.rg_names["dev"]
  location = module.resource_group.rg_locations["dev"]

  nsgs       = var.nsgs
  vnets      = var.vnets
  subnets    = var.subnets
  depends_on = [module.resource_group]
}

# =========================
# PUBLIC IP
# =========================
module "pip" {
  source     = "../../modules/pip"
  public_ips = var.public_ips
  depends_on = [module.resource_group]
}

# =========================
# NETWORK INTERFACE
# =========================


# =========================
# VIRTUAL MACHINE
# =========================
module "computing" {
  depends_on          = [module.networking]
  source              = "../../modules/computing"
  subnet_ids          = module.networking.subnet_ids
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  vms                 = var.vms
  subnets             = var.subnets
  public_ips          = var.public_ips





}




module "storage_account" {
  source           = "../../modules/storage"
  storage_accounts = var.storage_accounts
  containers       = var.containers

  depends_on = [module.resource_group]
}

module "sql_server" {
  source          = "../../modules/sql_server"
  sql_server_name = "aamit"

  resource_group_name    = module.resource_group.rg_names["dev"]
  location               = module.resource_group.rg_locations["dev"]
  administrator_username = var.administrator_username

  administrator_password = var.administrator_password


  tags = {}
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/sql_database"
  sql_db_name = "sqldb-dev-aamit"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = {}
}
module "appgw" {
  source = "../../modules/appgateway"

  rg_name         = module.resource_group.rg_names["dev"]
  location        = module.resource_group.rg_locations["dev"]
  vnet_name       = module.networking.vnet_names["dev"]
  appgw_subnet_id = module.networking.subnet_ids["appgw"]
  public_ip_id    = module.pip.public_ip_ids["appgw"]
  frontend_nic_ids = {
  vm1 = module.computing.nic_ids["vm1"]
}
}
