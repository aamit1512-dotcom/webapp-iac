



variable "rgs" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
    managed_by = optional(string)
  }))
}

variable "key_vaults" {
  type = map(object({
    kv_name  = string
    location = string
    rg_name  = string
    secrets  = map(string)
    tags     = map(string)
  }))
}

variable "nsgs" {
  type = map(object({
    name     = string
    location = string
    rg_name  = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
    tags = map(string)
  }))
}

variable "public_ips" {
  type = map(object({
    name              = string
    location          = string
    rg_name           = string
    allocation_method = string
    tags              = map(string)
  }))
}




variable "vms" {
  description = "Linux VM map"
  type        = map(any)
}



variable "vnets" {
  description = "Virtual networks and subnets"
  type = map(object({
    name          = string
    location      = string
    rg_name       = string
    address_space = list(string)

    subnets = map(object({
      name             = string
      address_prefixes = list(string)
    }))

    tags = map(string)
  }))
}
variable "storage_accounts" {
  description = "Storage accounts configuration"
  type = map(object({
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  }))

  default = {}
}
variable "subnets" {
  type = map(object({
    name             = string
    rg_name          = string
    nsg_key          = string
    vnet_name        = string
    address_prefixes = list(string)
  }))
}
variable "administrator_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}
variable "administrator_username" {
  description = "SQL admin username"
  type        = string
  sensitive   = true
}

variable "containers" {}
variable "admin_username" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}
