variable "module_depends_on" {
  default     = [""]
  description = "Modules that are required to run before this module does"
  type        = list
}

variable "vault_namespace" {
  default     = "vault"
  type        = string
  description = "namespace to install vault in"
}

variable "client_id" {
  default     = "fa35ee74-5c37-48ac-b14f-793e7c7b851a"
  type        = string
  description = "Client ID of the Azure subscription"
}
variable "vault_addr" {
  type        = string
  description = "Address of external Vault server"
} 


variable "resource_group_name" {
  default     = "AKSRG"
  type        = string
  description = "RG name"
}
variable "tenant_id" {
  default     = "392b0b4b-175c-4a2c-9996-485b9c07fb39"
  type        = string
  description = "Tenant ID of the Azure subscription"
}
variable "kes_namespace" {
  default     = "kes"
  type        = string
  description = "namespace to install kes in"
}