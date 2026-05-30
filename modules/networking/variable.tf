variable "nsgs" {
  type = map(object({
    name     = string
    rg_name  = string
    location = string

    rules = list(object({
      name                        = string
      priority                    = number
      direction                   = string
      access                      = string
      protocol                    = string
      source_port_range           = string

      destination_port_range      = optional(string, null)
      destination_port_ranges     = optional(list(string), null)

      source_address_prefix       = string
      destination_address_prefix = string
    }))

    tags = optional(map(string), {})
  }))
}


variable "location" {
  type        = string
  description = "Azure region for networking resources"
}

variable "rg_name" {
  type        = string
  description = "Resource group name for networking resources"
}


variable "vnets" {
  type = map(object({
    name                 = string
    rg_name  = string
    location = string
    address_space    = list(string)
   dns_servers     =  optional(list(string))
  }))
}


variable "subnets" {
  type = map(object({
    name                 = string
    rg_name  = string
    vnet_name = string
    address_prefixes     = optional(list(string))
    nsg_key              = optional(string)
  }))
}
