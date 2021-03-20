output "kubectx" {
  value       = "${azurerm_kubernetes_cluster.aks.name}"
  description = "kubectl context name"
}

output "cluster_endpoint" {
  value       = lookup(data.external.cluster_endpoint.result, "cluster_endpoint")
  description = "Endpoint of cluster, used as a placeholder to order modules"
}

output "cluster_ca" {
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  description = "ca certificate of cluster"
}

output "connect_command" {
  value       = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name}"
  description = "Get kubeconfig for cluster"
}