// aks variables
variable "location" {
  default     = "West Europe"
  type        = string
  description = "Azure location to place kubernetes cluster in"
}

variable "cluster_name" {
  default     = "demo"
  description = "Name of cluster to create on AKS"
  type        = string
}

// base variables
variable "vault_addr" {
  default = "https://vault.bahkuyt.tech"
  type        = string
  description = "Address of Vault server"

}
/* variable "vault_token" {
  type        = string
  description = "Token used to sign into Vault. Recommended to use the TF_VAR_vault_token environment variable for this"
} */