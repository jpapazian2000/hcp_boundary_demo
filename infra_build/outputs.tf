#VAULT OUTPUTS
output "vault_cluster_id" {
  value = module.hcp.vault_cluster_id
}

output "vault_tier" {
  value = module.hcp.vault_tier
}

output "vault_version" {
  value = module.hcp.vault_version
}

output "vault_token" {
  value = module.hcp.vault_token
}
output "vault_private_endpoint_url" {
  value = module.hcp.vault_private_endpoint_url
}

output "vault_public_endpoint_url" {
  value = module.hcp.vault_public_endpoint_url
}
#POSTGRES OUTPUTS
output "instance_ipv4" {
  value = google_compute_instance.pgsql_db.*.network_interface.0.access_config.0.nat_ip
}
output "db_ip" {
  value = element(google_compute_instance.pgsql_db.*.network_interface.0.access_config.0.nat_ip,1)
}
output "privkey" {
  value = local.privkey
  sensitive = true
}
output "pubkey" {
  value = local.pubkey
}
output "instance_db_name" {
  value = var.pgsql_db_name
}
output "instance_db_admin" {
  value = var.pgsql_admin_user
}
output "pgsql_server_name" {
  value = google_compute_instance.pgsql_db.name
}
output "pgsql_admin_pwd" {
  value = var.pgsql_admin_pwd
  sensitive = true
}
#BOUNDARY OUTPUTS
output "boundary_cluster" {
  value = hcp_boundary_cluster.boundary.cluster_url
}
output "boundary_user" {
  value = var.boundary_user
}
output "boundary_pwd" {
  value = var.boundary_pwd
  sensitive = true
}