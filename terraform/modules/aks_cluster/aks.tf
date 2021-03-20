// AKS cluster's RG
provider "azurerm" {
   features {}
}

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  # location = var.location
}


// AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "system"
    node_count          = var.node_count
    vm_size             = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }


  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" # CNI
/*     load_balancer_profile {
            outbound_ip_address_ids = [ "${data.azurerm_public_ip.ip.id}" ]
  } */
  }
}


// Get cluster credentials so we can perform tasks on it
resource "null_resource" "get-demo-credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name}"
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}

data "external" "cluster_endpoint" {
program = [ "/bin/bash", "${path.module}/files/cluster_endpoint.sh" ]
depends_on = [null_resource.get-demo-credentials]
}
