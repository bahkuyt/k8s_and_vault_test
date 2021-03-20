variable "location" {
  default     = "West Europe"
  type        = string
  description = "location to place cluster in"
}

variable "resource_group_name" {
  default     = "AKSRG"
  type        = string
  description = "RG name"
}

variable "ingress_external_ip" {
  type        = string
  description = "istio-ingressgateway external ip"
}

variable "module_depends_on" {
  default     = [""]
  type        = list
  description = "List of modules that must run before this one"
}

variable "dns_zone_name" {
  default     = "bahkuyt.tech"
  type        = string
  description = "dns zone name"

}