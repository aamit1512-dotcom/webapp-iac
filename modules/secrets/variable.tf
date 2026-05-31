variable "key_vaults" {
  type = map(object({
    kv_name  = string
    rg_name  = string
    location = string
    secrets  = map(string)
    tags     = map(string)
  }))
}
variable "administrator_password" {
  sensitive = true
}

variable "storage_key" {
  sensitive = true
}

variable "app_secret" {
  sensitive = true
}