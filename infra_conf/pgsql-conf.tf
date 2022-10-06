
locals {
    db_ip = data.terraform_remote_state.infra.outputs.db_ip
    admin_user = data.terraform_remote_state.infra.outputs.instance_db_admin
    pgsql_db_name = data.terraform_remote_state.infra.outputs.instance_db_name
    pgsql_admin_pwd = data.terraform_remote_state.infra.outputs.pgsql_admin_pwd
}
resource "null_resource" "conf_pgsql" {

    connection {
        type = "ssh"
        user = local.admin_user
        host = local.db_ip
        timeout = "300s"
        private_key = data.terraform_remote_state.infra.outputs.privkey
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 30",
            "sudo chown postgres:postgres /tmp/northwind-database.sql",
            "sudo chown postgres:postgres /tmp/northwind-roles.sql",
            "sudo -u postgres PGPASSWORD=${local.pgsql_admin_pwd} psql -h localhost -U postgres -d ${local.pgsql_db_name} -f /tmp/northwind-database.sql",
            "sudo -u postgres PGPASSWORD=${local.pgsql_admin_pwd} psql -h localhost -U postgres -d ${local.pgsql_db_name} -f /tmp/northwind-roles.sql",
            ]
        }    
}