# Vault Outputs

output "vault_namespace" {
  value = vault_namespace.database
}
output "vault_boundary_token_nonsensitive" {
    value = local.output_vault_token_nonsensitive
}