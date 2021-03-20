/*output "argocd_initial_password" {
  value = lookup(data.external.argocd_password.result, "podName")
}*/
output "vault_token" {
  value = lookup(data.external.token.result, "token")
}