variable "sql_server_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "administrator_username" {}
variable "administrator_password" {

  type      = string

  sensitive = true

}
variable "tags" {}