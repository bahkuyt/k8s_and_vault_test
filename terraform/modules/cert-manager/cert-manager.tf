// terraform hack to make this module wait until prerequisite modules are complete
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "null_resource" "cert_manager_install" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../../cert-manager/v0.14.1.yaml"
  }
  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "cert_manager_wait" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/files/cert_manager_wait.sh"
  }
/*   provisioner "local-exec" {
    command = "kubectl -n cert-manager wait --for=condition=complete job --all"
  } */
  depends_on = [null_resource.cert_manager_install]
} 


resource "null_resource" "cert_manager_clusterissuer_install" {
  provisioner "local-exec" {
    command = "helm install cert-manager ${path.module}/../../../cert-manager/"
  }
  depends_on = [null_resource.cert_manager_wait]
}

resource "null_resource" "istio_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../../istio/istio-namespace.yml"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.cert_manager_clusterissuer_install]
}
resource "null_resource" "istio_certificate_install" {
  provisioner "local-exec" {
    command = "helm install istio-certificate ${path.module}/../../../istio/helm/istio-certificate"
  }
  depends_on = [null_resource.cert_manager_clusterissuer_install]
}
