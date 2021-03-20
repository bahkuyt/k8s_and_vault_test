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

variable "public_ip_name" {
  default     = "LB_Static_IP"
  type        = string
  description = "LB static ip address"
}

variable "node_count" {
  default     = "2"
  type        = string
  description = "number of nodes"
}


variable "cluster_name" {
  type        = string
  description = "name of cluster"
}

variable "kubernetes_version" {
  default     = "1.18.10"
  type        = string
  description = "Kubernetes version"
}

variable "module_depends_on" {
  default     = [""]
  type        = list
  description = "List of modules that must run before this one"
}