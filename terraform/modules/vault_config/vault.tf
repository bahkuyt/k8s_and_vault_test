// terraform hack to make sure prerequisite modules have completed
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

// get the KES service account token from k8s cluster for vault config
data "external" "config_vault" {
  program = ["/bin/bash", "${path.module}/files/config-vault.sh"]

  /* query = {
    kes_namespace = "${var.kes_namespace}"
  } */

  depends_on = [null_resource.module_depends_on]
}
/* 
// vault kubernetes auth enable
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.vault_auth_path
}

// configure auth endpoint for our K8s cluster
resource "vault_kubernetes_auth_backend_config" "demo" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = var.cluster_endpoint
  kubernetes_ca_cert = base64decode(var.cluster_ca)
  token_reviewer_jwt = base64decode(lookup(data.external.config_vault.result, "kube_token"))
}

// create a new Vault role on this path
resource "vault_kubernetes_auth_backend_role" "kes" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = var.vault_role_name
  bound_service_account_names      = var.kes_service_account
  bound_service_account_namespaces = [var.kes_namespace]
  token_ttl                        = 3600
  token_policies                   = var.token_policies
} */

// create a Vault policy using a template to access our secrets
 /* data "template_file" "vault_policy" {
  template = "${file("${path.module}/templates/vault_policy.tpl")}"
  vars = {
    vault_kes_path         = var.vault_kes_path
  }
    depends_on = [null_resource.k8s_vault_role]

} */
 
// apply the rendered template to the Vault instance
/*
resource "vault_policy" "kes" {
  name   = "kes"
  policy = data.template_file.vault_policy.rendered
} */

// vault kubernetes auth enable


 resource "null_resource" "k8s_auth" {
  provisioner "local-exec" {
    command = "kubectl -n vault exec -it vault-0 -- vault auth enable -path=/${var.vault_auth_path} kubernetes"
  }
  depends_on = [data.external.config_vault]
}

// configure auth endpoint for our K8s cluster

 resource "null_resource" "k8s_vault_endpoint" {
  provisioner "local-exec" {
    command = "kubectl -n vault exec -it vault-0 -- vault write auth/${var.vault_auth_path}/config token_reviewer_jwt='${base64decode(lookup(data.external.config_vault.result, "kube_token"))}' kubernetes_host=${var.cluster_endpoint} kubernetes_ca_cert='${base64decode(var.cluster_ca)}'"
  }
  depends_on = [null_resource.k8s_auth]
} 

// create a new Vault role on this path


 resource "null_resource" "k8s_vault_role" {
  provisioner "local-exec" {
    command = "kubectl -n vault exec -it vault-0 -- vault write auth/${var.vault_auth_path}/role/${var.vault_role_name} bound_service_account_names=${var.kes_service_account} bound_service_account_namespaces=${var.kes_namespace} policies=${var.token_policies} ttl=24h"
  }
  depends_on = [null_resource.k8s_vault_endpoint]
}
 
// create a new Vault policy

resource "null_resource" "k8s_vault_policy" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/files/policy.sh"
  }
  depends_on = [null_resource.k8s_vault_role]
} 