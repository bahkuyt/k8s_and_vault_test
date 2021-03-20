// terraform hack to make this module wait until prerequisite modules are complete
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

// install chart in local path, the path exists outside the tf module and is part of the repository
resource "null_resource" "istio_init_install" {
   provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../../istio/istio-init.yml"
  }
  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "istio_init_crds_wait" {
  
  provisioner "local-exec" {
    command = "kubectl -n istio-system wait --for=condition=complete job --all"
  }
  depends_on = [null_resource.istio_init_install]
}

resource "null_resource" "istio_manifest_install" {
   provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../../istio/istio-manifest.yaml"
  }
  depends_on = [null_resource.istio_init_crds_wait]
}

data "external" "ingressgateway_ip" {
  program = ["/bin/bash", "${path.module}/files/istio-ingressgateway-ip.sh"]

  depends_on = [null_resource.istio_manifest_install]
}
resource "null_resource" "istio_services" {
  provisioner "local-exec" {
    command = "helm install istio-gwvs ${path.module}/../../../istio/helm/istio-gwvs"
  }
  depends_on = [data.external.ingressgateway_ip]
}