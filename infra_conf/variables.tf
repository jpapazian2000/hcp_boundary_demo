## Boundary variables
#
#variable "boundary_user" {
  #description = "name of the boundary user admin"
#}
#
#variable "boundary_pwd" {
  #description = "password of the boundary user"
#}
#
variable "boundary_auth_method" {
  description ="auth method for initial connection"
}
#Cloud Mandatory Tags
variable "purpose" {
  description = "goal of this code"
}

variable "owner" {
  description = "owner of the repo"
}

variable "se-region" {
  description = "geo where the infra is deployed"
}

variable "terraform" {
  description = "is it deployed with terraform"
}

variable "ttl" {
  description = "for automatic deletion"
}

# GOOGLE VARIABLES
variable "google_region" {
  description = "region for google project"
}

variable "google_zone" {}

variable "google_project" {}


#pgsql variables

#variable "pgsql_server_name" {
  #description = "name of server to host the db"
#}
#
#variable "pgsql_db_name" {
  #description = "name of the db"
#}
#
#variable "pgsql_admin_pwd" {
  #description = "admin passworkd for pgsql" 
#}
#
#variable "pgsql_admin_user" {
  #description = "admin user to connect to the instance"
#}

variable "pgsql_vault_name" {
  description = "user for configuring pgsql"
}

variable "pgsql_vault_pwd" {
  description = "passford for user for configuring pgsql"
}
