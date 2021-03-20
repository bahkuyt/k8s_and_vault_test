variable "istio_namespace" {
  default     = "istio-system"
  type        = string
  description = "namespace to install istio in"
}

variable "module_depends_on" {
  default     = [""]
  description = "Modules that are required to run before this module does"
  type        = list
}

variable "kubectx" {
  type        = string
  description = "Context of kubeconfig to parse for cluster"
}
