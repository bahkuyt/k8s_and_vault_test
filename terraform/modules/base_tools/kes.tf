resource "null_resource" "kes_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/kes-namespace.yaml"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.raft_join_wait]
}

// install chart in local path, the path exists outside the tf module and is part of the repository
resource "null_resource" "kes_install" {
  provisioner "local-exec" {
    command = "helm install kes ${path.module}/../../../kubernetes-external-secrets --set env.VAULT_ADDR=${var.vault_addr} --set env.VAULT_SKIP_VERIFY=true --set kes.namespace=${var.kes_namespace} -n ${var.kes_namespace}"
  }
  depends_on = [null_resource.kes_namespace]
}

resource "null_resource" "wait_for_kes_crd" {
  provisioner "local-exec" {
    command = "until kubectl get crd |grep externalsecrets.kubernetes-client.io; do echo Kubernetes External Secrets CRD not yet available; sleep 5; done"
  }
  depends_on = [null_resource.kes_install]
}
resource "null_resource" "istio_secrets" {
  provisioner "local-exec" {
    command = "helm install istio-secrets ${path.module}/../../../istio/secrets"
  }
  depends_on = [null_resource.wait_for_kes_crd]
}
