data "tfe_organization" "org" {
  name = var.tfcb_org
}
data "tfe_variable_set" "aws" {
    name = var.aws_credentials
    organization = data.tfe_organization.org.name
}
data "tfe_variable_set" "google" {
    name = var.google_credentials
    organization = data.tfe_organization.org.name
}
data "tfe_variable_set" "hcp" {
    name = var.hcp_credentials
    organization = data.tfe_organization.org.name
}
data "tfe_variable_set" "mandatory_tags" {
    name = var.mandatory_tags
    organization = data.tfe_organization.org.name
}

resource "tfe_oauth_client" "creds" {
  name             = "jpapazian-oauth-client"
  organization     = var.tfcb_org
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.vcs_token
  service_provider = "github"
}

#create workspace Build_infra
resource "tfe_workspace" "build" {
    depends_on = [
      tfe_workspace.conf
    ]
    name = var.build_workspace_name
    organization = data.tfe_organization.org.name
    tag_names = ["hcp", "vault", "boundary"]
    description = "workspace to create the infra for the boundary demo"
    allow_destroy_plan = true
    global_remote_state = false
    remote_state_consumer_ids = [ tfe_workspace.conf.id ]
    working_directory = "infra_build"
    queue_all_runs = false
    trigger_prefixes = ["/infra_build/*"]
    vcs_repo {
      identifier = "jpapazian2000/hcp_boundary_demo"
      oauth_token_id = tfe_oauth_client.creds.oauth_token_id
    }
}
#create workspace conf
resource "tfe_workspace" "conf" {
    name = var.conf_workspace_name
    organization = data.tfe_organization.org.name
    tag_names = ["hcp", "vault", "boundary"]
    description = "workspace to configure the infra for the boundary demo"
    allow_destroy_plan = true
    global_remote_state = false
    working_directory = "infra_conf"
    queue_all_runs = false
    trigger_prefixes = ["/infra_conf/*"]
    vcs_repo {
      identifier = "jpapazian2000/hcp_boundary_demo"
      oauth_token_id = tfe_oauth_client.creds.oauth_token_id
    }
}
#association of variable sets
resource  "tfe_workspace_variable_set" "aws_build" {
    variable_set_id = data.tfe_variable_set.aws.id
    workspace_id = tfe_workspace.build.id
}
resource  "tfe_workspace_variable_set" "google_build" {
    variable_set_id = data.tfe_variable_set.google.id
    workspace_id = tfe_workspace.build.id
}
resource  "tfe_workspace_variable_set" "hcp_build" {
    variable_set_id = data.tfe_variable_set.hcp.id
    workspace_id = tfe_workspace.build.id
}
resource  "tfe_workspace_variable_set" "mandatory_tags_build" {
    variable_set_id = data.tfe_variable_set.mandatory_tags.id
    workspace_id = tfe_workspace.build.id
}
resource  "tfe_workspace_variable_set" "google_conf" {
    variable_set_id = data.tfe_variable_set.google.id
    workspace_id = tfe_workspace.conf.id
}
resource  "tfe_workspace_variable_set" "hcp_conf" {
    variable_set_id = data.tfe_variable_set.hcp.id
    workspace_id = tfe_workspace.conf.id
}
resource  "tfe_workspace_variable_set" "mandatory_tags_conf" {
    variable_set_id = data.tfe_variable_set.mandatory_tags.id
    workspace_id = tfe_workspace.conf.id
}
#Variables Definition
resource "tfe_variable" "boundary_pwd" {
    key = "boundary_pwd"
    value = var.boundary_pwd
    sensitive = true
    workspace_id = tfe_workspace.build.id
    description = "password to connect to the provisionned boundary instance"
    category = "terraform"
}
resource "tfe_variable" "boundary_user" {
    key = "boundary_user"
    value = var.boundary_user
    workspace_id = tfe_workspace.build.id
    description = "admin user of the boundary cluster "
    category = "terraform"
}
resource "tfe_variable" "cluster" {
    key = "boundary_cluster_name"
    value = var.cluster
    workspace_id = tfe_workspace.build.id
    description = "name of the proivsionned boundary cluster "
    category = "terraform"
}
resource "tfe_variable" "google_subnet_prefix" {
    key = "google_subnet_prefix"
    value = var.google_subnet_prefix
    workspace_id = tfe_workspace.build.id
    description = "subnet in google in which to provision the database"
    category = "terraform"
}
resource "tfe_variable" "ssh_allowed_ip" {
    key = "ssh_allowed_ip"
    value = var.ssh_allowed_ip
    workspace_id = tfe_workspace.build.id
    description = "range of authorized ip to connect to the instance"
    category = "terraform"
}
resource "tfe_variable" "pgsql_vault_name" {
    key = "pgsql_vault_name"
    value = var.pgsql_vault_name
    workspace_id = tfe_workspace.conf.id
    description = "user that vault will use to connect to the instance"
    category = "terraform"
}
resource "tfe_variable" "pgsql_vault_pwd" {
    key = "pgsql_vault_pwd"
    value = var.pgsql_vault_pwd
    workspace_id = tfe_workspace.conf.id
    description = "pwd that vault will use to connect to the instance"
    category = "terraform"
    sensitive = true
}
resource "tfe_variable" "pgsql_admin_user" {
    key = "pgsql_admin_user"
    value = var.pgsql_admin_user
    workspace_id = tfe_workspace.build.id
    description = "admin user of the pgsql db"
    category = "terraform"
}
resource "tfe_variable" "pgsql_admin_pwd" {
    key = "pgsql_admin_pwd"
    value = var.pgsql_admin_pwd
    workspace_id = tfe_workspace.build.id
    description = "pwd  of the admin db"
    category = "terraform"
    sensitive = true
}
resource "tfe_variable" "pgsql_db_name" {
    key = "pgsql_db_name"
    value = var.pgsql_db_name
    workspace_id = tfe_workspace.build.id
    description = "name of the database in the pgsql instance to connect to"
    category = "terraform"
}
resource "tfe_variable" "pgsql_server_name" {
    key = "pgsql_server_name"
    value = var.pgsql_server_name
    workspace_id = tfe_workspace.build.id
    description = "name of the pgsql compute instance"
    category = "terraform"
}
resource "tfe_variable" "region" {
    key = "region"
    value = var.region
    workspace_id = tfe_workspace.build.id
    description = "HCP HVN Region for the vault/boundary infra"
    category = "terraform"
}
resource "tfe_variable" "boundary_auth_method" {
    key = "boundary_auth_method"
    value = var.boundary_auth_method
    workspace_id = tfe_workspace.conf.id
    description = "initial auth method for boundary"
    category = "terraform"
}





