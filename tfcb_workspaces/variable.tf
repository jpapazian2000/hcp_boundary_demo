variable "build_workspace_name" {
    description = "name of the build workspace"
    default = "hcp-vault-boundary-infra2"
}
variable "conf_workspace_name" {
    description = "name of the build workspace"
    default = "hcp-vault-boundary-conf2"
}
variable "vcs_token" {
    description = "oauth token for vcs connection"
    sensitive = true
}
variable "tfe_token" {
    description = "token tfcb connection"
    sensitive = true
}
variable "aws_credentials" {
    description = "name of the existing variable set for aws credentials"
}
variable "google_credentials" {
    description = "name of the existing variable set for google credentials"
}
variable "hcp_credentials" {
    description = "name of the existing variable set for hcp credentials"
}
variable "mandatory_tags" {
    description = "name of the existing variable set for mandatory tags to apply to all resources"
}
variable "boundary_pwd" {
    description = "admin pwd of boundary"
    sensitive = true
}
variable "boundary_user" {
    description = "admin user of boundary"
}
variable "cluster" {
    description = "boundary cluster name"
}
variable "google_subnet_prefix" {
    description = "google subnet"
    default = "10.0.10.0/24"
}
variable "ssh_allowed_ip" {
    description = "allowed ip to the db"
    default = "0.0.0.0/24"
}
variable "pgsql_vault_name" {
    description = "user for vault to connect to the db"
    default = "vault"
}
variable "pgsql_vault_pwd" {
    description = "user pwd for vault to connect to the db"
    default = "vault-password"
    sensitive = true
}
variable "pgsql_admin_user" {
    description = "admin of the pgsql db"
    default = "adminuser"
}
variable "pgsql_admin_pwd" {
    description = "pwd of the db"
    default = "B0nd4R1"
    sensitive = true
}
variable "pgsql_db_name" {
    description = "database name to connect to"
    default = "northwind"
}
variable "pgsql_server_name" {
    description = "compute instance name of the db"
    default = "jpapazian-pgsql"
}
variable "region" {
    description = "HCP HVN Region"
    default = "eu-central-1"
}