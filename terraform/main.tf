// Create the cluster, if you are using an existing project update the project_id and remove the module_depends_on line
module "aks_cluster" {
  source = "./modules/aks_cluster"

  location         = var.location
  cluster_name = var.cluster_name
}

module "cert-manager" {
  source = "./modules/cert-manager"
  module_depends_on = [module.aks_cluster]

}

module "istio_install" {
  source = "./modules/istio_install"
  kubectx    = module.aks_cluster.kubectx
  module_depends_on = [module.cert-manager]
}

module "dns" {
  source = "./modules/dns"
  ingress_external_ip    = module.istio_install.ingress_external_ip
  module_depends_on = [module.istio_install]
}

// Install and configure KES and Argo CD
module "base_tools" {
  source = "./modules/base_tools"

  vault_addr = var.vault_addr
  # kubectx    = module.aks_cluster.kubectx

  module_depends_on = [module.dns]
}

// Setup the auth for K8s to authenticate to Vault
module "vault_config" {
  source = "./modules/vault_config"

  vault_addr       = var.vault_addr
  vault_token      = module.base_tools.vault_token
  cluster_endpoint = module.aks_cluster.cluster_endpoint
  cluster_ca       = module.aks_cluster.cluster_ca

  module_depends_on = [module.base_tools]
}
