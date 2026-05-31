variable "resource_groups" {

  type = map(object({

    name       = string

    location   = string

    tags       = map(string)

    managed_by = optional(string)

  }))

}

