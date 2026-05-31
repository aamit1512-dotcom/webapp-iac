
variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = map(string)
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



variable "subnets" {
  type = map(object({
    name             = string
    rg_name          = string
    nsg_key          = optional(string)
    vnet_name        = string
    address_prefixes = list(string)
  }))
}

variable "administrator_password" {
  description = "SQL admin password — set via terraform.tfvars.local or TF_VAR_administrator_password"
  type        = string
  sensitive   = true
}

variable "administrator_username" {
  description = "SQL admin username — set via terraform.tfvars.local or TF_VAR_administrator_username"
  type        = string
  sensitive   = true
}
variable "storage_key" {
  sensitive = true
}

variable "app_secret" {
  sensitive = true
}


variable "admin_username" {
  type = string
}

# No default path here — path is provided via terraform.tfvars.local
# so each developer sets their own OS-specific path without touching shared files.
variable "ssh_public_key_path" {
  description = <<-EOT
    Path to your SSH public key file.
    Set this in terraform.tfvars.local (never in terraform.tfvars).
    Linux/Mac example : ~/.ssh/id_rsa.pub
    Windows example   : C:/Users/YOUR_USERNAME/.ssh/id_rsa.pub
  EOT
  type        = string
}
