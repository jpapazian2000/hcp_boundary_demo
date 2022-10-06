#Vault Namespace creation
resource "vault_namespace" "database" {
    depends_on = [
      null_resource.conf_pgsql
    ]
    namespace = "admin"
    path = "database"
}
#Boundary Controller policy Creation
resource "vault_policy" "boundary-controller" {
    namespace = vault_namespace.database.path_fq
    name = "boundary-controller"

    policy = <<EOT
    path "auth/token/lookup-self" {
      capabilities = ["read"]
        }

    path "auth/token/renew-self" {
    capabilities = ["update"]
        }

    path "auth/token/revoke-self" {
    capabilities = ["update"]
        }

    path "sys/leases/renew" {
    capabilities = ["update"]
        }

    path "sys/leases/revoke" {
    capabilities = ["update"]
        }

    path "sys/capabilities-self" {
    capabilities = ["update"]
        }
EOT    
}
#Database Secret engine creation
resource "vault_database_secrets_mount" "postgres" {
    path = "postgres"
    namespace = vault_namespace.database.path_fq

    postgresql {
        name = local.pgsql_db_name
        username = var.pgsql_vault_name
        password = var.pgsql_vault_pwd
        connection_url = "postgres://${var.pgsql_vault_name}:${var.pgsql_vault_pwd}@${local.db_ip}:5432/postgres"
        verify_connection = false
        allowed_roles = [
            "dba", "analyst"
        ]
    }
}
resource "vault_database_secret_backend_role" "dba" {
    namespace = vault_namespace.database.path_fq
    backend = vault_database_secrets_mount.postgres.path
    name = "dba"
    db_name = vault_database_secrets_mount.postgres.postgresql[0].name
    default_ttl = "120"
    creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' INHERIT;",
        "GRANT northwind_dba TO \"{{name}}\";",
        ]
}
resource "vault_database_secret_backend_role" "analyst" {
    namespace = vault_namespace.database.path_fq
    backend = vault_database_secrets_mount.postgres.path
    name = "analyst"
    db_name = vault_database_secrets_mount.postgres.postgresql[0].name
    creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' INHERIT;",
        "GRANT northwind_analyst TO \"{{name}}\";",
        ]
}

data "vault_policy_document" "northwind_database" {
    rule {
        path = "${vault_database_secrets_mount.postgres.path}/creds/${vault_database_secret_backend_role.analyst.name}"
        capabilities = ["read"]
        description = "allow creds for analyst"
    }
    rule {
        path = "${vault_database_secrets_mount.postgres.path}/creds/${vault_database_secret_backend_role.dba.name}"
        capabilities = ["read"]
        description = "allow creds for dba"        
    }
}
resource "vault_policy" "northwind_database_policy" {
    namespace = vault_namespace.database.path_fq
    name = "northwind-database"
    policy = data.vault_policy_document.northwind_database.hcl
}
resource "vault_token" "boundary_token" {
    depends_on = [
      vault_policy.northwind_database_policy, vault_policy.boundary-controller
    ]
    namespace = vault_namespace.database.path_fq
    #namespace = "admin"
    no_default_policy = "true"
    policies = ["boundary-controller", "northwind-database"]
    #policies = ["hcp-root"]
    period = "1200"
    renewable = true
    no_parent = true
}
locals {
    output_vault_token_nonsensitive = nonsensitive(vault_token.boundary_token.client_token)
}
output "namespace_fq" {
    value = vault_namespace.database.path_fq
}
output "namespace_short" {
    value = vault_namespace.database.path
}