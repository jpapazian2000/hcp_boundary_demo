resource "hcp_boundary_cluster" "boundary" {
    cluster_id = var.boundary_cluster_name
    username = var.boundary_user
    password = var.boundary_pwd
}