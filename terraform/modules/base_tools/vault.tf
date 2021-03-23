provider "azurerm" {
   features {}
}

data "azuread_service_principal" "vault_sp" {
  application_id = var.client_id
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "vault_rg" {
  name                = var.resource_group_name
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "null_resource" "vault_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/vault-namespace.yml"
  }
  depends_on = [null_resource.module_depends_on]
}


resource "null_resource" "vault_services" {
  provisioner "local-exec" {
    command = "helm install vault-svcs ${path.module}/../../../vault/services -n ${var.vault_namespace}"
  }
  depends_on = [null_resource.vault_namespace]
}

resource "azurerm_key_vault" "vault" {
  name                = "vault-k8s-data-test"
  location            = data.azurerm_resource_group.vault_rg.location
  resource_group_name = data.azurerm_resource_group.vault_rg.name
  tenant_id           = var.tenant_id
  enabled_for_deployment = true
  sku_name = "standard"
  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azuread_service_principal.vault_sp.object_id

    key_permissions = [
      "get",
      "wrapKey",
      "unwrapKey",
    ]
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
      "list",
      "create",
      "delete",
      "update",
    ]
  }
  depends_on = [null_resource.vault_namespace]
}

resource "azurerm_key_vault_key" "key_vault" {
  name         = "vault-k8s-unsealer-key"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "wrapKey",
    "unwrapKey",
  ]
}

resource "null_resource" "vault_install" {
  provisioner "local-exec" {
    command = "helm install vault ${path.module}/../../../vault/install -n ${var.vault_namespace}"
  }
  depends_on = [azurerm_key_vault_key.key_vault]
}

resource "null_resource" "vault_wait" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/files/vault_wait.sh"
  }
  depends_on = [null_resource.vault_install]
}

data "external" "token" {
  program = ["/bin/bash", "${path.module}/files/token.sh"]

  depends_on = [null_resource.vault_wait]
}

resource "null_resource" "login_wait" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  depends_on = [data.external.token]
}

resource "null_resource" "vault_login" {
  provisioner "local-exec" {
    command = "kubectl -n ${var.vault_namespace} exec -it vault-0 -- vault login ${lookup(data.external.token.result, "token")}"
  }
  depends_on = [null_resource.login_wait]
}

resource "null_resource" "raft_join_wait" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  depends_on = [null_resource.vault_login]
}

 resource "null_resource" "vault_raft" {
  provisioner "local-exec" {
    command = "kubectl -n ${var.vault_namespace} exec -it vault-1 -- vault operator raft join http://vault-0.vault-internal:8200"
  }
  depends_on = [null_resource.raft_join_wait]
}