resource "boundary_scope" "org" {
    scope_id = "global"
    global_scope = true
    auto_create_admin_role = true
    auto_create_default_role = true
}

resource "boundary_scope" "databases" {
    name = "databases"
    scope_id = boundary_scope.org.id
    auto_create_admin_role = true
    auto_create_default_role = true
}

resource "boundary_scope" "postgres" {
    name = "databases acces"
    description = "project to access to postgres databases"
    scope_id = boundary_scope.databases.id
    auto_create_admin_role = true
    auto_create_default_role = true
}

resource "boundary_credential_store_vault" "vault" {
    name = "vault_store"
    description = "where boundaries will get its credential"
    address = data.terraform_remote_state.infra.outputs.vault_public_endpoint_url
    token = vault_token.boundary_token.client_token
    namespace = vault_namespace.database.path_fq
    scope_id = boundary_scope.postgres.id
    tls_skip_verify = true
}

resource "boundary_credential_library_vault" "dba_library" {
    name = "vault_dba_library"
    description = "path in vault"
    credential_store_id = boundary_credential_store_vault.vault.id
    path = "${vault_database_secrets_mount.postgres.path}/creds/dba"
    http_method = "GET"
    credential_type = "username_password"
}
resource "boundary_credential_library_vault" "analyst_library" {
    name = "vault_analyst_library"
    description = "path in vault"
    credential_store_id = boundary_credential_store_vault.vault.id
    path = "${vault_database_secrets_mount.postgres.path}/creds/analyst"
    http_method = "GET"
    credential_type = "username_password"
}
resource "boundary_host_catalog_static" "db_catalog" {
    name = "db_catalog"
    description = "catalog that will host all pgsql db"
    scope_id = boundary_scope.postgres.id
}
resource "boundary_host_static" "pgsql_db" {
    name = local.pgsql_db_name
    host_catalog_id = boundary_host_catalog_static.db_catalog.id
    address = local.db_ip
}
resource "boundary_host_set_static" "pgsql_host_set" {
    host_catalog_id = boundary_host_catalog_static.db_catalog.id
    host_ids = [
        boundary_host_static.pgsql_db.id
    ]
}
resource "boundary_target" "pgsql_dba" {
    name = "pgsql_dba"
    type = "tcp"
    default_port = "5432"
    scope_id = boundary_scope.postgres.id
    host_source_ids = [ boundary_host_set_static.pgsql_host_set.id ]
    brokered_credential_source_ids = [ boundary_credential_library_vault.dba_library.id ]
}
resource "boundary_target" "pgsql_analyst" {
    name = "pgsql_analyst"
    type = "tcp"
    default_port = "5432"
    scope_id = boundary_scope.postgres.id
    host_source_ids = [ boundary_host_set_static.pgsql_host_set.id ]
    brokered_credential_source_ids = [ boundary_credential_library_vault.analyst_library.id ]
}