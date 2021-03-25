resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "null_resource" "argocd_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/argocd-namespace.yaml"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "tekton_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/tekton-namespace.yaml"
  }
  depends_on = [null_resource.argocd_namespace]
}

resource "null_resource" "tekton_install" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../../tekton"
  }
  depends_on = [null_resource.tekton_namespace]
}

// use helm to install argocd, secrets, and initial app-of-apps application
resource "null_resource" "argocd_install" {
  provisioner "local-exec" {
    command = "helm install argocd-base ${path.module}/../../../argocd_base -n argocd"
  }
  depends_on = [null_resource.tekton_install]
}



resource "null_resource" "argocd_networking" {
  provisioner "local-exec" {
    command = "helm install argocd ${path.module}/../../../argocd_networking"
  }
  depends_on = [null_resource.argocd_install]
}

// password for terraform output
data "external" "argocd_password" {
  program = ["/bin/bash", "${path.module}/files/argocd-get-password.sh"]

  depends_on = [null_resource.argocd_networking]
}